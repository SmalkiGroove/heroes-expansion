
dofile("/scripts/game/skills.lua") sleep(1)


function DuelLeadership(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Skill/Leadership.txt"; arg=0}, "NoneRoutine")
end


DUEL_SKILL_EFFECTS = {
    [SKILL_LEADERSHIP] = DuelLeadership,
}
