-- ================================================================================ --
--				Jamba EE - ( The Awesome MultiBoxing Assistant Ebony's Edition )    --
--				Current Author: Jennifer Cally (Ebony)								--
--				Copyright 2015 - 2018 Jennifer Cally "Ebony"						--
--																					--
--				License: The MIT License (MIT)										--
--				Copyright (c) 2008-2015  Michael "Jafula" Miller					--
--																					--
-- ================================================================================ --

local L = LibStub("AceLocale-3.0"):NewLocale( "Jamba-Interaction", "enUS", true )
L["SLASH_COMMANDS"] = "Slash Commands"
L["INTERACTION"] = "Interaction"
L["TAXI"] = "Taxi"
L["TAXI_OPTIONS"] = "Taxi Options"

L["TAKE_TEAMS_TAXI"] = "Take Teams Taxi"
L["TAKE_TEAMS_TAXI_HELP"] = "Take The Same Flight As The Any Team Member \n(Other Team Members Must Have Npc Flight Master Window Open)."

L["REQUEST_TAXI_STOP"] = "Request Taxi Stop With Team"
L["REQUEST_TAXI_STOP_HELP"] = "[PH] REQUEST_TAXI_STOP_HELP"
L["CLONES_TO_TAKE_TAXI_AFTER"] = "Clones To Take Taxi After Leader"

L["MOUNT"] = "Mount"
L["MOUNT_OPTIONS"] = "Mount Options"
L["MOUNT_WITH_TEAM"] = "Mount With Team"
L["MOUNT_WITH_TEAM_HELP"] = "[PH] MOUNT_WITH_TEAM_HELP"

L["DISMOUNT_WITH_TEAM"] = "Dismount With Team"
L["DISMOUNT_WITH_TEAM_HELP"] = "Dismount When Any Team Dismount's"

L["ONLY_DISMOUNT_WITH_MASTER"] = "Only Dismount's With Master"
L["ONLY_DISMOUNT_WITH_MASTER_HELP"] = "ONLY DISMOUNT'S WHEM MASTER CHARACTER DISMONTS."

L["ONLY_MOUNT_WHEN_IN_RANGE"] = "Only Mount When In Range"
L["ONLY_MOUNT_WHEN_IN_RANGE_HELP"] = "Dismounts Olny When The Team Is In Range /nOnly Works In A Party!"
L["I_AM_UNABLE_TO_MOUNT"] = "I Am Unable To Mount."

L["LOOT_OPTIONS"] = "Loot v2 Options"
L["DISMOUNT_WITH_CHARACTER"] = "Dismount With Character That Dismount"

L["ENABLE_AUTO_LOOT"] = "Enable Auto"
L["ENABLE_AUTO_LOOT_HELP"] = "Old Jambas Advanced Loot \Nbut Better"

L["TELL_TEAM_BOE_RARE"] = "Tell Team BoE Rare"
L["TELL_TEAM_BOE_RARE_HELP"] = "Tell The Team If I Loot A Boe Rare"
L["TELL_TEAM_BOE_EPIC"] = "Tell Team Boe Epic"
L["TELL_TEAM_BOE_EPIC_HELP"] = "Tell The Team If I Loot A Boe Epic"

L["I_HAVE_LOOTED_A_X_ITEM: "] = function( itemRarity, itemLink )
	return string.format( "I Have Looted A %s BoE Item: %s", itemRarity , itemLink )
end
L["EPIC"] = "Epic"
L["RARE"] = "Rare"


L["PUSH_SETTINGS"] = "Push Settings"
L["PUSH_SETTINGS_HELP"] = "Push The Interaction Settings To All Characters In The Team."
L["REQUESTED_STOP_X"] = function( sender )
	return string.format( "I Have Requested a Stop From %s", sender )
end
L["MESSAGE_AREA"] = "Message Area"
L["SEND_WARNING_AREA"] = "Send Warning Area"
L["SETTINGS_RECEIVED_FROM_A"] = function( characterName )
	return "Settings Received From "..characterName.."."
end
L["I_AM_UNABLE_TO_FLY_TO_A"] = function( nodename )
	return string.format( "I Am Unable To Fly To %s .", nodename )
end
