-- ================================================================================ --
--				Jamba EE - ( The Awesome MultiBoxing Assistant Ebony's Edition )    --
--				Current Author: Jennifer Cally (Ebony)								--
--				Copyright 2015 - 2018 Jennifer Cally "Ebony"						--
--																					--
--				License: The MIT License (MIT)										--
--				Copyright (c) 2008-2015  Michael "Jafula" Miller					--
--																					--
-- ================================================================================ --

-- The global private table for Jamba.
JambaPrivate = {}
JambaPrivate.Core = {}
JambaPrivate.Communications = {}
JambaPrivate.Message = {}
JambaPrivate.Team = {}
JambaPrivate.Tag = {}

-- The global public API table for Jamba.
JambaApi = {}

local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaCore", 
	"AceConsole-3.0" 
)

-- JambaCore is not a module, but the same naming convention for these values is convenient.
AJM.moduleName = "Jamba-Core"
local L = LibStub( "AceLocale-3.0" ):GetLocale( "Core" )
AJM.moduleDisplayName = L["NEWS"]
AJM.settingsDatabaseName = "JambaCoreProfileDB"
AJM.parentDisplayName = L["NEWS"]
AJM.chatCommand = "jamba"
AJM.teamModuleName = "Jamba-Team"
-- Icon 
AJM.moduleIcon = "Interface\\Addons\\Jamba\\Media\\NewsIcon.tga"
-- order
AJM.moduleOrder = 1


-- Load libraries.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )
local AceGUI = LibStub("AceGUI-3.0")

-- Create frame for Jamba Settings.
JambaPrivate.SettingsFrame = {}
JambaPrivate.SettingsFrame.Widget = AceGUI:Create( "JambaWindow" )
--JambaPrivate.SettingsFrame.Widget = AceGUI:Create( "Frame" )
JambaPrivate.SettingsFrame.Widget:SetTitle( "" )
JambaPrivate.SettingsFrame.Widget:SetStatusText(L["STATUSTEXT"])
JambaPrivate.SettingsFrame.Widget:SetWidth(900)
JambaPrivate.SettingsFrame.Widget:SetHeight(650)
JambaPrivate.SettingsFrame.Widget:SetLayout( "Fill" )
JambaPrivate.SettingsFrame.WidgetTree = AceGUI:Create( "JambaTreeGroup" )
JambaPrivate.SettingsFrame.TreeGroupStatus = { treesizable = false, groups = {} }
JambaPrivate.SettingsFrame.WidgetTree:SetStatusTable( JambaPrivate.SettingsFrame.TreeGroupStatus )
JambaPrivate.SettingsFrame.WidgetTree:EnableButtonTooltips( false )
JambaPrivate.SettingsFrame.Widget:AddChild( JambaPrivate.SettingsFrame.WidgetTree )
JambaPrivate.SettingsFrame.WidgetTree:SetLayout( "Fill" )

function AJM:OnEnable()

end

function AJM:OnDisable()
end

local function JambaSettingsTreeSort( a, b )
	local aText = ""
	local bText = ""
	local aJambaOrder = 0
	local bJambaOrder = 0
	if a ~= nil then
		aText = a.text
		aJambaOrder = a.jambaOrder
	end	
	if b ~= nil then
		bText = b.text
		bJambaOrder = b.jambaOrder
	end
	if aText == L["JAMBA"] or bText == L["JAMBA"] then
		if aText == L["JAMBA"] then
			return true
		end
		if bText == L["JAMBA"] then
			return false
		end
	end
	if aJambaOrder == bJambaOrder then
		return aText < bText
	end
	return aJambaOrder < bJambaOrder
end

local function JambaTreeGroupTreeGetParent( parentName )
	local parent
	for index, tableInfo in ipairs( JambaPrivate.SettingsFrame.Tree.Data ) do
		if tableInfo.value == parentName then
			parent = tableInfo			
		end
	end
	return parent
end

local function GetTreeGroupChildEmaOrder( childName )
	local order = 1000
	if childName == L["NEWS"] then
		order = 5
	end
	if childName == L["TEAM"] then
		order = 10
	end
	
	
	return order
end	


local function JambaAddModuleToSettings( childName, parentName, moduleIcon, order, moduleFrame, tabGroup )
	-- 	childName is the parentName then make the child the parent.
	if childName == parentName then
		local parent = JambaTreeGroupTreeGetParent( parentName )
		if parent == nil then
			table.insert( JambaPrivate.SettingsFrame.Tree.Data, { value = childName, text = childName, jambaOrder = order, icon = moduleIcon } )
			parent = JambaTreeGroupTreeGetParent( parentName )
			JambaPrivate.SettingsFrame.Tree.ModuleFrames[childName] = moduleFrame
			JambaPrivate.SettingsFrame.Tree.ModuleFramesTabGroup[childName] = tabGroup
		end	

	else
	-- [PH] Old Core for modules not supported by the new system -- ebony! 
	local parent = JambaTreeGroupTreeGetParent( parentName )
	if parent == nil then
		table.insert( JambaPrivate.SettingsFrame.Tree.Data, { value = parentName, text = parentName, jambaOrder = order } )
		parent = JambaTreeGroupTreeGetParent( parentName )
	end
	if parent.children == nil then
		parent.children = {}
	end	
	table.insert( parent.children, { value = childName, text = childName, jambaOrder = order, icon = moduleIcon } )
	table.sort( JambaPrivate.SettingsFrame.Tree.Data, JambaSettingsTreeSort )
	table.sort( parent.children, JambaSettingsTreeSort )
	JambaPrivate.SettingsFrame.Tree.ModuleFrames[childName] = moduleFrame
	JambaPrivate.SettingsFrame.Tree.ModuleFramesTabGroup[childName] = tabGroup
	end
end



local function JambaModuleSelected( tree, event, treeValue, selected )
	local parentValue, value = strsplit( "\001", treeValue )
	if tree == nil and event == nil then
		-- Came from chat command.
		value = treeValue
	end
	if value == nil then
		value = parentValue
	end
	JambaPrivate.SettingsFrame.Widget:Show()
	if JambaPrivate.SettingsFrame.Tree.CurrentChild ~= nil then
		
		JambaPrivate.SettingsFrame.Tree.CurrentChild.frame:Hide()
		JambaPrivate.SettingsFrame.Tree.CurrentChild = nil
	end
	for moduleValue, moduleFrame in pairs( JambaPrivate.SettingsFrame.Tree.ModuleFrames ) do	
		if moduleValue == value then
			moduleFrame:SetParent( JambaPrivate.SettingsFrame.WidgetTree )
			moduleFrame:SetWidth( JambaPrivate.SettingsFrame.WidgetTree.content:GetWidth() or 0 )
			moduleFrame:SetHeight( JambaPrivate.SettingsFrame.WidgetTree.content:GetHeight() or 0 )
			moduleFrame.frame:SetAllPoints() 
			moduleFrame.frame:Show()	
			JambaPrivate.SettingsFrame.Tree.CurrentChild = moduleFrame
			-- Hacky hack hack.
			if JambaPrivate.SettingsFrame.Tree.ModuleFramesTabGroup[value] ~= nil then		
				JambaPrivate.SettingsFrame.Tree.ModuleFramesTabGroup[value]:SelectTab( "OPTIONS" )
			else
				-- Hacky hack hack.
				LibStub( "AceConfigDialog-3.0" ):Open( AJM.moduleName.."OPTIONS", moduleFrame )
			end			
			return
		end
	end
end

JambaPrivate.SettingsFrame.Tree = {}
JambaPrivate.SettingsFrame.Tree.Data = {}
JambaPrivate.SettingsFrame.Tree.ModuleFrames = {}
JambaPrivate.SettingsFrame.Tree.ModuleFramesTabGroup = {}
JambaPrivate.SettingsFrame.Tree.CurrentChild = nil
JambaPrivate.SettingsFrame.Tree.Add = JambaAddModuleToSettings
JambaPrivate.SettingsFrame.Tree.ButtonClick = JambaModuleSelected
JambaPrivate.SettingsFrame.WidgetTree:SetTree( JambaPrivate.SettingsFrame.Tree.Data )
JambaPrivate.SettingsFrame.WidgetTree:SetCallback( "OnClick", JambaPrivate.SettingsFrame.Tree.ButtonClick )
JambaPrivate.SettingsFrame.Widget:Hide()
table.insert( UISpecialFrames, "JambaSettingsWindowsFrame" )

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
	},
}

-- Configuration.
local function GetConfiguration()
	local configuration = {
		name = "Jamba",
		handler = AJM,
		type = 'group',
		childGroups  = "tab",
		get = "ConfigurationGetSetting",
		set = "ConfigurationSetSetting",
		args = {	
			push = {
				type = "input",
				name = L["PUSH_SETTINGS"],
				desc = L["PUSH_SETTINGS_INFO"],
				usage = "/jamba push",
				get = false,
				set = "SendSettingsAllModules",
				order = 4,
				guiHidden = true,
			},
			resetsettingsframe = {
				type = "input",
				name = L["RESET_SETTINGS_FRAME"],
				desc = L["RESET_SETTINGS_FRAME"],
				usage = "/jamba resetsettingsframe",
				get = false,
				set = "ResetSettingsFrame",
				order = 5,
				guiHidden = true,				
			},
		},
	}
	return configuration
end

-- Get a settings value.
function AJM:ConfigurationGetSetting( key )
	return AJM.db[key[#key]]
end

-- Set a settings value.
function AJM:ConfigurationSetSetting( key, value )
	AJM.db[key[#key]] = value
end

local function DebugMessage( ... )
	AJM:Print( ... )
end

--WOW BetaBuild!
local function isBetaBuild()
	local _, _, _, tocversion = GetBuildInfo()
	-- Build For BFA 8.0.1 2018
	if tocversion >= 80000 then
		return true 
	else
		return  false
	end
end

--Ema Alpha
local function isEmaAlphaBuild()
	local EmaVersion = GetAddOnMetadata("EMA", "version")
	-- Jamba Alpha Build
	local Alpha = EmaVersion:find( "Alpha" )
	if Alpha then
		return true
	else
		return false
	end	
end

-------------------------------------------------------------------------------------------------------------
-- Module management.
-------------------------------------------------------------------------------------------------------------

-- Register a Jamba module.
local function RegisterModule( moduleAddress, moduleName )
	if AJM.registeredModulesByName == nil then
		AJM.registeredModulesByName = {}
	end
	if AJM.registeredModulesByAddress == nil then
		AJM.registeredModulesByAddress = {}
	end
	AJM.registeredModulesByName[moduleName] = moduleAddress
	AJM.registeredModulesByAddress[moduleAddress] = moduleName
end

-------------------------------------------------------------------------------------------------------------
-- Settings sending and receiving.
-------------------------------------------------------------------------------------------------------------

-- Send the settings for the module specified (using its address) to other Jamba Team characters.
local function SendSettings( moduleAddress, settings )
	-- Get the name of the module.
	local moduleName = AJM.registeredModulesByAddress[moduleAddress]
	-- Send the settings identified by the module name.
	JambaPrivate.Communications.SendSettings( moduleName, settings )
end

-- Settings are received, pass them to the relevant module.
local function OnSettingsReceived( sender, moduleName, settings )
	sender = JambaUtilities:AddRealmToNameIfMissing( sender )
	--AJM:Print("onsettings", sender, moduleName )
	-- Get the address of the module.
	local moduleAddress = AJM.registeredModulesByName[moduleName]	
	-- can not receive a message from a Module not Loaded so ignore it. Better tell them its not loaded --ebony.
	if moduleAddress == nil then 
		AJM:Print(L["MODULE_NOT_LOADED"], moduleName)
		return
	else
	-- loaded? Pass the module its settings.
		moduleAddress:JambaOnSettingsReceived( sender, settings )
	end	
end

function AJM:SendSettingsAllModules()
	AJM:Print( "Sending settings for all modules." )
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		AJM:Print( "Sending settings for: ", moduleName )
		moduleAddress:JambaSendSettings()
	end
end


-------------------------------------------------------------------------------------------------------------
-- Commands sending and receiving.
-------------------------------------------------------------------------------------------------------------

-- Send a command for the module specified (using its address) to other Jamba Team characters.
local function SendCommandToTeam( moduleAddress, commandName, ... )
	-- Get the name of the module.
	local moduleName = AJM.registeredModulesByAddress[moduleAddress]
	-- Send the command identified by the module name.
	if moduleAddress == nil then 
		AJM:Print(L["MODULE_NOT_LOADED"], moduleName)
		return
	else	
	JambaPrivate.Communications.SendCommandAll( moduleName, commandName, ... )
	end
end

-- Send a command for the module specified (using its address) to the master character.
local function SendCommandToMaster( moduleAddress, commandName, ... )
	-- Get the name of the module.
	local moduleName = AJM.registeredModulesByAddress[moduleAddress]
	-- Send the command identified by the module name.
	if moduleAddress == nil then 
		AJM:Print(L["MODULE_NOT_LOADED"], moduleName)
		return
	else	
	JambaPrivate.Communications.SendCommandMaster( moduleName, commandName, ... )
	end
end

local function SendCommandToToon( moduleAddress, characterName, commandName, ... )
	-- Get the name of the module.
	local moduleName = AJM.registeredModulesByAddress[moduleAddress]
	-- Send the command identified by the module name.
	if moduleAddress == nil then 
		AJM:Print(L["MODULE_NOT_LOADED"], moduleName)
		return
	else
	JambaPrivate.Communications.SendCommandToon( moduleName, characterName, commandName, ... )
	end
end

-- A command is received, pass it to the relevant module.
local function OnCommandReceived( sender, moduleName, commandName, ... )
	sender = JambaUtilities:AddRealmToNameIfMissing( sender )
	-- Get the address of the module.
	local moduleAddress = AJM.registeredModulesByName[moduleName]
	-- Pass the module its settings.
	if moduleAddress == nil then 
		AJM:Print(L["MODULE_NOT_LOADED"], moduleName)
		return
	else
		moduleAddress:JambaOnCommandReceived( sender, commandName, ... )
	end		
end

-------------------------------------------------------------------------------------------------------------
-- Jamba Core Profile Support.
-------------------------------------------------------------------------------------------------------------

function AJM:FireBeforeProfileChangedEvent()
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		if moduleName ~= AJM.moduleName then		
			moduleAddress:BeforeJambaProfileChanged()
		end
	end
end

function AJM:CanChangeProfileForModule( moduleName )
	if (moduleName ~= AJM.moduleName) and (moduleName ~= AJM.teamModuleName) then		
		return true
	end
	return false
end

function AJM:FireOnProfileChangedEvent( moduleAddress )
	moduleAddress.db = moduleAddress.completeDatabase.profile
	moduleAddress:OnJambaProfileChanged()
end

function AJM:OnProfileChanged( event, database, newProfileKey, ... )
	AJM:Print( "Profile changed - iterating all modules.")	
	AJM:FireBeforeProfileChangedEvent()
	-- Do the team module before all the others.
	local teamModuleAddress = AJM.registeredModulesByName[AJM.teamModuleName]
	AJM:Print( "Changing profile: ", AJM.teamModuleName )
	teamModuleAddress.completeDatabase:SetProfile( newProfileKey )
	AJM:FireOnProfileChangedEvent( teamModuleAddress )
	-- Do the other modules.
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		if AJM:CanChangeProfileForModule( moduleName ) == true then		
			AJM:Print( L["CHANGING_PROFILE"] , moduleName )
			moduleAddress.completeDatabase:SetProfile( newProfileKey )
			AJM:FireOnProfileChangedEvent( moduleAddress )
		end
	end
end

function AJM:OnProfileCopied( event, database, sourceProfileKey )
	AJM:Print( "Profile copied - iterating all modules." )
	AJM:FireBeforeProfileChangedEvent()
	-- Do the team module before all the others.
	local teamModuleAddress = AJM.registeredModulesByName[AJM.teamModuleName]
	AJM:Print( L["COPYING_PROFILE"], AJM.teamModuleName )
	teamModuleAddress.completeDatabase:CopyProfile( sourceProfileKey, true )
	AJM:FireOnProfileChangedEvent( teamModuleAddress )	
	-- Do the other modules.
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		if AJM:CanChangeProfileForModule( moduleName ) == true then		
			AJM:Print( L["COPYING_PROFILE"], moduleName )
			moduleAddress.completeDatabase:CopyProfile( sourceProfileKey, true )
			AJM:FireOnProfileChangedEvent( moduleAddress )
		end
	end
end

function AJM:OnProfileReset( event, database )
	AJM:Print( L["PROFILE_RESET"] )
	AJM:FireBeforeProfileChangedEvent()
	-- Do the team module before all the others.
	local teamModuleAddress = AJM.registeredModulesByName[AJM.teamModuleName]
	AJM:Print( L["RESETTING_PROFILE"], AJM.teamModuleName )
	teamModuleAddress.completeDatabase:ResetProfile()
	AJM:FireOnProfileChangedEvent( teamModuleAddress )	
	-- Do the other modules.	
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		if AJM:CanChangeProfileForModule( moduleName ) == true then		
			AJM:Print( L["RESETTING_PROFILE"], moduleName )
			moduleAddress.completeDatabase:ResetProfile()
			AJM:FireOnProfileChangedEvent( moduleAddress )
		end
	end
end

function AJM:OnProfileDeleted( event, database, profileKey )
	AJM:Print( L["PROFILE_DELETED"] )
	AJM:FireBeforeProfileChangedEvent()
	-- Do the team module before all the others.
	local teamModuleAddress = AJM.registeredModulesByName[AJM.teamModuleName]
	AJM:Print( L["DELETING_PROFILE"], AJM.teamModuleName )
	teamModuleAddress.completeDatabase:DeleteProfile( profileKey, true )
	AJM:FireOnProfileChangedEvent( teamModuleAddress )	
	-- Do the other modules.		
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		if AJM:CanChangeProfileForModule( moduleName ) == true then		
			AJM:Print( L["DELETING_PROFILE"], moduleName )
			moduleAddress.completeDatabase:DeleteProfile( profileKey, true )
			AJM:FireOnProfileChangedEvent( moduleAddress )
		end
	end
end

-------------------------------------------------------------------------------------------------------------
-- Jamba Core Initialization.
-------------------------------------------------------------------------------------------------------------

-- Initialize the addon.
function AJM:OnInitialize()
	-- Tables to hold registered modules - lookups by name and by address.  
	-- By name is used for communication between clients and by address for communication between addons on the same client.
	AJM.registeredModulesByName = {}
	AJM.registeredModulesByAddress = {}
	-- Create the settings database supplying the settings values along with defaults.
    AJM.completeDatabase = LibStub( "AceDB-3.0" ):New( AJM.settingsDatabaseName, AJM.settings )
	AJM.completeDatabase.RegisterCallback( AJM, "OnProfileChanged", "OnProfileChanged" )
	AJM.completeDatabase.RegisterCallback( AJM, "OnProfileCopied", "OnProfileCopied" )
	AJM.completeDatabase.RegisterCallback( AJM, "OnProfileReset", "OnProfileReset" )	
	AJM.completeDatabase.RegisterCallback( AJM, "OnProfileDeleted", "OnProfileDeleted" )	
	
	AJM.db = AJM.completeDatabase.profile
	-- Create the settings.
	LibStub( "AceConfig-3.0" ):RegisterOptionsTable( 
		AJM.moduleName, 
		GetConfiguration() 
	)
	-- Create the settings frame.
	AJM:CoreSettingsCreate()
	AJM.settingsFrame = AJM.settingsControl.widgetSettings.frame
	-- Blizzard options frame.
	local frame = CreateFrame( "Frame" )
	frame.name = L["JAMBA"]
	local button = CreateFrame( "Button", nil, frame, "OptionsButtonTemplate" )
	button:SetPoint( "CENTER" )
	button:SetText( "/jamba" )
	button:SetScript( "OnClick", AJM.LoadJambaSettings )
	InterfaceOptions_AddCategory( frame )
	-- Create the settings profile support.
	LibStub( "AceConfig-3.0" ):RegisterOptionsTable( 
		AJM.moduleName.."OPTIONS",
		LibStub( "AceDBOptions-3.0" ):GetOptionsTable( AJM.completeDatabase ) 
	)
	local profileContainerWidget = AceGUI:Create( "SimpleGroup" )
	profileContainerWidget:SetLayout( "Fill" )
	-- We need this to make it a working Module
	local moduleIcon = "Interface\\Addons\\Jamba\\Media\\SettingsIcon.tga"
	local order  = 10
	JambaPrivate.SettingsFrame.Tree.Add( L["OPTIONS"], L["OPTIONS"], moduleIcon, order, profileContainerWidget, nil )
	-- Register the core as a module.
	RegisterModule( AJM, AJM.moduleName )
	-- Register the chat command.
	AJM:RegisterChatCommand( AJM.chatCommand, "JambaChatCommand" )
	
	
	-- Attempt to load modules, if they are disabled, they won't be loaded.
	-- TODO: This kinda defeats the purpose of the module system if we have to update core each time a module is added.
	AJM:LoadJambaModule( "Jamba-AdvancedLoot" )
	AJM:LoadJambaModule( "Jamba-DisplayTeam" )
	AJM:LoadJambaModule( "Jamba-Follow" )
	AJM:LoadJambaModule( "Jamba-FTL" )
	AJM:LoadJambaModule( "Jamba-ItemUse" )
	AJM:LoadJambaModule( "Jamba-Macro" )
	AJM:LoadJambaModule( "Jamba-Proc" )
	AJM:LoadJambaModule( "Jamba-Purchase" )
	AJM:LoadJambaModule( "Jamba-Quest" )
	AJM:LoadJambaModule( "Jamba-QuestWatcher" )
	AJM:LoadJambaModule( "Jamba-Sell" )
	AJM:LoadJambaModule( "Jamba-Talk" )
	AJM:LoadJambaModule( "Jamba-Target" )
	AJM:LoadJambaModule( "Jamba-Taxi" )
	AJM:LoadJambaModule( "Jamba-Toon" )
	AJM:LoadJambaModule( "Jamba-Trade" )
	AJM:LoadJambaModule( "Jamba-Video" )
	AJM:LoadJambaModule( "Jamba-Curr" )
	AJM:LoadJambaModule( "Jamba-Mount" )
end

function AJM:LoadJambaModule( moduleName )
	local loaded, reason = LoadAddOn( moduleName )
	if not loaded then
		if reason ~= "DISABLED" and reason ~= "MISSING" then
			AJM:Print(L["Failed_LOAD_MODULE"]..moduleName.."' ["..reason.."]." )
		end
	end
end

function AJM:CoreSettingsCreateInfo( top )
	-- Get positions and dimensions.
	local buttonPushAllSettingsWidth = 200
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local radioBoxHeight = JambaHelperSettings:GetRadioBoxHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local labelContinueHeight = JambaHelperSettings:GetContinueLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local indent = horizontalSpacing * 10
	local indentContinueLabel = horizontalSpacing * 18
	local indentSpecial = indentContinueLabel + 9
	local checkBoxThirdWidth = (headingWidth - indentContinueLabel) / 3
	local column1Left = left
	local column2Left = column1Left + checkBoxThirdWidth + horizontalSpacing - 35
	local column1LeftIndent = left + indentContinueLabel
	local column2LeftIndent = column1LeftIndent + checkBoxThirdWidth + horizontalSpacing
	local column3LeftIndent = column2LeftIndent + checkBoxThirdWidth + horizontalSpacing
	local movingTop = top
	--Main Heading
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["STATUSTEXT"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.labelInformation1 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["ME"]
	)	
	movingTop = movingTop + movingTop * 2
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["RELEASE_NOTES"]..GetAddOnMetadata("Jamba", "version") , movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.labelInformation10 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEXT1"]
	)
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation11 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEXT2"]
	)	
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation12 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEXT3"]
	)	
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation13	= JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEXT4"]
	)	
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation14 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEXT5"]
	)	
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation15 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEXT6"]
	)	
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation16 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEXT7"]
	)	
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation17 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEXT8"]
	)	
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation18 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEXT9"]
	)	
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation19 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEXT10"]
	)	
	--movingTop = movingTop - labelContinueHeight
	-- Useful websites Heading
	movingTop = movingTop - labelContinueHeight * 2
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["WEBSITES"], movingTop, false )	
	movingTop = movingTop - headingHeight
	AJM.settingsControl.labelInformation30 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEMP_WEBSITE1"]
	)		
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation21 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["ME_TWITTER"]
		
	)
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation22 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["D-B"]
	)
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation23 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["ISB"]
	)
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation24 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEMP_WEBSITE2"]
	)
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation25 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["TEMP_WEBSITE3"]
	)	
	-- Special thanks Heading
	movingTop = movingTop - buttonHeight 
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["SPECIAL_THANKS"], movingTop, false )	
	movingTop = movingTop - headingHeight
	AJM.settingsControl.labelInformation20 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["THANKS1"]
	)	
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation21 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["THANKS2"]
		
	)	
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation22 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["THANKS3"]
	)	
	--CopyRight heading
	movingTop = movingTop - labelContinueHeight * 4
	AJM.settingsControl.labelInformation40 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["COPYRIGHT"]
	)
	movingTop = movingTop - labelContinueHeight
	AJM.settingsControl.labelInformation41 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column2Left, 
		movingTop,
		L["COPYRIGHTTWO"]
	)	
	return movingTop	
end

function AJM:CoreSettingsCreate()
	AJM.settingsControl = {}
	-- Create the settings panel.
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControl, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayName, 
		AJM.SendSettingsAllModules,
		AJM.moduleIcon,
		AJM.moduleOrder	
	)
	local bottomOfInfo = AJM:CoreSettingsCreateInfo( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfInfo )
end

-- Send core settings.
function AJM:JambaSendSettings()
	JambaPrivate.Communications.SendSettings( AJM.moduleName, AJM.db )
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
end

-- Core settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )
	--Checks character is not the the character that send the settings. Now checks the character has a realm on there name to match Jamba team list.
	--characterName = JambaUtilities:AddRealmToNameIfMissing( characterName )
	if characterName ~= AJM.characterName then
		-- Update the settings.
        -- TODO: What is this minimap icon?
		AJM.db.showMinimapIcon = settings.showMinimapIcon
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["SETTINGS_RECEIVED_FROM_A"]( characterName ) )
		-- Tell the team?
		--AJM:JambaSendMessageToTeam( AJM.db.messageArea,  L["Settings received from A."]( characterName ), false )
	end
end

function AJM:LoadJambaSettings()
	InterfaceOptionsFrameCancel_OnClick()
	HideUIPanel( GameMenuFrame )
	AJM:JambaChatCommand( "" )
end

-- Handle the chat command.
function AJM:JambaChatCommand( input )
    if not input or input:trim() == "" then
		JambaPrivate.SettingsFrame.Widget:Show()
		JambaPrivate.SettingsFrame.WidgetTree:SelectByValue( L["NEWS"] )
		JambaPrivate.SettingsFrame.Tree.ButtonClick( nil, nil, AJM.moduleDisplayName, false)
    else
        LibStub( "AceConfigCmd-3.0" ):HandleCommand( AJM.chatCommand, AJM.moduleName, input )
    end
end

function AJM:ResetSettingsFrame()
	AJM:Print( L["FRAME_RESET"] )
	JambaPrivate.SettingsFrame.Widget:SetPoint("TOPLEFT", 0, 0)
	JambaPrivate.SettingsFrame.Widget:SetWidth(900)
	JambaPrivate.SettingsFrame.Widget:SetHeight(650)
	JambaPrivate.SettingsFrame.Widget:Show()
end

-- Functions available from Jamba Core for other Jamba internal objects.
JambaPrivate.Core.RegisterModule = RegisterModule
JambaPrivate.Core.SendSettings = SendSettings
JambaPrivate.Core.OnSettingsReceived = OnSettingsReceived
JambaPrivate.Core.SendCommandToTeam = SendCommandToTeam
JambaPrivate.Core.SendCommandToMaster = SendCommandToMaster
JambaPrivate.Core.SendCommandToToon = SendCommandToToon
JambaPrivate.Core.OnCommandReceived = OnCommandReceived
JambaPrivate.Core.isBetaBuild = isBetaBuild
JambaPrivate.Core.isEmaAlphaBuild = isEmaAlphaBuild
