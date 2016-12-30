local window

function init(name)
   window = g_ui.displayUI('tvCam')
   window:setVisible(false) 
   onlineTv(name)
end

function terminate()
   disconnect(g_game, { onGameStart = online,
                       onGameEnd = destroy })

  destroy()
end
function onlineTv(name)
   window:setVisible(true)
   changelogText = window:recursiveGetChildById('textTvCam')
   local choiceList = window:recursiveGetChildById('moduleListTvCam')
   local txt = ""
   local t = string.explode(name, "/")
    for i = 2, #t do
    
    local label = g_ui.createWidget('ModuleListLabelTvCam', choiceList) 
         local txt1 = string.explode(t[i], ",")
         label:setText(txt1[1]) 
         label.onDoubleClick = function() selectLabel(window, txt1[2], txt1[3]) end
         
    end
       
end

function selectLabel(window, name, name2)
   changelogText = window:recursiveGetChildById('textTvCam')
   changelogText:setText(name) 
   
   g_game.talk('@tvCam Follow,'..name2)
end

function initCreateChannel()

   addChannelWindow = g_ui.displayUI('createChannel')
   addChannelWindow:setVisible(true)

end

function termiCreateChannel()

         addChannelWindow:setVisible(false)
  
end

function CreateChannel()

    
    local channelName = addChannelWindow:getChildById('createChannelText1'):getText()
    local channelDescription = addChannelWindow:getChildById('createChannelText2'):getText()
    g_game.talk('@tvCam onAir,' .. channelName .. ',' .. channelDescription)
    
    addChannelWindow:setVisible(false)
    
   connect(g_game, {onGameEnd = termiCreateChannel})
                         
end

function initChannelOnAir()

   ChannelOnAir = g_ui.displayUI('tvCamOnAir')
   ChannelOnAir:setVisible(true)
   ChannelOnAir:setPosition({x = 15, y = 15})
   
   connect(g_game, {onGameEnd = termiChannelOnAir})
   
end

function termiChannelOnAir()
   ChannelOnAir:setVisible(false)
   g_game.talk('@tvCam Close')
end

function destroy()
  if window then
    window:destroy()
    window = nil
  end
end

function assistir()

  g_game.talk('@tvCam Assistir')
  window:setVisible(false)
  
end

function assistirThen()

   assisntindoUI = g_ui.displayUI('tvCamWatch')
   assisntindoUI:setVisible(true)
   
   connect(g_game, {onGameEnd = termiAssistir1})

end

function termiAssistir()


      g_game.talk('@tvCam StopWatch')
      assisntindoUI:setVisible(false)

end

function termiAssistir1()
      assisntindoUI:setVisible(false)
end

local autoLootWin = nil

function autoLootShow(loot)

   autoLootWin = g_ui.displayUI('tvCamWatch1')
   autoLootWin:setVisible(true)
   
  local localesPanel = autoLootWin:getChildById('localesPanel')
        localesPanel:setImageSource('/images/ui/aqui')
  local layout = localesPanel:getLayout()
  local spacing = layout:getCellSpacing()
  local size = layout:getCellSize()
  local sizeWin = 0
  local t = string.explode(loot, ",")
  local count = loot:match("'(.-)'") 
  
 for i = 1, tonumber(count) do 
     if not t[i] then break end 
     
     local name = string.explode(t[i], "!")
     local widget = g_ui.createWidget('LocalesButtom', localesPanel)

           item = name[1]
           setLootImage(autoLootWin, i, item)
           widget:setText(name[2])
           sizeWin = sizeWin + 1
           
 end
 
  autoLootWin:setWidth(size.width * sizeWin)
  localesPanel:setWidth(size.width * sizeWin)
  
  connect(g_game, {onGameEnd = autoLootHide})
end

function getAutoLootWindow()
   return autoLootWin
end

function autoLootHide()
if getAutoLootWindow() ~= nil then
       autoLootWin:setVisible(false)
       autoLootWin = nil
end
end

function setLootImage(windown, orderLoot, id)

     itemLoot = windown:getChildById('itemPreview'..orderLoot)
     itemLoot:setItemId(id)

end