# CHANGELOG

## Global view

This list is not exhaustive, all stats and changes regarding skills, artifacts, spells, creatures, etc are available in game and are subject to change.

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
- Totally revamped skill tree with 15 branches
- Every hero is unique and all heroes are more powerful in general, and there are no trash heroes
- Scripts are massively used, on the map as well as during combats


## Releases

Using semver naming (major.minor.patch)

### 1.0.0

Initial release
