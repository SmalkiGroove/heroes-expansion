
SOURCE_LOADED = {
	["common"]    = 0,
	-- ["game-data"] = 0,
	-- ["game-core"] = 0,
}

function Source(path, key)
	-- print("Loading source "..path)
	dofile(path)
	repeat sleep(1) until SOURCE_LOADED[key] == 1
end

Source("/scripts/common.lua", "common")

LOAD_SOURCES = 1
