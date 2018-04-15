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
	"JambaTeam",
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceHook-3.0",
	"AceTimer-3.0"
)

-- Load libraries.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )

-- Constants required by JambaModule and Locale for this module.
AJM.moduleName = "Jamba-Team"
AJM.settingsDatabaseName = "JambaTeamProfileDB"
AJM.chatCommand = "jamba-team"
local L = LibStub( "AceLocale-3.0" ):GetLocale( "Core" )
AJM.parentDisplayName = L["TEAM"]
AJM.moduleDisplayName = L["TEAM"]
-- Icon 
AJM.moduleIcon = "Interface\\Addons\\Jamba\\Media\\TeamCore.tga"
-- order
AJM.moduleOrder = 20


-- Jamba key bindings.
BINDING_HEADER_JAMBATEAM = L["JAMBA-TEAM"]
BINDING_NAME_JAMBATEAMINVITE = L["INVITE_GROUP"]
BINDING_NAME_JAMBATEAMDISBAND = L["DISBAND_GROUP"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		master = "",
        teamList = {},
		newTeamList = {},
		isboxerSync = true,
		--characterOnline = {},
		--characterClass = {},
		masterChangePromoteLeader = false,
		inviteAcceptTeam = true,
		inviteAcceptFriends = false,
		inviteAcceptGuild = false,
		inviteDeclineStrangers = false,
		inviteConvertToRaid = true,
		inviteSetAllAssistant = false,

		masterChangeClickToMove = false,
	},
}

-- Configuration.
function AJM:GetConfiguration()
	local configuration = {
		name = AJM.moduleDisplayName,
		handler = AJM,
		type = "group",
		get = "JambaConfigurationGetSetting",
		set = "JambaConfigurationSetSetting",
		args = {	
			add = {
				type = "input",
				name = L["ADD"],
				desc = L["ADD_HELP"],
				usage = "/jamba-team add <name>",
				get = false,
				set = "AddMemberCommand",
			},			
			remove = {
				type = "input",
				name = L["REMOVE"],
				desc = L["REMOVE_REMOVE"],
				usage = "/jamba-team remove <name>",
				get = false,
				set = "RemoveMemberCommand",
			},						
			master = {
				type = "input",
				name = L["MASTER"],
				desc = L["MASTER_HELP"],
				usage = "/jamba-team master <name> <tag>",
				get = false,
				set = "CommandSetMaster",
			},						
			iammaster = {
				type = "input",
				name = L["I_AM_MASTER"],
				desc = L["I_AM_MASTER_HELP"],
				usage = "/jamba-team iammaster <tag>",
				get = false,
				set = "CommandIAmMaster",
			},	
			invite = {
				type = "input",
				name = L["INVITE"],
				desc = L["INVITE_HELP"],
				usage = "/jamba-team invite",
				get = false,
				set = "InviteTeamToParty",
			},				
			disband = {
				type = "input",
				name = L["DISBAND"],
				desc = L["DISBAND_HELP"],
				usage = "/jamba-team disband",
				get = false,
				set = "DisbandTeamFromParty",
			},
			addparty = {
				type = "input",
				name = L["ADD_GROUPS_MEMBERS"],
				desc = L["ADD_GROUPS_MEMBERS_HELP"],
				usage = "/jamba-team addparty",
				get = false,
				set = "AddPartyMembers",
			},
			removeall = {
				type = "input",
				name = L["REMOVE_ALL_MEMBERS"],
				desc = L["REMOVE_ALL_MEMBERS_HELP"],
				usage = "/jamba-team removeall",
				get = false,
				set = "DoRemoveAllMembersFromTeam",
			},
			setalloffline = {
				type = "input",
				name = L["SET_TEAM_OFFLINE"],
				desc = L["SET_TEAM_OFFLINE_HELP"] ,
				usage = "/jamba-team setalloffline",
				get = false,
				set = "SetAllMembersOffline",
			},
			setallonline = {
				type = "input",
				name = L["SET_TEAM_ONLINE"],
				desc = L["SET_TEAM_ONLINE_HELP"],
				usage = "/jamba-team setallonline",
				get = false,
				set = "SetAllMembersOnline",
			},
			push = {
				type = "input",
				name = L["PUSH_SETTINGS"],
				desc = L["PUSH_SETTINGS_INFO"],
				usage = "/jamba-team push",
				get = false,
				set = "JambaSendSettings",
			},				
		},
	}
	return configuration
end

-- Create the character online table and ordered characters tables.
AJM.orderedCharacters = {}
AJM.orderedCharactersOnline = {}

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------

AJM.COMMAND_TAG_PARTY = "JambaTeamTagGroup"
-- Leave party command.
AJM.COMMAND_LEAVE_PARTY = "JambaTeamLeaveGroup"
-- Set master command.
AJM.COMMAND_SET_MASTER = "JambaTeamSetMaster"
-- Set Minion OffLine
AJM.COMMAND_SET_OFFLINE = "JambaTeamSetOffline"
AJM.COMMAND_SET_ONLINE = "JambaTeamSetOnline"


-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-- Master changed, parameter: new master name.
AJM.MESSAGE_TEAM_MASTER_CHANGED = "JambaTeamMasterChanged"
-- Team order changed, no parameters.
AJM.MESSAGE_TEAM_ORDER_CHANGED = "JambaTeamOrderChanged"
-- Character has been added, parameter: characterName.
AJM.MESSAGE_TEAM_CHARACTER_ADDED = "JambaTeamCharacterAdded"
-- Character has been removed, parameter: characterName.
AJM.MESSAGE_TEAM_CHARACTER_REMOVED = "JambaTeamCharacterRemoved"
-- character online
AJM.MESSAGE_CHARACTER_ONLINE = "JmbTmChrOn"
-- character offline
AJM.MESSAGE_CHARACTER_OFFLINE = "JmbTmChrOf"


-------------------------------------------------------------------------------------------------------------
-- Constants used by module.
-------------------------------------------------------------------------------------------------------------

AJM.simpleAreaList = {}

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateTeamList()
	-- Position and size constants.
	local teamListButtonControlWidth = 250
	local iconSize = 24
	local groupListWidth = 200
	local extaSpacing = 40
	local rowHeight = 25
	local rowsToDisplay = 8
	local inviteDisbandButtonWidth = 105
	local setMasterButtonWidth = 120
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local top = JambaHelperSettings:TopOfSettings()
	local left = JambaHelperSettings:LeftOfSettings()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	
	local lefticon =  left + 35
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )

	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()

	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local dropBoxWidth = (headingWidth - horizontalSpacing) / 4	
	local iconHight = iconSize + 10
	local teamListWidth = headingWidth - teamListButtonControlWidth - horizontalSpacing
	local leftOfList = left + horizontalSpacing
	local rightOfList = teamListWidth + horizontalSpacing
	local checkBoxWidth = (headingWidth - horizontalSpacing) / 2
	local topOfList = top - headingHeight
	-- Team list internal variables (do not change).
	AJM.settingsControl.teamListHighlightRow = 1
	AJM.settingsControl.teamListOffset = 1
	-- Create a heading.
	AJM.settingsControl.labelOne = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		teamListButtonControlWidth,
		teamListWidth / 2, 
		leftOfList,
		L["TEAM_HEADER"]
	)
	AJM.settingsControl.labelTwo = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		teamListButtonControlWidth,  

		teamListButtonControlWidth + iconSize + groupListWidth, 
		leftOfList,
		L["GROUPS_HEADER"]
	)
	-- Create a team list frame.
	local list = {}
	list.listFrameName = "JambaTeamSettingsTeamListFrame"
	list.parentFrame = AJM.settingsControl.widgetSettings.content
	list.listTop = topOfList
	list.listLeft = lefticon
	list.listWidth = teamListWidth
	list.rowHeight = rowHeight
	list.rowsToDisplay = rowsToDisplay
	list.columnsToDisplay = 3
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 30
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 50
	list.columnInformation[2].alignment = "LEFT"
	list.columnInformation[3] = {}
	list.columnInformation[3].width = 20
	list.columnInformation[3].alignment = "LEFT"	
	list.scrollRefreshCallback = AJM.SettingsTeamListScrollRefresh
	list.rowClickCallback = AJM.SettingsTeamListRowClick
	AJM.settingsControl.teamList = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControl.teamList )
	-- Group Frame
	local listTwo = {}
	listTwo.listFrameName = "JambaTeamSettingsTeamListTwoFrame"
	listTwo.parentFrame = AJM.settingsControl.widgetSettings.content
	listTwo.listTop = topOfList
	listTwo.listLeft = rightOfList + extaSpacing
	listTwo.listWidth = groupListWidth
	listTwo.rowHeight = rowHeight
	listTwo.rowsToDisplay = rowsToDisplay
	listTwo.columnsToDisplay = 1
	listTwo.columnInformation = {}
	listTwo.columnInformation[1] = {}
	listTwo.columnInformation[1].width = 80
	listTwo.columnInformation[1].alignment = "LEFT"
	listTwo.scrollRefreshCallback = AJM.SettingsGroupListScrollRefresh
	listTwo.rowClickCallback = AJM.SettingsGroupListRowClick
	AJM.settingsControl.groupList = listTwo
	JambaHelperSettings:CreateScrollList( AJM.settingsControl.groupList )
	-- Position and size constants (once list height is known).
	local bottomOfList = topOfList - list.listHeight - verticalSpacing
	local bottomOfSection = bottomOfList -  dropdownHeight - verticalSpacing		
	--Create Icons
	AJM.settingsControl.teamListButtonAdd = JambaHelperSettings:Icon( 
		AJM.settingsControl, 
		iconSize,
		iconSize,
		"Interface\\Addons\\Jamba\\Media\\CharAdd.tga", --icon Image
		left - iconSize - 11 , 
		topOfList - verticalSpacing, 
		L[""], 
		AJM.SettingsAddClick,
		L["BUTTON_ADD_HELP"]
	)
	AJM.settingsControl.teamListButtonParty = JambaHelperSettings:Icon( 
		AJM.settingsControl, 
		iconSize,
		iconSize,
		"Interface\\Addons\\Jamba\\Media\\CharAddParty.tga", --icon Image
		left - iconSize - 11 , 
		topOfList - verticalSpacing - iconHight, 
		L[""], 
		AJM.SettingsAddPartyClick,
		L["BUTTON_ADDALL_HELP"]
	)
	AJM.settingsControl.teamListButtonMoveUp = JambaHelperSettings:Icon( 
		AJM.settingsControl, 
		iconSize,
		iconSize,
		"Interface\\Addons\\Jamba\\Media\\CharUp.tga", --icon Image
		left - iconSize - 11,
		topOfList - verticalSpacing - iconHight * 2, 
		L[""], 
		AJM.SettingsMoveUpClick,
		L["BUTTON_UP_HELP"]
	)
	AJM.settingsControl.teamListButtonMoveDown = JambaHelperSettings:Icon(
		AJM.settingsControl, 
		iconSize,
		iconSize,	
		"Interface\\Addons\\Jamba\\Media\\CharDown.tga", --icon Image
		left - iconSize - 11,
		topOfList - verticalSpacing - iconHight * 3,
		L[""],
		AJM.SettingsMoveDownClick,
		L["BUTTON_DOWN_HELP"]		
	)
	AJM.settingsControl.teamListButtonRemove = JambaHelperSettings:Icon( 
		AJM.settingsControl, 
		iconSize,
		iconSize,
		"Interface\\Addons\\Jamba\\Media\\CharRemove.tga", --icon Image
		left - iconSize - 11 , 
		topOfList - verticalSpacing - iconHight * 4,
		L[""], 
		AJM.SettingsRemoveClick,
		L["BUTTON_REMOVE_HELP"]
	)
	AJM.settingsControl.teamListButtonSetMaster = JambaHelperSettings:Icon( 
		AJM.settingsControl, 
		iconSize,
		iconSize,
		"Interface\\Addons\\Jamba\\Media\\CharMaster.tga", --icon Image
		left - iconSize - 11 , 
		topOfList - verticalSpacing - iconHight * 5,
		L[""], 
		AJM.SettingsSetMasterClick,
		L["BUTTON_MASTER_HELP"]
	)
	AJM.settingsControl.teamListButtonRemoveFromGroup = JambaHelperSettings:Icon( 
		AJM.settingsControl, 
		iconSize,
		iconSize,
		"Interface\\Addons\\Jamba\\Media\\CharRemoveParty.tga", --icon Image
		rightOfList + dropBoxWidth + 11 , 
		bottomOfList ,
		L[""], 
		AJM.SettingsRemoveGroupClick,
		L["BUTTON_GROUP_REMOVE_HELP"]
	)	
	-- Group Mangent
	AJM.settingsControl.teamListDropDownList = JambaHelperSettings:CreateDropdown(
		AJM.settingsControl, 
		dropBoxWidth,	
		rightOfList + extaSpacing, -- horizontalSpacing,
		bottomOfList + 11, 
		L["GROUP_LIST"]
	)
	AJM.settingsControl.teamListDropDownList:SetList( AJM.GroupAreaList() )
	AJM.settingsControl.teamListDropDownList:SetCallback( "OnValueChanged",  AJM.TeamListDropDownList )
	-- IsboxerSync
	AJM.settingsControl.teamListCheckBoxSyncIsboxer = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxWidth, 
		lefticon, 
		bottomOfList - 11,
		L["CHECKBOX_ISBOXER_SYNC"],
		AJM.SettingsSyncIsboxerToggle,
		L["CHECKBOX_ISBOXER_SYNC_HELP"]
	)	
	
	return bottomOfSection
end

local function SettingsCreateMasterControl( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local labelContinueHeight = JambaHelperSettings:GetContinueLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local checkBoxWidth = (headingWidth - horizontalSpacing) / 2
	local column1Left = left
	local column2Left = left + checkBoxWidth + horizontalSpacing
	local bottomOfSection = top - headingHeight - (checkBoxHeight * 1) - (verticalSpacing * 3)
	-- Create a heading.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["MASTER_CONTROL"], top, false )
	-- Create checkboxes.
	
	AJM.settingsControl.masterControlCheckBoxMasterChange = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxWidth, 
		column1Left, 
		top - headingHeight,
		L["CHECKBOX_MASTER_LEADER"],
		AJM.SettingsMasterChangeToggle,
		L["CHECKBOX_MASTER_LEADER_HELP"]
	)
	AJM.settingsControl.masterControlCheckBoxMasterChangeClickToMove = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxWidth, 
		column2Left, 
		top - headingHeight, 
		L["CHECKBOX_CTM"],
		AJM.SettingsMasterChangeClickToMoveToggle,
		L["CHECKBOX_CTM_HELP"]
	)	
	return bottomOfSection
end

local function SettingsCreatePartyInvitationsControl( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local checkBoxWidth = (headingWidth - horizontalSpacing) / 2
	local column1Left = left
	local column2Left = left + checkBoxWidth + horizontalSpacing
	local bottomOfSection = top - headingHeight - (checkBoxHeight * 3) - (verticalSpacing * 2)
	-- Create a heading.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["PARTY_CONTROLS"], top, false )
	-- Create checkboxes.
	AJM.settingsControl.partyInviteControlCheckBoxConvertToRaid = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxWidth, 
		column1Left, 
		top - headingHeight,
		L["CHECKBOX_CONVERT_RAID"],
		AJM.SettingsinviteConvertToRaidToggle,
		L["CHECKBOX_CONVERT_RAID_HELP"]
	)
	AJM.settingsControl.partyInviteControlCheckBoxSetAllAssist = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxWidth, 
		column2Left, 
		top - headingHeight,
		L["CHECKBOX_ASSISTANT"],
		AJM.SettingsinviteSetAllAssistToggle,
		L["CHECKBOX_ASSISTANT_HELP"]
	)
	AJM.settingsControl.partyInviteControlCheckBoxAcceptMembers = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxWidth, 
		column1Left, 
		top - headingHeight - checkBoxHeight, 
		L["CHECKBOX_TEAM"],
		AJM.SettingsAcceptInviteMembersToggle,
		L["CHECKBOX_TEAM_HELP"]
	)
	AJM.settingsControl.partyInviteControlCheckBoxAcceptFriends = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxWidth, 
		column2Left, 
		top - headingHeight - checkBoxHeight, 
		L["CHECKBOX_ACCEPT_FROM_FRIENDS"],
		AJM.SettingsAcceptInviteFriendsToggle,
		L["CHECKBOX_ACCEPT_FROM_FRIENDS_HELP"]
	)
	AJM.settingsControl.partyInviteControlCheckBoxAcceptGuild = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxWidth, 
		column1Left, 
		top - headingHeight - checkBoxHeight - checkBoxHeight,
		L["CHECKBOX_ACCEPT_FROM_GUILD"],
		AJM.SettingsAcceptInviteGuildToggle,
		L["CHECKBOX_ACCEPT_FROM_GUILD_HELP"]
	)	
	AJM.settingsControl.partyInviteControlCheckBoxDeclineStrangers = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxWidth, 
		column1Left, 
		top - headingHeight  - checkBoxHeight - checkBoxHeight - checkBoxHeight,
		L["CHECKBOX_DECLINE_STRANGERS"],
		AJM.SettingsDeclineInviteStrangersToggle,
		L["CHECKBOX_DECLINE_STRANGERS_HELP"]
	)
	return bottomOfSection	
end


local function SettingsCreate()
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
	-- Create the team list controls.
	local bottomOfTeamList = SettingsCreateTeamList()
	-- Create the master control controls.
	local bottomOfMasterControl = SettingsCreateMasterControl( bottomOfTeamList )
	-- Create the party invitation controls.
	local bottomOfPartyInvitationControl = SettingsCreatePartyInvitationsControl( bottomOfMasterControl )
	AJM.settingsControl.widgetSettings.content:SetHeight( - bottomOfPartyInvitationControl )
	-- Help
	local helpTable = {}
	JambaHelperSettings:CreateHelp( AJM.settingsControl, helpTable, AJM:GetConfiguration() )	
end

-------------------------------------------------------------------------------------------------------------
-- Popup Dialogs.
-------------------------------------------------------------------------------------------------------------

-- Initialize Popup Dialogs.
local function InitializePopupDialogs()
   -- Ask the name of the character to add as a new member.
   StaticPopupDialogs["JAMBATEAM_ASK_CHARACTER_NAME"] = {
        text = L["STATICPOPUP_ADD"],
        button1 = ACCEPT,
        button2 = CANCEL,
        hasEditBox = 1,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
		OnShow = function( self )
			self.editBox:SetText("")
            self.button1:Disable()
            self.editBox:SetFocus()
        end,
		OnAccept = function( self )
			AJM:AddMemberGUI( self.editBox:GetText() )
		end,
		EditBoxOnTextChanged = function( self )
            if not self:GetText() or self:GetText():trim() == "" then
				self:GetParent().button1:Disable()
            else
                self:GetParent().button1:Enable()
            end
        end,
		EditBoxOnEnterPressed = function( self )
            if self:GetParent().button1:IsEnabled() then
				AJM:AddMemberGUI( self:GetText() )
            end
            self:GetParent():Hide()
        end,			
    }
   -- Confirm removing characters from member list.
   StaticPopupDialogs["JAMBATEAM_CONFIRM_REMOVE_CHARACTER"] = {
        text = L["STATICPOPUP_REMOVE"],
        button1 = ACCEPT,
        button2 = CANCEL,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function( self )
			AJM:RemoveMemberGUI()
		end,
    }
end

-------------------------------------------------------------------------------------------------------------
-- Team management.
-------------------------------------------------------------------------------------------------------------

function AJM:GroupAreaList()
	return pairs( AJM.simpleAreaList )
end

local function refreshDropDownList()
	JambaUtilities:ClearTable( AJM.simpleAreaList )
	AJM.simpleAreaList[" "] = " "
	for id, tag in pairs( JambaApi.GroupList() ) do
		local groupName =  JambaUtilities:Capitalise( tag )
		AJM.simpleAreaList[groupName] = groupName	
	end
	table.sort( AJM.simpleAreaList )
	AJM.settingsControl.teamListDropDownList:SetList( AJM.simpleAreaList )
end

local function TeamList()
	--return pairs( AJM.db.teamList )
	local teamlist = {}
	for name, info in pairs( AJM.db.newTeamList ) do
		for _, charInfo in pairs (info) do
			teamlist[name] = charInfo.order
		end
	end
	return pairs( teamlist )
end


local function FullTeamList()
	local fullTeamList = {}
	for name, info in pairs ( AJM.db.newTeamList ) do
		for _, charInfo in pairs (info) do
		table.insert(fullTeamList, { charInfo.name, charInfo.order, charInfo.class, charInfo.online } )
		end
	end
	return pairs( fullTeamList )
end	


--[[
local function Offline()
	return pairs( AJM.db.characterOnline )
end

local function characterClass()
	return pairs( AJM.db.characterClass )
end


local function setClass()
	for characterName, position in pairs( AJM.db.newTeamList ) do
	local class, classFileName, classIndex = UnitClass( Ambiguate(characterName, "none") )
		--AJM:Print("new", class, CharacterName )
		if class ~= nil then
			AJM.db.characterClass[characterName] = classFileName
		end
	end	
end
]]

local function GetClass( characterName )
	local class = nil
	local color = nil
	for teamCharacterName, info in pairs( AJM.db.newTeamList ) do
		if characterName == teamCharacterName then
			for _, charInfo in pairs (info) do
			--charInfo.class
				--AJM:Print("classDatatest",  characterName, charInfo.class )
				if charInfo.class ~= nil or charInfo.class ~= "UNKNOWN" then
					class = JambaUtilities:Lowercase( charInfo.class )
					color = RAID_CLASS_COLORS[charInfo.class]
				end
			end			
		end	
	end
	return class, color
end	

-- Get the largest order number from the team list.
local function GetTeamListMaximumOrder()
	local largestPosition = 0
	for characterName, position in JambaApi.TeamList() do 
		if position > largestPosition then
			largestPosition = position
		end
	end
	return largestPosition
end

local function GetTeamListMaximumOrderOnline()
	local totalMembersDisplayed = 0
		for index, characterName in JambaApi.TeamList() do
			if JambaApi.GetCharacterOnlineStatus( characterName ) == true then
				totalMembersDisplayed = totalMembersDisplayed + 1
			end
		end	
	return totalMembersDisplayed
end		
		
local function IsCharacterInTeam( name )
	local characterName = JambaUtilities:Lowercase( name )
	local isMember = false
	if not isMember then
		for fullCharacterName, position in JambaApi.TeamList() do 
			local checkFullName = JambaUtilities:Lowercase( fullCharacterName )
			local name, realm = strsplit("-", checkFullName, 2 )
			--AJM:Print('checking', name, 'vs', characterName, "or", checkFullName )
			if name == characterName or checkFullName == characterName then
				--AJM:Print('match found')
				isMember = true
				break
			end
		end
	end
	--AJM:Print('returning', isMember)
	return isMember
end


-- Get the master for this character.
local function GetMasterName()
	return AJM.db.master	
end

-- Return true if the character specified is in the master.
local function IsCharacterTheMaster( characterName )
	local isTheMaster = false
	if characterName == GetMasterName() then
		isTheMaster = true
	end
	return isTheMaster
end

-- Set the master for AJM character; the master character must be online.
local function SetMaster( master )
	-- Make sure a valid string value is supplied.
	if (master ~= nil) and (master:trim() ~= "") then
		-- The name must be capitalised i still like this or though its not needed.
		--local character = JambaUtilities:Capitalise( master )
		local character = JambaUtilities:AddRealmToNameIfMissing( master )
		-- Only allow characters in the team list to be the master.
		if IsCharacterInTeam( character ) == true then
			-- Set the master.
			AJM.db.master = character
			-- Refresh the settings.
			AJM:SettingsRefresh()			
			-- Send a message to any listeners that the master has changed.
			AJM:SendMessage( AJM.MESSAGE_TEAM_MASTER_CHANGED, character )
		else
			-- Character not in team.  Tell the team.
			AJM:JambaSendMessageToTeam( AJM.characterName, L["A_IS_NOT_IN_TEAM"]( character ), false )
		end
	end
end

-- Add a member to the member list.
local function AddMember( characterName, class )
	local name = nil
	if characterName == "@Target" then
		local UnitIsPlayer = UnitIsPlayer("target")
		if UnitIsPlayer == true then
			local unitName = GetUnitName("target", true)
			--AJM:Print("Target", unitName)
			name = unitName
		else
			AJM:Print(L["TEAM_NO_TARGET"])
			return
		end	
	elseif characterName == "@Mouseover"  then
		local UnitIsPlayer = UnitIsPlayer("mouseover")
		if UnitIsPlayer == true then
			local unitName = GetUnitName("mouseover", true)
			--AJM:Print("mouseover", unitName)
			name = unitName
		else
			AJM:Print(L["TEAM_NO_TARGET"])
			return
		end	
	else
		name = characterName
	end	
	-- Wow names are at least two characters.
	if name ~= nil and name:trim() ~= "" and name:len() > 1 then
		-- If the character is not already in the list...
		local character = JambaUtilities:AddRealmToNameIfMissing( name )
		if AJM.db.newTeamList[character] == nil then
			-- Get the maximum order number.
			--Store TempData
			local maxOrder = "0"
			local CharacterClass = "UNKNOWN"
			local Online = true
			-- Real Data
			local maxOrder = GetTeamListMaximumOrder()	
			if class ~= nil then
				local upperClass = string.upper(class)
				CharacterClass = upperClass 
			end
			local _, classFileName = UnitClass( Ambiguate(character, "none") )
			if classFileName ~= nil then 
				CharacterClass = classFileName
			end
			--AJM:Print("DebugAddToDB", "toon", character, "order", maxOrder, "class", CharacterClass, "online", Online ) 
			AJM.db.newTeamList[character] = {}
			table.insert( AJM.db.newTeamList[character], {name = character, order = maxOrder + 1, class = CharacterClass, online = Online } )
			-- Send a message to any listeners that AJM character has been added.
			AJM:SendMessage( AJM.MESSAGE_TEAM_CHARACTER_ADDED, character )
			-- Refresh the settings.
			AJM:SettingsRefresh()
		end
	end	
end



-- Add all party members to the member list. does not worl cross rwalm todo
function AJM:AddPartyMembers()
	--local numberPartyMembers = GetNumSubgroupMembers()
	local numberPartyMembers = GetNumGroupMembers()
	for iteratePartyMembers = numberPartyMembers, 1, -1 do
		--AJM:Print("party/raid", numberPartyMembers, iteratePartyMembers)
		local inRaid = IsInRaid()
		if inRaid == true then
			local partyMemberName, partyMemberRealm = UnitName( "raid"..iteratePartyMembers )
			local character = JambaUtilities:AddRealmToNameIfNotNil( partyMemberName, partyMemberRealm )
			if IsCharacterInTeam( character ) == false then
				AddMember( character )
			end	
		else
			local partyMemberName, partyMemberRealm = UnitName( "party"..iteratePartyMembers )
			local character = JambaUtilities:AddRealmToNameIfNotNil( partyMemberName, partyMemberRealm )
			if IsCharacterInTeam( character ) == false then
				AddMember( character )
			end
		end
	end
end

-- Add a member to the member list.
function AJM:AddMemberGUI( value )
	AddMember( value )
	AJM:SettingsTeamListScrollRefresh()
	--AJM:SettingsGroupListScrollRefresh()
end

-- Add member from the command line.
function AJM:AddMemberCommand( info, parameters )
	-- Jamba-EE we No-longer remove character's from a team list when isboxer set's up the team we sync!
	if info == nil then
		--AJM:Print("isboxerContralRemove", parameters )
		AJM.IsboxerSyncList[parameters] = "add"
		return
	end	
	--AJM:Print("testremove", info, parameters )
	local characterName = parameters
	-- Add the character.
	AddMember( characterName )
end

-- Get the character name at a specific position.
local function GetCharacterNameAtOrderPosition( position )
	local characterNameAtPosition = ""
	for characterName, characterPosition in JambaApi.TeamList() do
		if characterPosition == position then
			characterNameAtPosition = characterName
			break
		end
	end
	return characterNameAtPosition
end

-- Get the position for a specific character.
local function GetPositionForCharacterName( findCharacterName )
	local positionForCharacterName = 0
	for characterName, characterPosition in JambaApi.TeamList() do
		if characterName == findCharacterName then
			positionForCharacterName = characterPosition
			break
		end
	end
	return positionForCharacterName
end

local function GetPositionForCharacterNameOnline( findCharacterName )
	local positionForCharacterName = 0
		for index, characterName in JambaApi.TeamListOrderedOnline() do
			if characterName == findCharacterName then
				--AJM:Print("found", characterName, index)
				positionForCharacterName = index
				--break
			end
	end
	return positionForCharacterName
end

-- Swap character positions.
local function TeamListSwapCharacterPositions( position1, position2 )
	-- Get characters at positions.
	local character1 = GetCharacterNameAtOrderPosition( position1 )
	local character2 = GetCharacterNameAtOrderPosition( position2 )
	for name, info in pairs (AJM.db.newTeamList) do
		for _, charInfo in pairs (info) do
			if name == character1 then
				charInfo.order = position2
			end
			if name == character2 then
				charInfo.order = position1
			end
		end
	end
	
	
	
	-- Swap the positions.
	--AJM.db.teamList[character1] = position2
	--AJM.db.teamList[character2] = position1
end

-- Makes sure that AJM character is a team member.  Enables if previously not a member.
local function ConfirmCharacterIsInTeam()
	if not IsCharacterInTeam( AJM.characterName ) then
		-- Then add as a member.
		AddMember( AJM.characterName )
	end
end

-- Make sure there is a master, if none, set this character.
local function ConfirmThereIsAMaster()
	-- Read the db option for master.  Is it set?
	if AJM.db.master:trim() == "" then
		-- No, set it to self.
		SetMaster( AJM.characterName )
	end
	-- Is the master in the member list?
	if not IsCharacterInTeam( AJM.db.master ) then
		-- No, set self as master.
		SetMaster( AJM.characterName )
	end	 
end

-- Remove a member from the member list.
local function RemoveMember( characterName )
	-- Is character in team?
	if IsCharacterInTeam( characterName ) == true and characterName ~= AJM.characterName then
		-- Remove character from list.
		local characterPosition = JambaApi.GetPositionForCharacterName( characterName )
		AJM.db.newTeamList[characterName] = nil
		-- If any character had an order greater than this character's order, then shift their order down by one.
		for name, position in JambaApi.TeamList() do	
			if position > characterPosition then
				for checkName, info in pairs (AJM.db.newTeamList) do
					for _, charInfo in pairs (info) do
						if name == checkName then
							charInfo.order = position - 1
						end	
					end
				end
			end
		end
		-- Send a message to any listeners that this character has been removed.
		AJM:SendMessage( AJM.MESSAGE_TEAM_CHARACTER_REMOVED, characterName )
		-- Make sure AJM character is a member.
		ConfirmCharacterIsInTeam()
		-- Make sure there is a master, if none, set this character.
		ConfirmThereIsAMaster()
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Resets to Top of list!
		AJM:SettingsTeamListRowClick( 1, 1 )
	else
		AJM:Print("[PH] CAN NOT REMOVE SELF")
	end
end

-- Provides a GUI for a user to confirm removing selected members from the member list.
function AJM:RemoveMemberGUI()
	local characterName = GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
	RemoveMember( characterName )
	AJM.settingsControl.teamListHighlightRow = 1	
	AJM:SettingsTeamListScrollRefresh()
	AJM:SettingsGroupListScrollRefresh()
end


-- Remove member from the command line.
function AJM:RemoveMemberCommand( info, parameters )
	-- Jamba-EE we No-longer remove character's from a team list when isboxer set's up the team we sync!
	if info == nil then
		--AJM:Print("isboxerContralAdd", parameters )
		AJM.IsboxerSyncList[parameters] = "remove"
		return
	end		
	--AJM:Print("testremove", info, parameters )
	local characterName = parameters
	-- Wow names are at least two characters.
	if characterName ~= nil and characterName:trim() ~= "" and characterName:len() > 1 then
		-- Remove the character.
		RemoveMember( characterName )
	end
end

local function RemoveAllMembersFromTeam()
	for characterName, characterPosition in pairs( AJM.db.teamList ) do
		RemoveMember( characterName )
	end
end

-- Remove all members from the team list via command line.
function AJM:DoRemoveAllMembersFromTeam( info, parameters )
	RemoveAllMembersFromTeam()
end

function AJM:CommandIAmMaster( info, parameters )
	local tag = parameters
	local target = AJM.characterName
	if tag ~= nil and tag:trim() ~= "" then 
		AJM:JambaSendCommandToTeam( AJM.COMMAND_SET_MASTER, target, tag )
	else
		SetMaster( target )
	end
end

function AJM:CommandSetMaster( info, parameters )
	local target, tag = strsplit( " ", parameters )
	if tag ~= nil and tag:trim() ~= "" then 
		AJM:JambaSendCommandToTeam( AJM.COMMAND_SET_MASTER, target, tag )
	else
		SetMaster( target )
	end
end

function AJM:ReceiveCommandSetMaster( target, tag )
	if JambaPrivate.Tag.DoesCharacterHaveTag( AJM.characterName, tag ) then
		SetMaster( target )
	end
end

-- Test IsboxerContral EbonyTest

function AJM:IsboxerSyncTeamList()
	if AJM.db.isboxerSync == true and IsAddOnLoaded("Isboxer" ) == true then
		for characterName, teamStatus in pairs( AJM.IsboxerSyncList ) do
			--AJM:Print("syncList", characterName, teamStatus )
			if IsCharacterInTeam( characterName ) == true and characterName ~= AJM.characterName then
				if teamStatus == "remove" then 
					--AJM:Print("memberNoLongerInIsboxerTeamDelete", characterName, teamStatus )
					RemoveMember( characterName )
				end
			else
				if teamStatus == "add" and characterName ~= AJM.characterName then 
				--AJM:Print("Isboxer-AddMember", characterName, teamStatus )
				AddMember( characterName )
				end
			end
		end
	end
end


-------------------------------------------------------------------------------------------------------------
-- Character online status.
-------------------------------------------------------------------------------------------------------------

-- Get a character's online status..
local function GetCharacterOnlineStatus( characterName )
	local online = nil
	for name, info in pairs (AJM.db.newTeamList) do
		for _, charInfo in pairs (info) do
			if characterName == name then
				online = charInfo.online
			end	
		end
	end
	return online
end

-- Set a character's online status.
local function SetCharacterOnlineStatus( characterName, isOnline )
	--AJM:Print("setting", characterName, "to be", isOnline )
	for name, info in pairs (AJM.db.newTeamList) do
		for _, charInfo in pairs (info) do
			if characterName == name then
				--AJM:Print("Set", characterName, isOnline, charInfo.online )
				charInfo.online = isOnline
			end	
		end
	end
end

local function SetTeamStatusToOffline()
	for characterName, characterPosition in JambaApi.TeamList() do
		SetCharacterOnlineStatus( characterName, false )
		AJM:SendMessage( AJM.MESSAGE_CHARACTER_OFFLINE )
		AJM:SettingsTeamListScrollRefresh()
	end
end

local function SetTeamOnline()
	-- Set all characters online status to false.
	for characterName, characterPosition in JambaApi.TeamList() do
		SetCharacterOnlineStatus( characterName, true )
		AJM:SendMessage( AJM.MESSAGE_CHARACTER_ONLINE )
		AJM:SettingsTeamListScrollRefresh()
		--AJM:SettingsGroupListScrollRefresh()
	end
end
	
--Set character Offline. 
local function setOffline( characterName )
	local character = JambaUtilities:AddRealmToNameIfMissing( characterName )
	SetCharacterOnlineStatus( character, false )
	AJM:SendMessage( AJM.MESSAGE_CHARACTER_OFFLINE )
	AJM:SettingsTeamListScrollRefresh()
	--AJM:SettingsGroupListScrollRefresh()
end

--Set character OnLine. 
local function setOnline( characterName )
	local character = JambaUtilities:AddRealmToNameIfMissing( characterName )
	SetCharacterOnlineStatus( character, true )
	AJM:SendMessage( AJM.MESSAGE_CHARACTER_ONLINE )
	AJM:SettingsTeamListScrollRefresh()
	--AJM:SettingsGroupListScrollRefresh()
end

function AJM.ReceivesetOffline( characterName )
	--AJM:Print("command", characterName )
	setOffline( characterName, false )
	AJM:SettingsRefresh()
end

function AJM.ReceivesetOnline( characterName )
	--AJM:Print("command", characterName )
	setOnline( characterName, false )
	AJM:SettingsRefresh()
end

function AJM:SetAllMembersOffline()
	SetTeamStatusToOffline()
end	

function AJM:SetAllMembersOnline()
	SetTeamOnline()
end

-------------------------------------------------------------------------------------------------------------
-- Character team list ordering.
-------------------------------------------------------------------------------------------------------------

local function SortTeamListOrdered( characterA, characterB )
	local positionA = GetPositionForCharacterName( characterA )
	local positionB = GetPositionForCharacterName( characterB )
	return positionA < positionB
end

-- Return all characters ordered.
local function TeamListOrdered()	
	JambaUtilities:ClearTable( AJM.orderedCharacters )
	for characterName, characterPosition in JambaApi.TeamList() do
		table.insert( AJM.orderedCharacters, characterName )
	end
	table.sort( AJM.orderedCharacters, SortTeamListOrdered )
	return ipairs( AJM.orderedCharacters )
end

-- Return all characters ordered online.
local function TeamListOrderedOnline()	
	JambaUtilities:ClearTable( AJM.orderedCharactersOnline )
	for characterName, characterPosition in JambaApi.TeamList() do
		if JambaApi.GetCharacterOnlineStatus( characterName ) == true then	
			table.insert( AJM.orderedCharactersOnline, characterName )
		end	
	end
	table.sort( AJM.orderedCharactersOnline, SortTeamListOrdered )
	return ipairs( AJM.orderedCharactersOnline )
end
-------------------------------------------------------------------------------------------------------------
-- Party.
-------------------------------------------------------------------------------------------------------------

-- Invite team to party.

function AJM.DoTeamPartyInvite()
	InviteUnit( AJM.inviteList[AJM.currentInviteCount] )
	AJM.currentInviteCount = AJM.currentInviteCount + 1
	if AJM.currentInviteCount < AJM.inviteCount then
		--if GetTeamListMaximumOrderOnline() > 5 and AJM.db.inviteConvertToRaid == true then
		if AJM.inviteCount > 5 and AJM.db.inviteConvertToRaid == true then
			if AJM.db.inviteSetAllAssistant == true then	
				ConvertToRaid()
				SetEveryoneIsAssistant(true)
			else				
				ConvertToRaid()
			end
		end
		AJM:ScheduleTimer( "DoTeamPartyInvite", 0.5 )
	end	
end


function AJM:InviteTeamToParty( info, tag )
	-- Iterate each enabled member and invite them to a group.
	if tag == nil or tag == "" then
		tag = "all"
	end
	if JambaApi.DoesGroupExist(tag) == true then
		if JambaPrivate.Tag.DoesCharacterHaveTag( AJM.characterName, tag ) == false then
			--AJM:Print("IDONOTHAVETAG", tag)
			for index, characterName in TeamListOrderedOnline() do
				--AJM:Print("NextChartohavetag", tag, characterName )
				if JambaApi.IsCharacterInGroup( characterName, tag ) then
					--AJM:Print("i have tag", tag, characterName )
					AJM:JambaSendCommandToTeam( AJM.COMMAND_TAG_PARTY, characterName, tag )
					break
				end
			end
			return
		else
			AJM.inviteList = {}
			AJM.inviteCount = 0
			for index, characterName in TeamListOrderedOnline() do
				if JambaApi.IsCharacterInGroup( characterName, tag ) then
					--AJM:Print("HasTag", characterName, tag )
					-- As long as they are not the player doing the inviting.
					if characterName ~= AJM.characterName then
						AJM.inviteList[AJM.inviteCount] = characterName
						AJM.inviteCount = AJM.inviteCount + 1
					end
				end
			end
		end
		AJM.currentInviteCount = 0
		AJM:ScheduleTimer( "DoTeamPartyInvite", 0.5 )
	else
	AJM:Print (L["UNKNOWN_GROUP"]..tag )
	end	
end


function AJM:PARTY_INVITE_REQUEST( event, inviter, ... )
	--AJM:Print("Inviter", inviter)
	-- Accept this invite, initially no.
	local acceptInvite = false
	-- Is character not in a group?
	if not IsInGroup( "player" ) then	
		-- Accept an invite from members?
		if AJM.db.inviteAcceptTeam == true then 
			-- If inviter found in team list, allow the invite to be accepted.
			if IsCharacterInTeam( inviter ) then
			acceptInvite = true
			end
		end			
		-- Accept an invite from friends?
		if AJM.db.inviteAcceptFriends == true then
			-- Iterate each friend; searching for the inviter in the friends list.
			for friendIndex = 1, GetNumFriends() do
				local friendName = GetFriendInfo( friendIndex )
				-- Inviter found in friends list, allow the invite to be accepted.
				if inviter == friendName then
					acceptInvite = true
					break
				end
			end	
		end
		-- Accept an invite from BNET/RealD?
		if AJM.db.inviteAcceptFriends == true and BNFeaturesEnabledAndConnected() == true then
			-- Iterate each friend; searching for the inviter in the friends list.
			local _, numFriends = BNGetNumFriends()
			for bnIndex = 1, numFriends do
				for toonIndex = 1, BNGetNumFriendGameAccounts( bnIndex ) do
					local _, toonName, client, realmName = BNGetFriendGameAccountInfo( bnIndex, toonIndex )
					--AJM:Print("BNFrindsTest", toonName, client, realmName, "inviter", inviter)
					if client == "WoW" then
						if toonName == inviter or toonName.."-"..realmName == inviter then
							acceptInvite = true
							break
						end	
					end
				end
			end	
		end					
		-- Accept and invite from guild members?
		if AJM.db.inviteAcceptGuild == true then
			if UnitIsInMyGuild( inviter ) then
				acceptInvite = true
			end
		end	
	end	
	-- Hide the party invite popup?
	local hidePopup = false
	-- Accept the group invite if allowed.
	if acceptInvite == true then
		AcceptGroup()
		hidePopup = true
	else
		-- Otherwise decline the invite if permitted.
		if AJM.db.inviteDeclineStrangers == true then
			DeclineGroup()
			hidePopup = true
		end
	end		
	-- Hide the popup group invitation request if accepted or declined the invite.
	if hidePopup == true then
		-- Make sure the invite dialog does not decline the invitation when hidden.
		for iteratePopups = 1, STATICPOPUP_NUMDIALOGS do
			local dialog = _G["StaticPopup"..iteratePopups]
			if dialog.which == "PARTY_INVITE" then
				-- Set the inviteAccepted flag to true (even if the invite was declined, as the
				-- flag is only set to stop the dialog from declining in its OnHide event).
				dialog.inviteAccepted = 1
				break
			end
			-- Ebony Sometimes invite is from XREALM even though Your on the same realm and have joined the party. This should hide the Popup.
			if dialog.which == "PARTY_INVITE_XREALM" then
				-- Set the inviteAccepted flag to true (even if the invite was declined, as the
				-- flag is only set to stop the dialog from declining in its OnHide event).
				dialog.inviteAccepted = 1
				break
			end
		end
		StaticPopup_Hide( "PARTY_INVITE" )
		StaticPopup_Hide( "PARTY_INVITE_XREALM" )
	end	
end

function AJM:DisbandTeamFromParty()
	AJM:JambaSendCommandToTeam( AJM.COMMAND_LEAVE_PARTY )
end

local function LeaveTheParty()
	if IsInGroup( "player" ) then
		LeaveParty()
	end
end

function AJM:OnMasterChange( message, characterName )
	local playerName = AJM.characterName
	if AJM.db.masterChangePromoteLeader == true then
		if IsInGroup( "player" ) and UnitIsGroupLeader( "player" ) == true and GetMasterName() ~= playerName then
			PromoteToLeader( Ambiguate( GetMasterName(), "all" ) )
		end
	end
	if AJM.db.masterChangeClickToMove == true then
		if IsCharacterTheMaster( self.characterName ) == true then
			ConsoleExec("Autointeract 0")
		else
			ConsoleExec("Autointeract 1")
		end
	end
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()	
	-- Initialise the popup dialogs.
	InitializePopupDialogs()
	-- Make sure this character is a member, add and enable if not on the list.
	ConfirmCharacterIsInTeam()
	-- Make sure there is a master, if none, set this character.
	ConfirmThereIsAMaster()
	-- Set team members online status to not connected. we do not want to do this on start-up!
	--SetTeamStatusToOffline()
	SetTeamOnline()
	-- Adds DefaultGroups to GUI
	AJM.characterGroupList = {}
	-- Key bindings.
	JambaTeamSecureButtonInvite = CreateFrame( "CheckButton", "JambaTeamSecureButtonInvite", nil, "SecureActionButtonTemplate" )
	JambaTeamSecureButtonInvite:SetAttribute( "type", "macro" )
	JambaTeamSecureButtonInvite:SetAttribute( "macrotext", "/jamba-team invite" )
	JambaTeamSecureButtonInvite:Hide()	
	JambaTeamSecureButtonDisband = CreateFrame( "CheckButton", "JambaTeamSecureButtonDisband", nil, "SecureActionButtonTemplate" )
	JambaTeamSecureButtonDisband:SetAttribute( "type", "macro" )
	JambaTeamSecureButtonDisband:SetAttribute( "macrotext", "/jamba-team disband" )
	JambaTeamSecureButtonDisband:Hide()
	-- Update teamList if necessary to include realm names. Only used from upgrading form 3.x to 4.0
	local updatedTeamList = {}
	--Ebony Using GetRealmName() shows realm name with a space the api does not like spaces. So we have to remove it
	local k = GetRealmName()
	-- remove space for server name if there is one.
	local realmName = k:gsub( "%s+", "")
	AJM.IsboxerSyncList = {}
	--Sets The class of the char.
--	setClass()
	-- Click the first row in the team list table to populate the tag list table.
	--AJM:SettingsTeamListRowClick( 1, 1 )
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	AJM:RegisterEvent( "PARTY_INVITE_REQUEST" )
	AJM:RegisterMessage( AJM.MESSAGE_TEAM_MASTER_CHANGED, "OnMasterChange" )
	-- Kickstart the settings team list scroll frame.
	AJM:SettingsTeamListScrollRefresh()
	--AJM.SettingsGroupListScrollRefresh()
	-- Click the first row in the team list table to populate the tag list table.
	--AJM:SettingsTeamListRowClick( 1, 1 )
	AJM:RegisterEvent( "PLAYER_ENTERING_WORLD" )
	-- Initialise key bindings.
	AJM.keyBindingFrame = CreateFrame( "Frame", nil, UIParent )
	AJM:RegisterEvent( "UPDATE_BINDINGS" )		
	AJM:UPDATE_BINDINGS()
	-- Update DropDownList
	refreshDropDownList()
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

-------------------------------------------------------------------------------------------------------------
-- Settings Populate.
-------------------------------------------------------------------------------------------------------------

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	-- Refresh the settings.
	AJM:SettingsRefresh()
	-- Make sure this character is a member, add and enable if not on the list.
	ConfirmCharacterIsInTeam()
	-- Make sure there is a master, if none, set this character.
	ConfirmThereIsAMaster()	
	-- Update the settings team list.
	AJM:SettingsTeamListScrollRefresh()
	--AJM:SettingsGroupListScrollRefresh()	
	-- Send team order changed and team master changed messages.
	AJM:SendMessage( AJM.MESSAGE_TEAM_ORDER_CHANGED )	
	AJM:SendMessage( AJM.MESSAGE_TEAM_MASTER_CHANGED )
end

function AJM:SettingsRefresh()
	-- Team/Group Control
	local test = " "
	AJM.settingsControl.teamListCheckBoxSyncIsboxer:SetValue( AJM.db.isboxerSync )

	-- Master Control.
	AJM.settingsControl.masterControlCheckBoxMasterChange:SetValue( AJM.db.masterChangePromoteLeader )
	AJM.settingsControl.masterControlCheckBoxMasterChangeClickToMove:SetValue( AJM.db.masterChangeClickToMove )
	-- Party Invitiation Control.
	AJM.settingsControl.partyInviteControlCheckBoxAcceptMembers:SetValue( AJM.db.inviteAcceptTeam )
	AJM.settingsControl.partyInviteControlCheckBoxAcceptFriends:SetValue( AJM.db.inviteAcceptFriends )
	AJM.settingsControl.partyInviteControlCheckBoxAcceptGuild:SetValue( AJM.db.inviteAcceptGuild )
	AJM.settingsControl.partyInviteControlCheckBoxDeclineStrangers:SetValue( AJM.db.inviteDeclineStrangers )
	AJM.settingsControl.partyInviteControlCheckBoxConvertToRaid:SetValue( AJM.db.inviteConvertToRaid )
	AJM.settingsControl.partyInviteControlCheckBoxSetAllAssist:SetValue( AJM.db.inviteSetAllAssistant )
	-- Ensure correct state.
	AJM.settingsControl.partyInviteControlCheckBoxSetAllAssist:SetDisabled (not AJM.db.inviteConvertToRaid )
	AJM.settingsControl.teamListCheckBoxSyncIsboxer:SetDisabled ( not IsAddOnLoaded("Isboxer" ) )
	
	-- Update the settings team list.
	AJM:SettingsTeamListScrollRefresh()
	-- Check the opt out of loot settings.
	--AJM:CheckMinionsOptOutOfLoot()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then	
	-- Update the settings.
		AJM.db.newTeamList = JambaUtilities:CopyTable( settings.newTeamList )
		AJM.db.isboxerSync = settings.isboxerSync
		
		AJM.db.masterChangePromoteLeader = settings.masterChangePromoteLeader 
		AJM.db.inviteAcceptTeam = settings.inviteAcceptTeam 
		AJM.db.inviteAcceptFriends = settings.inviteAcceptFriends 
		AJM.db.inviteAcceptGuild = settings.inviteAcceptGuild 
		AJM.db.inviteDeclineStrangers = settings.inviteDeclineStrangers
		AJM.db.inviteConvertToRaid = settings.inviteConvertToRaid
		AJM.db.inviteSetAllAssistant = settings.inviteSetAllAssistant
		AJM.db.masterChangeClickToMove = settings.masterChangeClickToMove
		AJM.db.master = settings.master
		SetMaster( settings.master )
		-- Refresh the settings.
		--AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["SETTINGS_RECEIVED_FROM_A"]( characterName ) )
	end
end

function AJM:PLAYER_ENTERING_WORLD()
	-- trying this
	-- Click the first row in the team list table to populate the tag list table.
	AJM:SettingsTeamListRowClick( 1, 1 )
	AJM:IsboxerSyncTeamList()
end

-------------------------------------------------------------------------------------------------------------
-- Settings Callbacks.
-------------------------------------------------------------------------------------------------------------

function AJM:SettingsTeamListScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControl.teamList.listScrollFrame, 
		GetTeamListMaximumOrder(),
		AJM.settingsControl.teamList.rowsToDisplay, 
		AJM.settingsControl.teamList.rowHeight
	)
	AJM.settingsControl.teamListOffset = FauxScrollFrame_GetOffset( AJM.settingsControl.teamList.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControl.teamList.rowsToDisplay do
		-- Reset.
		AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[3].textString:SetText( "" )
		AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[3].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.teamList.rows[iterateDisplayRows].highlight:SetColorTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControl.teamListOffset
		if dataRowNumber <= GetTeamListMaximumOrder() then
			-- Put character name and type into columns.
			local characterName = GetCharacterNameAtOrderPosition( dataRowNumber )
			
		--local class = AJM.db.characterClass[characterName]
			--AJM:Print("Test", class)
			-- Set Class Color
			local class, color = GetClass( characterName )
			if color ~= nil then
				AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( color.r, color.g, color.b, 1.0 )
			end
			local isMaster = false
			local characterType = L["MINION"]
			if IsCharacterTheMaster( characterName ) == true then
				characterType = L["MASTER"]
				isMaster = true
			end
			local displayCharacterName , displayCharacterRleam = strsplit( "-", characterName, 2 )
			
			local isOnline = GetCharacterOnlineStatus( characterName )
			local displayOnline = nil
			if isOnline == false then
				displayOnline = L["OFFLINE"]
				AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[3].textString:SetTextColor( 1.0, 0, 0, 1.0 )
			else
				displayOnline = L["ONLINE"]
				AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[3].textString:SetTextColor( 0, 1.0, 0, 1.0 )
			end
			
			-- Master is a yellow colour.
			
			if isMaster == true then
				local icon = "Interface\\GroupFrame\\UI-Group-LeaderIcon"
				displayCharacterName = strconcat(" |T"..icon..":20|t", L[" "]..displayCharacterName)
			--	AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[3].textString:SetTextColor( 1.0, 0.96, 0.41, 1.0 )
			end
			local RealmLinked = JambaUtilities:CheckIsFromMyRealm( characterName )
			-- Set Realms not linked Red
			if RealmLinked == false then
				displayCharacterRleam = displayCharacterRleam..L[" "]..L["NOT_LINKED"]
				AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 0, 0, 1.0 )
			end
			
			AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[1].textString:SetText( displayCharacterName )
			AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[2].textString:SetText( displayCharacterRleam )
			AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[3].textString:SetText( displayOnline )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControl.teamListHighlightRow then
				AJM.settingsControl.teamList.rows[iterateDisplayRows].highlight:SetColorTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
end


local function DisplayGroupsForCharacterInGroupsList( characterName )
	AJM.characterGroupList = JambaApi.GetGroupListForCharacter( characterName )
	table.sort( AJM.characterGroupList )
	AJM:SettingsGroupListScrollRefresh()
end

local function GetGroupAtPosition( position )
	return AJM.characterGroupList[position]
	
end

local function GetTagListMaxPosition()
	return #AJM.characterGroupList
end

function AJM:SettingsTeamListRowClick( rowNumber, columnNumber )		
	if AJM.settingsControl.teamListOffset + rowNumber <= GetTeamListMaximumOrder() then
		AJM.settingsControl.teamListHighlightRow = AJM.settingsControl.teamListOffset + rowNumber
		AJM:SettingsTeamListScrollRefresh()
		--AJM:SettingsGroupListScrollRefresh()
		-- Group
		AJM.settingsControl.groupListHighlightRow = 1
		local characterName = GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
		DisplayGroupsForCharacterInGroupsList( characterName )
	end
end
	

function AJM:SettingsGroupListScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControl.groupList.listScrollFrame, 
		--JambaPrivate.Tag.GetTagListMaxPosition(),
		JambaApi.CharacterMaxGroups(),
		AJM.settingsControl.groupList.rowsToDisplay, 
		AJM.settingsControl.groupList.rowHeight
	)
	AJM.settingsControl.groupListOffset = FauxScrollFrame_GetOffset( AJM.settingsControl.groupList.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControl.groupList.rowsToDisplay do	
		
		AJM.settingsControl.groupList.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControl.groupList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.groupList.rows[iterateDisplayRows].highlight:SetColorTexture( 0.0, 0.0, 0.0, 0.0 )
		local dataRowNumber = iterateDisplayRows + AJM.settingsControl.groupListOffset
		if dataRowNumber <= JambaApi.CharacterMaxGroups() then
		--local characterName = JambaApi.GetGroupListForCharacter --AJM.CharGroupListName
		--local group = GetGroupAtPosition(characterName,dataRowNumber)
		local group = GetGroupAtPosition( dataRowNumber )
		local groupName = JambaUtilities:Capitalise( group )
		--local group = JambaApi.GetGroupAtPosition( dataRowNumber )
			AJM.settingsControl.groupList.rows[iterateDisplayRows].columns[1].textString:SetText( groupName ) 
			--AJM:Print("test", dataRowNumber, group, characterName ) 
			local systemGroup = JambaApi.IsASystemGroup( group )
			if systemGroup == true then
				AJM.settingsControl.groupList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 0.96, 0.41, 1.0 )
			end
			if dataRowNumber == AJM.settingsControl.groupListHighlightRow then
				AJM.settingsControl.groupList.rows[iterateDisplayRows].highlight:SetColorTexture( 1.0, 1.0, 0.0, 0.5 )	
			end
		end	
	end

end	


function AJM:SettingsGroupListRowClick( rowNumber, columnNumber )		
	if AJM.settingsControl.groupListOffset + rowNumber <= GetTagListMaxPosition() then
		AJM.settingsControl.groupListHighlightRow = AJM.settingsControl.groupListOffset + rowNumber
		AJM:SettingsGroupListScrollRefresh()
	end
end

-- For Api Update For anywhere you add a Group. ( mosty Tag.lua )
local function RefreshGroupList()
	AJM:SettingsGroupListScrollRefresh()
end

function AJM:TeamListDropDownList(event, value )
	-- if nil or the blank group then don't get Name.
	if value == " " or value == nil then 
		return 
	end
	local characterName = GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
	local groupName = JambaUtilities:Lowercase( value )
	--AJM:Print("test", characterName, groupName )
	-- We Have a group and characterName Lets Add it to the groupList
	JambaApi.AddCharacterToGroup( characterName, groupName )
	-- Reset the groupList Back to "Nothing"
	AJM.settingsControl.teamListDropDownList:SetValue( " " )
	-- update Lists
	AJM:SettingsRefresh()
	AJM:SettingsGroupListScrollRefresh()
end

function AJM.SettingsRemoveGroupClick(event, value )
	local tag = GetGroupAtPosition( AJM.settingsControl.groupListHighlightRow )
	local systemGroup = JambaApi.IsASystemGroup( tag )
	local groupName = JambaUtilities:Lowercase( tag )
	local characterName = GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
	local systemGroup = JambaApi.IsASystemGroup( tag )
	-- Remove From Tag List
	if systemGroup == false then
		JambaApi.RemoveGroupFromCharacter( characterName, groupName )
	else
		--TODO: Update
		AJM:Print("[PH] CAN NOT REMOVE FORM THIS GROUP!")
	end
	-- update Lists
	AJM:SettingsRefresh()
	AJM:SettingsGroupListScrollRefresh()
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsMoveUpClick( event )
	if AJM.settingsControl.teamListHighlightRow > 1 then
		TeamListSwapCharacterPositions( AJM.settingsControl.teamListHighlightRow, AJM.settingsControl.teamListHighlightRow - 1 )
		AJM.settingsControl.teamListHighlightRow = AJM.settingsControl.teamListHighlightRow - 1
		if AJM.settingsControl.teamListHighlightRow <= AJM.settingsControl.teamListOffset then
			JambaHelperSettings:SetFauxScrollFramePosition( 
				AJM.settingsControl.teamList.listScrollFrame, 
				AJM.settingsControl.teamListHighlightRow - 1, 
				GetTeamListMaximumOrder(), 
				AJM.settingsControl.teamList.rowHeight 
			)
		end
		AJM:SettingsTeamListScrollRefresh()
		--AJM:SettingsGroupListScrollRefresh()
		AJM:SendMessage( AJM.MESSAGE_TEAM_ORDER_CHANGED )
	end
end

function AJM:SettingsMoveDownClick( event )
	if AJM.settingsControl.teamListHighlightRow < GetTeamListMaximumOrder() then
		TeamListSwapCharacterPositions( AJM.settingsControl.teamListHighlightRow, AJM.settingsControl.teamListHighlightRow + 1 )
		AJM.settingsControl.teamListHighlightRow = AJM.settingsControl.teamListHighlightRow + 1
		if AJM.settingsControl.teamListHighlightRow > ( AJM.settingsControl.teamListOffset + AJM.settingsControl.teamList.rowsToDisplay ) then
			JambaHelperSettings:SetFauxScrollFramePosition( 
				AJM.settingsControl.teamList.listScrollFrame, 
				AJM.settingsControl.teamListHighlightRow + 1, 
				GetTeamListMaximumOrder(), 
				AJM.settingsControl.teamList.rowHeight 
			)
		end
		AJM:SettingsTeamListScrollRefresh()
		--AJM:SettingsGroupListScrollRefresh()
		AJM:SendMessage( AJM.MESSAGE_TEAM_ORDER_CHANGED )
	end
end

function AJM:SettingsAddClick( event )
	StaticPopup_Show( "JAMBATEAM_ASK_CHARACTER_NAME" )
end

function AJM:SettingsRemoveClick( event )
	local characterName = GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
	StaticPopup_Show( "JAMBATEAM_CONFIRM_REMOVE_CHARACTER", characterName )
end

function AJM.SettingsAddPartyClick( event )
	AJM:AddPartyMembers()
end
function AJM:SettingsInviteClick( event )
	AJM:InviteTeamToParty(nil)
end

function AJM:SettingsDisbandClick( event )
	AJM:DisbandTeamFromParty()
end

function AJM:SettingsSyncIsboxerToggle( event, checked)
	AJM.db.isboxerSync = checked
	AJM:SettingsRefresh()
end	

function AJM:SettingsSetMasterClick( event )
	local characterName = GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
	SetMaster( characterName )
	AJM:SettingsTeamListScrollRefresh()
	--AJM:SettingsGroupListScrollRefresh()
end

function AJM:SettingsMasterChangeToggle( event, checked )
	AJM.db.masterChangePromoteLeader = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsMasterChangeClickToMoveToggle( event, checked )
	AJM.db.masterChangeClickToMove = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsAcceptInviteMembersToggle( event, checked )
	AJM.db.inviteAcceptTeam = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsAcceptInviteFriendsToggle( event, checked )
	AJM.db.inviteAcceptFriends = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsAcceptInviteGuildToggle( event, checked )
	AJM.db.inviteAcceptGuild = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsDeclineInviteStrangersToggle( event, checked )
	AJM.db.inviteDeclineStrangers = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsinviteConvertToRaidToggle( event, checked )
	AJM.db.inviteConvertToRaid = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsinviteSetAllAssistToggle( event, checked )
	AJM.db.inviteSetAllAssistant = checked
end

-------------------------------------------------------------------------------------------------------------
-- Key bindings.
-------------------------------------------------------------------------------------------------------------

function AJM:UPDATE_BINDINGS()
	if InCombatLockdown() then
		return
	end
	ClearOverrideBindings( AJM.keyBindingFrame )
	local key1, key2 = GetBindingKey( "JAMBATEAMINVITE" )		
	if key1 then 
		SetOverrideBindingClick( AJM.keyBindingFrame, false, key1, "JambaTeamSecureButtonInvite" ) 
	end
	if key2 then 
		SetOverrideBindingClick( AJM.keyBindingFrame, false, key2, "JambaTeamSecureButtonInvite" ) 
	end	
	key1, key2 = GetBindingKey( "JAMBATEAMDISBAND" )		
	if key1 then 
		SetOverrideBindingClick( AJM.keyBindingFrame, false, key1, "JambaTeamSecureButtonDisband" ) 
	end
	if key2 then 
		SetOverrideBindingClick( AJM.keyBindingFrame, false, key2, "JambaTeamSecureButtonDisband" ) 
	end
end

-------------------------------------------------------------------------------------------------------------
-- Commands.
-------------------------------------------------------------------------------------------------------------

function AJM:JambaOnCommandReceived( sender, commandName, ... )
	if commandName == AJM.COMMAND_LEAVE_PARTY then
		if IsCharacterInTeam( sender ) == true then
			LeaveTheParty()
		end
	end
	if commandName == AJM.COMMAND_SET_MASTER then
		if IsCharacterInTeam( sender ) == true then
			AJM:ReceiveCommandSetMaster( ... )
		end	
	end
	--Ebony
	if commandName == AJM.COMMAND_SET_OFFLINE then
		if IsCharacterInTeam( sender ) == true then
			AJM.ReceivesetOffline( ... )
		end
	end
	if commandName == AJM.COMMAND_SET_ONLINE then
		if IsCharacterInTeam( sender ) == true then
			AJM.ReceivesetOnline( ... )
		end
	end
	if commandName == AJM.COMMAND_TAG_PARTY then
		if IsCharacterInTeam( sender ) == true then
			AJM.TagParty( characterName, tag, ... )
		end	
	end	
end

-- Functions available from Jamba Team for other Jamba internal objects.
JambaPrivate.Team.MESSAGE_TEAM_MASTER_CHANGED = AJM.MESSAGE_TEAM_MASTER_CHANGED
JambaPrivate.Team.MESSAGE_TEAM_ORDER_CHANGED = AJM.MESSAGE_TEAM_ORDER_CHANGED
JambaPrivate.Team.MESSAGE_TEAM_CHARACTER_ADDED = AJM.MESSAGE_TEAM_CHARACTER_ADDED
JambaPrivate.Team.MESSAGE_TEAM_CHARACTER_REMOVED = AJM.MESSAGE_TEAM_CHARACTER_REMOVED
JambaPrivate.Team.TeamList = TeamList
JambaPrivate.Team.IsCharacterInTeam = IsCharacterInTeam
JambaPrivate.Team.IsCharacterTheMaster = IsCharacterTheMaster
JambaPrivate.Team.GetMasterName = GetMasterName
JambaPrivate.Team.SetTeamStatusToOffline = SetTeamStatusToOffline
JambaPrivate.Team.GetCharacterOnlineStatus = GetCharacterOnlineStatus
JambaPrivate.Team.SetTeamOnline = SetTeamOnline
JambaPrivate.Team.GetCharacterNameAtOrderPosition = GetCharacterNameAtOrderPosition
JambaPrivate.Team.GetTeamListMaximumOrder = GetTeamListMaximumOrder
JambaPrivate.Team.RemoveAllMembersFromTeam = RemoveAllMembersFromTeam
JambaPrivate.Team.setOffline = setOffline
JambaPrivate.Team.setOnline = setOline
JambaPrivate.Team.RefreshGroupList = RefreshGroupList


-- Functions available for other addons.
JambaApi.MESSAGE_TEAM_MASTER_CHANGED = AJM.MESSAGE_TEAM_MASTER_CHANGED
JambaApi.MESSAGE_TEAM_ORDER_CHANGED = AJM.MESSAGE_TEAM_ORDER_CHANGED
JambaApi.MESSAGE_TEAM_CHARACTER_ADDED = AJM.MESSAGE_TEAM_CHARACTER_ADDED
JambaApi.MESSAGE_TEAM_CHARACTER_REMOVED = AJM.MESSAGE_TEAM_CHARACTER_REMOVED
JambaApi.IsCharacterInTeam = IsCharacterInTeam
JambaApi.IsCharacterTheMaster = IsCharacterTheMaster
JambaApi.GetMasterName = GetMasterName
JambaApi.TeamList = TeamList
JambaApi.FullTeamList = FullTeamList
JambaApi.Offline = Offline
JambaApi.TeamListOrdered = TeamListOrdered
JambaApi.GetCharacterNameAtOrderPosition = GetCharacterNameAtOrderPosition
JambaApi.GetPositionForCharacterName = GetPositionForCharacterName 
JambaApi.GetTeamListMaximumOrder = GetTeamListMaximumOrder
JambaApi.GetCharacterOnlineStatus = GetCharacterOnlineStatus
JambaApi.RemoveAllMembersFromTeam = RemoveAllMembersFromTeam
JambaApi.MESSAGE_CHARACTER_ONLINE = AJM.MESSAGE_CHARACTER_ONLINE
JambaApi.MESSAGE_CHARACTER_OFFLINE = AJM.MESSAGE_CHARACTER_OFFLINE
JambaApi.setOffline = setOffline
JambaApi.setOnline = setOnline
JambaApi.GetTeamListMaximumOrderOnline = GetTeamListMaximumOrderOnline
JambaApi.TeamListOrderedOnline = TeamListOrderedOnline
JambaApi.GetPositionForCharacterNameOnline = GetPositionForCharacterNameOnline
JambaApi.GetClass = GetClass
--JambaApi.SetClass = setClass
JambaApi.GroupAreaList = GroupAreaList
JambaApi.refreshDropDownList = refreshDropDownList