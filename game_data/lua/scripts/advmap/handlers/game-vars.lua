
function Register(var, value)
    ExecConsoleCommand("@SetGameVar('"..var.."','"..value.."')")
end
function SetVarString(var, value)
	return "SetGameVar('"..var.."','"..value.."') "
end


function VarHeroLevel(hero)
	return "h5x_hero_"..hero.."_level"
end
function VarHeroSkillId(hero, skill)
	return "h5x_hero_"..hero.."_skill_"..skill
end
function VarHeroArtfsetId(hero, artfset)
	return "h5x_hero_"..hero.."_artfset_"..artfset
end


function StoreData(hero)
	local setvars = SetVarString(VarHeroLevel(hero), GetHeroLevel(hero))..
					SetVarString(VarHeroSkillId(hero,SKILL_SHATTER_MAGIC), GetHeroSkillMastery(hero,SKILL_SHATTER_MAGIC))..
					SetVarString(VarHeroSkillId(hero,PERK_TACTICS), GetHeroSkillMastery(hero,PERK_TACTICS))..
					SetVarString(VarHeroSkillId(hero,PERK_HOUNDMASTERS), GetHeroSkillMastery(hero,PERK_HOUNDMASTERS))
    -- log(setvars)
	ExecConsoleCommand("@"..setvars)
end


-- log("Loaded game-vars.lua")
ROUTINES_LOADED[30] = 1
