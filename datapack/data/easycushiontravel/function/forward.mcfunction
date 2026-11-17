# The travel loop: hops the player onto the cushion they're looking at.
# Called by tick every tick for players tagged ect_traveling, as the player, at the player.
#
# Sneaking stops travel. This has to be the first test, so the player is stopped
# before find and the mount below can put them back on a cushion.
#   Why there's a counter:
#       When bedrock players switch cushions, geyser SOMETIMES sends a fake sneak that lasts one tick, and
#       the pack is unable to tell it apart from a real sneak. This counter makes it so only a sneak held for
#       3 ticks in a row counts.
#
# Holding sneak adds 1 to the counter, letting go resets to zero.
execute if predicate easycushiontravel:sneaking run scoreboard players add @s ect_sneak 1
execute unless predicate easycushiontravel:sneaking run scoreboard players set @s ect_sneak 0
# On Bedrock Edition, Sneak cannot stop travel because real sneaking looks exactly the same as geyser's fake one.
# So there is a jump detector here:
execute if predicate easycushiontravel:jumping run return run function easycushiontravel:stop
# Stops after three ticks held (~0.15 seconds)
execute if score @s ect_sneak matches 3.. run return run function easycushiontravel:stop
# While the key is held, but hasn't reached three ticks, it skips the hop.
# This is important because if it wasn't here, the players would go forward two ticks worth of cushion travel after
# holding sneak. This makes it so the players that are sneaking don't move at all,
# which I personally think is the better of the two.
execute if score @s ect_sneak matches 1.. run return 0
# Tags the cushion the player is looking at with ect_cushion (or nothing).
function easycushiontravel:find
# Found a cushion: reset the idle counter. No cushion: count one more idle tick.
execute if entity @e[type=cushion,tag=ect_cushion] run scoreboard players set @s ect_idle 0
execute unless entity @e[type=cushion,tag=ect_cushion] run scoreboard players add @s ect_idle 1
# Timeout. Uses > instead of >= so a delay of 0 means "stop on the first miss".
# With >=, the counter of 0 after a hop would already count as timed out.
# Nothing is tagged on this path, so returning early skips no cleanup.
execute if score @s ect_idle > #delay_ticks ect_config run return run function easycushiontravel:stop
# /ride refuses to mount someone who is already riding, so dismount first. Only do it
# when a cushion was found, or looking away would knock the player off every tick.
execute if entity @e[type=cushion,tag=ect_cushion] run ride @s dismount
# Fails quietly when nothing is tagged.
ride @s mount @e[type=minecraft:cushion,tag=ect_cushion,limit=1,sort=nearest]
# Remove find's temporary tag in the same run that created it.
tag @e[type=minecraft:cushion,tag=ect_cushion] remove ect_cushion