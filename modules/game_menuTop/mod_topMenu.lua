-- Local variables
local duelIcon = nil
local bagIcon = nil
local fishingIcon = nil
local pokedexIcon = nil
local ropeIcon = nil

local path = '/images/ui/pxg/topMenu_icons/'
local currentSlot = 0
-- End local variables

-- Public functions
function init()  
   bagIcon = modules.client_topmenu.addCustomRightButton('bag_icon', 'Bag', path..'bag_icon_apagado', toggleBagIcon, true)
   bagIcon:setOn(false)
   bagIcon:setVisible(false)
   
   fishingIcon = modules.client_topmenu.addCustomRightButton('fishingIcon', 'Fishing', path..'fishing_icon', toggleFishingIcon, true)
   fishingIcon:setVisible(false)                              
   
   pokedexIcon = modules.client_topmenu.addCustomRightButton('pokedexIcon', 'Pokedex', path..'pokedex_icon', togglePokedexIcon, true)
   pokedexIcon:setVisible(false)  
   
   duelIcon = modules.client_topmenu.addCustomRightButton('duelIcon', 'Duel Icon', path..'duel icon', toggleDuelIcon, true)
   duelIcon:setVisible(false)
   
   ropeIcon = modules.client_topmenu.addCustomRightButton('ropeIcon', 'Rope', path..'rope_icon', toggleRopeIcon, true)
   ropeIcon:setVisible(false)

   connect(g_game, { onGameStart = online,
                     onGameEnd = offline })
end

function terminate()
   bagIcon:destroy()
   fishingIcon:destroy()
   pokedexIcon:destroy()
   duelIcon:destroy()
   ropeIcon:destroy()
end

function offline()
   bagIcon:setIcon(path..'bag_icon_apagado')
   bagIcon:setOn(false)
   bagIcon:setVisible(false)
   fishingIcon:setVisible(false)
   pokedexIcon:setVisible(false)
   duelIcon:setVisible(false)
   ropeIcon:setVisible(false)
end       


function online()
   bagIcon:setVisible(true)
   fishingIcon:setVisible(true)
   pokedexIcon:setVisible(true)
   ropeIcon:setVisible(true)
   duelIcon:setVisible(true)
end

-- Complex functions
function startChooseItem(releaseCallback)
  if not releaseCallback then
    error("No mouse release callback parameter set.")
  end
  local mouseGrabberWidget = g_ui.createWidget('UIWidget')
  mouseGrabberWidget:setVisible(false)
  mouseGrabberWidget:setFocusable(false)

  connect(mouseGrabberWidget, { onMouseRelease = releaseCallback })
  
  mouseGrabberWidget:grabMouse()
  g_mouse.pushCursor('target')
end

function onClickWithMouse(self, mousePosition, mouseButton)
  local item = nil
  if mouseButton == MouseLeftButton then
    local clickedWidget = modules.game_interface.getRootPanel():recursiveGetChildByPos(mousePosition, false)
    if clickedWidget then
      if clickedWidget:getClassName() == 'UIMap' then
        local tile = clickedWidget:getTile(mousePosition)
        if tile then
          if currentSlot == 1 then
             item = tile:getGround()
          else
              local thing = tile:getTopMoveThing()
              if thing and thing:isItem() then
                 item = thing
              else
                 item = tile:getTopCreature()
              end
          end
        elseif clickedWidget:getClassName() == 'UIItem' and not clickedWidget:isVirtual() then
           item = clickedWidget:getItem()
        end
      end
    end
  end
    if item then
       if currentSlot == 4 and not item:isPlayer() then
          modules.game_textmessage.displayFailureMessage('Use it only in players!')
       else   
          local player = g_game.getLocalPlayer()               --2  --6 pokedex
          g_game.useInventoryItemWith(player:getInventoryItem(currentSlot):getId(), item) 
       end
    end
  g_mouse.popCursor()
  self:ungrabMouse()
  self:destroy()
end

-- Toggles functions
function toggleRopeIcon()
   currentSlot = 1
   startChooseItem(onClickWithMouse)
end

function toggleBagIcon()            
   if bagIcon:isOn() then
      bagIcon:setOn(false)
      bagIcon:setIcon(path..'bag_icon_apagado')
   else
      bagIcon:setOn(true)
      bagIcon:setIcon(path..'bag_icon')
   end
   local player = g_game.getLocalPlayer() 
   g_game.useInventoryItem(player:getInventoryItem(3):getId())
end

function toggleFishingIcon()
   currentSlot = 2
   startChooseItem(onClickWithMouse)
end

function togglePokedexIcon()
   currentSlot = 6
   startChooseItem(onClickWithMouse)
end

function toggleDuelIcon()
  currentSlot = 4
  startChooseItem(onClickWithMouse)
end
-- End public functions