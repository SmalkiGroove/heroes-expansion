
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
	return "h5x_hero_"..hero.."_skill_"..id
end
function VarHeroArtifactId(hero, artifact)
	return "h5x_hero_"..hero.."_artifact_"..id
end


-- print("Loaded game-vars.lua")
ROUTINES_LOADED[15] = 1
