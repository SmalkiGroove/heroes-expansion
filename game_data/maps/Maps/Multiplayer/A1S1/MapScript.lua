player_1_hero_name = {};
player_2_hero_name = {};

sleep ( 1 );
player_1_hero_name = GetPlayerHeroes(PLAYER_1);
print (player_1_hero_name[0]);
player_2_hero_name = GetPlayerHeroes(PLAYER_2);
print (player_2_hero_name[0]);

if HasHeroSkill(player_1_hero_name[0], SKILL_COURAGE) == true then
	SetObjectDwellingCreatures("town1", 1 , 1000);
	SetObjectDwellingCreatures("town1", 3 , 700);
	SetObjectDwellingCreatures("town1", 5 , 500);
	SetObjectDwellingCreatures("town1", 7 , 300);
	SetObjectDwellingCreatures("town1", 9 , 100);
	SetObjectDwellingCreatures("town1", 11 , 50);
	SetObjectDwellingCreatures("town1", 13 , 30);
end;
if HasHeroSkill(player_1_hero_name[0], SKILL_GATING) == true then
	SetObjectDwellingCreatures("town1", 15 , 1000);
	SetObjectDwellingCreatures("town1", 17 , 700);
	SetObjectDwellingCreatures("town1", 19 , 500);
	SetObjectDwellingCreatures("town1", 21 , 300);
	SetObjectDwellingCreatures("town1", 23 , 100);
	SetObjectDwellingCreatures("town1", 25 , 50);
	SetObjectDwellingCreatures("town1", 27 , 30);
end;
if HasHeroSkill(player_1_hero_name[0], SKILL_NECROMANCY) == true then
	SetObjectDwellingCreatures("town1", 29 , 1000);
	SetObjectDwellingCreatures("town1", 31 , 700);
	SetObjectDwellingCreatures("town1", 33 , 500);
	SetObjectDwellingCreatures("town1", 35 , 300);
	SetObjectDwellingCreatures("town1", 37 , 100);
	SetObjectDwellingCreatures("town1", 39 , 50);
	SetObjectDwellingCreatures("town1", 41 , 30);
end;
if HasHeroSkill(player_1_hero_name[0], SKILL_AVENGER) == true then
	SetObjectDwellingCreatures("town1", 43 , 1000);
	SetObjectDwellingCreatures("town1", 45 , 700);
	SetObjectDwellingCreatures("town1", 47 , 500);
	SetObjectDwellingCreatures("town1", 49 , 300);
	SetObjectDwellingCreatures("town1", 51 , 100);
	SetObjectDwellingCreatures("town1", 53 , 50);
	SetObjectDwellingCreatures("town1", 55 , 30);
end;
if HasHeroSkill(player_1_hero_name[0], SKILL_ARTIFICIER) == true then
	SetObjectDwellingCreatures("town1", 57 , 1000);
	SetObjectDwellingCreatures("town1", 59 , 700);
	SetObjectDwellingCreatures("town1", 61 , 500);
	SetObjectDwellingCreatures("town1", 63 , 300);
	SetObjectDwellingCreatures("town1", 65 , 100);
	SetObjectDwellingCreatures("town1", 67 , 50);
	SetObjectDwellingCreatures("town1", 69 , 30);
end;
if HasHeroSkill(player_1_hero_name[0], SKILL_ARCANISM) == true then
	SetObjectDwellingCreatures("town1", 71 , 1000);
	SetObjectDwellingCreatures("town1", 73 , 700);
	SetObjectDwellingCreatures("town1", 75 , 500);
	SetObjectDwellingCreatures("town1", 77 , 300);
	SetObjectDwellingCreatures("town1", 79 , 100);
	SetObjectDwellingCreatures("town1", 81 , 50);
	SetObjectDwellingCreatures("town1", 83 , 30);
end;
if HasHeroSkill(player_1_hero_name[0], SKILL_RUNELORE) == true then
	SetObjectDwellingCreatures("town1", 92 , 1000);
	SetObjectDwellingCreatures("town1", 94 , 700);
	SetObjectDwellingCreatures("town1", 96 , 500);
	SetObjectDwellingCreatures("town1", 98 , 300);
	SetObjectDwellingCreatures("town1", 100 , 100);
	SetObjectDwellingCreatures("town1", 102 , 50);
	SetObjectDwellingCreatures("town1", 104 , 30);
end;

if HasHeroSkill(player_2_hero_name[0], SKILL_COURAGE) == true then
	SetObjectDwellingCreatures("town2", 1 , 1000);
	SetObjectDwellingCreatures("town2", 3 , 700);
	SetObjectDwellingCreatures("town2", 5 , 500);
	SetObjectDwellingCreatures("town2", 7 , 300);
	SetObjectDwellingCreatures("town2", 9 , 100);
	SetObjectDwellingCreatures("town2", 11 , 50);
	SetObjectDwellingCreatures("town2", 13 , 30);
end;
if HasHeroSkill(player_2_hero_name[0], SKILL_GATING) == true then
	SetObjectDwellingCreatures("town2", 15 , 1000);
	SetObjectDwellingCreatures("town2", 17 , 700);
	SetObjectDwellingCreatures("town2", 19 , 500);
	SetObjectDwellingCreatures("town2", 21 , 300);
	SetObjectDwellingCreatures("town2", 23 , 100);
	SetObjectDwellingCreatures("town2", 25 , 50);
	SetObjectDwellingCreatures("town2", 27 , 30);
end;
if HasHeroSkill(player_2_hero_name[0], SKILL_NECROMANCY) == true then
	SetObjectDwellingCreatures("town2", 29 , 1000);
	SetObjectDwellingCreatures("town2", 31 , 700);
	SetObjectDwellingCreatures("town2", 33 , 500);
	SetObjectDwellingCreatures("town2", 35 , 300);
	SetObjectDwellingCreatures("town2", 37 , 100);
	SetObjectDwellingCreatures("town2", 39 , 50);
	SetObjectDwellingCreatures("town2", 41 , 30);
end;
if HasHeroSkill(player_2_hero_name[0], SKILL_AVENGER) == true then
	SetObjectDwellingCreatures("town2", 43 , 1000);
	SetObjectDwellingCreatures("town2", 45 , 700);
	SetObjectDwellingCreatures("town2", 47 , 500);
	SetObjectDwellingCreatures("town2", 49 , 300);
	SetObjectDwellingCreatures("town2", 51 , 100);
	SetObjectDwellingCreatures("town2", 53 , 50);
	SetObjectDwellingCreatures("town2", 55 , 30);
end;
if HasHeroSkill(player_2_hero_name[0], SKILL_ARTIFICIER) == true then
	SetObjectDwellingCreatures("town2", 57 , 1000);
	SetObjectDwellingCreatures("town2", 59 , 700);
	SetObjectDwellingCreatures("town2", 61 , 500);
	SetObjectDwellingCreatures("town2", 63 , 300);
	SetObjectDwellingCreatures("town2", 65 , 100);
	SetObjectDwellingCreatures("town2", 67 , 50);
	SetObjectDwellingCreatures("town2", 69 , 30);
end;
if HasHeroSkill(player_2_hero_name[0], SKILL_ARCANISM) == true then
	SetObjectDwellingCreatures("town2", 71 , 1000);
	SetObjectDwellingCreatures("town2", 73 , 700);
	SetObjectDwellingCreatures("town2", 75 , 500);
	SetObjectDwellingCreatures("town2", 77 , 300);
	SetObjectDwellingCreatures("town2", 79 , 100);
	SetObjectDwellingCreatures("town2", 81 , 50);
	SetObjectDwellingCreatures("town2", 83 , 30);
end;
if HasHeroSkill(player_2_hero_name[0], SKILL_RUNELORE) == true then
	SetObjectDwellingCreatures("town2", 92 , 1000);
	SetObjectDwellingCreatures("town2", 94 , 700);
	SetObjectDwellingCreatures("town2", 96 , 500);
	SetObjectDwellingCreatures("town2", 98 , 300);
	SetObjectDwellingCreatures("town2", 100 , 100);
	SetObjectDwellingCreatures("town2", 102 , 50);
	SetObjectDwellingCreatures("town2", 104 , 30);
end;

Trigger(NEW_DAY_TRIGGER , "hero_teleport");
function hero_teleport()
	print ("aga");
	if GetDate(DAY) == 4 then
		x,y,f = RegionToPoint("player1_t");
		x2,y2,f2 = RegionToPoint("player2_t");
		SetObjectPosition(player_1_hero_name[0], x, y, f);
		SetObjectPosition(player_2_hero_name[0], x2, y2, f2);
	end;
end;