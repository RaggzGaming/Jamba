-- ================================================================================ --
--				Jamba EE - ( The Awesome MultiBoxing Assistant Ebony's Edition )    --
--				Current Author: Jennifer Cally (Ebony)								--
--				Copyright 2015 - 2018 Jennifer Cally "Ebony"						--
--																					--
--				License: The MIT License (MIT)										--
--				Copyright (c) 2008-2015  Michael "Jafula" Miller					--
--																					--
-- ================================================================================ --

local L = LibStub("AceLocale-3.0"):NewLocale( "Core", "enUS", true )
-- NewLocales

--PreCoded ALL
L["JAMBA"] = "Jamba"
L["JAMBA EE"] = "Jamba EE"
L[""] = true
L[" "] = true
L[": "] = true
L["("] = true
L[")"] = true
L[" / "] = true
L["%"] = true
L["PUSH_SETTINGS"] = "Push Settings"
L["PUSH_ALL_SETTINGS"] = "Push All Settings"
L["PUSH_SETTINGS_INFO"] = "Push Settings To Team Members" 
L["MINION"] = "Minion"
L["NAME"] = "Name"
L["MASTER"] = "Master"
L["ALL"] = "All"
L["MESSAGES_HEADER"] = "Messages"
L["MESSAGE_AREA"]  = "Message Area"
L["SEND_WARNING_AREA"] = "Warning Area"
L["PH"] = "PH"
L["GUILD"] = "Guild"

-- Display Options
L["APPEARANCE_LAYOUT_HEALDER"] = "Appearance & Layout"
L["BLIZZARD"] = "Blizzard"
L["BLIZZARD_TOOLTIP"] = "Blizzard Tooltip"
L["BLIZZARD_DIALOG_BACKGROUND"] = "Blizzard Dialog Background"
L["ARIAL_NARROW"] = "Arial Narrow"
L["NUMBER_OF_ROWS"] = "Number Of Rows"
L["SCALE"] = "Scale"
L["TRANSPARENCY"] = "Transparency"
L["BORDER_STYLE"] = "Border Style" 
L["BORDER COLOUR"] = "Border Colour"
L["BACKGROUND"] = "Background"
L["BG_COLOUR"] = "Background Colour"
L["FONT"] = "Font"
L["FONT SIZE"] = "Font Size"
L["BAR_TEXTURES"] = "Status Bar Textures"
L["WIDTH"] = "Width"
L["HEIGHT"] = "Hight"

-- Numbers
L["1"] = "One"
L["2"] = "Two"
L["3"] = "Three"
L["4"] = "Four"
L["5"] = "Five"
L["6"] = "Six"
L["7"] = "Seven"
L["8"] = "Eight"
L["9"] = "Nine"
L["10"] = "Ten"
L["11"] = "Eleven"
L["12"] = "Twelve"
L["13"] = "Thirteen"
L["14"] = "Fourteen"
L["15"] = "Fifteen"
L["16"] = "Sixteen"
L["17"] = "Sventeen"
L["18"] = "Eighteen"
L["19"] = "Nineteen"
L["20"] = "Twenty"

--------------------------
-- Modules Locale
L["NEWS"] = "News"
L["OPTIONS"] = "Options"
L["SETUP"] = "Setup" 
L["PROFILES"] = "Profiles"
L["TEAM"] = "Team"
L["COMMUNICATIONS"] = "Communications"
L["MESSAGE_DISPLAY"] = "Message Display"
L["GROUP_LIST"] = "Group List"
L["DISPLAY"] = "Display"
L["ITEM_USE"] = "Item Use"
L["VENDER"] = "Vender"
L["VENDER_LIST_MODULE"] = "Sell List"
L["INTERACTION"] = "Interaction"
L["CURRENCY"] = "Currency"
L["TOON"] = "Toon"
L["FOLLOW"] = "Follow"
L["PURCHASE"] = "Purchase"
L["VENDER"] = "Vender"
L["PURCHASE"] = "Purchase"
L["QUEST"] = "Quest"
L["TRADE"] = "Trade"


--------------------------
-- Pecoded String Formats
L["SETTINGS_RECEIVED_FROM_A"] = function( characterName )
	return string.format("Settings Received From %s", characterName )
end

L["A_IS_NOT_IN_TEAM"] = function( characterName )
	return string.format("%s Is Not In My Team List. I Can Not Set Them To Be My Master.", characterName )
end
--------------------------
-- Core Locale
L["STATUSTEXT"] = "The Awesome MultiBoxing Assistant Ebony's Edition"
L["RESET_SETTINGS_FRAME"] = "Reset Settings Frame"
L["MODULE_NOT_LOADED"] = "Module Not Loaded Or Is Out Of Date"
L["RELEASE_NOTES"] = "Release Notes "
L["COPYING_PROFILE"] = "Copying profile: "
L["CHANGING_PROFILE"] = "Changing profile: "
L["PROFILE_RESET"] = "Profile reset - iterating all modules."
L["RESETTING_PROFILE"] = "Resetting profile: "
L["PROFILE_DELETED"] = "Profile deleted - iterating all modules."
L["DELETING_PROFILE"] = "Deleting profile: "
L["Failed_LOAD_MODULE"] =  "Failed to load Jamba Module: "
L["TEXT1"] = "Jamba Ebony's Edition v8" 
L["TEXT2"] = ""
L["TEXT3"] = "Thanks For Being A Alpha Tester Of This Build"
L["TEXT4"] = ""
L["TEXT5"] = "If you Have any bugs report them to LINK"
L["TEXT6"] = ""
L["TEXT7"] = "Thanks so much for Making Jamba-EE Great!"
L["TEXT8"] = ""
L["TEXT9"] = ""
L["TEXT10"] = ""

L["SPECIAL_THANKS"] = "Special Thanks:"
L["THANKS1"] = "Michael Jafula Miller Untill 2015"
L["THANKS2"] = ""
L["THANKS3"] = ""

L["WEBSITES"] = "Websites"
L["ME"] = "Current Project Manger Jenny (Ebony) Cally" 
L["ME_TWITTER"] = "https://twitter.com/Jenn_Ebony"
L["D-B"] = "http://Dual-boxing.com"
L["ISB"] = "http://IsBoxer.com"
L["TEMP_WEBSITE1"] = ""
L["TEMP_WEBSITE2"] = ""
L["TEMP_WEBSITE3"] = ""


L["COPYRIGHT"] = "Copyright (c) 2015-2018  Jennifer Cally"
L["COPYRIGHTTWO"] = "Released Under License: The MIT License"
L["FRAME_RESET"] = "Frame Reset"

--------------------------
-- Communications Locale

L["A: Failed to deserialize command arguments for B from C."] = function( libraryName, moduleName, sender )
	return libraryName..": Failed to deserialize command arguments for "..moduleName.." from "..sender.."."
end
L["AUTO_SET_TEAM"] = "Auto Set Team Members On and Off Line"
L["BOOST_COMMUNICATIONS"] = "Boost Jamba to Jamba Communications"
L["BOOST_COMMUNICATIONS_HELP"] = "Reload Ui To Take Effect, May Cause Disconnections"
L["USE_GUILD_COMMS"] = "Use Guild Communications"
L["USE_GUILD_COMMS_INFO"] = "Use Guild Communications All Of Team Needs To Be In Same Guild" 

----------------------------
-- Helper Locale
L["COMMANDS"] = "Commands"
L["SLASH_COMMANDS"] = "Slash Commands"

----------------------------
-- Team Locale
L["JAMBA-TEAM"] = "Jamba-Team"
L["INVITE_GROUP"] = "Invite Team To Group"
L["DISBAND_GROUP"] = "Disband Group"
L["ADD"] = "Add"
L["ADD_HELP"] = "Add a member to the team list."
L["REMOVE"] = "Remove"
L["REMOVE_REMOVE"] = "Remove A Member From The Team List."
L["MASTER_HELP"] = "Set The Master Character."
L["I_AM_MASTER"] = "I'm The Master"
L["I_AM_MASTER_HELP"] = "Set this character to be the master character."
L["INVITE"] = "Invite"
L["INVITE_HELP"] = "Invite team members to a party with or without a <Group>."
L["DISBAND"] = "Disband"
L["DISBAND_HELP"] = "Disband All Team Members From Their Parties."
L["ADD_GROUPS_MEMBERS"] = "Add Groups Members"
L["ADD_GROUPS_MEMBERS_HELP"] = "Add Members In The Current Group To The Team."
L["REMOVE_ALL_MEMBERS"] = "Remove All Members"
L["REMOVE_ALL_MEMBERS_HELP"] = "Remove all members from the team."
L["SET_TEAM_OFFLINE"] = "Set Team OffLine"
L["SET_TEAM_OFFLINE_HELP"] = "Set All Team Members OffLine"
L["SET_TEAM_ONLINE"] = "Set Team OnLine"
L["SET_TEAM_ONLINE_HELP"] = "Set All Team Members OnLine"
L["TEAM_HEADER"] = "Team"
L["GROUPS_HEADER"] = "Groups"
L["BUTTON_ADD_HELP"] = "Adds a member to the team list\nYou can Use:\nCharacterName\nCharacterName-realm\n@Target\n@Mouseover"
L["BUTTON_ADDALL_HELP"] = "Adds all Party/Raid members to the team list"
L["BUTTON_UP_HELP"] = "Move The Character Up A Place In The Team List"
L["BUTTON_DOWN_HELP"] = "Move The Character Down A Place In The Team List"
L["BUTTON_REMOVE_HELP"] = "Removes Selected Member From The Team List"
L["BUTTON_MASTER_HELP"] = "Set The Selected Member To Be The Master Of The Group"
L["BUTTON_GROUP_REMOVE_HELP"] = "Removes The Group From The Selected Character"
L["CHECKBOX_ISBOXER_SYNC"] = "Sync With Isboxer"
L["CHECKBOX_ISBOXER_SYNC_HELP"] = "Sync With Isboxer TeamList \nAdd/Remove Characters No Longer In Isboxer Team"
L["MASTER_CONTROL"] = "Master Control"
L["CHECKBOX_MASTER_LEADER"] = "Promote Master To Party Leader."
L["CHECKBOX_MASTER_LEADER_HELP"] = "Master Will Always Be The Party Leader."
L["CHECKBOX_CTM"] = "Sets Click-To-Move On Minions"
L["CHECKBOX_CTM_HELP"] = "Auto Activate Click-To-Move On Minions And Deactivate On Master."
L["PARTY_CONTROLS"] = "Party Invitations Control"
L["CHECKBOX_CONVERT_RAID"] = "Auto Convert To Raid"
L["CHECKBOX_CONVERT_RAID_HELP"] = "Auto Convert To Raid If Team Is Over Five Characters"
L["CHECKBOX_ASSISTANT"] = "Auto Set All Assistant"
L["CHECKBOX_ASSISTANT_HELP"] = "Auto Set all raid Member's to Assistant."
L["CHECKBOX_TEAM"] = "Accept From Team"
L["CHECKBOX_TEAM_HELP"] = "Auto Accept Invites From The Team."
L["CHECKBOX_ACCEPT_FROM_FRIENDS"] = "Accept From Friends"
L["CHECKBOX_ACCEPT_FROM_FRIENDS_HELP"] = "Auto Accept Invites From Your Friends List."
L["CHECKBOX_ACCEPT_FROM_GUILD"] = "Accept From Guild."
L["CHECKBOX_ACCEPT_FROM_GUILD_HELP"] = "Auto Accept Invites From Your Guild."
L["CHECKBOX_DECLINE_STRANGERS"] = "Decline from strangers."
L["CHECKBOX_DECLINE_STRANGERS_HELP"] = "Decline Invites From Anyone Else"
L["NOT_LINKED"] = "(Not Linked)"
L["TEAM_NO_TARGET"] = "No Target Or Target Is Not A Player"
L["UNKNOWN_GROUP"] = "Unknown Group"
L["ONLINE"] = "Online"
L["OFFLINE"] = "Offline"
L["STATICPOPUP_ADD"] = "Enter character to add in name-server format:"
L["STATICPOPUP_REMOVE"] = "Are you sure you wish to remove %s from the team list?"

--------------------------
-- Message Locale
L["DEFAULT_CHAT_WINDOW"] = "Default Chat Window"
L["WHISPER"] = "Whisper"
L["PARTY"] = "Party" 
L["GUILD"] = "Guild"
L["GUILD_OFFICER"] = "Guild Officer"
L["RAID"] = "Raid"
L["RAID_WARNING"] = "Raid Warning"
L["MUTE"] = "MUTE"
L["DEFAULT_MESSAGE"] = "Default Message"
L["DEFAULT_WARNING"] = "Default Warning"
L["MUTE_POFILE"] = "Mute (Default)"
L["ADD_MSG_HELP"] = "Add's New Message Area"
L["REMOVE_MSG_HELP"] = "Remove's Message Area"
L["NAME"] = "Name"
L["PASSWORD"] = "Password"
L["AREA"]  = "Area On Screen"
L["SOUND_TO_PLAY"] = "Sound To Play"
L["SAVE"] = "Save"
L["STATICPOPUP_ADD_MSG"] = "Enter Name Of The Message Area To Add:"
L['Are you sure you wish to remove "%s" from the message area list?'] = true
L["MESSAGE_AREA_LIST"] = "Message Area List"
L["MESSAGE_AREA_CONFIGURATION"] = "Message Area Configuration"

--------------------------
-- Tag/Group Locale
L["ADD_TAG_HELP"]= "Add a Group To This Character."
L["REMMOVE_TAG_HELP"] = "Remove A Tag From This Character."
L["GROUP"] =  "Group"
L["BUTTON_TAG_ADD_HELP"] = "Adds A New Group To The List"
L["BUTTON_TAG_REMOVE_HELP"] = "Removes A Group From The List"
L["ADD_TO_GROUP"] = "Add To Group"
L["ADD_TO_GROUP_HELP"] = "Add Character To Group"
L["REMOVE_FROM_GROUP"] = "Remove From Group"
L["REMOVE_FROM_GROUP_HELP"] = "Remove Character From Group"
L["WRONG_TEXT_INPUT_GROUP"] = "Needs To Be In <Character-realm> <Group> Format"
L["NEW_GROUP_NAME"] = "Adds A New Group:"
L["Are You Sure You Wish To Remove %s From The Tag List?"] = true
--Note This need to be lowercase! 
--If translated Make Sure you keep them as a the lowercase words or you Will breck Group/Tag
--It be a headache i don't need -- Ebony
L["ALL_LOWER"] = "all"
L["MASTER_LOWER"] = "master"
L["MINION_LOWER"] = "minion"

--------------------------
-- Item-Use Locale
L["JAMBA-ITEM-USE"] = "Jamba-Item-Use"
L["ITEM"] = "Item"
L["HIDE_ITEM_BAR"] = "Hide Item Bar"
L["HIDE_ITEM_BAR_HELP"] = "Hide The Item Bar Panel."
L["SHOW_ITEM_BAR"] = "Show Item Bar"
L["SHOW_ITEM_BAR_HELP"] = "Show The Item Bar Panel."
L["CLEAR_ITEM_BAR"] = "Clear Item Bar"
L["CLEAR_ITEM_BAR_HELP"] = "Clear The Item Bar (Remove All Items)."
L["TOOLTIP_SYNCHRONISE"] = "Synchronise The Item-Use Bar"
L["TOOLTIP_NOLONGER_IN_BAGS"] = "Remove Items No Longer In Your Bags, From The Item Bar"
L["NEW_QUEST_ITEM"] = "New Item That Starts A Quest Found!"
L["ITEM_USE_OPTIONS"] = "Item Use Options"
L["SHOW_ITEM_BAR"] = "Shows The ItemBar"
L["SHOW_ITEM_BAR_HELP"] = "Shows The Jamba Item Use Bar"
L["ONLY_ON_MASTER"] = "Only On Master"
L["ONLY_ON_MASTER_HELP"] = "Only Shows On The Master Character"
L["KEEP_BARS_SYNCHRONIZED"] = "Keep Item Bars On Minions Synchronized"
--TODO WORK OUT WHAT THIS DOES AGAIN!
L["KEEP_BARS_SYNCHRONIZED_HELP"] = "Keep Item Bars On Minions Synchronized"
L["ADD_QUEST_ITEMS_TO_BAR"] = "Automatically Add Quest Items To Bar"
L["ADD_QUEST_ITEMS_TO_BAR_HELP"] = "Automatically Add's Useable Quest Items To Bar"
L["ADD_ARTIFACT_ITEMS"] = "Automatically Add ArtifactPower Tokens To Bar"
L["ADD_ARTIFACT_ITEMS_HELP"] = "Automatically Add ArtifactPower Tokens To Bar (Legion)"
L["ADD_SATCHEL_ITEMS"] = "Automatically Add Satchel Items To Bar"
L["ADD_SATCHEL_ITEMS_HELP"] = "Automatically Add Satchel Items To Bar ( Lootable Bags/Box's )"
L["HIDE_BUTTONS"] = "Hide Buttons"
L["HIDE_BUTTONS_HELP"] = "Hides The Top Buttons (Clear)"
L["HIDE_IN_COMBAT"] = "Hide In Combat" 
L["HIDE_IN_COMBAT_HELP_IU"] = "Hide Item Bar In Combat"
L["NUMBER_OF_ITEMS"] = "Number Of Items"
L["CLEAR_BUTT"] = "Clear"
L["SYNC_BUTT"] = "Sync"
L["ITEM_BAR_CLEARED"] = "Item Bar Cleared"
L["TEAM_BAGS"] = "Items In Team Bags"
L["BAG_BANK"] = "Bag (Banks)"

--------------------------
-- X Jamba-Sell
L["SELL"] = "Sell"
L["SELL_LIST"] = "Sell Item's List"
L["SELL_ALL"] = "Sell Item's On All Toons"
L["ALT_SELL_ALL"] = "Hold [Alt] While Selling An Item, To Sell On All Toons"
L["ALT_SELL_ALL_HELP"] = "Hold [Alt] Key While Selling An Item To The Vender, To Sell That Item On All Toons"
L["AUTO_SELL_ITEMS"] = "Automatically Sell Items"
L["AUTO_SELL_ITEMS_HELP"] = "Automatically Sell Items Below"
L["ONLY_SB"] = "Only SoulBound"
L["ONLY_SB_HELP"] = "Only Sell SoulBound Items"
L["iLVL"] = "Item Level"
L["iLVL_HELP"] = "Sell Items Below The Item Level"
L["SELL_GRAY"] = "Sell Gray Items"
L["SELL_GRAY_HELP"] = "Sell All Gray Items"
L["SELL_GREEN"] = "Sell Uncommon Items"
L["SELL_GREEN_HELP"] = "Sell All Uncommon(Green) Items"
L["SELL_RARE"] = "Sell Rare Items"
L["SELL_RARE_HELP"] = "Sell All Rare(Blue) Items"
L["SELL_EPIC"] = "Sell Epic Items"
L["SELL_EPIC_HELP"]	= "Sell All Epic(Purple) Items"
L["SELL_LIST_DROP_ITEM"] = "Sell Other Item (DRAG ITEM TO BOX)"
L["ITEM_TAG_ERR"] = "Item Tags Must Only Be Made Up Of Letters And Numbers."
L["POPUP_REMOVE_ITEM"] = "Are You Sure You Wish To Remove The Selected Item From The Auto Sell: Items List?"
L["ADD_TO_LIST"] = "Adds Item To List"
L["SELL_ITEMS"] = "Sell Items"
L["POPUP_DELETE_ITEM"] = "What You like to delete?"
L["I_HAVE_SOLD_X"] = function( temLink )
	return string.format("I Have Sold: %s", temLink )
end
L["I_SOLD_ITEMS_PLUS_GOLD"] = function( count )
	return string.format( "I have sold: %s Items And Made: ", count )
end	
L["DELETE_ITEM"] = function( bagItemLink )
	return string.format( "I Have DELETED: %s", bagItemLink )
end

--------------------------
-- X Interaction
L["TAXI"] = "Taxi"
L["TAXI_OPTIONS"] = "Taxi Options"
L["TAKE_TEAMS_TAXI"] = "Take Teams Taxi"
L["TAKE_TEAMS_TAXI_HELP"] = "Take The Same Flight As The Any Team Member \n(Other Team Members Must Have Npc Flight Master Window Open)."
L["REQUEST_TAXI_STOP"] = "Request Taxi Stop With Team"
L["REQUEST_TAXI_STOP_HELP"] = "[PH] REQUEST_TAXI_STOP_HELP"
L["CLONES_TO_TAKE_TAXI_AFTER"] = "Clones To Take Taxi After Leader"
--Mount
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
-- Loot
L["LOOT_OPTIONS"] = "Loot v2 Options"
L["DISMOUNT_WITH_CHARACTER"] = "Dismount With Character That Dismount"
L["ENABLE_AUTO_LOOT"] = "Enable Auto"
L["ENABLE_AUTO_LOOT_HELP"] = "Old Jambas Advanced Loot \Nbut Better"
L["TELL_TEAM_BOE_RARE"] = "Tell Team BoE Rare"
L["TELL_TEAM_BOE_RARE_HELP"] = "Tell The Team If I Loot A Boe Rare"
L["TELL_TEAM_BOE_EPIC"] = "Tell Team Boe Epic"
L["TELL_TEAM_BOE_EPIC_HELP"] = "Tell The Team If I Loot A Boe Epic"
L["I_HAVE_LOOTED_X_Y_ITEM"] = function( rarity, itemName )
	return string.format( "I Have Looted A %q BoE Item: %s .", rarity, itemName )
end
L["EPIC"] = "Epic"
L["RARE"] = "Rare"
L["REQUESTED_STOP_X"] = function( sender )
	return string.format( "I Have Requested a Stop From %s", sender )
end
L["SETTINGS_RECEIVED_FROM_A"] = function( characterName )
	return "Settings Received From "..characterName.."."
end
L["I_AM_UNABLE_TO_FLY_TO_A"] = function( nodename )
	return string.format( "I Am Unable To Fly To %s .", nodename )
end
--------------------------
-- X Locale
L["JAMBA_CURRENCY"] = "Jamba Currency"
L["SHOW_CURRENCY"] = "Show Currency"
L["SHOW_CURRENCY_HELP"] = "Show The Currency Frame Window."
L["HIDE_CURRENCY"] = "Hide Currency"
L["HIDE_CURRENCY_HELP"] = "Hide The Currency Values For All Members In The Team."
L["CURRENCY_HEADER"] = "Currency Selection To Show On Frame"
L["GOLD"] = "Gold"
L["GOLD_HELP"] = "Shows The Minions Gold"
L["GOLD_GB"] = "Include Gold In Guild Bank"
L["GOLD_GB_HELP"] = "Show Gold In Guild Bank\n(This Does Not Update Unless You Visit The Guildbank)"
L["CURR_STARTUP"] = "Open Currency List On Start Up"
L["CURR_STARTUP_HELP"] = "Open Currency List On Start Up.\nThe Master Only)"
L["LOCK_CURR_LIST"] = "Lock The Currency List Frame"
L["LOCK_CURR_LIST_HELP"] = "Lock's The Currency List Frame And Enables Mouse Click-Through"
L["SPACE_FOR_NAME"] = "Space For Name"
L["SPACE_FOR_GOLD"] =  "Space For Name"
L["SPACE_FOR_POINTS"] = "Space For Points"
L["SPACE_BETWEEN_VALUES"] = "Space Between Values"
L["TOTAL"] = "Total"
L["CURR"] = "Curr"
L["UPDATE"] = "Update"

--------------------------
-- Display Team Locale
L["JAMBA_TEAM"] = "Jamba Team"
L["HIDE_TEAM_DISPLAY"] = "Hide Team Display"
L["HIDE_TEAM_DISPLAY_HELP"] = "Hide The Display Team Panel."
L["SHOW_TEAM_DISPLAY"] = "Show Team Display"
L["SHOW_TEAM_DISPLAY_HELP"] = "Show The Display Team Panel."
L["DISPLAY_HEADER"] = "Display Team Options"
L["SHOW"] = "Show"
L["SHOW_TEAM_FRAME"] = "Show Team Frame"
L["SHOW_TEAM_FRAME_HELP"] = "Show Jamba Team Frame List"
L["HIDE_IN_COMBAT_HELP_DT"] = "Hides The TeamFrame In Combat"
L["ENABLE_CLIQUE"] = "Enable Clique Support"
L["ENABLE_CLIQUE_HELP"] = "Enable Clique Support\n([/Reload Ui] To Take Effect)"
L["SHOW_PARTY"] = "Only Show Party Members"
L["SHOW_PARTY_HELP"] = "Only Show Party Team Members"
L["HEALTH_POWER_GROUP"] = "Health & Power Out of Group"
L["HEALTH_POWER_GROUP_HELP"] = "Update Health and Power Out Of Groups\nUse Guild Communications!"
L["SHOW_TITLE"] = "Show Title on Frame"
L["SHOW_TITLE_HELP"] = "Show Team List Title on Display Team Frame"
L["STACK_VERTICALLY"] = "Stack Bars Vertically"
L["STACK_VERTICALLY_HELP"] = "Stack Display Team Frame Bars Vertically"
L["CHARACTERS_PER_BAR"] = "Number of Characters Per Row"
L["SHOW_CHARACTER_PORTRAIT"] = "Shows Characters Portraits"
L["SHOW_FOLLOW_BAR"] = "Shows the Follow Bar and Character Name"
L["SHOW_NAME"] = "Show Character Name"
L["SHOW_XP_BAR"] = "Show the Team Experience bar\n\nAnd Artifact XP Bar\nAnd Honor XP Bar\nAnd Reputation Bar"
L["VALUES"] = "Values"
L["VALUES_HELP"] = "Show Values"
L["PERCENTAGE"] = "Percentage"
L["PERCENTAGE_HELP"] = "Show Percentage"
L["SHOW_XP"] = "Experience Bar"
L["SHOW_XP_HELP"] = "Show the Team Experience bar"
L["ARTIFACT_BAR"] = "Artifact Bar"
L["ARTIFACT_BAR_HELP"] = "Show the Team Artifact Experience bar"
L["HONORXP"] = "Show Honor Bar"
L["HONORXP_HELP"] = "Show the Team Honor Experience Bar"
L["REPUTATION_BAR"] = "Show Reputation Bar"
L["REPUTATION_BAR_HELP"] = "Show the Team Reputation Bar" 
L["SHOW_HEALTH"] = "Show the Teams Health Bars"
L["SHOW_CLASS_COLORS"] = "Show Class Colors"
L["SHOW_CLASS_COLORS_HELP"] = "Show class Coulor on Health Bars"
L["POWER_HELP"] = "Show the Team Power Bar\n\nMana, Rage, Etc..."
L["CLASS_POWER"] = "Show the Teams Class Power Bar\n\nComboPoints\nSoulShards\nHoly Power\nRunes"
L["DEAD"] = "Dead"
L["PORTRAIT_HEADER"] = "Portrait"
L["FOLLOW_BAR_HEADER"] = "Follow Status Bar"
L["EXPERIENCE_HEADER"] = "Experience Bars"
L["HEALTH_BAR_HEADER"] = "Health Bar"
L["POWER_BAR_HEADER"] = "Power Bar"
L["CLASS_BAR_HEADER"] = "Class Power Bar"

--------------------------
-- X Follow
L["FOLLOW_BROKEN_MSG"] = "Follow Borken!"
L["FOLLOW_MASTER"] = "Follow The Master <Group>"
L["FOLLOW_MASTER_HELP"] = "Follow The Master Currebt Master (Group)"
L["FOLLOW_TARGET"] = "Follow A Target <TargetName>"
L["FOLLOW_TARGET_HELP"] = "Follow The Specified Target (Group)"
L["FOLLOW_AFTER_COMBAT"] = "Auto Folllow After Combat"
L["FOLLOW_AFTER_COMBAT_HELP"] = "Automatically Follow After Combat"
L["DELAY_FOLLOW_AFTER_COMBAT"] = "Delay_Follow_After_Combat (S)"
L["DELAY_FOLLOW_AFTER_COMBAT_HELP"] = "Delay_Follow_After_Combat In Seconds"
L["FOLLOW_STROBING"] = "Begin Follow Strobing <TargetName>"
L["FOLLOW_STROBING_HELP"] = "Begin A Sequence Of Follow Commands That Strobe Every Second (Configurable) A Specified Target."
L["FOLLOW_STROBING_ME"] = "Begin Follow Strobing Me"
L["FOLLOW_STROBING_ME_HELP"] = "Begin A Sequence Of Follow Commands That Strobe Every Second (Configurable) This Character"
L["FOLLOW_STROBING_END"] = "Ends Follow Strobing"
L["FOLLOW_STROBING_END_HELP"] = "Ends Follow Strobing On All Characters" 
L["FOLLOW_SET_MASTER"] = "Sets Follow By Name"
L["FOLLOW_SET_MASTER_HELP"] = "Sets Follow By Name"
L["TRAIN"] = "Makes All Characters Follow In A Train"
L["TRAIN_HELP"] = "Makes All Characters Follow In A Train Behind Each Other"
L["SNW"] = "Snw"
L["SNW_HELP"] = "Suppress Next Warning"
L["TIME_DELAY_FOLLOWING"] = "Seconds To Delay Before Following After Combat"
L["DIFFERENT_TOON_FOLLOW"] = "Use Different Character For Follow"
L["DIFFERENT_TOON_FOLLOW_HELP"] = "Use Different Character Below For Follow"
L["NEW_FOLLOW_MASTER"] = "New Follow Character"
L["FOLLOW_BROKEN_WARNING"] = "Follow Broken Warning"
L["WARN_STOP_FOLLOWING"] = "Warn If I Stop Following"
L["WARN_STOP_FOLLOWING_HELP"] = "Tell The Master If A Character Stops Following"
L["ONLY_IF_OUTSIDE_RANGE"] = "Only Warn If Outside Follow Range"
L["ONLY_IF_OUTSIDE_RANGE_HELP"] = "Only Warn If Character Is Outside Follow Range"
L["FOLLOW_BROKEN_MESSAGE"] = "Follow Broken Custom Message"
L["DO_NOT_WARN"] = "Do Not Warn If"
L["IN_COMBAT"] = "In Combat"
L["ANY_MEMBER_IN_COMBAT"] = "Any Member In Combat"
L["FOLLOW_STROBING"] = "Follow Strobing"
L["FOLLOW_STROBING_AJM_FOLLOW_COMMANDS."] = "Follow Strobing Is Controlled By /Jamba-Follow Commands."
L["USE_MASTER_STROBE_TARGET"] = "Always Use Master As The Strobe Target"
L["PAUSE_FOLLOW_STROBING"] = "Pause Follow Strobing If ...."
L["DRINKING_EATING"] = "Drinking/Eating"
L["IN_A_VEHICLE"] = "In A Vehicle"
L["GROUP_FOLLOW_STROBE"] = "Group For Follow Strobe"
L["FREQUENCY"] = "Frequency (S)"
L["FREQUENCY_COMABT"] = "Frequency In Combat (S)"
L["ON"] = "On"
L["OFF"] = "Off"
L["DRINK"] = "Drink"
L["FOOD"] = "Food"
L["REFRESHMENT"] = "Refreshment"

--------------------------
-- Vender/Purchase Locale.
L["AUTO_BUY_ITEMS"] = "Auto Buy Items"
L["OVERFLOW"] = "Overflow"
L["REMOVE_VENDER_LIST"] = "Remove From Vender List"
L["ITEM_DROP"] = "Item (Drag Item To Box From Your Bags)"
L["PURCHASE_ITEMS"] = "Auto Purchase Items"
L["ADD_ITEM"] = "Add Item"
L["AMOUNT"] = "Amount"
L["PURCHASE_MSG"] = "Purchase Messages"
L["ITEM_ERROR"] = "Item Tags Must Only Be Made Up Of Letters And Numbers."
L["NUM_ERROR"] = "Amount To Buy Must Be A Number."
L["BUY_POPUP_ACCEPT"] = "Are You Sure You Wish To Remove The Selected Item From The Auto Buy Items List?"
L["ERROR_BAGS_FULL"] =  "I Do Not Have Enough Space In My Bags To Complete My Purchases."
L["ERROR_GOLD"] = "I Do Not Have Enough Money To Complete My Purchases." 
L["ERROR_CURR"] = "I Do Not Have Enough Other Currency To Complete My Purchases."

--------------------------
-- Trade Locale
L["REMOVE_TRADE_LIST"] = "Are You Sure You Wish To Remove The Selected Item From The Trade Items List?"
L["TRADE_LIST_HEADER"] = "Trade Item List"
L["TRADE_LIST"] = "Trade The List Of Items With Master"
L["TRADE_LIST_HELP"] = "The List Will Trade With The Current Masster \nGroups Do not Currently Work"
L["TRADE_BOE_ITEMS"] = "Trades Binds When Equipped Items With Master"
L["TRADE_BOE_ITEMS_HELP"] = "Trade All Boe Items With The Current Master"
L["TRADE_REAGENTS"] = "Trades Crafting Reagents Items With Master"
L["TRADE_REAGENTS_HELP"] = "Trades All Crafting Reagents Items Current Master"
L["TRADE_OPTIONS"] = "Trade Master Options"
L["TRADE_GOLD"] = "Trade Excess Gold To Master From Minion"
L["TRADE_GOLD_HELP"] = "Trade Excess Gold To Master From Minions \nAlways Be Careful When Auto Trading."
L["GOLD_TO_KEEP"] = "Amount of Gold To Keep On Current Minion"
L["TRADE_TAG_ERR"] = "Item Tags Must Only Be Made Up Of Letters And Numbers."
L["ERR_WILL_NOT_TRADE"] = "Is Not A Member Of The Team, Will Not Trade Items."
L["ADD_ITEMS"] = "Add Items"

-- PH
L["GB_OPTIONS"] = "[PH]:Guild Bank Options"
L["TRADE_GB"] = "[PH]:Adjust Characters Money While Visiting A Guild Bank"
L["TRADE_GB_HELP"] = "[PH]Adjust Characters Money While Visiting A Guild Bank \nThis Is a PlaceHolder And Will Be Moved"


--------------------------
-- X Locale