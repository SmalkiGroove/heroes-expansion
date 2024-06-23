
HERO_ARTFSETS_PIECES = {}
HERO_ARTFSETS_STATUS = {}

for hero,_ in HEROES do
    HERO_ARTFSETS_PIECES[hero] = {}
    for set = 1,ARTIFACT_SET_COUNT do
        HERO_ARTFSETS_PIECES[hero][set] = 0
    end
    HERO_ARTFSETS_STATUS[hero] = {}
    for set = 1,ARTFSET_ACTIVABLES_COUNT do
        HERO_ARTFSETS_STATUS[hero][set] = 0
    end
end

ARTIFACT_SETS_ACTIVATIONS = {
    [ARTIFACT_SET_HAVEN]     = { [4]=ARTFSET_HAVEN_4PC, [6]=ARTFSET_HAVEN_6PC },
    [ARTIFACT_SET_SYLVAN]    = { [4]=ARTFSET_SYLVAN_4PC, [6]=ARTFSET_SYLVAN_6PC },
    [ARTIFACT_SET_INFERNO]   = { [4]=ARTFSET_INFERNO_4PC, [6]=ARTFSET_INFERNO_6PC },
    [ARTIFACT_SET_NECRO]     = { [4]=ARTFSET_NECRO_4PC, [6]=ARTFSET_NECRO_6PC },
    [ARTIFACT_SET_ACADEMY]   = { [4]=ARTFSET_ACADEMY_4PC, [6]=ARTFSET_ACADEMY_6PC },
    [ARTIFACT_SET_DUNGEON]   = { [4]=ARTFSET_DUNGEON_4PC, [6]=ARTFSET_DUNGEON_6PC },
    [ARTIFACT_SET_DWARVEN]   = { [4]=ARTFSET_DWARVEN_4PC, [6]=ARTFSET_DWARVEN_6PC },
    [ARTIFACT_SET_ORCS]      = { [4]=ARTFSET_ORCS_4PC, [6]=ARTFSET_ORCS_6PC },
    [ARTIFACT_SET_DRAGON]    = { [4]=ARTFSET_DRAGON_4PC, [6]=ARTFSET_DRAGON_6PC, [8]=ARTFSET_DRAGON_8PC },
    [ARTIFACT_SET_ENLIGHTEN] = { [4]=ARTFSET_ENLIGHTEN_4PC },
    [ARTIFACT_SET_FROST]     = { [5]=ARTFSET_FROST_5PC },
    [ARTIFACT_SET_GENJI]     = { [4]=ARTFSET_GENJI_4PC },
    [ARTIFACT_SET_ELDENA]    = { [3]=ARTFSET_ELDENA_3PC },
    [ARTIFACT_SET_WAR]       = { [4]=ARTFSET_WAR_4PC },
    [ARTIFACT_SET_VIZIR]     = { [5]=ARTFSET_VIZIR_4PC },
    [ARTIFACT_SET_SPIRIT]    = { [5]=ARTFSET_SPIRIT_5PC },
    [ARTIFACT_SET_WARMAGE]   = { [5]=ARTFSET_WARMAGE_5PC },
    [ARTIFACT_SET_BANDIT]    = { [5]=ARTFSET_BANDIT_5PC },
    [ARTIFACT_SET_BESTIAL]   = { [5]=ARTFSET_BESTIAL_5PC },
    [ARTIFACT_SET_SAINT]     = { [4]=ARTFSET_SAINT_4PC, [6]=ARTFSET_SAINT_6PC },
    [ARTIFACT_SET_ARCHANGEL] = { [5]=ARTFSET_ARCHANGEL_5PC },
    [ARTIFACT_SET_SAILOR]    = { [3]=ARTFSET_SAILOR_3PC },
    [ARTIFACT_SET_MOON]      = { [4]=ARTFSET_MOON_4PC },
}


function ScanHeroArtifacts(hero)
    -- print("$ ScanHeroArtifacts : "..hero)
    local faction = HEROES[hero].faction
    local tracker = {}
    for set = 1,ARTFSET_ACTIVABLES_COUNT do
        if HERO_ARTFSETS_STATUS[hero][set] == 1 then tracker[set] = 0 end
    end
    for set = 1,ARTIFACT_SET_COUNT do
        local pieces = 0
        local active_set = 0
        for _,a in ARTIFACT_SETS[set] do
            if HasArtefact(hero, a, 1) then
                pieces = pieces + 1
            end
        end
        for k,v in ARTIFACT_SETS_ACTIVATIONS[set] do
            if pieces >= k then active_set = v end
        end
        if active_set ~= 0 then
            if faction == set then active_set = active_set + 1 end
            tracker[active_set] = 1
        end
        if pieces ~= HERO_ARTFSETS_PIECES[hero][set] then
            print("Hero "..hero.." artifact set #"..set.." has changed from "..HERO_ARTFSETS_PIECES[hero][set].." to "..pieces.." pieces")
            HERO_ARTFSETS_PIECES[hero][set] = pieces
        end
    end
    for k,v in tracker do
        if HERO_ARTFSETS_STATUS[hero][k] ~= v then
            HERO_ARTFSETS_STATUS[hero][k] = v
            Register(VarHeroArtfsetId(hero,k), v)
        end
    end
    -- do
    --     if HasHeroArtifact(hero, 230) and hero ~= H_RANLETH then RemoveArtefact(hero, 230) end
    --     if HasHeroArtifact(hero, 231) and hero ~= H_RANLETH then RemoveArtefact(hero, 231) end
    --     if HasHeroArtifact(hero, 232) and hero ~= H_BIARA then RemoveArtefact(hero, 232) end
    --     if HasHeroArtifact(hero, 233) and hero ~= H_BIARA then RemoveArtefact(hero, 233) end
    --     if HasHeroArtifact(hero, 236) and hero ~= H_SEPHINROTH then RemoveArtefact(hero, 236) end
    --     if HasHeroArtifact(hero, 237) and hero ~= H_SEPHINROTH then RemoveArtefact(hero, 237) end
    --     if HasHeroArtifact(hero, 244) and hero ~= H_LASZLO then RemoveArtefact(hero, 244) end
    --     if HasHeroArtifact(hero, 245) and hero ~= H_LASZLO then RemoveArtefact(hero, 245) end
    --     if HasHeroArtifact(hero, 247) and hero ~= H_KUJIN then RemoveArtefact(hero, 247) end
    --     if HasHeroArtifact(hero, 248) and hero ~= H_KUJIN then RemoveArtefact(hero, 248) end
    --     if HasHeroArtifact(hero, 251) and hero ~= H_THEODORUS then RemoveArtefact(hero, 251) end
    --     if HasHeroArtifact(hero, 252) and hero ~= H_THEODORUS then RemoveArtefact(hero, 252) end
    -- end
end


-- print("Loaded artifact-manager.lua")
ROUTINES_LOADED[17] = 1
