# CHANGELOG

## Global view

This list is not exhaustive, all stats and changes regarding heroes, skills, artifacts, spells, creatures, etc are available in game and are subject to change.

- [Creatures data](documentation/CREATURES.md)
- [Heroes data](documentation/HEROES.md)
- [Skills data](documentation/SKILLS.md)
- [Artifacts data](documentation/ARTIFACTS.md)
- [Spells data](documentation/SPELLS.md)


### Exe patches

- Maximum creature ATB at the start of combats lowered from 25% to 5%
- Mass spells consume all the ATB, like any other spell
- Creature's spellpower formula is now linear : `S = 1 + 2.5 * N / G` (N is number of creatures in the stack, G is the creature's weekly growth)
- First Aid Tent healing and damages now also scale with hero's level and defense stat
- Battlefield size is 14x11
- PEST (permanent endless simultaneous turns)
- Heroes can learn up to 8 skills
- Adjusted experience / level curve and maximum level is now 50
- Removed free morale point for creatures that are from the same faction as the hero
- Creature split default amounts changed from 50%-50% to N-1/1
- Hero initiative is increased by the knowledge stat

### Config changes

- Each faction has 2 hero classes (might/magic)
- Heroes have lower movement points and vision range
- Attack and defense stats mitigate damages for 3% per point instead of 5%
- Lucky hits deal 66% more damage, unlucky hits deal 33% less damage
- Good morale gives 0.4 ATB, bad morale removes 0.4 ATB
- Magic school summoning replaced by natural, which includes more diverse spells
- Lower tier creatures have higher weekly growth, and high tier creatures are considerably stronger

### Quality of Life

- In-game documentation

### Gameplay

- Many new artifacts and sets
- Some additional creatures, either neutral or granted by specific heroes
- Totally revamped skill tree with 15 branches and totally new skills
- Every hero is unique and all heroes are more powerful in general, and there are no trash heroes
- Scripts are massively used, on the map as well as during combats


## Releases

Using semver naming (major.minor.patch)

### 0.1.0 (31/12/2024)

Initial beta release !

### 0.2.0 (26/01/2025)

#### New

- New artifacts with new effects

#### Fixed/Changed

- Sometimes a tavern hero might have 1 placeholder creature in the starting army
- Add in Governance description that it unlocks conversion
- Kha Beleth initial gating freeze on obstacle
- Gabrielle refresh nb of griffins
- Magic Guild wrong icon
- Neutral Darkstorms spawn on the map
- Give Training bonuses to Lizardman, Basilisk, Behemoth, Druid of the Council
- Gabrielle move points logarithmic curve
- Limit Earth elems with Deleb
- Viking shield gives too many resources
- Leadership spawns caravan even with not enough creature to transfer
- Crash when opening spellbook with Archangels
- Brown Behemoths texture and white icon
- Lich no Harm Touch animation
- War academy and School of Magic text in french
- Frozen Heart effects not working
- Elrath Divine Shield effect not working
- Arcanism magic penetration does not match description
- Book of Power effect does not match description
- Replace Bone Dragons by Black Knights in necro lineup
- Firehounds should be grey
- Obsidian Armor does not immune to Armaggedon
- Remove Duel mode from main menu
- Witch hut popup player filter
- Vaults have too many creatures
- Nearly impossible to get sword with Raelag
- Raelag doesn't get twice the amount of legendary dragons
- Draconic set spawns 1 stack of dragons for each stack that dies at the same time
- Offender spec op with multiplicative bonus from combat

### 0.2.1 (22/03/2025)

#### New

- Added ability Natural Luck to Gold Dragons

#### Fixed/Changed

- Avenger description does not mention luck
- Rework Elleshar spec to not add magic schools
- Ballista HP are a little too low
- Gabrielle infinite movement
- Script error when ballista has no ammo
- Nerf Sheltem
- Sheltem proc after unit moves
- Kha Beleth army growth script error
- Giving skill can take ultimate's spot
- 2 Meteor shower spells in natural magic school
- Dragon tombstone does not work
- Magnetic field disabled
- Black Knights no dash anim
- Crash when Agrael turn's come in combat
- Crash on cast firewall
- Sentinels boots effect not working
- Darkstorm 1 creature instance per hero level
- Attribute building no UI
- Kha Beleth attack anim not sync
- Occultism invalid prerequisites

### 0.3.0 (18/08/2025)

#### New

- In-game UI for documentations (heroes and skills)
- More impactful starting bonuses

#### Fixed/Changed

- Skill tree accessible from level up window
- UI incorrect size
- Maps with Tear of Asha are broken
- Darkstorm creature should not stay in army after battle
- Commander heroes cannot learn special perks
- Graduate unlocks ultimate skill
- Dragon Tombstone building script error
- Give AI more bonuses
- Hero class specific vanilla artifact sets do not match the new hero classes
- Hall of Intrigue gives bonus to wrong hero class
- Doc button not in LAN interface
- One hero per faction with ultimate racial skill
- Leadership caravan doesn't spawn if no other tile available
- Vittorio too easy
- Ballista commander reworked
- Multiple heroes and creatures tweaked

### 0.4.0 (07/11/2025)

#### New

- New skill Despotism with 3 new perks
- New perks for Shatter Magic, Training, Spiritism, Voice
- Few new artifacts
- Significant changes to many hero specs
- New town building orders for all towns

#### Fixed/Changed

- Academy and Sylvan female heroes textures glitched
- Hero name in hero pedia
- Add might/magic toggle in skills pedia
- Arcane Brillance creature mana cost reduction from 50% to 25%
- Crash when loading games sometimes
- Immunity should clean everything
- Lower damage diff between magic levels
- Talanar loses turns when casting righteous might
- Magic Filter incorrectly immunes to spells
- Rissa spec quick battle crash
- Hero that start with Absolute faction skill should get it later
- Swaped town dwellings wrong model
- Give Tavern mapobject the town portal effect
- Improve Dougal peasant upgrade mechanic
- Guardian Angel now also rez units on victories
- Crash when engaging fight with rune priests sometimes
- Double combat script activation sometimes
- Thunder Power skill does not apply air damage of creatures attacks
- Many more little things...

### 0.4.1 (13/11/2025)

#### New

- New artifact sets are now correctly handled by the game

#### Fixed/Changed

- Game stuck on script error when difficulty is greater than normal
- Crash while generating maps with underground
- Agrael can get 2 consecutive turns
- Deleb spawn less elem stack but more per stack
- Tieru recovers all druids after battles
- Anger Treant change ability root for fierce retal
- Nerf Meteor Shower base damage
- Dragon set artifacts increase creature initiative by 5% instead of 10%

### 0.4.2 (19/11/2025)

#### Fixed/Changed

- Battles don't end when enemy stacks are killed simultaneously
- Gateways and subterra entrance not working when monsters on the other side
- Buff/fix Conjure Phoenix
- Buff Regeneration spell
- Level Up skillswheel shows superposed skills

### 0.5.0

#### New

- New artifacts and creatures from the mod added to the editor
- Added spells and training bonuses sections in creatures description window
- More artifacts (Ardent Smith, war machine rings, Genji's set and many others that were disabled are now working)
- Totally reworked destructive magic spells and skills
- New Sorcery perk Arcane Protection that reduces damage taken by army based on hero's spellpower
- Changed map objects effects (Idol of Fortune, Tomb of the Warrior, Seer Hut, War Academy, Arcane Sanctuary, Mother Earth Shrine)

#### Fixed/Changed

- Much faster script initialization = shorter freeze time at game start
- Summoned Wolves stack stay in army permanently
- Starting bonus artifact not working
- Elem orb spawn position random
- Nerf Kha Beleth late game
- Frozen heart not in frost artifact set
- Leadership give +2 Luck instead of Precision
- Inferno sacrificial pit not required for city hall
- Witchcraft perk has no effect if natively known
- Combat does not end if Goblin treason
- Despotism doesn't reduce army morale
- Spear of the Frost Lord effect now works
- Dragon Flame Tongue immunity to cold death now works
- Shield of Crystal Ice immunity to ignite now works
- Celestial Justicar's Armor melee damage reduction now works
- Celestial Justicar's Helmet immunity to blind/confusion/berserk now works
- Dragonsbane damages ignoring defense now works
- Phoenix Feather's Cape immunity to freeze now works
- Collar of Primal Rage bonus rage points now works
- Codex of the Saint atb reset now works
- Staff of the Saint bonus spellpower now works
- Avenger Bow bonus ranged damage now works
- Ranger Cuirass defense vs large creatures now works
- Butcher Glaive bonus melee damage now works
- Sentinel's Blade blade barrier effect now works
- Barbarian Cape immunity to fear now works
- Ogre Club and Ogre Shield stat reduction effect now works
- Shackles of the Last Man stat reduction effect now works
- Plumed Boots flying effect now works
- Shantiri Moon Disc blocks all light magic
- Nerf early game AI
- Nerf Druid of the Council spellpower
- Script error if Tieru does not have Druids of the Council at the end of battle
- Nightmare icon low quality
- Tap Runes has no grey icon
- Hero (kha beleth only?) swaping his spellpower for attack after months of game
- Nerf Devotion broken values
- All fire spells now reduce armor by 30% without skill required
- All ice spells now freeze atb for 0.4 turn witout skill required
- All lightning spells now remove 50% of atb without skill required
- All earth spells now ignore half of the spell-proof
- Rebalanced damage of destructive magic spells
- Buff spiteful ability from +1 to +3
- Magnetic Field ability now works
- Remove 2nd retaliation combo with Preparation + Unlimited retaliations
- Maeve no additional peasant recruits when skill Logistics is known

