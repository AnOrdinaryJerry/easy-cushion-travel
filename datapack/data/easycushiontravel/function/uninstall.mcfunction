# Removes Easy Cushion Travel's scores and tags. An admin runs it with
# /function easycushiontravel:uninstall (/function needs op, so regular players can't run it).
# Datapack: this also turns the pack off at the end, so nothing else is needed.
# Mod: this only clears the data. The mod keeps running tick and load until the jar is gone,
# so the admin has to stop the server and remove the jar right after.
# This file is the same in the datapack and the mod. Keep both copies identical.
#
# Stop everyone who is traveling. This removes ect_traveling and sends the stop message.
# It has to run before the objectives are removed, because stop sets ect_idle.
# The temporary tags (ect_rider, ect_cushion, ect_occupied) never outlive the run that adds
# them, so there's nothing else to clean up.
# A player who is offline right now keeps ect_traveling, because commands can't reach offline
# players. That's harmless once the pack or mod is gone, since nothing reads the tag.
execute as @a[tag=ect_traveling] run function easycushiontravel:stop
# Removing an objective deletes every score on it, for every player (online or not),
# including the fake players #delay, #delay_ticks, and #20 on ect_config.
scoreboard objectives remove ect
scoreboard objectives remove ect_idle
scoreboard objectives remove ect_left
scoreboard objectives remove ect_config
# Tell whoever ran this what happened. The first line is true for everyone.
# The second line is for mod users: until the jar is removed, a /reload or restart runs load
# again and recreates the objectives. Datapack users can ignore it, since the pack turns itself
# off below. From the server console, @s is the console, so neither line will show.
tellraw @s {"text":"Easy Cushion Travel's scores and tags have been removed.","color":"green"}
tellraw @s {"text":"Using the mod? Stop and remove the jar now. A /reload or restart before removal will bring it all back.","color":"yellow"}
# Datapack: turn the pack off so tick stops running and /reload doesn't recreate everything.
# This goes last because disabling triggers a reload. The pack's ID depends on how it was
# installed: file/easy_cushion_travel.zip as a zip, file/easy_cushion_travel as a folder.
# Both are tried, and the one that doesn't exist just fails with a harmless "Unknown data pack" error.
# Mod: the mod's pack has a different ID, so both lines fail harmlessly and nothing reloads.
# That's why mod users have to remove the jar themselves.
datapack disable "file/easy_cushion_travel.zip"
datapack disable "file/easy_cushion_travel"