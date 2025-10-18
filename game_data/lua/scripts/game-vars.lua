
function Register(var, value)
    ExecConsoleCommand("@SetGameVar('"..var.."','"..value.."')")
end


function VarHeroLevel(hero)
	return "h5x_hero_"..hero.."_level"
end
function VarHeroSkillId(hero, skill)
	return "h5x_hero_"..hero.."_skill_"..skill
end
function VarHeroArtifactId(hero, artifact)
	return "h5x_hero_"..hero.."_artifact_"..artifact
end
function VarHeroArtfsetId(hero, artfset)
	return "h5x_hero_"..hero.."_artfset_"..artfset
end


-- log(DEBUG, "Loaded game-vars.lua")
ROUTINES_LOADED[30] = 1
