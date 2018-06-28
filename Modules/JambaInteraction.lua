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
	"JambaInteraction", 
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
AJM.moduleName = "Jamba-Interaction"
AJM.settingsDatabaseName = "JambaInteractionProfileDB"
AJM.chatCommand = "jamba-Interaction"
local L = LibStub( "AceLocale-3.0" ):GetLocale( "Core" )
AJM.parentDisplayName = L["INTERACTION"]
AJM.moduleDisplayName = L["INTERACTION"]
-- Icon 
 AJM.moduleIcon = "Interface\\Addons\\Jamba\\Media\\InteractionIcon.tga"
-- order
AJM.moduleOrder = 60

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		takeMastersTaxi = true,
		requestTaxiStop = true,
		changeTexiTime = 2,
		--Mount
		mountWithTeam = false,
		dismountWithTeam = false,
		dismountWithMaster = false,
		mountInRange = false,
		--Loot
		autoLoot = false,
		tellBoERare = false,
		tellBoEEpic = false,		
		messageArea = JambaApi.DefaultMessageArea(),
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
				name = L["PUSH_SETTINGS"],
				desc = L["PUSH_SETTINGS_INFO"],
				usage = "/jamba-interaction push",
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

AJM.COMMAND_TAKE_TAXI = "JambaTaxiTakeTaxi"
AJM.COMMAND_EXIT_TAXI = "JambaTaxiExitTaxi"
AJM.COMMAND_CLOSE_TAXI = "JambaCloseTaxi"
AJM.COMMAND_MOUNT_ME = "JambaMountMe"
AJM.COMMAND_MOUNT_DISMOUNT = "JambaMountDisMount"

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-- Taxi has been taken, no parameters.
AJM.MESSAGE_TAXI_TAKEN = "JambaTaxiTaxiTaken"

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	AJM.JambaTakesTaxi = false
	AJM.JambaLeavsTaxi = false
	AJM.TaxiFrameName = TaxiFrame
	-- Create the settings control.
	AJM:SettingsCreate()
	-- Initialse the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()
	AJM:DisableAutoLoot()	
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	-- Hook the TaketaxiNode function.
	AJM:SecureHook( "TakeTaxiNode" )
	AJM:SecureHook( "TaxiRequestEarlyLanding" )
	if JambaPrivate.Core.isBetaBuild() == false then
		AJM:RegisterEvent("UNIT_SPELLCAST_START")
		AJM:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	end	
	AJM:RegisterEvent( "LOOT_READY" )
	if JambaPrivate.Core.isBetaBuild() == true then
		AJM:RegisterEvent( "TAXIMAP_OPENED" )
	end		
	-- WoW API Events.
	AJM:RegisterEvent("TAXIMAP_CLOSED")
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
		AJM.SettingsPushSettingsClick,
		AJM.moduleIcon,
		AJM.moduleOrder		
	)
	local bottomOfInfo = AJM:SettingsCreateTaxi( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfInfo )
	-- Help
	local helpTable = {}
	JambaHelperSettings:CreateHelp( AJM.settingsControl, helpTable, AJM:GetConfiguration() )		
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsCreateTaxi( top )
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local iconSize = JambaHelperSettings:GetIconHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local sliderHeight = JambaHelperSettings:GetSliderHeight()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local halfWidthSlider = (headingWidth - horizontalSpacing) / 2
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local leftIcon = left + iconSize	
	local movingTop = top
	-- A blank to get layout to show right?
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L[""], movingTop, false )
	movingTop = movingTop - headingHeight	
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["TAXI_OPTIONS"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxTakeMastersTaxi = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["TAKE_TEAMS_TAXI"],
		AJM.SettingsToggleTakeTaxi,
		L["TAKE_TEAMS_TAXI_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.checkBoxrequestStop = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["REQUEST_TAXI_STOP"],
		AJM.SettingsTogglerequestStop,
		L["REQUEST_TAXI_STOP_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight		
	AJM.settingsControl.changeTexiTime = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop,
		L["CLONES_TO_TAKE_TAXI_AFTER"]
	)		
	AJM.settingsControl.changeTexiTime:SetSliderValues( 0, 5, 0.5 )
	AJM.settingsControl.changeTexiTime:SetCallback( "OnValueChanged", AJM.SettingsChangeTaxiTimer )
	-- Mount
	movingTop = movingTop - sliderHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["MOUNT_OPTIONS"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxMountWithTeam = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["MOUNT_WITH_TEAM"],
		AJM.SettingsToggleMountWithTeam,
		L["MOUNT_WITH_TEAM_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.checkBoxDismountWithTeam = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["DISMOUNT_WITH_TEAM"],
		AJM.SettingsToggleDisMountWithTeam,
		L["DISMOUNT_WITH_TEAM_HELP"] 
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.checkBoxDismountWithMaster = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["ONLY_DISMOUNT_WITH_MASTER"],
		AJM.SettingsToggleDisMountWithMaster,
		L["ONLY_DISMOUNT_WITH_MASTER_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.checkBoxMountInRange = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["ONLY_MOUNT_WHEN_IN_RANGE"],
		AJM.SettingsToggleMountInRange,
		L["ONLY_MOUNT_WHEN_IN_RANGE_HELP"]
	)	
	-- Loot
	movingTop = movingTop - headingHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["LOOT_OPTIONS"] , movingTop, false )	
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxAutoLoot = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["ENABLE_AUTO_LOOT"],
		AJM.SettingsToggleAutoLoot,
		L["ENABLE_AUTO_LOOT_HELP"]
	)
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.checkBoxTellBoERare = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["TELL_TEAM_BOE_RARE"],
		AJM.SettingsToggleTellBoERare,
		L["TELL_TEAM_BOE_RARE_HELP"]
	)
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.checkBoxTellBoEEpic = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["TELL_TEAM_BOE_EPIC"] ,
		AJM.SettingsToggleTellBoEEpic,
		L["TELL_TEAM_BOE_EPIC_HELP"]
	)
	movingTop = movingTop - sliderHeight - verticalSpacing
	AJM.settingsControl.dropdownMessageArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["MESSAGE_AREA"]
	)
	AJM.settingsControl.dropdownMessageArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControl.dropdownMessageArea:SetCallback( "OnValueChanged", AJM.SettingsSetMessageArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing
	AJM.settingsControl.dropdownWarningArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["SEND_WARNING_AREA"] 
	)
	AJM.settingsControl.dropdownWarningArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControl.dropdownWarningArea:SetCallback( "OnValueChanged", AJM.SettingsSetWarningArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing
	return movingTop	
end

function AJM:OnMessageAreasChanged( message )
	AJM.settingsControl.dropdownMessageArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControl.dropdownWarningArea:SetList( JambaApi.MessageAreaList() )
end

function AJM:SettingsSetMessageArea( event, value )
	AJM.db.messageArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsSetWarningArea( event, value )
	AJM.db.warningArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleTakeTaxi( event, checked )
	AJM.db.takeMastersTaxi = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsTogglerequestStop( event, checked )
	AJM.db.requestTaxiStop = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeTaxiTimer( event, value )
	AJM.db.changeTexiTime = tonumber( value )
	AJM:SettingsRefresh()
end

-- Mount 
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

function AJM:SettingsToggleAutoLoot( event, checked )
	AJM.db.autoLoot = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleTellBoERare( event, checked )
	AJM.db.tellBoERare = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleTellBoEEpic( event, checked )
	AJM.db.tellBoEEpic = checked
	AJM:SettingsRefresh()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.takeMastersTaxi = settings.takeMastersTaxi
		AJM.db.requestTaxiStop = settings.requestTaxiStop
		AJM.db.changeTexiTime = settings.changeTexiTime
		
		AJM.db.mountWithTeam = settings.mountWithTeam
		AJM.db.dismountWithTeam = settings.dismountWithTeam
		AJM.db.dismountWithMaster = settings.dismountWithMaster
		AJM.db.mountInRange = settings.mountInRange
		
		AJM.db.autoLoot = settings.autoLoot
		AJM.db.tellBoERare = settings.tellBoERare
		AJM.db.tellBoEEpic = settings.tellBoEEpic
		
		AJM.db.messageArea = settings.messageArea
		AJM.db.warningArea = settings.warningArea	
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["SETTINGS_RECEIVED_FROM_A"]( characterName ) )
	end
end

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	AJM.settingsControl.checkBoxTakeMastersTaxi:SetValue( AJM.db.takeMastersTaxi )
	AJM.settingsControl.checkBoxrequestStop:SetValue( AJM.db.requestTaxiStop )
	AJM.settingsControl.changeTexiTime:SetValue( AJM.db.changeTexiTime )
	AJM.settingsControl.checkBoxMountWithTeam:SetValue( AJM.db.mountWithTeam )
	AJM.settingsControl.checkBoxDismountWithTeam:SetValue( AJM.db.dismountWithTeam )
	AJM.settingsControl.checkBoxDismountWithMaster:SetValue( AJM.db.dismountWithMaster )
	AJM.settingsControl.checkBoxMountInRange:SetValue( AJM.db.mountInRange )
	AJM.settingsControl.dropdownMessageArea:SetValue( AJM.db.messageArea )
	AJM.settingsControl.dropdownWarningArea:SetValue( AJM.db.warningArea )
	AJM.settingsControl.checkBoxAutoLoot:SetValue( AJM.db.autoLoot )
	AJM.settingsControl.checkBoxTellBoERare:SetValue( AJM.db.tellBoERare )
	AJM.settingsControl.checkBoxTellBoEEpic:SetValue( AJM.db.tellBoEEpic )
	-- Set state.
	AJM.settingsControl.checkBoxDismountWithTeam:SetDisabled( not AJM.db.mountWithTeam )
	AJM.settingsControl.checkBoxDismountWithMaster:SetDisabled( not AJM.db.dismountWithTeam or not AJM.db.mountWithTeam )
	AJM.settingsControl.checkBoxMountInRange:SetDisabled( not AJM.db.mountWithTeam )
	-- BETA TODO FIX FOR 8.0!
	AJM.settingsControl.checkBoxMountWithTeam:SetDisabled( JambaPrivate.Core.isBetaBuild() )
end

-------------------------------------------------------------------------------------------------------------
-- JambaTaxi Functionality.
-------------------------------------------------------------------------------------------------------------

function AJM:TAXIMAP_OPENED(event, ...)
	local uiMapSystem = ...
	if (uiMapSystem == Enum.UIMapSystem.Taxi) then	
		AJM.TaxiFrameName = TaxiFrame
	else
		AJM.TaxiFrameName = FlightMapFrame
	end
end	

-- Take a taxi.
local function TakeTaxi( sender, nodeName )
	-- If the take masters taxi option is on.
	if AJM.db.takeMastersTaxi == true then
		-- If the sender was not this character and is the master then...
		if sender ~= AJM.characterName then
			-- Find the index of the taxi node to fly to.
			local nodeIndex = nil
			for iterateNodes = 1, NumTaxiNodes() do
				if TaxiNodeName( iterateNodes ) == nodeName then
					nodeIndex = iterateNodes
					break
				end
			end	
			-- If a node index was found...
			if nodeIndex ~= nil then
				-- Send a message to any listeners that a taxi is being taken.
				AJM:SendMessage( AJM.MESSAGE_TAXI_TAKEN )
				-- Take a taxi.
				AJM.JambaTakesTaxi = true
				AJM:ScheduleTimer( "TakeTimedTaxi", AJM.db.changeTexiTime , nodeIndex )
				--GetNumRoutes( nodeIndex )
				--TakeTaxiNode( nodeIndex )
			else
				-- Tell the master that this character could not take the same flight.
				AJM:JambaSendMessageToTeam( AJM.db.messageArea,  L["I_AM_UNABLE_TO_FLY_TO_A"]( nodeName ), false )
			end
		end
	end
end

function AJM.TakeTimedTaxi( event, nodeIndex, ...)
	if nodeIndex ~= nil then
		GetNumRoutes( nodeIndex )
		TakeTaxiNode( nodeIndex )
	end		
end

-- Called after the character has just taken a flight (hooked function).
function AJM:TakeTaxiNode( taxiNodeIndex )
	-- If the take masters taxi option is on.
	if AJM.db.takeMastersTaxi == true then
		-- Get the name of the node flown to.
		local nodeName = TaxiNodeName( taxiNodeIndex )
		if AJM.JambaTakesTaxi == false then
			-- Tell the other characters about the taxi.
			AJM:JambaSendCommandToTeam( AJM.COMMAND_TAKE_TAXI, nodeName )
		end
		AJM.JambaTakesTaxi = false
	end
end

local function LeaveTaxi ( sender )
	if AJM.db.requestTaxiStop == true then
		if sender ~= AJM.characterName then
			AJM.JambaLeavsTaxi = true
			TaxiRequestEarlyLanding()
			AJM:JambaSendMessageToTeam( AJM.db.messageArea,  L["REQUESTED_STOP_X"]( sender ), false )	
		end
	end	
end

function AJM.TaxiRequestEarlyLanding( sender )
	-- If the take masters taxi option is on.
	--AJM:Print("test")
	if AJM.db.requestTaxiStop == true then
		if UnitOnTaxi( "player" ) and CanExitVehicle() == true then
			if AJM.JambaLeavsTaxi == false then
				-- Send a message to any listeners that a taxi is being taken.
				AJM:JambaSendCommandToTeam ( AJM.COMMAND_EXIT_TAXI )
			end
		end
		AJM.JambaLeavsTaxi = false
	end
end

function AJM:TAXIMAP_CLOSED( event, ... )
	-- TODO Clean UP AFTER BETA
	if JambaPrivate.Core.isBetaBuild() == false then
		if TaxiFrame_ShouldShowOldStyle() or FlightMapFrame:IsVisible() then
			AJM:JambaSendCommandToTeam ( AJM.COMMAND_CLOSE_TAXI )
		end
	else
		AJM:JambaSendCommandToTeam ( AJM.COMMAND_CLOSE_TAXI )
	end		
end

local function CloseTaxiMapFrame()
	if AJM.JambaTakesTaxi == false then
		CloseTaxiMap()
	end
end

-------------------------------------------------------------------------------------------------------------
-- JambaMount Functionality.
-------------------------------------------------------------------------------------------------------------

function AJM:UNIT_SPELLCAST_START(event, unitID, spell, rank, lineID, spellID, ...  )
	--AJM:Print("Looking for Spells.", unitID, spellID, spell)
	AJM.castingMount = nil
	if unitID == "player" then
	local mountIDs = C_MountJournal.GetMountIDs()	
		for i = 1, #mountIDs do
			--local name , id, icon, active = C_MountJournal.GetMountInfoByID(i)
			local creatureName,_,_,_,_,_,_,_,_,_,_,mountID = C_MountJournal.GetMountInfoByID(mountIDs[i])
			--AJM:Print("Test", spell, creatureName)
			if spell == creatureName then
				--AJM:Print("SendtoTeam", "name", creatureName, "id", mountID)
				if IsShiftKeyDown() == false then
					AJM:JambaSendCommandToTeam( AJM.COMMAND_MOUNT_ME, creatureName, mountID )
					AJM.castingMount = creatureName
					break	
				end	
			end
		end	
	end
end

function AJM:UNIT_SPELLCAST_SUCCEEDED(event, unitID, spell, rank, lineID, spellID, ... )
	if unitID ~= "player" then
        return
    end
	--AJM:Print("Looking for Spells Done", spell, AJM.castingMount)
	if spell == AJM.castingMount then
		--AJM:Print("test", spell)
		AJM.isMounted = spell
		--AJM:Print("Mounted!", AJM.isMounted)
		AJM:RegisterEvent("UNIT_AURA")
	--else
		-- SomeThing gone wrong! so going to cast a random mount!
		--AJM:Print("This Mount is not supported!", spell)
		--AJM:JambaSendCommandToTeam( AJM.COMMAND_MOUNT_ME, "Random", "0" )
	end
	
end

function AJM:UNIT_AURA(event, unitID, ... )
	--AJM:Print("tester", unitID, AJM.isMounted)
	if unitID ~= "player" or AJM.isMounted == nil or AJM.db.dismountWithTeam == false then
        return
    end
	if not UnitBuff( unitID, AJM.isMounted) then
		--AJM:Print("I have Dismounted - Send to team!")
		if AJM.db.dismountWithMaster == true then
			if JambaApi.IsCharacterTheMaster( AJM.characterName ) == true then
				if IsShiftKeyDown() == false then	
					--AJM:Print("test")
					AJM:JambaSendCommandToTeam( AJM.COMMAND_MOUNT_DISMOUNT )
					AJM:UnregisterEvent("UNIT_AURA")
				end		
			else	
				--AJM:Print("test1")
				return
			end
		else
			AJM:JambaSendCommandToTeam( AJM.COMMAND_MOUNT_DISMOUNT )
			AJM:UnregisterEvent("UNIT_AURA")
		end		
	end
end

function AJM:TeamMount(characterName, name, mountID)
	--AJM:Print("testTeamMount", characterName, name, mountID )
	--mount with team truned off.
	if AJM.db.mountWithTeam == false then
		return
	end
	-- already mounted.
	if IsMounted() then 
		return
	end
	-- Checks if character is in range.
	if AJM.db.mountInRange == true then
		if UnitIsVisible(Ambiguate(characterName, "none") ) == false then
			--AJM:Print("UnitIsNotVisible", characterName)
			return	
		end
	end
	-- Checks done now the fun stuff!
	--Do i have the same mount as master?
	hasMount = false
	local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected, mountID = C_MountJournal.GetMountInfoByID(mountID)
	local x_creatureDisplayID, x_descriptionText, x_sourceText, x_isSelfMount, x_mountTypeID, x_uiModelSceneID = C_MountJournal.GetMountInfoExtraByID(mountID)
	if isUsable == true then
		--AJM:Print("i have this Mount", creatureName)
		hasMount = true
		mount = mountID
	else
		--AJM:Print("i DO NOT have Mount", creatureName)
		for i = 1, C_MountJournal.GetNumMounts() do
			local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected,   mountID = C_MountJournal.GetMountInfoByID(i)
			--AJM:Print("looking for a mount i can use", i)
			if isUsable == true then
				local creatureDisplayID, descriptionText, sourceText, isSelfMount, mountTypeID, uiModelSceneID = C_MountJournal.GetMountInfoExtraByID(mountID)
				-- AJM:Print("looking for a mount i can use of type", x_mountTypeID, mountTypeID, i, creatureName, spellID)
				-- mount a similar type of mount, e.g. if mounting a flying mount, also mount a flying mount
				if x_mountTypeID == mountTypeID then
					mount = mountID
					hasMount = true
					break
				end
			end	
		end
	end		
	
	--AJM:Print("test1420", mount, name)
	-- for unsupported mounts.	
	if hasMount == true then
		--AJM:Print("test14550", mount, name )
		if name == "Random" then  -- name doesn't seem to be set anywhere...
			C_MountJournal.SummonByID(0)
		else 
			--AJM:Print("test1054" )
			C_MountJournal.SummonByID( mount )
		end
		if IsMounted() == false then	
			AJM:ScheduleTimer( "AmNotMounted", 2 )
		end		
	end	
end

function AJM:AmNotMounted()
	if IsMounted() == false then
		--AJM:Print("test")
		AJM:JambaSendMessageToTeam( AJM.db.warningArea, L["I_AM_UNABLE_TO_MOUNT"], false )
	end	
end

-------------------------------------------------------------------------------------------------------------
-- JambaLoot Functionality.
-------------------------------------------------------------------------------------------------------------

function AJM:LOOT_READY( event, ... )
	if AJM.db.autoLoot == true then
			AJM:doLoot()
	end	
end

function AJM:doLoot( tries )
	AJM:DisableAutoLoot()
	if tries == nil then
		tries = 0
	end
	local numloot = GetNumLootItems()
	if numloot ~= 0 then
		for slot = 1, numloot do
			-- BETA 8.0 FIX NEED's to be local when released.
			if JambaPrivate.Core.isBetaBuild() == true then 
				_, name, _, _, lootQuality, locked = GetLootSlotInfo(slot)
			else
				_,name,_,lootQuality,locked = GetLootSlotInfo(slot)
			end	
			--AJM:Print("items", slot, locked, name, tries)
			if locked ~= nil and not locked then
				if AJM.db.tellBoERare == true then
					if lootQuality == 3 then
						AJM:ScheduleTimer( "TellTeamEpicBoE", 1 , name)
					end
				end		
				if AJM.db.tellBoEEpic == true then
					if lootQuality == 4 then
						AJM:ScheduleTimer( "TellTeamEpicBoE", 1 , name)
					end
				end
				---AJM:Print("canLoot", "slot", slot, "name", name )
				LootSlot(slot)
				
				numloot = GetNumLootItems()
			end	
		end
		tries = tries + 1
		if tries < 8 then
			AJM:doLootLoop( tries )
		else	
			CloseLoot()
		end	
	end	
end

function AJM:doLootLoop( tries )
	--AJM:Print("loop", tries)
	AJM:ScheduleTimer("doLoot", 0.8, tries )
end

function AJM:DisableAutoLoot()
	if AJM.db.autoLoot == true then	
		if GetCVar("autoLootDefault") == "1" then	
			--AJM:Print("testSetOFF")
			SetCVar( "autoLootDefault", 0 )
		end	
	end	
end


function AJM:TellTeamEpicBoE( name )
	local _, itemName, itemRarity, _, _, itemType, itemSubType = GetItemInfo( name )
	--AJM:Print("loottest", itemName, itemRarity , itemType , itemSubType )
	if itemName ~= nil then
		if itemType == WEAPON or itemType == ARMOR or itemSubType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC then
			local _, isBop = JambaUtilities:TooltipScaner(itemName)
			if isBop == ITEM_BIND_ON_EQUIP then
				AJM:Print("test", isBop )
				local rarity = nil
				if itemRarity == 4 then
					rarity = L["EPIC"]
				else
					rarity = L["RARE"]
				end
				--AJM:Print("I have looted a Epic BOE Item: ", rarity, itemName )
				AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["I_HAVE_LOOTED_X_Y_ITEM"]( rarity, itemName ), false )
			end	
		end	
	end
end


-------------------------------------------------------------------------------------------------------------
-- Jamba Commands functionality.
-------------------------------------------------------------------------------------------------------------


-- A Jamba command has been received.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	if characterName ~= self.characterName then
		-- If the command was to take a taxi...
		if commandName == AJM.COMMAND_TAKE_TAXI then
			-- If not already on a taxi...
			if not UnitOnTaxi( "player" ) then
				-- And if the taxi frame is open...
				if JambaPrivate.Core.isBetaBuild() == false then
					if TaxiFrame_ShouldShowOldStyle() == true then
						if TaxiFrame:IsVisible() then
							TakeTaxi( characterName, ... )
						end
					else
						if FlightMapFrame:IsVisible() then
							TakeTaxi( characterName, ... )
						end
					end	
				else
					local JambaTaxiFrame = AJM.TaxiFrameName
					if JambaTaxiFrame:IsVisible() then
						TakeTaxi( characterName, ... )
					end	
				end
			end
		end
		if commandName == AJM.COMMAND_EXIT_TAXI then
			if UnitOnTaxi ( "player") then
				LeaveTaxi ( characterName, ... )
			end
		end
		if commandName == AJM.COMMAND_CLOSE_TAXI then
			CloseTaxiMapFrame()
		end
		
		if commandName == AJM.COMMAND_MOUNT_ME then
			--AJM:Print("command")
			AJM:TeamMount( characterName, ... ) 
		end
		-- Dismount if mounted!
		if commandName == AJM.COMMAND_MOUNT_DISMOUNT then
			--AJM:Print("time to Dismount")
			if IsMounted() then
				Dismount()
			end	
		end		
	end
end

JambaApi.Taxi = {}
JambaApi.Taxi.MESSAGE_TAXI_TAKEN = AJM.MESSAGE_TAXI_TAKEN
