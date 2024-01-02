
HERO_SKILL_BONUSES = {}

for i,hero in HEROES_ALL do
    HERO_SKILL_BONUSES[hero] = {
        [SKILLBONUS_OFFENCE] = 0,
        [SKILLBONUS_DEFENSE] = 0,
        [SKILLBONUS_LEARNING] = 0,
        [SKILLBONUS_SORCERY] = 0,
        [SKILLBONUS_VOICE] = 0,
        [SKILLBONUS_COURAGE] = 0,
        [SKILLBONUS_PRECISION] = 0,
        [SKILLBONUS_INTELLIGENCE] = 0,
        [SKILLBONUS_EXALTATION] = 0,
        [SKILLBONUS_ARCANE_EXCELLENCE] = 0,
        [SKILLBONUS_GRADUATE] = 0,
        [SKILLBONUS_OCCULTISM] = 0,
        [SKILLBONUS_SECRETS_OF_DESTRUCT] = 0,
        [SKILLBONUS_MOTIVATION] = 0,
        [SKILLBONUS_SHEER_STRENGTH] = 0,
    }
end

-- print("Loaded skills management script")
ROUTINES_LOADED[16] = 1
