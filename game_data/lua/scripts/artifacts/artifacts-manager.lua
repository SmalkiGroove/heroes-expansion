
HERO_EQUIPPED_ARTIFACTS = {}

for i,hero in HEROES_ALL do
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
    }
end


function ScanHeroArtifacts(hero)
    for location = 1,9 do
        local artifact = HERO_EQUIPPED_ARTIFACTS[hero][location]
        if artifact == ARTIFACT_NONE then
            for _,a in ARTIFACT_LOCATIONS[loc] do
                if HasArtefact(hero, a, 1) then
                    print(hero.." now has artifact #"..a.." at location "..location)
                    UpdateArtifactSets(hero, artifact, a)
                    HERO_EQUIPPED_ARTIFACTS[hero][location] = a
                    break
                end
            end
        else
            if not HasArtefact(hero, artifact, 1) then
                local rep = ARTIFACT_NONE
                for _,a in ARTIFACT_LOCATIONS[loc] do
                    if HasArtefact(hero, a, 1) then
                        rep = a
                        break
                    end
                end
                print(hero.." has replaced artifact #"..artifact.." by #"..rep.." at location "..location)
                UpdateArtifactSets(hero, artifact, rep)
                HERO_EQUIPPED_ARTIFACTS[hero][location] = rep
            end
        end
    end
end

function UpdateArtifacts(player)
    for i,hero in GetPlayerHeroes(player) do
        -- print("Update artifact for hero "..hero)
        ScanHeroArtifacts(hero)
    end
end


-- print("Loaded artifact management script")
ROUTINES_LOADED[12] = 1
