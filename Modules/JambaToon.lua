-- ================================================================================ --
--				Jamba EE - ( The Awesome MultiBoxing Assistant Ebony's Edition )    --
--				Current Author: Jennifer Cally (Ebony)								--
--				Copyright 2015 - 2018 Jennifer Cally "Ebony"						--
--																					--
--				License: The MIT License (MIT)										--
--				Copyright (c) 2008-2015  Michael "Jafula" Miller					--
--																					--
-- ================================================================================ --

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaToon", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceHook-3.0",
	"AceTimer-3.0"
)

-- Get the Jamba Utilities Library.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )
local LibBagUtils = LibStub:GetLibrary( "LibBagUtils-1.0" )
AJM.SharedMedia = LibStub( "LibSharedMedia-3.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Toon"
AJM.settingsDatabaseName = "JambaToonProfileDB"
AJM.chatCommand = "jamba-toon"
local L = LibStub( "AceLocale-3.0" ):GetLocale( "Core" )
AJM.parentDisplayName = L["TOON"]
AJM.parentDisplayNameToon = L["TOON"]
AJM.parentDisplayNameMerchant = L["VENDER"]
AJM.moduleDisplayName = L["TOON"]
-- Icon 
AJM.moduleIcon = "Interface\\Addons\\Jamba\\Media\\Toon.tga"
AJM.moduleIconWarnings = "Interface\\Addons\\Jamba\\Media\\WarningIcon.tga"
AJM.moduleIconRepair = "Interface\\Addons\\Jamba\\Media\\moduleIconRepair.tga"
-- order
AJM.moduleOrder = 40


-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		warnHitFirstTimeCombat = false,
		hitFirstTimeMessage = L["ATTACKED"],
		warnTargetNotMasterEnterCombat = false,
		warnTargetNotMasterMessage = L["TARGETING"],
		warnFocusNotMasterEnterCombat = false,
		warnFocusNotMasterMessage = L["FOCUS"],
		warnWhenHealthDropsBelowX = true,
		warnWhenHealthDropsAmount = "30",
		warnHealthDropsMessage = L["LOW_HEALTH"],
		warnWhenManaDropsBelowX = true,
		warnWhenManaDropsAmount = "30",
		warnManaDropsMessage = L["LOW_MANA"],
		warnBagsFull = true,
		bagsFullMessage = L["BAGS_FULL"],	
		warnCC = true,
		CcMessage = L["CCED"],
		warningArea = JambaApi.DefaultWarningArea(),
		autoAcceptResurrectRequest = true,
		acceptDeathRequests = true,
		autoDenyDuels = true,
		autoAcceptSummonRequest = false,
		autoDenyGuildInvites = false,
		requestArea = JambaApi.DefaultMessageArea(),
		autoRepair = true,
		autoRepairUseGuildFunds = true,
		merchantArea = JambaApi.DefaultMessageArea(),
		autoAcceptRoleCheck = false,
		enterLFGWithTeam = false,
		acceptReadyCheck = false,
		teleportLFGWithTeam = false,
		rollWithTeam = false,
		--Debug Suff
		testAlwaysOff = true
	},
}

-- Configuration.
function AJM:GetConfiguration()
	local configuration = {
		name = AJM.moduleDisplayName,
		handler = AJM,
		type = 'group',
		args = {
				push = {
				type = "input",
				name = L["PUSH_SETTINGS"],
				desc = L["PUSH_ALL_SETTINGS"],
				usage = "/jamba-toon push",
				get = false,
				set = "JambaSendSettings",
			},											
		},
	}
	return configuration
end

local function DebugMessage( ... )
	--AJM:Print( ... )
end

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------

AJM.COMMAND_TEAM_DEATH = "JambaToonTeamDeath"
AJM.COMMAND_RECOVER_TEAM = "JambaToonRecoverTeam"
AJM.COMMAND_SOUL_STONE = "JambaToonSoulStone"
AJM.COMMAND_READY_CHECK = "JambaReadyCheck"
AJM.COMMAND_TELE_PORT = "Jambateleport"
AJM.COMMAND_LOOT_ROLL = "JamabaLootRoll"

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Variables used by module.
-------------------------------------------------------------------------------------------------------------

AJM.sharedInvData = {}


-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateMerchant( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local thirdWidth = (headingWidth - (horizontalSpacing * 2)) / 3
	local column2left = left + halfWidth
	local left2 = left + thirdWidth
	local left3 = left + (thirdWidth * 2)
	local movingTop = top
	-- A blank to get layout to show right?
	JambaHelperSettings:CreateHeading( AJM.settingsControlMerchant, "", movingTop, false )
	movingTop = movingTop - headingHeight	
	JambaHelperSettings:CreateHeading( AJM.settingsControlMerchant, L["VENDOR"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlMerchant.checkBoxAutoRepair = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlMerchant, 
		headingWidth, 
		left, 
		movingTop, 
		L["AUTO_REPAIR"],
		AJM.SettingsToggleAutoRepair,
		L["AUTO_REPAIR_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlMerchant.checkBoxAutoRepairUseGuildFunds = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlMerchant, 
		headingWidth, 
		left, 
		movingTop, 
		L["REPAIR_GUILD_FUNDS"],
		AJM.SettingsToggleAutoRepairUseGuildFunds,
		L["REPAIR_GUILD_FUNDS_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlMerchant.dropdownMerchantArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControlMerchant, 
		headingWidth, 
		left, 
		movingTop, 
		L["MESSAGE_AREA"]
	)
	AJM.settingsControlMerchant.dropdownMerchantArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlMerchant.dropdownMerchantArea:SetCallback( "OnValueChanged", AJM.SettingsSetMerchantArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing				
	return movingTop	
end

function AJM:OnMessageAreasChanged( message )
	AJM.settingsControlMerchant.dropdownMerchantArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlToon.dropdownRequestArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlWarnings.dropdownWarningArea:SetList( JambaApi.MessageAreaList() )
end

function AJM:OnCharactersChanged()
	AJM:SettingsRefresh()
end

local function SettingsCreateToon( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local thirdWidth = (headingWidth - (horizontalSpacing * 2)) / 3
	local column2left = left + halfWidth
	local left2 = left + thirdWidth
	local left3 = left + (thirdWidth * 2)
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControlToon, L["REQUESTS"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlToon.checkBoxAutoDenyDuels = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlToon, 
		halfWidth, 
		left, 
		movingTop, 
		L["DENY_DUELS"],
		AJM.SettingsToggleAutoDenyDuels,
		L["DENY_DUELS_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlToon.checkBoxAutoDenyGuildInvites = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlToon, 
		halfWidth, 
		left, 
		movingTop, 
		L["DENY_GUILD_INVITES"],
		AJM.SettingsToggleAutoDenyGuildInvites,
		L["DENY_GUILD_INVITES_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlToon.checkBoxAutoAcceptResurrectRequest = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlToon, 
		halfWidth, 
		left, 
		movingTop, 
		L["ACCEPT_RESURRECT"],
		AJM.SettingsToggleAutoAcceptResurrectToon,
		L["ACCEPT_RESURRECT_AUTO"]
	)
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlToon.checkBoxAcceptDeathRequests = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlToon, 
		halfWidth, 
		left, 
		movingTop, 
		L["RELEASE_PROMPTS"],
		AJM.SettingsToggleAcceptDeathRequests,
		L["RELEASE_PROMPTS_HELP"]
	)
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlToon.checkBoxAutoAcceptSummonRequest = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlToon, 
		halfWidth, 
		left, 
		movingTop, 
		L["SUMMON_REQUEST"],
		AJM.SettingsToggleAutoAcceptSummonRequest,
		L["SUMMON_REQUEST_HELP"]
	)
	movingTop = movingTop - checkBoxHeight			
	JambaHelperSettings:CreateHeading( AJM.settingsControlToon, L["GROUPTOOLS_HEADING"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlToon.checkBoxAutoRoleCheck = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlToon, 
		halfWidth, 
		left, 
		movingTop, 
		L["ROLE_CHECKS"],
		AJM.SettingsToggleAutoRoleCheck,
		L["ROLE_CHECKS_HELP"]
	)		
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlToon.checkBoxAcceptReadyCheck = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlToon, 
		halfWidth, 
		left, 
		movingTop,
		L["READY_CHECKS"],
		AJM.SettingsToggleAcceptReadyCheck,
		L["READY_CHECKS_HELP"]
	)
 	movingTop = movingTop - checkBoxHeight
 	AJM.settingsControlToon.checkBoxLFGTeleport = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlToon, 
		halfWidth, 
		left, 
		movingTop,
		L["LFG_Teleport"],
		AJM.SettingsToggleLFGTeleport,
		L["LFG_Teleport_HELP"]
	)
 	movingTop = movingTop - checkBoxHeight
 	AJM.settingsControlToon.checkBoxLootWithTeam = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlToon, 
		halfWidth, 
		left, 
		movingTop,
		L["ROLL_LOOT"],
		AJM.SettingsToggleLootWithTeam,
		L["ROLL_LOOT_HELP"]
	)
	movingTop = movingTop - checkBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControlToon, L["MESSAGES_HEADER"], movingTop, false )
	movingTop = movingTop - dropdownHeight - verticalSpacing
 	AJM.settingsControlToon.dropdownRequestArea = JambaHelperSettings:CreateDropdown( 
	AJM.settingsControlToon, 
		headingWidth, 
		left, 
		movingTop, 
		L["MESSAGE_AREA"]
	)
	AJM.settingsControlToon.dropdownRequestArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlToon.dropdownRequestArea:SetCallback( "OnValueChanged", AJM.SettingsSetRequestArea )	
	return movingTop	
end

local function SettingsCreateWarnings( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( true )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local thirdWidth = (headingWidth - (horizontalSpacing * 2)) / 3
	local column2left = left + halfWidth
	local left2 = left + thirdWidth
	local left3 = left + (thirdWidth * 2)
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["COMBAT"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControlWarnings.checkBoxWarnHitFirstTimeCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["WARN_HIT"],
		AJM.SettingsToggleWarnHitFirstTimeCombat,
		L["WARN_HIT_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["WARN_HIT"]
	)	
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedHitFirstTimeMessage )

	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.checkBoxWarnTargetNotMasterEnterCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["TARGET_NOT_MASTER"],
		AJM.SettingsToggleWarnTargetNotMasterEnterCombat,
		L["TARGET_NOT_MASTER_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["TARGETING"]
	)	
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnTargetNotMasterMessage )

	movingTop = movingTop - editBoxHeight	
	AJM.settingsControlWarnings.checkBoxWarnFocusNotMasterEnterCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["FOCUS_NOT_MASTER"],
		AJM.SettingsToggleWarnFocusNotMasterEnterCombat,
		L["FOCUS_NOT_MASTER_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["FOCUS"]
	)	
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnFocusNotMasterMessage )
	movingTop = movingTop - editBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["HEALTH_POWER"], movingTop, true )
	movingTop = movingTop - headingHeight	
	AJM.settingsControlWarnings.checkBoxWarnWhenHealthDropsBelowX = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["HEALTH_DROPS_BELOW"],
		AJM.SettingsToggleWarnWhenHealthDropsBelowX,
		L["HEALTH_DROPS_BELOW_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["HEALTH_PERCENTAGE"]
	)	
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnWhenHealthDropsAmount )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["LOW_HEALTH"]
	)	
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnHealthDropsMessage )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.checkBoxWarnWhenManaDropsBelowX = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["MANA_DROPS_BELOW"],
		AJM.SettingsToggleWarnWhenManaDropsBelowX,
		L["MANA_DROPS_BELOW_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["MANA_PERCENTAGE"]
	)	
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnWhenManaDropsAmount )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["LOW_MANA"]
	)	
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnManaDropsMessage )
	movingTop = movingTop - editBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["BAG_SPACE"], movingTop, true )
	movingTop = movingTop - headingHeight
    AJM.settingsControlWarnings.checkBoxWarnBagsFull = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["BAGS_FULL"],
		AJM.SettingsToggleWarnBagsFull,
		L["BAGS_FULL_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxBagsFullMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["BAGS_FULL"]
	)	
	AJM.settingsControlWarnings.editBoxBagsFullMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedBagsFullMessage )
	movingTop = movingTop - editBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["OTHER"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControlWarnings.checkBoxWarnCC = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["WARN_IF_CC"],
		AJM.SettingsToggleWarnCC,
		L["WARN_IF_CC_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxCCMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["CCED"]
	)
	AJM.settingsControlWarnings.editBoxCCMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedCCMessage )
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControlWarnings.dropdownWarningArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["SEND_WARNING_AREA"] 
	)
	AJM.settingsControlWarnings.dropdownWarningArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlWarnings.dropdownWarningArea:SetCallback( "OnValueChanged", AJM.SettingsSetWarningArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing		
	return movingTop	
end

local function SettingsCreate()
	AJM.settingsControlToon = {}
	AJM.settingsControlWarnings = {}
	AJM.settingsControlMerchant = {}
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlToon,
		AJM.moduleDisplayName, 
		AJM.parentDisplayNameToon, 
		AJM.SettingsPushSettingsClick,
		AJM.moduleIcon,
		AJM.moduleOrder
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlWarnings,
		L["WARNINGS"],
		AJM.parentDisplayNameToon, 
		AJM.SettingsPushSettingsClick,
		AJM.moduleIconWarnings
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlMerchant, 
		L["REPAIR"], 
		AJM.parentDisplayNameMerchant, 
		AJM.SettingsPushSettingsClick,
		AJM.moduleIconRepair		
	)
	local bottomOfToon = SettingsCreateToon( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlToon.widgetSettings.content:SetHeight( -bottomOfToon )
	local bottomOfWarnings = SettingsCreateWarnings( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlWarnings.widgetSettings.content:SetHeight( -bottomOfWarnings)
	local bottomOfMerchant = SettingsCreateMerchant( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlMerchant.widgetSettings.content:SetHeight( -bottomOfMerchant )	
	-- Help
	local helpTable = {}
	JambaHelperSettings:CreateHelp( AJM.settingsControlWarnings, helpTable, AJM:GetConfiguration() )		
end

-------------------------------------------------------------------------------------------------------------
-- Settings Populate.
-------------------------------------------------------------------------------------------------------------

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	AJM.settingsControlWarnings.checkBoxWarnHitFirstTimeCombat:SetValue( AJM.db.warnHitFirstTimeCombat )
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage:SetText( AJM.db.hitFirstTimeMessage )
	AJM.settingsControlWarnings.checkBoxWarnTargetNotMasterEnterCombat:SetValue( AJM.db.warnTargetNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage:SetText( AJM.db.warnTargetNotMasterMessage )
	AJM.settingsControlWarnings.checkBoxWarnFocusNotMasterEnterCombat:SetValue( AJM.db.warnFocusNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage:SetText( AJM.db.warnFocusNotMasterMessage )
	AJM.settingsControlWarnings.checkBoxWarnWhenHealthDropsBelowX:SetValue( AJM.db.warnWhenHealthDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount:SetText( AJM.db.warnWhenHealthDropsAmount )
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage:SetText( AJM.db.warnHealthDropsMessage )
	AJM.settingsControlWarnings.checkBoxWarnWhenManaDropsBelowX:SetValue( AJM.db.warnWhenManaDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount:SetText( AJM.db.warnWhenManaDropsAmount )
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage:SetText( AJM.db.warnManaDropsMessage )
	AJM.settingsControlWarnings.checkBoxWarnBagsFull:SetValue( AJM.db.warnBagsFull )
	AJM.settingsControlWarnings.editBoxBagsFullMessage:SetText( AJM.db.bagsFullMessage )
	AJM.settingsControlWarnings.checkBoxWarnCC:SetValue( AJM.db.warnCC )
	AJM.settingsControlWarnings.editBoxCCMessage:SetText( AJM.db.CcMessage ) 
	AJM.settingsControlWarnings.dropdownWarningArea:SetValue( AJM.db.warningArea )
	AJM.settingsControlToon.checkBoxAutoAcceptResurrectRequest:SetValue( AJM.db.autoAcceptResurrectRequest )
	AJM.settingsControlToon.checkBoxAcceptDeathRequests:SetValue( AJM.db.acceptDeathRequests )
	AJM.settingsControlToon.checkBoxAutoDenyDuels:SetValue( AJM.db.autoDenyDuels )
	AJM.settingsControlToon.checkBoxAutoAcceptSummonRequest:SetValue( AJM.db.autoAcceptSummonRequest )
	AJM.settingsControlToon.checkBoxAutoDenyGuildInvites:SetValue( AJM.db.autoDenyGuildInvites )
	AJM.settingsControlToon.checkBoxAutoRoleCheck:SetValue( AJM.db.autoAcceptRoleCheck )
	AJM.settingsControlToon.checkBoxAcceptReadyCheck:SetValue( AJM.db.acceptReadyCheck )
	AJM.settingsControlToon.checkBoxLFGTeleport:SetValue( AJM.db.teleportLFGWithTeam )
	AJM.settingsControlToon.checkBoxLootWithTeam:SetValue( AJM.db.rollWithTeam )
	AJM.settingsControlToon.dropdownRequestArea:SetValue( AJM.db.requestArea )
	AJM.settingsControlMerchant.checkBoxAutoRepair:SetValue( AJM.db.autoRepair )
	AJM.settingsControlMerchant.checkBoxAutoRepairUseGuildFunds:SetValue( AJM.db.autoRepairUseGuildFunds )
	AJM.settingsControlMerchant.dropdownMerchantArea:SetValue( AJM.db.merchantArea )
	-- Set state.
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage:SetDisabled( not AJM.db.warnHitFirstTimeCombat )
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage:SetDisabled( not AJM.db.warnTargetNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage:SetDisabled( not AJM.db.warnFocusNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount:SetDisabled( not AJM.db.warnWhenHealthDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage:SetDisabled( not AJM.db.warnWhenHealthDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount:SetDisabled( not AJM.db.warnWhenManaDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage:SetDisabled( not AJM.db.warnWhenManaDropsBelowX )
	AJM.settingsControlMerchant.checkBoxAutoRepairUseGuildFunds:SetDisabled( not AJM.db.autoRepair )
	AJM.settingsControlWarnings.editBoxBagsFullMessage:SetDisabled( not AJM.db.warnBagsFull )
	AJM.settingsControlWarnings.editBoxCCMessage:SetDisabled( not AJM.db.warnCC )
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsToggleAutoRepair( event, checked )
	AJM.db.autoRepair = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoRepairUseGuildFunds( event, checked )
	AJM.db.autoRepairUseGuildFunds = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoDenyDuels( event, checked )
	AJM.db.autoDenyDuels = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoAcceptSummonRequest( event, checked )
	AJM.db.autoAcceptSummonRequest = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoDenyGuildInvites( event, checked )
	AJM.db.autoDenyGuildInvites = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoAcceptResurrectRequests( event, checked )
	AJM.db.autoAcceptResurrectRequest = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAcceptDeathRequests( event, checked )
	AJM.db.acceptDeathRequests = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoRoleCheck( event, checked )
	AJM.db.autoAcceptRoleCheck = checked
	AJM:SettingsRefresh()
end


function AJM:SettingsToggleAcceptReadyCheck( event, checked )
	AJM.db.acceptReadyCheck = checked 	
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleLFGTeleport( event, checked )
	AJM.db.teleportLFGWithTeam = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleLootWithTeam( event, checked )
	AJM.db.rollWithTeam = checked
	AJM:SettingsRefresh()
end

-- Warnings Toggles

function AJM:SettingsToggleWarnHitFirstTimeCombat( event, checked )
	AJM.db.warnHitFirstTimeCombat = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedHitFirstTimeMessage( event, text )
	AJM.db.hitFirstTimeMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnBagsFull( event, checked )
	AJM.db.warnBagsFull = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedBagsFullMessage( event, text )
	AJM.db.bagsFullMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnCC( event, checked )
	AJM.db.warnCC = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedCCMessage( event, text )
	AJM.db.CcMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnTargetNotMasterEnterCombat( event, checked )
	AJM.db.warnTargetNotMasterEnterCombat = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnTargetNotMasterMessage( event, text )
	AJM.db.warnTargetNotMasterMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnFocusNotMasterEnterCombat( event, checked )
	AJM.db.warnFocusNotMasterEnterCombat = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnFocusNotMasterMessage( event, text )
	AJM.db.warnFocusNotMasterMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnWhenHealthDropsBelowX( event, checked )
	AJM.db.warnWhenHealthDropsBelowX = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnWhenHealthDropsAmount( event, text )
	local amount = tonumber( text )
	amount = JambaUtilities:FixValueToRange( amount, 0, 100 )
	AJM.db.warnWhenHealthDropsAmount = tostring( amount )
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnHealthDropsMessage( event, text )
	AJM.db.warnHealthDropsMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnWhenManaDropsBelowX( event, checked )
	AJM.db.warnWhenManaDropsBelowX = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnWhenManaDropsAmount( event, text )
	local amount = tonumber( text )
	amount = JambaUtilities:FixValueToRange( amount, 0, 100 )
	AJM.db.warnWhenManaDropsAmount = tostring( amount )
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnManaDropsMessage( event, text )
	AJM.db.warnManaDropsMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsSetWarningArea( event, value )
	AJM.db.warningArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsSetRequestArea( event, value )
	AJM.db.requestArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsSetMerchantArea( event, value )
	AJM.db.merchantArea = value
	AJM:SettingsRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControlWarnings.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()
	-- Flag set when told the master about health falling below a certain percentage.
	AJM.toldMasterAboutHealth = false
	-- Flag set when told the master about mana falling below a certain percentage.
	AJM.toldMasterAboutMana = false
	-- Have been hit flag.
	AJM.haveBeenHit = false
	-- Bags full changed count.
	AJM.previousFreeBagSlotsCount = false
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	AJM.isInternalCommand = false
	-- WoW events.
	AJM:RegisterEvent( "UNIT_COMBAT" )
	AJM:RegisterEvent( "PLAYER_REGEN_DISABLED" )
	AJM:RegisterEvent( "PLAYER_REGEN_ENABLED" )
	AJM:RegisterEvent( "UNIT_HEALTH" )
	AJM:RegisterEvent( "MERCHANT_SHOW" )
	AJM:RegisterEvent( "UNIT_POWER_FREQUENT" )
	AJM:RegisterEvent( "RESURRECT_REQUEST" )
	AJM:RegisterEvent( "PLAYER_DEAD" )
	AJM:RegisterEvent( "CORPSE_IN_RANGE" )
	AJM:RegisterEvent( "CORPSE_IN_INSTANCE" )
	AJM:RegisterEvent( "CORPSE_OUT_OF_RANGE" )	
	AJM:RegisterEvent( "PLAYER_UNGHOST" )
	AJM:RegisterEvent( "PLAYER_ALIVE" )
	AJM:RegisterEvent( "CONFIRM_SUMMON")
	AJM:RegisterEvent( "DUEL_REQUESTED" )
	AJM:RegisterEvent( "GUILD_INVITE_REQUEST" )
	AJM:RegisterEvent( "LFG_ROLE_CHECK_SHOW" )
	AJM:RegisterEvent( "READY_CHECK" )
	AJM:RegisterEvent("LOSS_OF_CONTROL_ADDED")
	AJM:RegisterEvent( "UI_ERROR_MESSAGE", "BAGS_FULL" )
	AJM:RegisterEvent(  "BAG_UPDATE_DELAYED" )
	AJM:RegisterMessage( JambaApi.MESSAGE_MESSAGE_AREAS_CHANGED, "OnMessageAreasChanged" )
	AJM:RegisterMessage( JambaApi.MESSAGE_CHARACTER_ONLINE, "OnCharactersChanged" )
	AJM:RegisterMessage( JambaApi.MESSAGE_CHARACTER_OFFLINE, "OnCharactersChanged" )
	-- Ace Hooks
	AJM:SecureHook( "ConfirmReadyCheck" )
	AJM:SecureHook( "LFGTeleport" )
	AJM:SecureHook( "RollOnLoot" )
	
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.warnHitFirstTimeCombat = settings.warnHitFirstTimeCombat
		AJM.db.hitFirstTimeMessage = settings.hitFirstTimeMessage
		AJM.db.warnTargetNotMasterEnterCombat = settings.warnTargetNotMasterEnterCombat
		AJM.db.warnTargetNotMasterMessage = settings.warnTargetNotMasterMessage
		AJM.db.warnFocusNotMasterEnterCombat = settings.warnFocusNotMasterEnterCombat
		AJM.db.warnFocusNotMasterMessage = settings.warnFocusNotMasterMessage
		AJM.db.warnWhenHealthDropsBelowX = settings.warnWhenHealthDropsBelowX
		AJM.db.warnWhenHealthDropsAmount = settings.warnWhenHealthDropsAmount
		AJM.db.warnHealthDropsMessage = settings.warnHealthDropsMessage
		AJM.db.warnWhenManaDropsBelowX = settings.warnWhenManaDropsBelowX
		AJM.db.warnWhenManaDropsAmount = settings.warnWhenManaDropsAmount
		AJM.db.warnManaDropsMessage = settings.warnManaDropsMessage
		AJM.db.warnBagsFull = settings.warnBagsFull
		AJM.db.bagsFullMessage = settings.bagsFullMessage
		AJM.db.warnCC = settings.warnCC
		AJM.db.CcMessage = settings.CcMessage			
		AJM.db.autoAcceptResurrectRequest = settings.autoAcceptResurrectRequest
		AJM.db.acceptDeathRequests = settings.acceptDeathRequests
		AJM.db.autoDenyDuels = settings.autoDenyDuels
		AJM.db.autoAcceptSummonRequest = settings.autoAcceptSummonRequest
		AJM.db.autoDenyGuildInvites = settings.autoDenyGuildInvites
		AJM.db.autoAcceptRoleCheck = settings.autoAcceptRoleCheck
		AJM.db.enterLFGWithTeam = settings.enterLFGWithTeam
		AJM.db.acceptReadyCheck = settings.acceptReadyCheck
		AJM.db.teleportLFGWithTeam = settings.teleportLFGWithTeam
		AJM.db.rollWithTeam = settings.rollWithTeam
		AJM.db.autoRepair = settings.autoRepair
		AJM.db.autoRepairUseGuildFunds = settings.autoRepairUseGuildFunds
		AJM.db.warningArea = settings.warningArea
		AJM.db.requestArea = settings.requestArea
		AJM.db.merchantArea = settings.merchantArea
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["SETTINGS_RECEIVED_FROM_A"]( characterName ) )
	end
end

function AJM:UNIT_COMBAT( event, unitAffected, action )
	if AJM.db.warnHitFirstTimeCombat == false then
		return
	end
	if JambaApi.IsCharacterTheMaster( self.characterName ) == true then
		return
	end
	if InCombatLockdown() then
		if unitAffected == "player" and action ~= "HEAL" and not AJM.haveBeenHit then
			AJM.haveBeenHit = true
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.hitFirstTimeMessage, false )
		end
	end
end

function AJM:GUILD_INVITE_REQUEST( event, inviter, guild, ... )
	if AJM.db.autoDenyGuildInvites == true then
		DeclineGuild()
		GuildInviteFrame:Hide()
		AJM:JambaSendMessageToTeam( AJM.db.requestArea, L["REFUSED_GUILD_INVITE"]( guild, inviter ), false )
	end
end

function AJM:DUEL_REQUESTED( event, challenger, ... )
	if AJM.db.autoDenyDuels == true then
		CancelDuel()
		StaticPopup_Hide( "DUEL_REQUESTED" )
		AJM:JambaSendMessageToTeam( AJM.db.requestArea, L["I_REFUSED_A_DUEL_FROM_X"]( challenger ), false )
	end
end

function AJM:PLAYER_UNGHOST(event, ...)
		StaticPopup_Hide( "RECOVER_CORPSE" )
		StaticPopup_Hide( "RECOVER_CORPSE_INSTANCE" )
		StaticPopup_Hide( "XP_LOSS" )
		StaticPopup_Hide( "RECOVER_TEAM")
		StaticPopup_Hide(  "TEAMDEATH" )
end

function AJM:PLAYER_ALIVE(event, ...)
		StaticPopup_Hide( "RECOVER_CORPSE" )
		StaticPopup_Hide( "RECOVER_CORPSE_INSTANCE" )
		StaticPopup_Hide( "XP_LOSS" )
		StaticPopup_Hide( "RECOVER_TEAM" )
		StaticPopup_Hide( "TEAMDEATH" )
end


function AJM:CORPSE_IN_RANGE(event, ...)
	local teamMembers = JambaApi.GetTeamListMaximumOrderOnline()
	if teamMembers > 1 and AJM.db.acceptDeathRequests == true then
		StaticPopup_Show("RECOVER_TEAM")
	end		
end	
	
function AJM:CORPSE_IN_INSTANCE(event, ...)
		StaticPopup_Show("RECOVER_CORPSE_INSTANCE")
		StaticPopup_Hide("RECOVER_TEAM")
end
		
function AJM:CORPSE_OUT_OF_RANGE(event, ...)
		StaticPopup_Hide("RECOVER_CORPSE")
		StaticPopup_Hide("RECOVER_CORPSE_INSTANCE")
		StaticPopup_Hide("XP_LOSS")
		StaticPopup_Hide("RECOVER_TEAM")
end

function AJM:PLAYER_DEAD( event, ...)
	-- jamba Team Stuff.
	local teamMembers = JambaApi.GetTeamListMaximumOrderOnline()
	if teamMembers > 1 and AJM.db.acceptDeathRequests == true then
		StaticPopup_Show( "TEAMDEATH" )	
	end
end

-- Mosty taken from blizzard StaticPopup Code
-- 8.0 changes self Res to much to beable to work like we want it to
-- Not sure if we can do this anymore? maybe just remove it for now
StaticPopupDialogs["TEAMDEATH"] = {
	text = L["RELEASE_TEAM_Q"],
	button1 = DEATH_RELEASE,
	--button2 = USE_SOULSTONE,
	button2 = CANCEL,
	OnShow = function(self)
		--self.timeleft = GetReleaseTimeRemaining()
		--[[
		-- TODO FIX FOR 8.0
		if JambaPrivate.Core.isBetaBuild == true then
			-- Find out new code????? for now we can not use this
			local text = nil
		else 
			local text = HasSoulstone()
		end
		if ( text ) then
			self.button2:SetText(text)
		end
		if ( self.timeleft == -1 ) then
			self.text:SetText(DEATH_RELEASE_NOTIMER)
		end
		--]]
		self.button1:SetText(L["RELEASE_TEAM"])
	end,
	OnAccept = function(self)
		if not ( CannotBeResurrected() ) then
			return 1
		end
		
		AJM.teamDeath()
	end,
	OnCancel = function(self, data, reason)
		--[[
		if ( reason == "override" ) then
			return;
		end
		if ( reason == "timeout" ) then
			return;
		end
		if ( reason == "clicked" ) then
			if ( HasSoulstone() ) then
				AJM.teamSS()
			else
				AJM.teamRes()
			end
			if ( CannotBeResurrected() ) then
				return 1
			end
		end
		]]
	end,
	OnUpdate = function(self, elapsed)
		if ( IsFalling() and not IsOutOfBounds()) then
			self.button1:Disable()
			self.button2:Disable()
			--self.button3:Disable()
			return;
		end
		
		local b1_enabled = self.button1:IsEnabled()
		self.button1:SetEnabled(not IsEncounterInProgress())
		
		if ( b1_enabled ~= self.button1:IsEnabled() ) then
			if ( b1_enabled ) then
				self.text:SetText(CAN_NOT_RELEASE_IN_COMBAT)
			else
				self.text:SetText("");
				StaticPopupDialogs[self.which].OnShow(self)
			end
			StaticPopup_Resize(dialog, which)
		end
		--[[
		if( HasSoulstone() and CanUseSoulstone() ) then
			self.button2:Enable()
		else
			self.button2:Disable()
		end
		--]]
	end,
	--[[
	DisplayButton2 = function(self)
		return HasSoulstone()
	end,
	]]
	timeout = 0,
	whileDead = 1,
	interruptCinematic = 1,
	notClosableByLogout = 1,
	noCancelOnReuse = 1,
	cancels = "RECOVER_TEAM"
}

StaticPopupDialogs["RECOVER_TEAM"] = {
	text = L["RECOVER_CORPSES"],
	button1 = ACCEPT,
	OnAccept = function(self)
		AJM:relaseTeam();
		return 1;
	end,
	timeout = 0,
	whileDead = 1,
	interruptCinematic = 1,
	notClosableByLogout = 1
};

function AJM:relaseTeam()
	AJM:JambaSendCommandToTeam( AJM.COMMAND_RECOVER_TEAM )
end

function AJM:teamDeath()
	
	AJM:JambaSendCommandToTeam( AJM.COMMAND_TEAM_DEATH )
end

--Remove
function AJM:teamSS()
	AJM:JambaSendCommandToTeam( AJM.COMMAND_SOUL_STONE )
	--UseSoulstone()
end

function AJM:doRecoverTeam()
	RetrieveCorpse()
	if UnitIsGhost("player") then
		local delay = GetCorpseRecoveryDelay()	  
		if delay > 0 then
			AJM:JambaSendMessageToTeam( AJM.db.requestArea, L["RELEASE_CORPSE_FOR_X"]( delay ), false )
			StaticPopup_Show("RECOVER_TEAM")
		else	
			RetrieveCorpse()
			StaticPopup_Hide("RECOVER_TEAM")
		end		
	end
end
			
function AJM:doTeamDeath()
	if UnitIsDead("player") and not UnitIsGhost("player") then
		RepopMe()
		StaticPopup_Hide("TEAMDEATH")
	end
end

--CleanUP
function AJM:doSoulStone()
	if UnitIsDead("player") and not UnitIsGhost("player") then
		-- Dead code do not use!
		--[[
		if HasSoulstone() then
			UseSoulstone()
			StaticPopup_Hide("TEAMDEATH")
		else
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, L["I Do not have a SoulStone"], false )
		end	
		]]
	end
end

function AJM:RESURRECT_REQUEST( event, ... )
	if AJM.db.autoAcceptResurrectRequest == true then
		AcceptResurrect()
		StaticPopup_Hide( "RESURRECT")
		StaticPopup_Hide( "RESURRECT_NO_SICKNESS" )
		StaticPopup_Hide( "RESURRECT_NO_TIMER" )
		StaticPopup_Hide( "SKINNED" )
		StaticPopup_Hide( "SKINNED_REPOP" )
		StaticPopup_Hide( "DEATH" )
		StaticPopup_Hide( "RECOVER_TEAM" )
		StaticPopup_Hide( "TEAMDEATH" )
	end
end

--LFG stuff

function AJM:READY_CHECK( event, name, ... )
	-- Auto do Ready Check if team member is the one that does the readycheck
	if AJM.db.acceptReadyCheck == true then
		--AJM:Print("readyCheck", name )
		for index, characterName in JambaApi.TeamListOrderedOnline() do
			if name == Ambiguate( characterName, "none") then
				AJM.isInternalCommand = ture
				--AJM:Print("found in team", characterName)
				if ReadyCheckFrame:IsShown() == true then
					--AJM:Print("Ok?")
					ConfirmReadyCheck(1)
					ReadyCheckFrame:Hide()
				end	
				AJM.isInternalCommand = false
			end	
		end	
	end	
end


function AJM:ConfirmReadyCheck( ready )
	--AJM:Print("Test", ready )
	if AJM.db.acceptReadyCheck == true then	
		if AJM.isInternalCommand == false then
			AJM:JambaSendCommandToTeam( AJM.COMMAND_READY_CHECK, ready)
		end	
	end		
end

function AJM:AmReadyCheck( ready )
	--AJM:Print("AmReady!", ready )
	AJM.isInternalCommand = true
		if ready == 1 then
			ConfirmReadyCheck(1)
			ReadyCheckFrame:Hide()
		else
			ConfirmReadyCheck()
			ReadyCheckFrame:Hide()
		end	
	AJM.isInternalCommand = false
end

function AJM:LFGTeleport( event, arg1, ... )
	--AJM:Print("LFGtest")
	if AJM.db.teleportLFGWithTeam == true then
		if IsShiftKeyDown() == false then
			if AJM.isInternalCommand == false then
				if IsInLFGDungeon() == true then
					AJM:JambaSendCommandToTeam( AJM.COMMAND_TELE_PORT, true )
				else
					AJM:JambaSendCommandToTeam( AJM.COMMAND_TELE_PORT, false )	
				end	
			end	
		end	
	end		
end

function AJM:DoLFGTeleport(port)
	--AJM:Print("TeleCommand", port)
	AJM.isInternalCommand = true
	if IsShiftKeyDown() == false then
		if port == true then
			LFGTeleport(1)
		else
			LFGTeleport()
		end
	end		
	AJM.isInternalCommand = false
end

function AJM:LFG_ROLE_CHECK_SHOW( event, ... )
	if AJM.db.autoAcceptRoleCheck == true then	
		--AJM:Print("testPopup?")
		CompleteLFGRoleCheck("ture")
	end	
end

function AJM:RollOnLoot(id, rollType, ...)
	--AJM:Print("lootTest", id, rollType)
	local texture, name, count, quality, bindOnPickUp = GetLootRollItemInfo( id )
	--AJM:Print("lootItemTest", name)
	if AJM.db.rollWithTeam == true then
		if IsShiftKeyDown() == false then
			if AJM.isInternalCommand == false then
				AJM:JambaSendCommandToTeam( AJM.COMMAND_LOOT_ROLL, id, rollType, name)
			end
		end		
	end
end

function AJM:DoLootRoll( id, rollType, name )
	--AJM:Print("i have a command to roll on item", name)
	AJM.isInternalCommand = true
	if name ~= nil then
		RollOnLoot(id, rollType)
	end	
	AJM.isInternalCommand = false
end

function AJM:CONFIRM_SUMMON( event, sender, location, ... )
	local sender, location = GetSummonConfirmSummoner(), GetSummonConfirmAreaName()
	if AJM.db.autoAcceptSummonRequest == true then
		if GetSummonConfirmTimeLeft() > 0 then
		ConfirmSummon()
		StaticPopup_Hide("CONFIRM_SUMMON")
		AJM:JambaSendMessageToTeam( AJM.db.requestArea, L["SUMMON_FROM_X_TO_Y"]( sender, location ), false )
		end
	end
end

function AJM:MERCHANT_SHOW( event, ... )	
	-- Does the user want to auto repair?
	if AJM.db.autoRepair == false then
		return
	end	
	-- Can this merchant repair?
	if not CanMerchantRepair() then
		return
	end		
	-- How much to repair?
	local repairCost, canRepair = GetRepairAllCost()
	if canRepair == nil then
		return
	end
	-- At least some cost...
	if repairCost > 0 then
		-- If allowed to use guild funds, then attempt to repair using guild funds.
		if AJM.db.autoRepairUseGuildFunds == true then
			if IsInGuild() and CanGuildBankRepair() then
				RepairAllItems( 1 )
			end
		end
		-- After guild funds used, still need to repair?
		repairCost = GetRepairAllCost()
		-- At least some cost...
		if repairCost > 0 then
			-- How much money available?
			local moneyAvailable = GetMoney()
			-- More or equal money than cost?
			if moneyAvailable >= repairCost then
				-- Yes, repair.
				RepairAllItems()
			else
				-- Nope, tell the boss.
				 AJM:JambaSendMessageToTeam( AJM.db.merchantArea, L["ERR_GOLD_TO_REPAIR"], false )
			end
		end
	end
	if repairCost > 0 then
		-- Tell the boss how much that cost.
		local costString = JambaUtilities:FormatMoneyString( repairCost )
		AJM:JambaSendMessageToTeam( AJM.db.merchantArea, L["REPAIRING_COST_ME_X"]( costString ), false )
	end
end

function AJM:UNIT_POWER_FREQUENT( event, unitAffected, power, ... )
	if AJM.db.warnWhenManaDropsBelowX == false then
		return
	end
	if unitAffected ~= "player" then
		return
	end
	if power ~= "MANA" then
		return
	end			
	local currentMana = (UnitPower( "player", 0 ) / UnitPowerMax( "player", 0 ) * 100)
	if AJM.toldMasterAboutMana == true then
		if currentMana >= tonumber( AJM.db.warnWhenManaDropsAmount ) then
			AJM.toldMasterAboutMana = false
		end
	else
		if currentMana < tonumber( AJM.db.warnWhenManaDropsAmount ) then
			AJM.toldMasterAboutMana = true
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnManaDropsMessage, false )
		end
	end
end

function AJM:UNIT_HEALTH( event, unitAffected, ... )
	if AJM.db.warnWhenHealthDropsBelowX == false then
		return
	end	
	if unitAffected ~= "player" then
		return
	end
	local currentHealth = (UnitHealth( "player" ) / UnitHealthMax( "player" ) * 100)
	if AJM.toldMasterAboutHealth == true then
		if currentHealth >= tonumber( AJM.db.warnWhenHealthDropsAmount ) then
			AJM.toldMasterAboutHealth = false
		end
	else
		if currentHealth < tonumber( AJM.db.warnWhenHealthDropsAmount ) then
			AJM.toldMasterAboutHealth = true
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnHealthDropsMessage, false )
		end
	end
end

function AJM:PLAYER_REGEN_ENABLED( event, ... )
	AJM.haveBeenHit = false
end

function AJM:PLAYER_REGEN_DISABLED( event, ... )
	AJM.haveBeenHit = false
	if AJM.db.warnTargetNotMasterEnterCombat == true then
		if JambaApi.IsCharacterTheMaster( AJM.characterName ) == false then
			local name, realm = UnitName( "target" )
			local character = JambaUtilities:AddRealmToNameIfNotNil( name, realm )
			if character ~= JambaApi.GetMasterName() then
				AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnTargetNotMasterMessage, false )
			end
		end
	end
	if AJM.db.warnFocusNotMasterEnterCombat == true then
		if JambaApi.IsCharacterTheMaster( AJM.characterName ) == false then
			local name, realm = UnitName( "focus" )
			local character = JambaUtilities:AddRealmToNameIfNotNil( name, realm )
			if character ~= JambaApi.GetMasterName() then
				AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnFocusNotMasterMessage, false )
			end
		end
	end
end

function AJM:BAGS_FULL( event, arg1, message, ... )
   if AJM.db.warnBagsFull == true then
		if UnitIsGhost( "player" ) then 
			return 
		end
		if UnitIsDead( "player" ) then 
			return 
		end
		local numberFreeSlots, numberTotalSlots = LibBagUtils:CountSlots( "BAGS", 0 )
		if  message == ERR_INV_FULL or message == INVENTORY_FULL then
			if numberFreeSlots == 0 then
				if AJM.previousFreeBagSlotsCount == false then
					AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.bagsFullMessage, false )
					AJM.previousFreeBagSlotsCount = true
					AJM:ScheduleTimer("ResetBagFull", 60, nil )
				end
			end
		end	
	end
end

function AJM:BAG_UPDATE_DELAYED(event, ... )
	if AJM.db.warnBagsFull == true then	
		local numberFreeSlots, numberTotalSlots = LibBagUtils:CountSlots( "BAGS", 0 )
		if numberFreeSlots > 0 then
			 AJM.previousFreeBagSlotsCount = false
			 AJM:CancelAllTimers()
		end
	end	
end

function AJM:ResetBagFull()
	AJM.previousFreeBagSlotsCount = false
	AJM:CancelAllTimers()
end	

--Ebony CCed
function AJM:LOSS_OF_CONTROL_ADDED( event, ... )
	if AJM.db.warnCC == true then
		local eventIndex = C_LossOfControl.GetNumEvents()
		if eventIndex > 0 then
		local locType, spellID, text, iconTexture, startTime, timeRemaining, duration, lockoutSchool, priority, displayType = C_LossOfControl.GetEventInfo(eventIndex)	
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.CcMessage..L[" "]..text, false )
		end
	end
end

-- A Jamba command has been received.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	--AJM:Print("Test", characterName, commandName)
	if commandName == AJM.COMMAND_RECOVER_TEAM then
		AJM:doRecoverTeam()
	end
	if commandName == AJM.COMMAND_TEAM_DEATH then
		AJM:doTeamDeath()
	end
	-- More then likey to get removed
	if commandName == AJM.COMMAND_SOUL_STONE then
		--AJM:doSoulStone()
	end
	if commandName == AJM.COMMAND_READY_CHECK then
		if characterName ~= self.characterName then
			AJM.AmReadyCheck( characterName, ... )
		end	
	end
	if commandName == AJM.COMMAND_TELE_PORT then
		if characterName ~= self.characterName then
			AJM.DoLFGTeleport( characterName, ... )
		end	
	end
	if commandName == AJM.COMMAND_LOOT_ROLL then
		if characterName ~= self.characterName then
			AJM.DoLootRoll( characterName, ... )
		end	
	end
end
