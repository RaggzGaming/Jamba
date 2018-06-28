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
	"JambaGuild", 
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
local AceGUI = LibStub( "AceGUI-3.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Guild"
AJM.settingsDatabaseName = "JambaGuildProfileDB"
AJM.chatCommand = "jamba-guild"
local L = LibStub( "AceLocale-3.0" ):GetLocale( "Core" )
AJM.parentDisplayName = L["INTERACTION"]
AJM.moduleDisplayName = L["GUILD"]
-- Icon 
AJM.moduleIcon = "Interface\\Addons\\Jamba\\Media\\GuildIcon.tga"
-- order
AJM.moduleOrder = 20

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		messageArea = JambaApi.DefaultMessageArea(),
		showJambaGuildWindow = false,
		GuildBoEItems = false,
		GuildCRItems = false,
		autoGuildItemsList = {},
		adjustMoneyWithGuildBank = false,
		goldAmountToKeepOnToon = 200,
		adjustMoneyWithMasterOnGuild = false,
		goldAmountToKeepOnToonGuild = 200,
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
				desc = L["PUSH_ALL_SETTINGS"],
				usage = "/jamba-Guild push",
				get = false,
				set = "JambaSendSettings",
				guiHidden = true,
			},
		},
	}
	return configuration
end

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------
-- Popup Dialogs.
-------------------------------------------------------------------------------------------------------------

local function InitializePopupDialogs()
	StaticPopupDialogs["JAMBAGuild_CONFIRM_REMOVE_Guild_ITEMS"] = {
        text = L["REMOVE_GUILD_LIST"],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:RemoveItem()
		end,
    }
end

-------------------------------------------------------------------------------------------------------------
-- GBank Tab Dropdown Stuff
-------------------------------------------------------------------------------------------------------------

AJM.simpleAreaList = {}
AJM.simpleGrpAreaList = {}

function AJM:TabAreaList()
	return pairs( AJM.simpleAreaList )
end

function AJM:RefreshTabDropDownList()
	JambaUtilities:ClearTable( AJM.simpleAreaList )
	for index = 1, GetNumGuildBankTabs() do 
		AJM.simpleAreaList[index] = L["GUILDTAB"]..L[" "]..index	
	end
	table.sort( AJM.simpleAreaList )
	AJM.settingsControl.tabNumListDropDownList:SetList( AJM.simpleAreaList )
end

------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	-- Initialise the popup dialogs.
	InitializePopupDialogs()
	AJM.autoGuildItemLink = nil
	AJM.autoGuildBankTab = 1
	AJM.GroupName = JambaApi.AllTag()
	AJM.putItemsInGB = {}
	-- Create the settings control.
	AJM:SettingsCreate()
	-- Initialse the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()	
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	AJM:RegisterEvent( "GUILDBANKFRAME_OPENED" ) -- Temp!
	AJM:RegisterMessage( JambaApi.MESSAGE_MESSAGE_AREAS_CHANGED, "OnMessageAreasChanged" )
	AJM:RegisterMessage( JambaApi.GROUP_LIST_CHANGED , "OnGroupAreasChanged" )
	-- Update DropDownList
	AJM:ScheduleTimer("RefreshTabDropDownList", 1 )
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
	local bottomOfInfo = AJM:SettingsCreateGuild( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfInfo )
	-- Help
	local helpTable = {}
	JambaHelperSettings:CreateHelp( AJM.settingsControl, helpTable, AJM:GetConfiguration() )		
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsCreateGuild( top )
	local buttonControlWidth = 85
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local GuildWidth = headingWidth
	local movingTop = top
	local dropBoxWidth = (headingWidth - horizontalSpacing) / 4	
	-- A blank to get layout to show right?
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L[""], movingTop, false )
	movingTop = movingTop - headingHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["GUILD_LIST_HEADER"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxShowJambaGuildWindow = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["GUILD_LIST"],
		AJM.SettingsToggleShowJambaGuildWindow,
		L["GUILD_LIST_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.GuildItemsHighlightRow = 1
	AJM.settingsControl.GuildItemsOffset = 1
	local list = {}
	list.listFrameName = "JambaGuildIteamsSettingsFrame"
	list.parentFrame = AJM.settingsControl.widgetSettings.content
	list.listTop = movingTop
	list.listLeft = left
	list.listWidth = GuildWidth
	list.rowHeight = 15
	list.rowsToDisplay = 10
	list.columnsToDisplay = 3
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 40
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 30
	list.columnInformation[2].alignment = "LEFT"
	list.columnInformation[3] = {}
	list.columnInformation[3].width = 30
	list.columnInformation[3].alignment = "LEFT"	
	list.scrollRefreshCallback = AJM.SettingsScrollRefresh
	list.rowClickCallback = AJM.SettingsGuildItemsRowClick
	AJM.settingsControl.GuildItems = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControl.GuildItems )
	movingTop = movingTop - list.listHeight - verticalSpacing
	AJM.settingsControl.GuildItemsButtonRemove = JambaHelperSettings:CreateButton(
		AJM.settingsControl, 
		buttonControlWidth, 
		left, 
		movingTop,
		L["REMOVE"],
		AJM.SettingsGuildItemsRemoveClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["ADD_ITEMS"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.GuildItemsEditBoxGuildItem = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControl,
		headingWidth,
		left,
		movingTop,
		L["ITEM_DROP"]
	)
	AJM.settingsControl.GuildItemsEditBoxGuildItem:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedGuildItem )
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControl.tabNumListDropDownList = JambaHelperSettings:CreateDropdown(
		AJM.settingsControl, 
		dropBoxWidth,	
		left,
		movingTop,
		L["GB_TAB_LIST"]
	)
	AJM.settingsControl.tabNumListDropDownList:SetList( AJM.TabAreaList() )
	AJM.settingsControl.tabNumListDropDownList:SetCallback( "OnValueChanged",  AJM.GBTabDropDownList )
	--Group
	AJM.settingsControl.GuildItemsEditBoxGuildTag = JambaHelperSettings:CreateDropdown(
		AJM.settingsControl, 
		dropBoxWidth,	
		left + dropBoxWidth + horizontalSpacing,
		movingTop, 
		L["GROUP_LIST"]
	)
	AJM.settingsControl.GuildItemsEditBoxGuildTag:SetList( JambaApi.GroupList() )
	AJM.settingsControl.GuildItemsEditBoxGuildTag:SetCallback( "OnValueChanged",  AJM.GroupListDropDownList )
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControl.GuildItemsButtonAdd = JambaHelperSettings:CreateButton(	
		AJM.settingsControl, 
		buttonControlWidth, 
		left, 
		movingTop, 
		L["ADD"],
		AJM.SettingsGuildItemsAddClick
	)
	movingTop = movingTop -	buttonHeight		
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["GB_OPTIONS"], movingTop, false )
	movingTop = movingTop - headingHeight
--[[	
	AJM.settingsControl.checkBoxGuildBoEItems = JambaHelperSettings:CreateCheckBox( 
	AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["GUILD_BOE_ITEMS"],
		AJM.SettingsToggleGuildBoEItems,
		L["GUILD_BOE_ITEMS_HELP"]
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.checkBoxGuildCRItems = JambaHelperSettings:CreateCheckBox( 
	AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["GUILD_REAGENTS"],
		AJM.SettingsToggleGuildCRItems,
		L["GUILD_REAGENTS_HELP"]
	)
	
	movingTop = movingTop - checkBoxHeight
]]	
	AJM.settingsControl.checkBoxAdjustMoneyOnToonViaGuildBank = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["GB_GOLD"],
		AJM.SettingsToggleAdjustMoneyOnToonViaGuildBank,
		L["GB_GOLD_HELP"]
	)
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.editBoxGoldAmountToLeaveOnToon = JambaHelperSettings:CreateEditBox( AJM.settingsControl,
		headingWidth,
		left,
		movingTop,
		L["GOLD_TO_KEEP"]
	)
	AJM.settingsControl.editBoxGoldAmountToLeaveOnToon:SetCallback( "OnEnterPressed", AJM.EditBoxChangedGoldAmountToLeaveOnToon )
	movingTop = movingTop - editBoxHeight	
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
	return movingTop	
end


-------------------------------------------------------------------------------------------------------------
-- Settings Callbacks.
-------------------------------------------------------------------------------------------------------------

function AJM:SettingsScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControl.GuildItems.listScrollFrame, 
		AJM:GetGuildItemsMaxPosition(),
		AJM.settingsControl.GuildItems.rowsToDisplay, 
		AJM.settingsControl.GuildItems.rowHeight
	)
	AJM.settingsControl.GuildItemsOffset = FauxScrollFrame_GetOffset( AJM.settingsControl.GuildItems.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControl.GuildItems.rowsToDisplay do
		-- Reset.
		AJM.settingsControl.GuildItems.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControl.GuildItems.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.GuildItems.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControl.GuildItems.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )		
		AJM.settingsControl.GuildItems.rows[iterateDisplayRows].columns[3].textString:SetText( "" )
		AJM.settingsControl.GuildItems.rows[iterateDisplayRows].columns[3].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )		
		AJM.settingsControl.GuildItems.rows[iterateDisplayRows].highlight:SetColorTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControl.GuildItemsOffset
		if dataRowNumber <= AJM:GetGuildItemsMaxPosition() then
			-- Put data information into columns.
			local GuildItemsInformation = AJM:GetGuildItemsAtPosition( dataRowNumber )
			AJM.settingsControl.GuildItems.rows[iterateDisplayRows].columns[1].textString:SetText( GuildItemsInformation.name )
			AJM.settingsControl.GuildItems.rows[iterateDisplayRows].columns[2].textString:SetText( GuildItemsInformation.GBTab )
			AJM.settingsControl.GuildItems.rows[iterateDisplayRows].columns[3].textString:SetText( GuildItemsInformation.tag )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControl.GuildItemsHighlightRow then
				AJM.settingsControl.GuildItems.rows[iterateDisplayRows].highlight:SetColorTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
end

function AJM:SettingsGuildItemsRowClick( rowNumber, columnNumber )		
	if AJM.settingsControl.GuildItemsOffset + rowNumber <= AJM:GetGuildItemsMaxPosition() then
		AJM.settingsControl.GuildItemsHighlightRow = AJM.settingsControl.GuildItemsOffset + rowNumber
		AJM:SettingsScrollRefresh()
	end
end

function AJM:SettingsGuildItemsRemoveClick( event )
	StaticPopup_Show( "JAMBAGuild_CONFIRM_REMOVE_Guild_ITEMS" )
end

function AJM:SettingsEditBoxChangedGuildItem( event, text )
	AJM.autoGuildItemLink = text
	AJM:SettingsRefresh()
end

function AJM:GBTabDropDownList (event, value )
	-- if nil or the blank group then don't get Name.
	if value == " " or value == nil then 
		return 
	end
	AJM.autoGuildBankTab = value
	AJM:SettingsRefresh()
end

function AJM:GroupListDropDownList (event, value )
	-- if nil or the blank group then don't get Name.
	if value == " " or value == nil then 
		return 
	end
	for index, groupName in ipairs( JambaApi.GroupList() ) do
		if index == value then
			AJM.GroupName = groupName
			break
		end
	end
	AJM:SettingsRefresh()
end

function AJM:SettingsGuildItemsAddClick( event )
	if AJM.autoGuildItemLink ~= nil and AJM.autoGuildBankTab ~= nil and AJM.GroupName ~= nil then
		AJM:AddItem( AJM.autoGuildItemLink, AJM.autoGuildBankTab, AJM.GroupName )
		AJM.autoGuildItemLink = nil
		AJM:SettingsRefresh()
	end
end

function AJM:OnMessageAreasChanged( message )
	AJM.settingsControl.dropdownMessageArea:SetList( JambaApi.MessageAreaList() )
end

function AJM:OnGroupAreasChanged( message )
	AJM.settingsControl.GuildItemsEditBoxGuildTag:SetList( JambaApi.GroupList() )
end

function AJM:SettingsSetMessageArea( event, value )
	AJM.db.messageArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowJambaGuildWindow( event, checked )
	AJM.db.showJambaGuildWindow = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleGuildBoEItems(event, checked )
	AJM.db.GuildBoEItems = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleGuildCRItems(event, checked )
	AJM.db.GuildCRItems = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAdjustMoneyOnToonViaGuildBank( event, checked )
	AJM.db.adjustMoneyWithGuildBank = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAdjustMoneyWithMasterOnGuild( event, checked )
	AJM.db.adjustMoneyWithMasterOnGuild = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedGoldAmountToLeaveOnToon( event, text )
	AJM.db.goldAmountToKeepOnToon = tonumber( text )
	if AJM.db.goldAmountToKeepOnToon == nil then
		AJM.db.goldAmountToKeepOnToon = 0
	end
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedGoldAmountToLeaveOnToonGuild( event, text )
	AJM.db.goldAmountToKeepOnToonGuild = tonumber( text )
	if AJM.db.goldAmountToKeepOnToonGuild == nil then
		AJM.db.goldAmountToKeepOnToonGuild = 0
	end
	AJM:SettingsRefresh()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.messageArea = settings.messageArea
		AJM.db.showJambaGuildWindow = settings.showJambaGuildWindow
		AJM.db.GuildBoEItems = settings.GuildBoEItems
		AJM.db.GuildCRItems = settings.GuildCRItems
		AJM.db.autoGuildItemsList = JambaUtilities:CopyTable( settings.autoGuildItemsList )
		AJM.db.adjustMoneyWithGuildBank = settings.adjustMoneyWithGuildBank
		AJM.db.goldAmountToKeepOnToon = settings.goldAmountToKeepOnToon
		AJM.db.adjustMoneyWithMasterOnGuild = settings.adjustMoneyWithMasterOnGuild
		AJM.db.goldAmountToKeepOnToonGuild = settings.goldAmountToKeepOnToonGuild
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
	AJM.settingsControl.checkBoxShowJambaGuildWindow:SetValue( AJM.db.showJambaGuildWindow )
--	AJM.settingsControl.checkBoxGuildBoEItems:SetValue( AJM.db.GuildBoEItems)
--	AJM.settingsControl.checkBoxGuildCRItems:SetValue( AJM.db.GuildCRItems)
	AJM.settingsControl.dropdownMessageArea:SetValue( AJM.db.messageArea )
	AJM.settingsControl.checkBoxAdjustMoneyOnToonViaGuildBank:SetValue( AJM.db.adjustMoneyWithGuildBank )
	AJM.settingsControl.editBoxGoldAmountToLeaveOnToon:SetDisabled( not AJM.db.adjustMoneyWithGuildBank )
	AJM.settingsControl.GuildItemsEditBoxGuildItem:SetDisabled( not AJM.db.showJambaGuildWindow )
	AJM.settingsControl.GuildItemsEditBoxGuildTag:SetDisabled( not AJM.db.showJambaGuildWindow )	
	AJM.settingsControl.tabNumListDropDownList:SetDisabled( not AJM.db.showJambaGuildWindow )
	AJM.settingsControl.GuildItemsButtonRemove:SetDisabled( not AJM.db.showJambaGuildWindow )
	AJM.settingsControl.GuildItemsButtonAdd:SetDisabled( not AJM.db.showJambaGuildWindow )	
	AJM:SettingsScrollRefresh()

end

--Comms not sure if we going to use comms here.
-- A Jamba command has been received.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	if characterName == self.characterName then
		return
	end
end

-------------------------------------------------------------------------------------------------------------
-- Guild functionality.
-------------------------------------------------------------------------------------------------------------

function AJM:GetGuildItemsMaxPosition()
	return #AJM.db.autoGuildItemsList
end

function AJM:GetGuildItemsAtPosition( position )
	return AJM.db.autoGuildItemsList[position]
end

function AJM:AddItem( itemLink, GBTab, itemTag )
	--AJM:Print("testDBAdd", itemLink, GBTab, itemTag )
	-- Get some more information about the item.
	local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo( itemLink )
	-- If the item could be found.
	if name ~= nil then
		local itemInformation = {}
		itemInformation.link = link
		itemInformation.name = name
		itemInformation.GBTab = GBTab
		itemInformation.tag = itemTag
			table.insert( AJM.db.autoGuildItemsList, itemInformation )
			AJM:SettingsRefresh()			
			AJM:SettingsGuildItemsRowClick( 1, 1 )
	end	
end

function AJM:RemoveItem()
	table.remove( AJM.db.autoGuildItemsList, AJM.settingsControl.GuildItemsHighlightRow )
	AJM:SettingsRefresh()
	AJM:SettingsGuildItemsRowClick( 1, 1 )		
end


function AJM:GUILDBANKFRAME_OPENED()
	if 	AJM.db.showJambaGuildWindow == true then
		AJM:AddToGuildBankFromList()
	end
	if AJM.db.adjustMoneyWithGuildBank == true then
		AddGoldToGuildBank()
	end
end

function AJM:AddToGuildBankFromList()
	local delay = 1.5
	for position, itemInformation in pairs( AJM.db.autoGuildItemsList ) do
		if JambaApi.IsCharacterInGroup(AJM.characterName, itemInformation.tag ) == true then
			--AJM:Print("AddToGB", position, itemInformation.name, itemInformation.GBTab )
			name, icon, isViewable, canDeposit, numWithdrawals, remainingWithdrawals = GetGuildBankTabInfo(itemInformation.GBTab)
			if canDeposit == true then
				for bag,slot,link in LibBagUtils:Iterate("BAGS", itemInformation.link ) do
					if bag ~= nil then
						delay = delay + 1.5
						AJM:ScheduleTimer("PlaceItemInGuildBank", delay, bag, slot, itemInformation.GBTab )
					end
				end
			end
		end
	end
end

function AJM:SelectBankTab( tab )
	if GetCurrentGuildBankTab() == tab then
	else
		GuildBankTab_OnClick(_G["GuildBankTab" .. tab], "LeftButton", tab )
	end
end

function AJM:PlaceItemInGuildBank(bag, slot, tab)
	if GuildBankFrame:IsVisible() == true then
		AJM:SelectBankTab( tab )				
		if GetCurrentGuildBankTab() == tab then
			PickupContainerItem( bag,slot )
			UseContainerItem( bag,slot )
		end	
	end
end

---------
function AJM:GuildBoEItems()
	if JambaApi.IsCharacterTheMaster( AJM.characterName ) == true then
		return
	end
	for index, character in JambaApi.TeamListOrderedOnline() do
		--AJM:Print("Team", character )
		local teamCharacterName = ( Ambiguate( character, "short" ) )
		local GuildPlayersName = GetUnitName("NPC")
		if GuildPlayersName == teamCharacterName then
			if JambaApi.IsCharacterTheMaster(character) == true and JambaUtilities:CheckIsFromMyRealm(character) == true then
				for bag,slot,link in LibBagUtils:Iterate("BAGS") do
					if bag ~= nil then			
						local _, _, locked, quality = GetContainerItemInfo(bag, slot)
						-- quality is Uncommon (green) to  Epic (purple) 2 - 3 - 4
						if quality ~= nil and locked == false then
							if quality >= 2 and quality <= 4 then 
								-- tooltips scan is the olny way to find if the item is BoE in bags!
								local isBoe = JambaUtilities:ToolTipBagScaner(link, bag, slot)
								-- if the item is boe then add it to the Guild list!
								if isBoe ~= ITEM_SOULBOUND then
									--AJM:Print("test21", link, locked)
									for iterateGuildSlots = 1, (MAX_Guild_ITEMS - 1) do
										if GetGuildPlayerItemLink( iterateGuildSlots ) == nil then
											PickupContainerItem( bag, slot )
											ClickGuildButton( iterateGuildSlots )
										end	
									end
								end	
							end	
						end	
					end	
				end
			end
		end
	end		
end

function AJM:GuildCRItems()
	if JambaApi.IsCharacterTheMaster( AJM.characterName ) == true then
		return
	end
	for index, character in JambaApi.TeamListOrderedOnline() do
		--AJM:Print("Team", character )
		local teamCharacterName = ( Ambiguate( character, "short" ) )
		local GuildPlayersName = GetUnitName("NPC")
		if GuildPlayersName == teamCharacterName then
			if JambaApi.IsCharacterTheMaster(character) == true and JambaUtilities:CheckIsFromMyRealm(character) == true then
				for bag,slot,itemLink in LibBagUtils:Iterate("BAGS") do
					if itemLink then
						-- using legion CraftingReagent API, as tooltip massess up some "items"
						local _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,isCraftingReagent = GetItemInfo(itemLink)
						if isCraftingReagent == true then
							--AJM:Print("GuildCraftingGoods", isCraftingReagent, itemLink)
							-- tooltips scan is the olny way to find if the item is BOP in bags!
							local isBop = JambaUtilities:TooltipScaner(itemLink)
							--AJM:Print("testBOP", itemLink, isBop)
							if isBop ~= ITEM_BIND_ON_PICKUP then
							--AJM:Print("AddToGuild", itemLink)
								for iterateGuildSlots = 1, (MAX_Guild_ITEMS - 1) do
									if GetGuildPlayerItemLink( iterateGuildSlots ) == nil then
										PickupContainerItem( bag, slot )
										ClickGuildButton( iterateGuildSlots )
									end	
								end	
							end	
						end	
					end	
				end
			end
		end
	end		
end

function AddGoldToGuildBank()
	if not CanWithdrawGuildBankMoney() then
		return
	end
	local moneyToKeepOnToon = tonumber( AJM.db.goldAmountToKeepOnToon ) * 10000
	local moneyOnToon = GetMoney()
	local moneyToDepositOrWithdraw = moneyOnToon - moneyToKeepOnToon
	--AJM:Print(" testa", moneyToDepositOrWithdraw )
	if moneyToDepositOrWithdraw == 0 then
		return
	end
	if moneyToDepositOrWithdraw > 0 then
	--	AJM:Print(" test", moneyToDepositOrWithdraw )
		--DepositGuildBankMoney( moneyToDepositOrWithdraw )
		AJM:ScheduleTimer("SendMoneyToGuild", 0.5, moneyToDepositOrWithdraw)
	else
		local takeoutmoney = -1 * moneyToDepositOrWithdraw
	--	AJM:Print("takeout", takeoutmoney)
		AJM:ScheduleTimer("TakeMoneyOut", 0.5, takeoutmoney )
	end
end


function AJM:SendMoneyToGuild( money )
	DepositGuildBankMoney( money )
end

function AJM:TakeMoneyOut( money )
	WithdrawGuildBankMoney( money )	
end