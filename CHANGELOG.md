# CHANGELOG

## Global view

This list is not exhaustive, all stats and changes regarding heroes, skills, artifacts, spells, creatures, etc are available in game and are subject to change.

- [Creatures data](doc/CREATURES.md)
- [Heroes data](doc/HEROES.md)
- [Skills data](doc/SKILLS.md)
- [Artifacts data](doc/ARTIFACTS.md)


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

### Bonus

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
