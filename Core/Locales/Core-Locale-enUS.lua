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
L["PUSH_SETTINGS"] = "Push Settings"
L["PUSH_SETTINGS_INFO"] = "Push Settings To Online Team"


L["SETTINGS_RECEIVED_FROM_A."] = function( characterName )
	return "Settings Received From "..characterName.."."
end


-- Modules
L["NEWS"] = "News"
L["OPTIONS"] = "Options"
L["SETUP"] = "Setup" 
L["PROFILES"] = "Profiles"
L["TEAM"] = "Team"
L["COMMUNICATIONS"] = "Communications"

--------------------------
-- Core
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
L["TEXT3"] = "Thanks For Being A Beta Tester Of This Build"
L["TEXT4"] = ""
L["TEXT5"] = "If you Have any bugs report them to LINK"
L["TEXT6"] = ""
L["TEXT7"] = "Thanks so much for Making Jamba-EE Great!"
L["TEXT8"] = ""
L["TEXT9"] = ""
L["TEXT10"] = ""

L["SPECIAL_THANKS"] = "Special Thanks:"
L["THANKS1"] = "Michael Jafula Miller -2015"
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
-- Communications

L["A: Failed to deserialize command arguments for B from C."] = function( libraryName, moduleName, sender )
	return libraryName..": Failed to deserialize command arguments for "..moduleName.." from "..sender.."."
end
L["AUTO_SET_TEAM"] = "Auto Set Team Members On and Off Line"
L["BOOST_COMMUNICATIONS"] = "Boost Jamba to Jamba Communications"
L["BOOST_COMMUNICATIONS_HELP"] = "Reload Ui To Take Effect, May Cause Disconnections"
L["USE_GUILD_COMMS"] = "Use Guild Communications"
L["USE_GUILD_COMMS_INFO"] = "Use Guild Communications All Of Team Needs To Be In Same Guild" 

----------------------------
-- Helper Settings
L["COMMANDS"] = "Commands"
L["SLASH_COMMANDS"] = "Slash Commands"
