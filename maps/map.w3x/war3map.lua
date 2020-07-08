gg_trg_demo_init = nil
gg_trg_mui_init = nil

function InitGlobals()
end
do
    local data = {}
    function SetTimerData(whichTimer, dat)
        data[whichTimer] = dat
    end

    --GetData functionality doesn't even require an argument.
    function GetTimerData(whichTimer)
        if not whichTimer then whichTimer = GetExpiredTimer() end
        return data[whichTimer]
    end

    --NewTimer functionality includes optional parameter to pass data to timer.
    function NewTimer(dat)
        local t = CreateTimer()
        if dat then data[t] = dat end
        return t
    end

    --Release functionality doesn't even need for you to pass the expired timer.
    --as an arg. It also returns the user data passed.
    function ReleaseTimer(whichTimer)
        if not whichTimer then whichTimer = GetExpiredTimer() end
        local dat = data[whichTimer]
        data[whichTimer] = nil
        PauseTimer(whichTimer)
        DestroyTimer(whichTimer)
        return dat
    end
end


-- - - - - - - - - - - -
local mui                    = {}
local mui_data               = {}
-- - - - - - - - - - - -
mui_data.frameStack          = {}                            -- where custom frames are kept for reference.
-- - - - - - - - - - - -
mui_data.portraitSize        = 0.0225                        -- height and width.
mui_data.maxPlayers          = 9                             -- (0-based) how many players can play the map (starts at Player(0))
-- - - - - - - - - - - -
mui_data.consoleUIOffsetY    = -0.24                         -- pushes the console UI originframe down.
mui_data.minimapBtnPadding   = 0.02365                       -- spaces out the minimap buttons.
mui_data.menuBtnOffsetY      = 0.0218                        -- distance from bottom row of command bar.
mui_data.menuBtnPadding      = 0.0015                        -- menu button padding bottom and right.
mui_data.menuBtnWidth        = 0.065                         -- resized width.
mui_data.infoPanelOffsetX    = 0.4                           -- offset from left of screen.
mui_data.infoPanelOffsetY    = 0.00325                       -- offset from bottom of screen.
mui_data.infoPanelGutterY    = 0.004                         -- nudges the backdrop up for edge alignment.
mui_data.resourceBarOffsetX  = -0.004                        -- moves backdrop left and right
mui_data.resourceBarOffsetY  = -0.0005                       -- moves backdrop up and down.
mui_data.inventoryPadding    = 0.0256                        -- space between inventory buttons
mui_data.inventoryOffsetX    = -0.075                        -- pushes inventory buttons left of info panel.
mui_data.inventoryOffsetY    = 0.0041                        -- starting Y offset.
-- - - - - - - - - - - -
mui_data.commandBarFrameSize = 0.029                         -- somewhat arbitrary frame width that is hardcoded and scary to change. calcs length.
mui_data.commandBarGutterY   = 0.007                         -- gap between top and bottom rows.
mui_data.commandBarOffsetX   = 0.315                         -- start X is calced based on icon size. this value nudges the command bar left or right.
mui_data.commandBarOffsetY   = 0.065                         -- offset from bottom of screen.
mui_data.commandBarPadding   = 0.01                          -- gap between command bar buttons.
mui_data.commandBarNudgeDiv  = 2.26                          -- psuedo-combined width, gutter, offset ratio. lower = move command bar left, vice versa.
mui_data.commandBarSize      = 0.035                         -- height and width.
mui_data.commandBarOrder     = {0,1,2,3,4,5,8,9,10,11,6,7}   -- requires 12 items. arranges the command bar top-to-bottom. see below for default rubric.
-- - - - - - - - - - - -
mui_data.getCenter           = 0.4                           -- approximate center of the original UI.
mui_data.getMaxY             = 0.6                           -- top edge of 4:3 screen.
mui_data.inventoryTxtAlpha   = 225                           -- 'Inventory' over the inv. pane.
mui_data.unitInfoHeight      = 0.605                         -- controls the hero portrait Y offset from center (percentage of parent info frame).
mui_data.unitInfoWidth       = 0.4265                        -- controls the hero portrait X offset from center (percentage of parent info frame).
mui_data.backdropAlpha       = 130                           -- (0 to 255-based int) set alpha for floating UI elements (default = ~51).
mui_data.screenGutter        = mui_data.infoPanelGutterY + mui_data.infoPanelOffsetY
mui_data.txtColor            = '|cffffffff'
mui_data.textureMain         = 'war3mapImported\\ui_black_colorizer.tga'
mui_data.textureFlagBTN      = 'ReplaceableTextures\\CommandButtons\\BTNRallyPoint.blp'
-- - - - - - - - - - - -
--[[
    original command bar matrix (reference):
    row1:   | 0| | 1| | 2| | 3|
    row2:   | 4| | 5| | 6| | 7|
    row3:   | 8| | 9| |10| |11|

    default mui command bar matrix (reference):
    top:    | 0| | 1| | 2| | 3| | 4| | 5|
    bot:    | 8| | 9| |10| |11| | 6| | 7|
--]]
-- - - - - - - - - - - -

-- iterate through command buttons:
mui_data.commandBarMap = {
    [0] = "CommandButton_0",
    [1] = "CommandButton_1",
    [2] = "CommandButton_2",
    [3] = "CommandButton_3",
    [4] = "CommandButton_4",
    [5] = "CommandButton_5",
    [6] = "CommandButton_6",
    [7] = "CommandButton_7",
    [8] = "CommandButton_8",
    [9] = "CommandButton_9",
    [10] = "CommandButton_10",
    [11] = "CommandButton_11",
}

-- unhide desired components:
mui_data.unhideFramesByName = {
    [0] = "MiniMapFrame",
    [1] = "Multiboard",
    [2] = "UpperButtonBarFrame",
    [3] = "SimpleUnitStatsPanel",
    [4] = "SimpleHeroLevelBar",
    [5] = "ResourceBarFrame",
    [6] = "MinimapButtonBar"
}

mui_data.minimapButtons = {
    [0] = "FormationButton",
    [1] = "MiniMapCreepButton",
    [2] = "MiniMapAllyButton",
    [3] = "MiniMapTerrainButton",
    [4] = "MinimapSignalButton"
}

mui_data.inventoryButtons = {
    [0] = "InventoryButton_0",
    [1] = "InventoryButton_1",
    [2] = "InventoryButton_2",
    [3] = "InventoryButton_3",
    [4] = "InventoryButton_4",
    [5] = "InventoryButton_5"
}

mui_data.menuButtons = {
    [0] = "UpperButtonBarQuestsButton",
    [1] = "UpperButtonBarMenuButton",
    [2] = "UpperButtonBarAlliesButton",
    [3] = "UpperButtonBarChatButton"
}

-- rearrange originframes that were moved off screen:
mui_data.consoleFrames = {
    [0] = { frame = ORIGIN_FRAME_UNIT_MSG, x = 0.0, y = 0.25},
}


function mui.Init()

    for pInt = 0,mui_data.maxPlayers do

        if Player(pInt) == GetLocalPlayer() then

            -- temporary framehandle variable for multiple lookups + readability:
            local fh

            -- will stop the moving of frames when changing resolution or window mode when set to false:
            BlzEnableUIAutoPosition(false)

            -- move undesired items off screen:
            BlzFrameSetAbsPoint(BlzGetFrameByName("ConsoleUI", 0), FRAMEPOINT_BOTTOM, 0.0, mui_data.consoleUIOffsetY)

            -- fetch items we use repeatedly:
            mui_data.gameUI       = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)
            mui_data.portrait     = BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT,0)
            mui_data.chatMsg      = BlzGetOriginFrame(ORIGIN_FRAME_CHAT_MSG,0)
            mui_data.infoPanel    = BlzFrameGetParent(BlzGetFrameByName("SimpleInfoPanelUnitDetail",0))
            mui_data.minimap      = BlzGetFrameByName("MiniMapFrame",0)
            mui_data.minimapBar   = BlzGetFrameByName("MinimapButtonBar",0)
            mui_data.resourceBar  = BlzGetFrameByName("ResourceBarFrame",0)
            mui_data.inventoryTxt = BlzGetFrameByName("InventoryText", 0)

            -- reposition items move after nudging ConsoleUI off screen:
            for i = 0,#mui_data.consoleFrames do
                fh = BlzGetOriginFrame(mui_data.consoleFrames[i].frame,0)
                BlzFrameClearAllPoints(fh)
                BlzFrameSetAbsPoint(fh,FRAMEPOINT_BOTTOMLEFT,mui_data.consoleFrames[i].x,mui_data.consoleFrames[i].y + mui_data.screenGutter)
            end
            fh = BlzGetFrameByName("MiniMapFrame",0)
            BlzFrameClearAllPoints(fh)
            BlzFrameSetAbsPoint(fh, FRAMEPOINT_BOTTOMLEFT, 0.0, 0.0 + mui_data.screenGutter)
            BlzFrameClearAllPoints(mui_data.chatMsg)
            -- for some reason the chat frame ignores x offset:
            BlzFrameSetPoint(mui_data.chatMsg, FRAMEPOINT_BOTTOMLEFT, mui_data.minimap, FRAMEPOINT_TOPLEFT, 0.0, 0.0)
            BlzFrameSetSize(mui_data.chatMsg, 0.5, 0.2)

            -- unhide:
            for i = 0,#mui_data.unhideFramesByName do
                BlzFrameSetVisible(BlzGetFrameByName(mui_data.unhideFramesByName[i],0), true)
            end
            for i = 0,#mui_data.inventoryButtons do
                BlzFrameSetVisible(BlzGetFrameByName(mui_data.inventoryButtons[i],0), true)
            end
            for i = 0,#mui_data.menuButtons do
                BlzFrameSetVisible(BlzGetFrameByName(mui_data.menuButtons[i],0), true)
            end

            -- hide:
            BlzFrameSetVisible(BlzGetFrameByName("ConsoleUIBackdrop",0), false)
            BlzFrameSetVisible(BlzFrameGetParent(BlzGetFrameByName("ResourceBarFrame",0)), false)

            -- unhide specific frames:
            for i = 0,4 do
                BlzFrameSetVisible(BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP_BUTTON,i), true)
            end
            BlzFrameSetVisible(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BAR,0), true)
            BlzFrameSetVisible(mui_data.infoPanel,true)

            -- cover cannot be hidden, has to be made 100ransparent:
            fh = BlzGetFrameByName("SimpleInventoryCover", 0)
            BlzFrameSetAlpha(fh, 0)
            BlzFrameSetAbsPoint(fh, FRAMEPOINT_BOTTOMLEFT, 1.0,1.0)

            -- set custom transparencies:
            BlzFrameSetAlpha(mui_data.inventoryTxt, mui_data.inventoryTxtAlpha)

            -- set custom text overrides:
            BlzFrameSetText(mui_data.inventoryTxt, mui_data.txtColor .. 'Inventory|r')

            -- move specific frames (these need to be done before backdrops are generated):
--             mui.UnitPortraitAttachContainer()       -- move unit portrait.
            mui.UnitStatsPanelMove()                -- reposition unit stats panel.
            mui.CommandBarMove()                    -- load command bar.
            mui.MinimapMove()                       -- reposition minimap buttons.
            mui.InventoryMove()                     -- reposition inventory icons.
            mui.MenuButtonMove()                    -- moves top left menu buttons.

            -- create custom frames, assign stored index for future manipulation:
            mui_data.frameStack[#mui_data.frameStack + 1] = mui.AttachBackdropByHandle(mui_data.minimap,'minimap_bd',mui_data.textureMain)
            mui_data.frameStack[#mui_data.frameStack + 1] = mui.AttachBackdropByHandle(mui_data.infoPanel,
                'unitinfo_bd',mui_data.textureMain,mui_data.backdropAlpha,nil,mui_data.infoPanelGutterY)
            for i = 0,5 do
                mui_data.frameStack[#mui_data.frameStack + 1] = mui.AttachBackdropByHandle(BlzGetFrameByName("InventoryButton_"..i,0),
                    'inv_bd_'..i,mui_data.textureMain,mui_data.backdropAlpha)
            end
            for i = 0,4 do
                mui_data.frameStack[#mui_data.frameStack + 1] = mui.AttachBackdropByHandle(BlzGetFrameByName(mui_data.minimapButtons[i],0),
                    'minimapbar_bd_'..i,mui_data.textureMain,mui_data.backdropAlpha)
            end

            mui_data.frameStack[#mui_data.frameStack + 1] = mui.AttachBackdropByHandle(mui_data.resourceBar,'resourcebar_bd',
                mui_data.textureMain,mui_data.backdropAlpha, mui_data.resourceBarOffsetX, mui_data.resourceBarOffsetY)

        end
    end

    -- keep outside of local player to stop desyncs:
    -- mui.InitUnitSelectedUpdate()

end


function mui.UnitPortraitAttachContainer()
    mui_data.portraitContainer = mui.AttachBackdropByHandle(mui_data.infoPanel, 'portrait_container',
        mui_data.textureFlagBTN, 0, 0.0, BlzFrameGetHeight(mui_data.infoPanel)*mui_data.unitInfoHeight + 0.00672,
        mui_data.portraitSize, mui_data.portraitSize)
    BlzFrameSetAlpha(mui_data.portraitContainer, 0)
    mui.UnitPortraitMove()
end


function mui.UnitPortraitMove()
    BlzFrameClearAllPoints(mui_data.portrait)
    BlzFrameSetSize(mui_data.portrait,mui_data.portraitSize,mui_data.portraitSize)
    BlzFrameSetAbsPoint(mui_data.portrait,FRAMEPOINT_CENTER,mui_data.getCenter,BlzFrameGetHeight(mui_data.infoPanel) + 0.02265)
end


-- we have to do some janky stuff here to allow hp/text bars to update.
-- the short version of it is:
--   a) the unit selected needs to be present for all players or it can desync. we make one for each player so they are guaranteed to have visibility of it.
--   b) there is a few frames of delay between hp/mana text becoming enabled. trying to move it too early can cause a client crash.
function mui.InitUnitSelectedUpdate()
    for pSlot = 0,9 do
        local player = Player(pSlot)
        TimerStart(NewTimer(), 0.1, false, function()
            local u = CreateUnit(player, FourCC('hfoo'),0.0,0.0,270.0)
            PauseUnit(u,true)
            SetUnitVertexColorBJ(u, 0, 0, 0, 100)
            if GetLocalPlayer() == player then
                SelectUnit(u, true)
            end
            TimerStart(NewTimer(), 0.3, false, function()
                if GetLocalPlayer() == player then
                    local fh   = BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT_HP_TEXT, 0)
                    local fh2  = BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT_MANA_TEXT, 0)

                    BlzFrameClearAllPoints(fh)
                    BlzFrameSetPoint(fh, FRAMEPOINT_CENTER, mui_data.portraitContainer,
                        FRAMEPOINT_CENTER,-(mui_data.portraitSize*2.5),-0.0056)

                    BlzFrameClearAllPoints(fh2)
                    BlzFrameSetPoint(fh2, FRAMEPOINT_CENTER, mui_data.portraitContainer,
                        FRAMEPOINT_CENTER,mui_data.portraitSize*2.5,-0.0056)

                    SelectUnit(u, false)
                end
                RemoveUnit(u)
                ReleaseTimer()
            end)
            ReleaseTimer()
        end)
    end
end


function mui.CommandBarMove()

    local fh
    local prevfh
    -- where top 1st btn starts on screen (expanding right):
    local top_row_x = mui_data.getCenter - (12*mui_data.commandBarFrameSize)/mui_data.commandBarNudgeDiv + mui_data.commandBarOffsetX
    -- where bot 1st btn starts on screen (expanding right):
    local bot_row_x = mui_data.getCenter - (12*mui_data.commandBarFrameSize)/mui_data.commandBarNudgeDiv + mui_data.commandBarOffsetX
    local reorder_index

    for i = 0,11 do
        reorder_index = mui_data.commandBarOrder[i+1]
        fh = BlzGetFrameByName(mui_data.commandBarMap[reorder_index],0)
        BlzFrameClearAllPoints(fh)
        if (i >= 6) then -- bot row
            if (i ~= 6) then
                prevfh = BlzGetFrameByName(mui_data.commandBarMap[mui_data.commandBarOrder[i]],0)
                BlzFrameSetPoint(fh, FRAMEPOINT_LEFT, prevfh, FRAMEPOINT_RIGHT, mui_data.commandBarPadding, 0.0)
            else
                BlzFrameSetAbsPoint(fh,FRAMEPOINT_RIGHT,bot_row_x,mui_data.commandBarOffsetY - mui_data.commandBarGutterY)
            end
        else -- top row
            if (i ~= 0) then
                prevfh = BlzGetFrameByName(mui_data.commandBarMap[mui_data.commandBarOrder[i]],0)
                BlzFrameSetPoint(fh, FRAMEPOINT_LEFT, prevfh, FRAMEPOINT_RIGHT, mui_data.commandBarPadding, 0.0)
            else
                BlzFrameSetAbsPoint(fh,FRAMEPOINT_RIGHT,top_row_x,
                    mui_data.commandBarOffsetY+mui_data.commandBarFrameSize+mui_data.commandBarPadding)
            end
        end
        BlzFrameSetSize(fh,mui_data.commandBarSize,mui_data.commandBarSize)
        BlzFrameSetLevel(fh, 1)
        mui_data.frameStack[#mui_data.frameStack + 1] = mui.AttachBackdropByHandle(fh,'cmd_bd_'..i,mui_data.textureMain,mui_data.backdropAlpha)
    end

end


function mui.InventoryMove()
    local fh
    local nudgeX = 0.0
    local nudgeY = 0.0
    -- inventory txt:
    BlzFrameClearAllPoints(mui_data.inventoryTxt)
    BlzFrameSetPoint(mui_data.inventoryTxt,FRAMEPOINT_TOPRIGHT,mui_data.infoPanel,FRAMEPOINT_TOPLEFT,
            mui_data.inventoryOffsetX + BlzFrameGetWidth(mui_data.inventoryTxt)/2 + mui_data.inventoryPadding/4.33,
            mui_data.inventoryOffsetY + mui_data.inventoryPadding*0.65)
    -- inventory buttons:
    for i = 0,5 do
        fh = BlzGetFrameByName(mui_data.inventoryButtons[i],0)
        if i == 2 or i == 4 then
            nudgeY = nudgeY + -(BlzFrameGetWidth(fh)/2 + mui_data.inventoryPadding)
        end
        if i == 1 or i == 3 or i == 5 then
            nudgeX = BlzFrameGetWidth(fh)/2 + mui_data.inventoryPadding
        else
            nudgeX = 0.0
        end
        BlzFrameClearAllPoints(fh)
        BlzFrameSetPoint(fh,FRAMEPOINT_TOPRIGHT,mui_data.infoPanel,FRAMEPOINT_TOPLEFT,
            mui_data.inventoryOffsetX + nudgeX, mui_data.inventoryOffsetY + nudgeY)
    end
end


function mui.MenuButtonMove()
    local fh
    for i = 0,#mui_data.menuButtons do
        fh = BlzGetFrameByName(mui_data.menuButtons[i],0)
        BlzFrameClearAllPoints(fh)
        BlzFrameSetSize(fh, mui_data.menuBtnWidth, BlzFrameGetHeight(fh))
        --BlzFrameSetTexture(fh, mui_data.textureMain, 0, true)
        --[[BlzFrameSetAlpha(fh,0.0)
        mui_data.frameStack[#mui_data.frameStack + 1] = mui.AttachBackdropByHandle(fh,'menu_bd_'..i,
                mui_data.textureMain,mui_data.backdropAlpha,0.0,0.0)--]]
    end
    BlzFrameSetPoint(BlzGetFrameByName(mui_data.menuButtons[0],0),FRAMEPOINT_TOPLEFT,BlzGetFrameByName(mui_data.commandBarMap[8],0),
        FRAMEPOINT_BOTTOMLEFT,-mui_data.menuBtnPadding,-(mui_data.menuBtnOffsetY - mui_data.commandBarGutterY))
    BlzFrameSetPoint(BlzGetFrameByName(mui_data.menuButtons[1],0),FRAMEPOINT_LEFT,BlzGetFrameByName(mui_data.menuButtons[0],0),
        FRAMEPOINT_RIGHT,mui_data.menuBtnPadding,0.0)
    BlzFrameSetPoint(BlzGetFrameByName(mui_data.menuButtons[2],0),FRAMEPOINT_LEFT,BlzGetFrameByName(mui_data.menuButtons[1],0),
        FRAMEPOINT_RIGHT,mui_data.menuBtnPadding,0.0)
    BlzFrameSetPoint(BlzGetFrameByName(mui_data.menuButtons[3],0),FRAMEPOINT_LEFT,BlzGetFrameByName(mui_data.menuButtons[2],0),
        FRAMEPOINT_RIGHT,mui_data.menuBtnPadding,0.0)
end


function mui.UnitStatsPanelMove()
    BlzFrameClearAllPoints(mui_data.infoPanel)
    BlzFrameSetAbsPoint(mui_data.infoPanel,FRAMEPOINT_BOTTOM,mui_data.infoPanelOffsetX,mui_data.infoPanelOffsetY)
end


function mui.MinimapMove()
    local fh
    for i = 0,4 do
        fh = BlzGetFrameByName(mui_data.minimapButtons[i],0)
        BlzFrameClearAllPoints(fh)
        BlzFrameSetPoint(fh, FRAMEPOINT_BOTTOMLEFT, mui_data.minimap, FRAMEPOINT_BOTTOMRIGHT,0.005,mui_data.minimapBtnPadding*i)
    end
end


-- must be run after a cinematic or hero portrait resets position:
function mui.AfterCinematic()
    BlzFrameSetVisible(BlzGetFrameByName("ConsoleUIBackdrop",0), false)
    BlzFrameSetVisible(BlzGetFrameByName("CinematicPortrait",0), false)
    BlzFrameSetAlpha(BlzGetFrameByName("SimpleInventoryCover", 0), 0)
    BlzFrameSetAbsPoint(BlzGetFrameByName("SimpleInventoryCover", 0), FRAMEPOINT_BOTTOMLEFT, 1.0,1.0)
    BlzFrameSetAbsPoint(mui_data.chatMsg,FRAMEPOINT_BOTTOMLEFT,0.15,0.20)
    mui.UnitPortraitMove()
end


-- create a backdrop and set it to be positioned at the desired frame via FRAMEPOINT_CENTER.
-- @fh = target this frame
-- @newFrameNameString = enter a custom value to manipulate backdrop by name if needed e.g. "myInventoryBackdrop"
-- @texturePathString = [optional; usually needed] texture (.blp) as the background
-- @alphaValue = [optional] if the backdrop should be transparent, pass in a value 0-255
-- @offsetx = [optional] nudge the frame left or right (percentage of screen)
-- @offsety = [optional] nudge the frame up or down (percentage of screen)
-- @width, @height = [optional] override the frame size
-- :: returns framehandle
function mui.AttachBackdropByHandle(fh, newFrameNameString, texturePathString, alphaValue, offsetx, offsety, width, height)
    local nh = BlzCreateFrameByType("BACKDROP", newFrameNameString, BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0), "", 0)
    local x = offsetx or 0.0
    local y = offsety or 0.0
    local w = width or BlzFrameGetWidth(fh)
    local h = height or BlzFrameGetHeight(fh)
    BlzFrameSetSize(nh, w, h)
    BlzFrameSetPoint(nh, FRAMEPOINT_CENTER, fh, FRAMEPOINT_CENTER, 0.0 + x, 0.0 + y)
    if texturePathString then
        BlzFrameSetTexture(nh, texturePathString, 0, true)
    end
    BlzFrameSetLevel(nh, 0)
    if alphaValue then
        BlzFrameSetAlpha(nh, math.ceil(alphaValue))
    end
    return nh
end


-- show or hide custom made UI elements during a cinematic (be sure to use local player only)
-- @bool = should it be visible? true = visible; false = hide
function mui.ShowHideCustomUI(bool)
    for i = 1,#mui_data.frameStack do
        if mui_data.frameStack[i] ~= nil then
            BlzFrameSetVisible(mui_data.frameStack[i], bool)
        end
    end
end

do
    function CinematicModeExBJ(cineMode,forForce,interfaceFadeTime)
        -- If the game hasn't started yet, perform interface fades immediately
        if (not bj_gameStarted) then
            interfaceFadeTime = 0
        end

        if (cineMode) then
            -- Save the UI state so that we can restore it later.
            if (not bj_cineModeAlreadyIn) then
                bj_cineModeAlreadyIn = true
                bj_cineModePriorSpeed = GetGameSpeed()
                bj_cineModePriorFogSetting = IsFogEnabled()
                bj_cineModePriorMaskSetting = IsFogMaskEnabled()
                bj_cineModePriorDawnDusk = IsDawnDuskEnabled()
                bj_cineModeSavedSeed = GetRandomInt(0, 1000000)
            end

            -- Perform local changes
            if (IsPlayerInForce(GetLocalPlayer(), forForce)) then
                -- Use only local code (no net traffic) within this block to avoid desyncs.
                ClearTextMessages()
                ShowInterface(false, interfaceFadeTime)
                EnableUserControl(false)
                EnableOcclusion(false)
                SetCineModeVolumeGroupsBJ()
                mui.ShowHideCustomUI(false)  -- our custom addition
            end

            -- Perform global changes
            SetGameSpeed(bj_CINEMODE_GAMESPEED)
            SetMapFlag(MAP_LOCK_SPEED, true)
            FogMaskEnable(false)
            FogEnable(false)
            EnableWorldFogBoundary(false)
            EnableDawnDusk(false)

            -- Use a fixed random seed, so that cinematics play consistently.
            SetRandomSeed(0)
        else
            bj_cineModeAlreadyIn = false

            -- Perform local changes
            if (IsPlayerInForce(GetLocalPlayer(), forForce)) then
                -- Use only local code (no net traffic) within this block to avoid desyncs.
                ShowInterface(true, interfaceFadeTime)
                EnableUserControl(true)
                EnableOcclusion(true)
                VolumeGroupReset()
                EndThematicMusic()
                CameraResetSmoothingFactorBJ()
                mui.AfterCinematic()        -- our custom addition
                mui.ShowHideCustomUI(true)  -- our custom addition
            end

            -- Perform global changes
            SetMapFlag(MAP_LOCK_SPEED, false)
            SetGameSpeed(bj_cineModePriorSpeed)
            FogMaskEnable(bj_cineModePriorMaskSetting)
            FogEnable(bj_cineModePriorFogSetting)
            EnableWorldFogBoundary(true)
            EnableDawnDusk(bj_cineModePriorDawnDusk)
            SetRandomSeed(bj_cineModeSavedSeed)
        end
    end
end
--
function InitCustomPlayerSlots()
    SetPlayerStartLocation(Player(0), 0)
    ForcePlayerStartLocation(Player(0), 0)
    SetPlayerColor(Player(0), ConvertPlayerColor(0))
    SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    SetPlayerRaceSelectable(Player(0), false)
    SetPlayerController(Player(0), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(1), 1)
    ForcePlayerStartLocation(Player(1), 1)
    SetPlayerColor(Player(1), ConvertPlayerColor(1))
    SetPlayerRacePreference(Player(1), RACE_PREF_ORC)
    SetPlayerRaceSelectable(Player(1), false)
    SetPlayerController(Player(1), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(2), 2)
    ForcePlayerStartLocation(Player(2), 2)
    SetPlayerColor(Player(2), ConvertPlayerColor(2))
    SetPlayerRacePreference(Player(2), RACE_PREF_UNDEAD)
    SetPlayerRaceSelectable(Player(2), false)
    SetPlayerController(Player(2), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(3), 3)
    ForcePlayerStartLocation(Player(3), 3)
    SetPlayerColor(Player(3), ConvertPlayerColor(3))
    SetPlayerRacePreference(Player(3), RACE_PREF_NIGHTELF)
    SetPlayerRaceSelectable(Player(3), false)
    SetPlayerController(Player(3), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(11), 4)
    ForcePlayerStartLocation(Player(11), 4)
    SetPlayerColor(Player(11), ConvertPlayerColor(11))
    SetPlayerRacePreference(Player(11), RACE_PREF_NIGHTELF)
    SetPlayerRaceSelectable(Player(11), false)
    SetPlayerController(Player(11), MAP_CONTROL_COMPUTER)
end

function InitCustomTeams()
    SetPlayerTeam(Player(0), 0)
    SetPlayerTeam(Player(1), 0)
    SetPlayerTeam(Player(2), 0)
    SetPlayerTeam(Player(3), 0)
    SetPlayerAllianceStateAllyBJ(Player(0), Player(1), true)
    SetPlayerAllianceStateAllyBJ(Player(0), Player(2), true)
    SetPlayerAllianceStateAllyBJ(Player(0), Player(3), true)
    SetPlayerAllianceStateAllyBJ(Player(1), Player(0), true)
    SetPlayerAllianceStateAllyBJ(Player(1), Player(2), true)
    SetPlayerAllianceStateAllyBJ(Player(1), Player(3), true)
    SetPlayerAllianceStateAllyBJ(Player(2), Player(0), true)
    SetPlayerAllianceStateAllyBJ(Player(2), Player(1), true)
    SetPlayerAllianceStateAllyBJ(Player(2), Player(3), true)
    SetPlayerAllianceStateAllyBJ(Player(3), Player(0), true)
    SetPlayerAllianceStateAllyBJ(Player(3), Player(1), true)
    SetPlayerAllianceStateAllyBJ(Player(3), Player(2), true)
    SetPlayerAllianceStateVisionBJ(Player(0), Player(1), true)
    SetPlayerAllianceStateVisionBJ(Player(0), Player(2), true)
    SetPlayerAllianceStateVisionBJ(Player(0), Player(3), true)
    SetPlayerAllianceStateVisionBJ(Player(1), Player(0), true)
    SetPlayerAllianceStateVisionBJ(Player(1), Player(2), true)
    SetPlayerAllianceStateVisionBJ(Player(1), Player(3), true)
    SetPlayerAllianceStateVisionBJ(Player(2), Player(0), true)
    SetPlayerAllianceStateVisionBJ(Player(2), Player(1), true)
    SetPlayerAllianceStateVisionBJ(Player(2), Player(3), true)
    SetPlayerAllianceStateVisionBJ(Player(3), Player(0), true)
    SetPlayerAllianceStateVisionBJ(Player(3), Player(1), true)
    SetPlayerAllianceStateVisionBJ(Player(3), Player(2), true)
    SetPlayerTeam(Player(11), 1)
end

function InitAllyPriorities()
    SetStartLocPrioCount(0, 3)
    SetStartLocPrio(0, 0, 1, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(0, 1, 2, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(0, 2, 3, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(1, 3)
    SetStartLocPrio(1, 0, 0, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(1, 1, 2, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(1, 2, 3, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(2, 3)
    SetStartLocPrio(2, 0, 0, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(2, 1, 1, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(2, 2, 3, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(3, 3)
    SetStartLocPrio(3, 0, 0, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(3, 1, 1, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(3, 2, 2, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(4, 3)
    SetStartLocPrio(4, 0, 0, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(4, 1, 2, MAP_LOC_PRIO_HIGH)
end

function InitTrig_demo_init()
    gg_trg_demo_init = CreateTrigger()
    TriggerRegisterTimerEventSingle(gg_trg_demo_init, 0.00)
    TriggerAddAction(gg_trg_demo_init, Trig_demo_init_Actions)
end
function Trig_demo_init_Actions()
--     SetTimeOfDay(12)
    CinematicModeBJ(true, GetPlayersAll())
    TriggerSleepAction(0.66)
    CinematicModeBJ(false, GetPlayersAll())
    bj_forLoopAIndex = 1
    bj_forLoopAIndexEnd = 4
--     while (true) do
--         if (bj_forLoopAIndex > bj_forLoopAIndexEnd) then break end
--         SetPlayerStateBJ(ConvertedPlayer(GetForLoopIndexA()), PLAYER_STATE_RESOURCE_GOLD, 9999)
--         SetPlayerStateBJ(ConvertedPlayer(GetForLoopIndexA()), PLAYER_STATE_RESOURCE_LUMBER, 9999)
--         SetPlayerStateBJ(ConvertedPlayer(GetForLoopIndexA()), PLAYER_STATE_RESOURCE_FOOD_CAP, 100)
--         if (Trig_demo_init_Func007Func004C()) then
--             SetPlayerAllianceStateBJ(ConvertedPlayer(GetForLoopIndexA()), Player(0), bj_ALLIANCE_ALLIED_UNITS)
--         else
--             if (Trig_demo_init_Func007Func004Func001C()) then
--                 SetPlayerAllianceStateBJ(ConvertedPlayer(GetForLoopIndexA()), Player(1), bj_ALLIANCE_ALLIED_UNITS)
--             else
--                 if (Trig_demo_init_Func007Func004Func001Func001C()) then
--                     SetPlayerAllianceStateBJ(ConvertedPlayer(GetForLoopIndexA()), Player(2), bj_ALLIANCE_ALLIED_UNITS)
--                 else
--                     if (Trig_demo_init_Func007Func004Func001Func001Func001C()) then
--                         SetPlayerAllianceStateBJ(ConvertedPlayer(GetForLoopIndexA()), Player(3), bj_ALLIANCE_ALLIED_UNITS)
--                     else
--                     end
--                 end
--             end
--         end
--         bj_forLoopAIndex = bj_forLoopAIndex + 1
--     end
end
function Trig_mui_init_Actions()
        mui.Init()
    TriggerSleepAction(0.00)
        mui.InitUnitSelectedUpdate()
end

function InitTrig_mui_init()
    gg_trg_mui_init = CreateTrigger()
    TriggerAddAction(gg_trg_mui_init, Trig_mui_init_Actions)
end

function InitCustomTriggers()
    InitTrig_demo_init()
    InitTrig_mui_init()
end

function RunInitializationTriggers()
    ConditionalTriggerExecute(gg_trg_mui_init)
end

function main()
    SetCameraBounds(-12288.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -12800.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 12288.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 11776.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -12288.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 11776.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 12288.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -12800.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    NewSoundEnvironment("Default")
    SetAmbientDaySound("LordaeronSummerDay")
    SetAmbientNightSound("LordaeronSummerNight")
    SetMapMusic("Music", true, 0)
    InitBlizzard()
    InitGlobals()
    InitCustomTriggers()
    RunInitializationTriggers()
end

function config()
    SetMapName("TRIGSTR_001")
    SetMapDescription("")
    SetPlayers(5)
    SetTeams(5)
    SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)
    DefineStartLocation(0, 0.0, -512.0)
    DefineStartLocation(1, 0.0, -512.0)
    DefineStartLocation(2, 0.0, -512.0)
    DefineStartLocation(3, 0.0, -512.0)
    DefineStartLocation(4, 0.0, -512.0)
    InitCustomPlayerSlots()
    InitCustomTeams()
    InitAllyPriorities()
end

