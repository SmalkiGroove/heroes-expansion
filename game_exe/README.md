# EXE PATCHES

### General

- [x] 64 bits
- [x] PEST enabled
- [x] Adventure map and combat scripts enabled
- [x] Expand to XXX hero classes
- [x] Expand to XXX artifacts
- [ ] Expand to XXX skills
- [ ] Expand to XXX creatures
- [x] Allow heroes to learn up to 8 skills

### TOE bugfixes

- [x] **Arcane Renewal** should not trigger when Summon Hive, Blade Barrier and Arcane Crystal are cast succesfully
- [x] **Cold Death** should not affect units with Mechanical and Crystal Scale abilities
- [x] **Empowered Armageddon** should be affected by Master Of Fire and Ignite perks, meteor hit should inflict damages, and War Machines should take damages
- [x] **Fire Weilder** spe should affect Empowered Fireball too
- [x] **Imbue Arrow** should be canceled when we close the spellbook
- [x] **Imbue Ballista** should not drain hero ATB when triggered
- [x] **Snare** should not crash the game when stacked with an Arcane Crystal or Blade Barrier
- [x] **Perks** should always have a chance to appear on a hero level-up if the unlock conditions are filled

### RMG

- 

### Advmap

- [x] Change hero maximum level to 50 with realistic exp curve
- [x] Change hero movement cost to 100 on homeland, 80 on roads, 90 on ship, and every move penalty to 20
- [x] Barbarians should gain (500 * spell_level) experience when visiting a shrine instead of (1000 * spell_level)
- 

### Combat

- [x] Creatures should have 0 ATB at the start of combats by default, instead of random value
- [x] Battlefield size 14x12
- [x] Divide by 5 proc change of **Paw Strike** ability
- [x] Change **Battle Dive** damage multiplier from 2 to 1.5
- [x] Change **Energy Channel** mana reduction from 25% to 10%

### War Machines

- [x] Change base heal from **Healing Tent** from 10/20/50/100 to 20/40/60/80
- [x] Add heal per hero level to **Healing Tent** depending on mastery level, equal to 1/2/3/4
- [x] Add heal per point of Defense to **Healing Tent** depending on mastery level, equal to 1/2/3/4
- [x] Change **Plague Tent** to not consume shots and increased its damage by 20%

### Hero spe

- [x] Change **Embalmer** healing tent buff from 5 per hero level to 5% per hero level

### Skills

- [ ] Make **Enlightenment** give only Knowledge every 6/5/4 levels
- [ ] Make **Offence** give +1 Attack every 6/5/4 levels
- [ ] Make **Defence** give +1 Defence every 6/5/4 levels
- [ ] Make **Sorcery** and **Shouting** give +1 Spellpower every 6/5/4 levels
- [x] Make **Avenger** work for all classes
- [x] Change **Irresistible Magic** penetration values from 20/40/50/75 to 25/50/75/99
- [x] Change **Logistics** movement buff per mastery level from 10% to 5%
- [x] Change **Retaliation Strike** to apply on ranged attacks too
- [x] Make **Offensive / Defensive formation** skills applicable to all units
- [x] Change **Chilling Bones** returned damage from 5% to 10%
- [ ] Change **Dead Man's Luck** debuff from 1 to 2
- [ ] Change **Protection** magic resistance from 15% to 20%
- [x] Change **Erratic Mana** trigger chance from 50% to 100% and mana reduction from 10-50% to 10-30%

### Artifacts

- [x] Add 33% bonus spell damage for artifacts 192 (air), 193 (earth), 194 (fire), 195 (water)
- [ ] Change from 50% to 20% bonus spell damage for artifacts 5 (air), 61 (earth), 32 (fire), 18 (water)
- [ ] Add 33% elemental resistance for artifacts ...
- [ ] Change from 50% to 25% elemental resistance for artifacts 20 (air), 62 (earth), 9 (fire), 43 (water)
- [ ] Add magic resistance values for artifacts ...
- [ ] Change magic resistance values for artifacts 13 (20% to 10%), 27 (10% to 15%)
- [ ] Add enemy debuff to morale for artifacts ...
- [ ] Add enemy debuff to luck for artifacts ...
- [ ] Add enemy debuff to initiative for artifacts ...
- [ ] Add enemy debuff to speed for artifacts ...
- [ ] Add buff to creature HP for artifacts ...
- [ ] Add buff to creature initiative for artifacts ...
- [ ] Add buff to creature speed for artifacts ...
- [ ] Add buff to creature spellpower for artifacts ...
- [ ] Add spell immunity for artifacts ...
- [ ] Add creature ability for artifacts ...
- [ ] Change spell charges for **Wand of X** and +4 spellpower when casting spell X
- [ ] Change **Ring of Machine Affinity** multiplier for healing tent from 2 to 1
- [ ] Add a 20% initiative buff to Ballista and Catapult for **Ring of Machine Affinity**
- [ ] Change **Boots of the Swift Journey** movement buff value from 25% to 15%


### Spells

- [x] Change **Chain Lightning** damage multiplier per hit from 0.5 to 0.75
- [x] Change **Frenzy** duration to be always 1 turn
- [ ] Change **Counterspell** mana drain multiplier from 2 to 1.1
- [x] Change **Earthquake** spell to be usable anytime, to be affected by Tremors effect by default, and strike all units
- [x] Change **Vulnerability** spell to be affected by Disruptor damage by default, with a Spellpower scaling

### LUA

- [ ] Port the function GetHeroLevel to combat scripts
- [ ] Port the function HasHeroArtifact to combat scripts
- [ ] Port the function HasHeroSkill to combat scripts
- [ ] Make trigger HERO_LEVELUP_TRIGGER callback function take hero name as arg

### Misc

- [ ] Change condition for being able to learn spells from (does not have skill Blood Rage) to (should not be class Barbarian)
- [x] Hero screen UI

### Optional

- [ ] Add of config key in DefaultStats.xdb for **Defender** spe level divisor
- [ ] Enable mass spells mana cost to be configured in their xdb file
