
function Register(var, value)
    ExecConsoleCommand("@SetGameVar('"..var.."','"..value.."')")
end
function SetVarString(var, value)
	return "SetGameVar('"..var.."','"..value.."') "
end


function VarHeroLevel(hero)
	return "h5x_hero_"..hero.."_level"
end
function VarHeroStatAttack(hero)
	return "h5x_hero_"..hero.."_stat_attack"
end
function VarHeroStatDefense(hero)
	return "h5x_hero_"..hero.."_stat_defense"
end
function VarHeroStatSpellpower(hero)
	return "h5x_hero_"..hero.."_stat_spellpower"
end
function VarHeroStatKnowledge(hero)
	return "h5x_hero_"..hero.."_stat_knowledge"
end
function VarHeroStatMorale(hero)
	return "h5x_hero_"..hero.."_stat_morale"
end
function VarHeroStatLuck(hero)
	return "h5x_hero_"..hero.."_stat_luck"
end
function VarHeroSkillId(hero, skill)
	return "h5x_hero_"..hero.."_skill_"..skill
end
function VarHeroArtifactId(hero, artifact)
	return "h5x_hero_"..hero.."_artifact_"..artifact
end


function StoreData(hero)
	local setvars = SetVarString(VarHeroLevel(hero),GetHeroLevel(hero))..
					SetVarString(VarHeroStatAttack(hero),GetHeroStat(hero, STAT_ATTACK))..
					SetVarString(VarHeroStatDefense(hero),GetHeroStat(hero, STAT_DEFENCE))..
					SetVarString(VarHeroStatSpellpower(hero),GetHeroStat(hero, STAT_SPELL_POWER))..
					SetVarString(VarHeroStatKnowledge(hero),GetHeroStat(hero, STAT_KNOWLEDGE))..
					SetVarString(VarHeroStatMorale(hero),GetHeroStat(hero, STAT_MORALE))..
					SetVarString(VarHeroStatLuck(hero),GetHeroStat(hero, STAT_LUCK))..
					SetVarString(VarHeroSkillId(hero,SKILL_SHATTER_MAGIC), GetHeroSkillMastery(hero, SKILL_SHATTER_MAGIC))..
					SetVarString(VarHeroSkillId(hero,PERK_HOUNDMASTERS), GetHeroSkillMastery(hero, PERK_HOUNDMASTERS))
    -- print(setvars)
	ExecConsoleCommand("@"..setvars)
end


-- print("Loaded game-vars.lua")
ROUTINES_LOADED[30] = 1
