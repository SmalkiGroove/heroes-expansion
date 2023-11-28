dofile = doFile

LOAD_SOURCES = 1
dofile("/scripts/town-common.lua")
repeat sleep(1) until LOAD_SOURCES == 1

HeroHired = function(name) end
CreatureHired = function(type, number) end
