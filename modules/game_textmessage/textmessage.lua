MessageSettings = {
  none            = {},
  consoleRed      = { color = TextColors.red,    consoleTab='Default' },
  consoleOrange   = { color = TextColors.orange, consoleTab='Default' },
  consoleBlue     = { color = TextColors.blue,   consoleTab='Default' },
  centerRed       = { color = TextColors.red,    consoleTab='Server Log', screenTarget='lowCenterLabel' },
  centerGreen     = { color = TextColors.green,  consoleTab='Server Log', screenTarget='highCenterLabel',   consoleOption='showInfoMessagesInConsole' },
  centerWhite     = { color = TextColors.white,  consoleTab='Server Log', screenTarget='middleCenterLabel', consoleOption='showEventMessagesInConsole' },
  bottomWhite     = { color = TextColors.white,  consoleTab='Server Log', screenTarget='statusLabel',       consoleOption='showEventMessagesInConsole' },
  status          = { color = TextColors.white,  consoleTab='Server Log', screenTarget='statusLabel',       consoleOption='showStatusMessagesInConsole' },
  statusSmall     = { color = TextColors.white,                           screenTarget='statusLabel' },
  private         = { color = TextColors.lightblue,                       screenTarget='privateLabel' }
}

MessageTypes = {
  [MessageModes.MonsterSay] = MessageSettings.consoleOrange,
  [MessageModes.MonsterYell] = MessageSettings.consoleOrange,
  [MessageModes.BarkLow] = MessageSettings.consoleOrange,
  [MessageModes.BarkLoud] = MessageSettings.consoleOrange,
  [MessageModes.Failure] = MessageSettings.statusSmall,
  [MessageModes.Login] = MessageSettings.bottomWhite,
  [MessageModes.Game] = MessageSettings.centerWhite,
  [MessageModes.Status] = MessageSettings.status,
  [MessageModes.Warning] = MessageSettings.centerRed,
  [MessageModes.Look] = MessageSettings.centerGreen,
  [MessageModes.Loot] = MessageSettings.centerGreen,
  [MessageModes.Red] = MessageSettings.consoleRed,
  [MessageModes.Blue] = MessageSettings.consoleBlue,
  [MessageModes.PrivateFrom] = MessageSettings.consoleBlue,

  [MessageModes.DamageDealed] = MessageSettings.status,
  [MessageModes.DamageReceived] = MessageSettings.status,
  [MessageModes.Heal] = MessageSettings.status,
  [MessageModes.Exp] = MessageSettings.status,

  [MessageModes.DamageOthers] = MessageSettings.none,
  [MessageModes.HealOthers] = MessageSettings.none,
  [MessageModes.ExpOthers] = MessageSettings.none,

  [MessageModes.TradeNpc] = MessageSettings.centerWhite,
  [MessageModes.Guild] = MessageSettings.centerWhite,
  [MessageModes.PartyManagement] = MessageSettings.centerWhite,
  [MessageModes.TutorialHint] = MessageSettings.centerWhite,
  [MessageModes.Market] = MessageSettings.centerWhite,
  [MessageModes.BeyondLast] = MessageSettings.centerWhite,
  [MessageModes.Report] = MessageSettings.consoleRed,
  [MessageModes.HotkeyUse] = MessageSettings.centerGreen,

  [254] = MessageSettings.private
}

messagesPanel = nil

function init()
  connect(g_game, 'onTextMessage', displayMessage)
  connect(g_game, 'onGameEnd', clearMessages)
  messagesPanel = g_ui.loadUI('textmessage', modules.game_interface.getRootPanel())
end

function terminate()
  disconnect(g_game, 'onTextMessage', displayMessage)
  disconnect(g_game, 'onGameEnd',clearMessages)
  clearMessages()
  messagesPanel:destroy()
end

function calculateVisibleTime(text)
  return math.max(#text * 100, 4000)
end

function displayMessage(mode, text)
  if not g_game.isOnline() then return end

  local msgtype = MessageTypes[mode]

  if not msgtype then
    perror('unhandled onTextMessage message mode ' .. mode .. ': ' .. text)
    return
  end

  if msgtype == MessageSettings.none then return end

  if msgtype.consoleTab ~= nil and (msgtype.consoleOption == nil or modules.client_options.getOption(msgtype.consoleOption)) then
    modules.game_console.addText(text, msgtype, tr(msgtype.consoleTab))
    --TODO move to game_console
  end

  if msgtype.screenTarget then
    if string.find(text, '#getSto#') or string.find(text, '#getBadges#') or string.find(text, 'p#,') or string.find(text, '#ph#,') then
    return     --alterado!
    end 
    if string.find(text, '@pokedex') and not string.find(text, 'MySelf') then
       local t = string.explode(text, "/")
          modules.Base.init2(t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12], t[13], t[14], t[15], t[16], t[17], text)
                          --t[2] = nome
                          --t[3] = level
                          --t[4] = specialhabilities(ride, fly)
                          --t[5]/t[16] = moves
                          --t[17] = evoluções
          --doShowPokedex()
          return
    elseif string.find(text, 'MySelf') and string.find(text, '@pokedex') then 
            modules.Base.init3(text)
         return
    elseif string.find(text, '@dex') then 
    local t = string.explode(text, "/")
            modules.Base.init4(t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12], t[13], t[14], t[15], t[16], t[17], text)
         return
    elseif string.find(text, '@shop Done') then
           modules.Shop.hide()
           modules.Shop.showMiniWindowDone()   
           return
           
    elseif string.find(text, "@shop Can'tDone") then
           modules.Shop.hide()
           modules.Shop.showMiniWindow()   
           return 
    elseif string.find(text, "@tvCam Channels") then
           modules.tvCam.init(text)
           return 
    elseif string.find(text, "@tvCam Create") then
           modules.tvCam.initCreateChannel()
           return
    elseif string.find(text, "@tvCamOnAir") then
           modules.tvCam.initChannelOnAir()
           return
    elseif string.find(text, "@tvCamcloseAssistir") then 
           modules.tvCam.termiAssistir1()
           return
    elseif string.find(text, "@tvCamAssistirThen") then
           modules.tvCam.assistirThen()
           return 
    elseif string.find(text, "@autoLoot") then 
    local t = string.explode(text, "/")
           modules.tvCam.autoLootHide()
           modules.tvCam.autoLootShow(t[2], count)
           return
    elseif string.find(text, "@autolootClose") then 
           modules.tvCam.autoLootHide()       
           return   
    elseif string.find(text, '12//,') then
           modules.cdBar.cdBar.barConfig(text) 
           return 
    elseif string.find(text, '12|,') then
           modules.cdBar.cdBar.atualizarCDs(text) 
           return   
    elseif string.find(text, '12&,') then
           modules.cdBar.cdBar.toolTipChange(text)
           return
    end  
    
    local label = messagesPanel:recursiveGetChildById(msgtype.screenTarget)
    label:setText(text)
    label:setColor(msgtype.color)
    label:setVisible(true)
    removeEvent(label.hideEvent)
    label.hideEvent = scheduleEvent(function() label:setVisible(false) end, calculateVisibleTime(text))
  end
end

function displayPrivateMessage(text)
  displayMessage(254, text)
end

function displayStatusMessage(text)
  displayMessage(MessageModes.Status, text)
end

function displayFailureMessage(text)
  displayMessage(MessageModes.Failure, text)
end

function displayGameMessage(text)
  displayMessage(MessageModes.Game, text)
end

function displayBroadcastMessage(text)
  displayMessage(MessageModes.Warning, text)
end

function clearMessages()
  for _i,child in pairs(messagesPanel:recursiveGetChildren()) do
    if child:getId():match('Label') then
      child:hide()
      removeEvent(child.hideEvent)
    end
  end
end

function LocalPlayer:onAutoWalkFail(player)
  modules.game_textmessage.displayFailureMessage(tr('There is no way.'))
end

function doShowPokedex()
   modules.Base.init()
end