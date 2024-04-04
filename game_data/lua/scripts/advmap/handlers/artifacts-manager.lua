
HERO_ACTIVE_ARTIFACT_SETS = {}
for hero,_ in HEROES do
    HERO_ACTIVE_ARTIFACT_SETS[hero] = {0,0}
end


function SetHeroActiveSet(hero, pieces, set, id)
    local faction = HEROES[hero].faction

    local activations = set[0]
    if set[faction] then activations = set[faction] end

    local artfset = 0
    local before = 0
    
    for n,v in activations do
        if pieces >= n then artfset = v end
        if contains(HERO_ACTIVE_ARTIFACT_SETS[hero], v) then before = v end
    end

    if before == artfset then
        print("Hero "..hero.." artifact set "..id.." has not changed")
    else
        print("Hero "..hero.." artifact set "..id.." has changed from "..before.." to "..artfset)
        replace(HERO_ACTIVE_ARTIFACT_SETS[hero], before, artfset, nil)
        print("["..HERO_ACTIVE_ARTIFACT_SETS[hero][1]..","..HERO_ACTIVE_ARTIFACT_SETS[hero][2].."]")
    end
end


function ScanHeroArtifacts(hero)
    for set = 1,ARTIFACT_SET_COUNT do
        local pieces = 0
        for _,a in ARTIFACT_SETS[set] do
            if HasArtefact(hero, a, 1) then
                pieces = pieces + 1
            end
        end
        SetHeroActiveSet(hero, pieces, ARTIFACT_SETS_ACTIVATIONS[set], set)
    end
end


-- print("Loaded artifact-manager.lua")
ROUTINES_LOADED[17] = 1
