
function GetCreatureFactionID(id)
	local race = 0
	if 	   (id >= 1 and id <= 14) or (id >= 106 and id <= 112) then race = 1
	elseif (id >= 43 and id <= 56) or (id >= 145 and id <= 151) then race = 2
	elseif (id >= 15 and id <= 28) or (id >= 131 and id <= 137) then race = 3
	elseif (id >= 29 and id <= 42) or (id >= 152 and id <= 158) then race = 4
	elseif (id >= 57 and id <= 70) or (id >= 159 and id <= 165) then race = 5
	elseif (id >= 71 and id <= 84) or (id >= 138 and id <= 144) then race = 6
	elseif (id >= 92 and id <= 105) or (id >= 166 and id <= 172) then race = 7
	elseif (id >= 117 and id <= 130) or (id >= 173 and i <= 179) then race = 8 end
	return race
end

function GetHeroFactionID(hero)
	return HEROES[hero]
end


SOURCE_LOADED["game-core"] = 1