
function ActivateDigging(player, hero)
    print("$ ActivateDigging")

end


function ActivateBuildingConversion(player, hero)
    print("$ ActivateBuildingConversion")
    local obj = HERO_IN_CONVERTIBLE[hero]
    if not obj then ShowFlyingSign("/Text/Game/Scripts/Abilities/HeroNotInConvertible.txt", hero, player, 3) return end
    local tier = MAP_CONVERTIBLES[obj][1]
    if tier == 0 then
        QuestionBoxForPlayers(
            GetPlayerFilter(player),
            {"/Text/Game/Scripts/Abilities/ConvertTown.txt"; wood=20,ore=20,gold=10000},
            "ConvertTown('"..player.."','"..hero.."','"..obj.."')",
            "NoneRoutine"
        )
    else
        QuestionBoxForPlayers(
            GetPlayerFilter(player),
            {"/Text/Game/Scripts/Abilities/ConvertDwelling.txt"; wood=3*tier,ore=3*tier,gold=1000*tier},
            "ConvertDwelling('"..player.."','"..hero.."','"..obj.."','"..tier.."')",
            "NoneRoutine"
        )
    end
end

CUSTOM_ABILITIES = {
    [CUSTOM_ABILITY_1] = NoneRoutine,
    [CUSTOM_ABILITY_2] = NoneRoutine,
    [CUSTOM_ABILITY_3] = NoneRoutine,
    [CUSTOM_ABILITY_4] = ActivateBuildingConversion,
}

function CustomAbilityHandler(hero, id)
    local player = GetObjectOwner(hero)
    startThread(CUSTOM_ABILITIES[id], player, hero)
end


-- print("Loaded custom-abilities.lua")
ROUTINES_LOADED[23] = 1