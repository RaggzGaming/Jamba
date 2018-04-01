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
	"JambaSync", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceHook-3.0",
	"AceTimer-3.0"
)

-- Get the Jamba Utilities Library.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Sync"
AJM.settingsDatabaseName = "JambaSyncProfileDB"
AJM.chatCommand = "jamba-Sync"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.parentDisplayName = L["SYNC"]
AJM.moduleDisplayName = L["SYNC"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		mountWithTeam = false,
		dismountWithTeam = false,
		dismountWithMaster = false,
		mountInRange = false,

		--messageArea = JambaApi.DefaultMessageArea(),
		warningArea = JambaApi.DefaultWarningArea()
	},
}

-- Configuration.
function AJM:GetConfiguration()
	local configuration = {
		name = AJM.moduleDisplayName,
		handler = AJM,
		type = 'group',
		childGroups  = "tab",
		get = "JambaConfigurationGetSetting",
		set = "JambaConfigurationSetSetting",
		args = {	
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the Mount settings to all characters in the team."],
				usage = "/jamba-mount push",
				get = false,
				set = "JambaSendSettings",
				order = 4,
				guiHidden = true,
			},
		},
	}
	return configuration
end

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------

AJM.COMMAND_MOUNT_ME = "JambaMountMe"
AJM.COMMAND_MOUNT_DISMOUNT = "JambaMountDisMount"

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	-- Create the settings control.
	AJM:SettingsCreate()
	-- Initialse the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()
	-- BlizzUI Frames
	AJM:CreateJambaInterFaceSyncFrame()	
end

-- Called when the addon is enabled.
function AJM:OnEnable()
--	AJM:RegisterEvent("PLAYER_REGEN_ENABLED")

	AJM:HookScript( InterfaceOptionsFrame, "OnShow", "InterfaceOptionsFrameOnShow" )
	AJM:RegisterMessage( JambaApi.MESSAGE_MESSAGE_AREAS_CHANGED, "OnMessageAreasChanged" )
	
end

-- Called when the addon is disabled.
function AJM:OnDisable()
	-- AceHook-3.0 will tidy up the hooks for us. 
end

function AJM:SettingsCreate()
	AJM.settingsControl = {}
	-- Create the settings panel.
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControl, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	local bottomOfInfo = AJM:SettingsCreateMount( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfInfo )
	-- Help
	local helpTable = {}
	JambaHelperSettings:CreateHelp( AJM.settingsControl, helpTable, AJM:GetConfiguration() )		
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsCreateMount( top )
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["PH"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxMountWithTeam = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["PH"],
		AJM.SettingsToggleMountWithTeam,
		L["PH"]
	)	
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxDismountWithTeam = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["PH"],
		AJM.SettingsToggleDisMountWithTeam,
		L["PH"]
	)	
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxDismountWithMaster = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["PH"],
		AJM.SettingsToggleDisMountWithMaster,
		L["PH"]
	)	
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxMountInRange = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["PH"],
		AJM.SettingsToggleMountInRange,
		L["PH"]
	)
-- DO WE NEED THIS?
--	movingTop = movingTop - checkBoxHeight
--	AJM.settingsControl.dropdownMessageArea = JambaHelperSettings:CreateDropdown( 
--		AJM.settingsControl, 
--		headingWidth, 
--		left, 
--		movingTop, 
--		L["Message Area"] 
--	)
--	AJM.settingsControl.dropdownMessageArea:SetList( JambaApi.MessageAreaList() )
--	AJM.settingsControl.dropdownMessageArea:SetCallback( "OnValueChanged", AJM.SettingsSetMessageArea )
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.dropdownWarningArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Send Warning Area"] 
	)
	AJM.settingsControl.dropdownWarningArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControl.dropdownWarningArea:SetCallback( "OnValueChanged", AJM.SettingsSetWarningArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing
	return movingTop	
end

function AJM:OnMessageAreasChanged( message )
	--AJM.settingsControl.dropdownMessageArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControl.dropdownWarningArea:SetList( JambaApi.MessageAreaList() )
end

function AJM:SettingsSetWarningArea( event, value )
	AJM.db.warningArea = value
	AJM:SettingsRefresh()
end

--function AJM:SettingsSetMessageArea( event, value )
--	AJM.db.messageArea = value
--	AJM:SettingsRefresh()
--end

function AJM:SettingsToggleMountWithTeam( event, checked )
	AJM.db.mountWithTeam = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleDisMountWithTeam( event, checked )
	AJM.db.dismountWithTeam = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleDisMountWithMaster( event, checked )
	AJM.db.dismountWithMaster = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleMountInRange( event, checked )
	AJM.db.mountInRange = checked
	AJM:SettingsRefresh()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.mountWithTeam = settings.mountWithTeam
		AJM.db.dismountWithTeam = settings.dismountWithTeam
		AJM.db.dismountWithMaster = settings.dismountWithMaster
		AJM.db.mountInRange = settings.mountInRange
		AJM.db.messageArea = settings.messageArea
		AJM.db.warningArea = settings.warningArea
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	AJM.settingsControl.checkBoxMountWithTeam:SetValue( AJM.db.mountWithTeam )
	AJM.settingsControl.checkBoxDismountWithTeam:SetValue( AJM.db.dismountWithTeam )
	AJM.settingsControl.checkBoxDismountWithMaster:SetValue( AJM.db.dismountWithMaster )
	AJM.settingsControl.checkBoxMountInRange:SetValue( AJM.db.mountInRange )
	--AJM.settingsControl.dropdownMessageArea:SetValue( AJM.db.messageArea )
	AJM.settingsControl.dropdownWarningArea:SetValue( AJM.db.warningArea )
	-- Set state.
	--AJM.settingsControl.checkBoxMountWithTeam:SetDisabled( not AJM.db.mountWithTeam )
	AJM.settingsControl.checkBoxDismountWithTeam:SetDisabled( not AJM.db.mountWithTeam )
	AJM.settingsControl.checkBoxDismountWithMaster:SetDisabled( not AJM.db.dismountWithTeam or not AJM.db.mountWithTeam )
	AJM.settingsControl.checkBoxMountInRange:SetDisabled( not AJM.db.mountWithTeam )
end

-------------------------------------------------------------------------------------------------------------
-- JambaSync functionality.
-------------------------------------------------------------------------------------------------------------

--Frames Buttons

function AJM:ShowTooltip(frame, show, text)
	if show then
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		GameTooltip:SetPoint("TOPLEFT", frame, "TOPRIGHT", 16, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine( text , 1, 0.82, 0, 1)
		GameTooltip:Show()
	else
	GameTooltip:Hide()
	end
end


function AJM:CreateJambaInterFaceSyncFrame()
	JambaInterFaceSyncFrame = CreateFrame( "Frame", "InterFaceSyncFrame", InterfaceOptionsFrame )
    local frame = JambaInterFaceSyncFrame
	frame:SetWidth( 110 )
	frame:SetHeight( 30 )
	frame:SetFrameStrata( "HIGH" )
	frame:SetToplevel( true )
	frame:SetClampedToScreen( true )
	--frame:EnableMouse( true )
	--frame:SetMovable( true )	
	frame:ClearAllPoints()
	frame:SetPoint("TOPRIGHT", InterfaceOptionsFrame, "TOPRIGHT", -5, -8 )
	--[[
		frame:SetBackdrop( {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
		tile = true, tileSize = 15, edgeSize = 15, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	} )
	]]
	table.insert( UISpecialFrames, "JambaInterFaceSyncFrame" )
	local syncButton = CreateFrame( "Button", "syncButton", frame, "UIPanelButtonTemplate" )
	syncButton:SetScript( "OnClick", function()  AJM:DoSyncInterfaceSettings() end )
	syncButton:SetPoint( "TOPLEFT", frame, "TOPLEFT", 10 , -5)
	syncButton:SetHeight( 20 )
	syncButton:SetWidth( 90 )
	syncButton:SetText( L["SYNC"] )	
	syncButton:SetScript("OnEnter", function(self) AJM:ShowTooltip(syncButton, true, L["SYNC"] ) end)
	syncButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	syncButtonFrameButton = syncButton
	
end

function AJM:InterfaceOptionsFrameOnShow()
	--AJM:Print("test")
	-- This sorts out hooking on L or marcioMenu button
	--if AJM.db.showJambaQuestLogWithWoWQuestLog == true then
		if InterfaceOptionsFrame:IsVisible() then
			AJM:ToggleShowSyncInterfaceFrame( true )
		else
			AJM:ToggleShowSyncInterfaceFrame( false )
		end
	--end
end


function AJM:ToggleShowSyncInterfaceFrame( show )
    if show == true then
		JambaInterFaceSyncFrame:Show()
    else
		JambaInterFaceSyncFrame:Hide()
    end
end

function AJM:DoSyncInterfaceSettings()
    AJM:Print("[PH] Button Does Nothing" ) 
end


-- COMMS

-- A Jamba command has been received.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	if characterName ~= self.characterName then
		--[[
		if commandName == AJM.COMMAND_MOUNT_ME then
			--AJM:Print("command")
			AJM:TeamMount( characterName, ... ) 
		end
		]]
	end
end
