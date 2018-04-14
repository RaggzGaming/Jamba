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
L["PUSH_SETTINGS"] = "Push Settings"
L["PUSH_ALL_SETTINGS"] = "Push All Settings"
L["PUSH_SETTINGS_INFO"] = "Push Settings To Team Members" 
L["MINION"] = "Minion"
L["MASTER"] = "Master"
L["ALL"] = "All"

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

--------------------------
-- ALL String_Formats
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
L["CHECKBOX_ISBOXER_SYNC_HELP"] = "Sync With Isboxer TeamList \nAdd/Remove Character's No Longer In Isboxer Team"
L["MASTER_CONTROL"] = "Master Control"
L["CHECKBOX_MASTER_LEADER"] = "Promote Master To Party Leader."
L["CHECKBOX_MASTER_LEADER_HELP"] = "Master Will Always Be The Party Leader."
L["CHECKBOX_CTM"] = "Sets Click-To-Move On Minions"
L["CHECKBOX_CTM_HELP"] = "Auto Activate Click-To-Move On Minions And Deactivate On Master."
L["PARTY_CONTROLS"] = "Party Invitations Control"
L["CHECKBOX_CONVERT_RAID"] = "Auto Convert To Raid"
L["CHECKBOX_CONVERT_RAID_HELP"] = "Auto Convert To Raid If Team Is Over Five Character's"
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
L["MESSAGE_AREA"] = "Message Area Type"
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
-- X Locale


