// Game launchers, in the game's root folder. Both run bin\H5X.exe with their arguments.
//
// H5X.exe (regular): starts the game.
// H5X-Duel.exe (built with H5X_DUEL): starts the game with the duel files installed.
// Every file under <root>\duel\ is moved to the same path under the game's root folder
// (duel\data\h5x-texts-duel.pak -> data\h5x-texts-duel.pak), then the game runs, and the
// files are moved back when it exits.
// The moved files are listed in duel\installed.txt while they are in the game folders,
// so after a duel launcher killed during the game, both launchers put them back first.

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <shellapi.h>
#include <shlwapi.h>

#include <string>
#include <vector>

#ifdef H5X_DUEL
static const wchar_t* TITLE = L"H5X Duel";
#else
static const wchar_t* TITLE = L"H5X";
#endif
static const wchar_t* JOURNAL = L"installed.txt";
static const wchar_t* ELEVATED_FLAG = L"--h5x-elevated";

static std::wstring g_root;  // game root folder, with a trailing backslash
static std::wstring g_duel;  // duel folder in the game root, with a trailing backslash

static void Error(const std::wstring& msg, DWORD code = 0)
{
    std::wstring text = msg;
    if (code) {
        wchar_t* sys = nullptr;
        FormatMessageW(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
                       nullptr, code, 0, (LPWSTR)&sys, 0, nullptr);
        if (sys) {
            text += L"\n\n";
            text += sys;
            LocalFree(sys);
        }
    }
    MessageBoxW(nullptr, text.c_str(), TITLE, MB_OK | MB_ICONERROR);
}

static bool Exists(const std::wstring& path)
{
    return GetFileAttributesW(path.c_str()) != INVALID_FILE_ATTRIBUTES;
}

// Creates the parent folders of a file path.
static void CreateParents(const std::wstring& file)
{
    for (size_t i = g_root.size(); (i = file.find(L'\\', i)) != std::wstring::npos; ++i)
        CreateDirectoryW(file.substr(0, i).c_str(), nullptr);
}

#ifdef H5X_DUEL
// Relative paths of the files under <root>duel\, the journal excluded.
static void ListDuelFiles(const std::wstring& rel, std::vector<std::wstring>& out)
{
    WIN32_FIND_DATAW fd;
    HANDLE h = FindFirstFileW((g_duel + rel + L"*").c_str(), &fd);
    if (h == INVALID_HANDLE_VALUE)
        return;
    do {
        std::wstring name = fd.cFileName;
        if (name == L"." || name == L"..")
            continue;
        if (fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
            ListDuelFiles(rel + name + L"\\", out);
        else if (!(rel.empty() && lstrcmpiW(name.c_str(), JOURNAL) == 0))
            out.push_back(rel + name);
    } while (FindNextFileW(h, &fd));
    FindClose(h);
}
#endif

static std::vector<std::wstring> ReadJournal()
{
    std::vector<std::wstring> files;
    HANDLE h = CreateFileW((g_duel + JOURNAL).c_str(), GENERIC_READ, FILE_SHARE_READ, nullptr, OPEN_EXISTING, 0, nullptr);
    if (h == INVALID_HANDLE_VALUE)
        return files;
    std::string data(GetFileSize(h, nullptr), '\0');
    DWORD read = 0;
    ReadFile(h, &data[0], (DWORD)data.size(), &read, nullptr);
    CloseHandle(h);
    data.resize(read);
    size_t start = 0;
    while (start < data.size()) {
        size_t end = data.find('\n', start);
        if (end == std::string::npos)
            end = data.size();
        std::string line = data.substr(start, end - start);
        if (!line.empty() && line.back() == '\r')
            line.pop_back();
        if (!line.empty()) {
            int n = MultiByteToWideChar(CP_UTF8, 0, line.c_str(), (int)line.size(), nullptr, 0);
            std::wstring w(n, L'\0');
            MultiByteToWideChar(CP_UTF8, 0, line.c_str(), (int)line.size(), &w[0], n);
            files.push_back(w);
        }
        start = end + 1;
    }
    return files;
}

#ifdef H5X_DUEL
static DWORD WriteJournal(const std::vector<std::wstring>& files)
{
    std::string data;
    for (const auto& f : files) {
        int n = WideCharToMultiByte(CP_UTF8, 0, f.c_str(), (int)f.size(), nullptr, 0, nullptr, nullptr);
        std::string s(n, '\0');
        WideCharToMultiByte(CP_UTF8, 0, f.c_str(), (int)f.size(), &s[0], n, nullptr, nullptr);
        data += s + "\r\n";
    }
    HANDLE h = CreateFileW((g_duel + JOURNAL).c_str(), GENERIC_WRITE, 0, nullptr, CREATE_ALWAYS, 0, nullptr);
    if (h == INVALID_HANDLE_VALUE)
        return GetLastError();
    DWORD written = 0;
    BOOL ok = WriteFile(h, data.data(), (DWORD)data.size(), &written, nullptr);
    DWORD err = ok ? 0 : GetLastError();
    CloseHandle(h);
    return err;
}
#endif

// Moves the files listed in the journal back to duel\, then deletes the journal.
// A file that is also in duel\ again (updated by a sync while installed) keeps the duel\ copy.
static bool Uninstall()
{
    bool ok = true;
    for (const auto& rel : ReadJournal()) {
        std::wstring installed = g_root + rel;
        std::wstring stored = g_duel + rel;
        if (!Exists(installed))
            continue;
        if (Exists(stored)) {
            if (!DeleteFileW(installed.c_str())) {
                Error(L"Could not remove " + installed, GetLastError());
                ok = false;
            }
        } else {
            CreateParents(stored);
            if (!MoveFileExW(installed.c_str(), stored.c_str(), MOVEFILE_COPY_ALLOWED)) {
                Error(L"Could not move back " + installed, GetLastError());
                ok = false;
            }
        }
    }
    if (ok)
        DeleteFileW((g_duel + JOURNAL).c_str());
    return ok;
}

#ifdef H5X_DUEL
// Moves every file of duel\ into the game folders. Returns 0, or the error of the failed move
// after putting the already moved files back.
static DWORD Install(std::wstring& failed)
{
    std::vector<std::wstring> files;
    ListDuelFiles(L"", files);
    // Written first, so that a crash in the middle still lets Uninstall find everything.
    if (DWORD err = WriteJournal(files)) {
        failed = g_duel + JOURNAL;
        return err;
    }
    for (const auto& rel : files) {
        std::wstring target = g_root + rel;
        CreateParents(target);
        if (!MoveFileExW((g_duel + rel).c_str(), target.c_str(), MOVEFILE_REPLACE_EXISTING | MOVEFILE_COPY_ALLOWED)) {
            DWORD err = GetLastError();
            failed = target;
            Uninstall();
            return err;
        }
    }
    return 0;
}

static bool IsElevated()
{
    HANDLE token;
    TOKEN_ELEVATION elevation = {};
    DWORD size;
    if (!OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &token))
        return false;
    GetTokenInformation(token, TokenElevation, &elevation, sizeof(elevation), &size);
    CloseHandle(token);
    return elevation.TokenIsElevated != 0;
}

// The game folder is not writable (Program Files): restarts the launcher as administrator.
static void RelaunchElevated(const std::wstring& self, const std::wstring& args)
{
    std::wstring params = std::wstring(ELEVATED_FLAG) + L" " + args;
    SHELLEXECUTEINFOW sei = { sizeof(sei) };
    sei.lpVerb = L"runas";
    sei.lpFile = self.c_str();
    sei.lpParameters = params.c_str();
    sei.nShow = SW_SHOWNORMAL;
    if (!ShellExecuteExW(&sei) && GetLastError() != ERROR_CANCELLED)
        Error(L"Could not restart the launcher as administrator.", GetLastError());
}
#endif

int WINAPI wWinMain(HINSTANCE, HINSTANCE, LPWSTR, int)
{
    wchar_t buffer[MAX_PATH];
    GetModuleFileNameW(nullptr, buffer, MAX_PATH);
    std::wstring self = buffer;
    g_root = self.substr(0, self.rfind(L'\\') + 1);
    g_duel = g_root + L"duel\\";

    // Arguments are passed on to the game, without the flag of an elevated restart.
    std::wstring args = PathGetArgsW(GetCommandLineW());
    bool relaunched = args.compare(0, lstrlenW(ELEVATED_FLAG), ELEVATED_FLAG) == 0;
    if (relaunched)
        args = PathGetArgsW(args.c_str());

    std::wstring bin = g_root + L"bin\\";
    std::wstring game = bin + L"H5X.exe";
    if (!Exists(game)) {
        Error(L"The game was not found:\n" + game + L"\n\nThe launcher must be in the game's root folder.");
        return 1;
    }

#ifdef H5X_DUEL
    if (!Exists(g_duel)) {
        Error(L"The duel folder was not found:\n" + g_duel);
        return 1;
    }

    // Leftovers of a launcher that did not finish.
    if (!Uninstall())
        return 1;

    std::wstring failed;
    if (DWORD err = Install(failed)) {
        if (err == ERROR_ACCESS_DENIED && !relaunched && !IsElevated())
            RelaunchElevated(self, args);
        else
            Error(L"Could not install the duel files:\n" + failed, err);
        return 1;
    }
#else
    (void)relaunched;
    // Leftovers of a duel launcher that did not finish. The game starts even if they stay.
    Uninstall();
#endif

    std::wstring cmd = L"\"" + game + L"\" " + args;
    STARTUPINFOW si = { sizeof(si) };
    PROCESS_INFORMATION pi;
    if (!CreateProcessW(game.c_str(), &cmd[0], nullptr, nullptr, FALSE, 0, nullptr, bin.c_str(), &si, &pi)) {
        Error(L"Could not start the game.", GetLastError());
#ifdef H5X_DUEL
        Uninstall();
#endif
        return 1;
    }
    CloseHandle(pi.hThread);
#ifdef H5X_DUEL
    WaitForSingleObject(pi.hProcess, INFINITE);
    CloseHandle(pi.hProcess);
    return Uninstall() ? 0 : 1;
#else
    CloseHandle(pi.hProcess);
    return 0;
#endif
}
