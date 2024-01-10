
HERO_EQUIPPED_ARTIFACTS = {}
HERO_ACTIVE_ARTIFACT_SETS = {}

for hero,_ in HEROES do
    HERO_EQUIPPED_ARTIFACTS[hero] = {
        [ARTIFACT_LOCATION_BODY]      = ARTIFACT_NONE,
        [ARTIFACT_LOCATION_HEAD]      = ARTIFACT_NONE,
        [ARTIFACT_LOCATION_RIGHTHAND] = ARTIFACT_NONE,
        [ARTIFACT_LOCATION_LEFTHAND]  = ARTIFACT_NONE,
        [ARTIFACT_LOCATION_LEGS]      = ARTIFACT_NONE,
        [ARTIFACT_LOCATION_SHOULDERS] = ARTIFACT_NONE,
        [ARTIFACT_LOCATION_RING]      = ARTIFACT_NONE,
        [ARTIFACT_LOCATION_NECK]      = ARTIFACT_NONE,
        [ARTIFACT_LOCATION_POCKET]    = ARTIFACT_NONE,
        [10]                          = ARTIFACT_NONE,
    }
    HERO_ACTIVE_ARTIFACT_SETS[hero] = {0,0}
end


function SetHeroActiveSet(hero, pieces, set, id)
    local faction = GetHeroFactionID(hero)

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

function UpdateArtifactSets(hero, previous, artifact)
    for set = 1,24 do
        if contains(ARTIFACT_SETS[set], previous) or contains(ARTIFACT_SETS[set], artifact) then
            local pieces = 0
            for _,a in ARTIFACT_SETS[set] do
                if HasArtefact(hero, a, 1) then
                    pieces = pieces + 1
                end
            end
            SetHeroActiveSet(hero, pieces, ARTIFACT_SETS_ACTIVATIONS[set], set)
        end
    end
end


function ScanHeroArtifacts(hero)
    for location = 1,9 do
        local loc = location
        local artifact = HERO_EQUIPPED_ARTIFACTS[hero][location]
        local found = artifact == ARTIFACT_NONE
        for _,a in ARTIFACT_LOCATIONS[location] do
            if HasArtefact(hero, a, 1) then
                found = a
                local same = a == artifact
                if location == ARTIFACT_LOCATION_RING and not same then
                    same = a == HERO_EQUIPPED_ARTIFACTS[hero][10]
                end
                if not same then
                    if location == ARTIFACT_LOCATION_RING and HasArtefact(hero, artifact, 1) then loc = 10; artifact = HERO_EQUIPPED_ARTIFACTS[hero][10] end
                    print(hero.." now has artifact #"..a.." at location "..loc)
                    UpdateArtifactSets(hero, artifact, a)
                    HERO_EQUIPPED_ARTIFACTS[hero][loc] = a
                end
            end
        end
        if not found then
            print(hero.." has no more artifact at location "..location)
            UpdateArtifactSets(hero, artifact, ARTIFACT_NONE)
            HERO_EQUIPPED_ARTIFACTS[hero][location] = ARTIFACT_NONE
        end
    end
end


-- print("Loaded artifact management script")
ROUTINES_LOADED[12] = 1
