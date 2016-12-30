-- Local variables
local barWindow = nil
local barPanel = nil
local barButton = nil
local healthBar = nil
local pokeHealthBar = nil
local invButton = nil
local healthTooltip = 'Your character health is %d out of %d.'
local pokeHealthTooltip = 'Your pokemon health is %d out of %d.'
local pbs = {}
local path = '/images/ui/pxg/topMenu_icons/'

local fightModeRadioGroup = nil
local fightOffensiveBox = nil
local fightBalancedBox = nil
local fightDefensiveBox = nil

local InventorySlotStyles = {
  [InventorySlotHead] = "HeadSlot",
  [InventorySlotNeck] = "NeckSlot",
  [InventorySlotBack] = "BackSlot",
  [InventorySlotBody] = "BodySlot",
  [InventorySlotRight] = "RightSlot",
  [InventorySlotLeft] = "LeftSlot",
  [InventorySlotLeg] = "LegSlot",
  [InventorySlotFeet] = "FeetSlot",
  [InventorySlotFinger] = "FingerSlot", 
  [InventorySlotAmmo] = "AmmoSlot"
}
-- End local variables

-- Public functions
function init()
   barWindow = g_ui.loadUI('HealthBar', modules.game_interface.getRightPanel())  
   barWindow:disableResize()
   barPanel = barWindow:getChildById('contentsPanel')
   
   barButton = modules.client_topmenu.addCustomRightButton('barButton', 'Pokemon', path..'pokemon_icon_apagado', toggle, true)
   barButton:setVisible(false)
   
   healthBar = barWindow:recursiveGetChildById("healthBar")
   pokeHealthBar = barWindow:recursiveGetChildById("pokeHealthBar")
   
   invButton = barWindow:recursiveGetChildById("invButton")
   invButton:setVisible(false)
   
   fightOffensiveBox = barWindow:recursiveGetChildById('fightOffensiveBox')
   fightBalancedBox = barWindow:recursiveGetChildById('fightBalancedBox')
   fightDefensiveBox = barWindow:recursiveGetChildById('fightDefensiveBox')
   
   fightModeRadioGroup = UIRadioGroup.create()
   fightModeRadioGroup:addWidget(fightOffensiveBox)
   fightModeRadioGroup:addWidget(fightBalancedBox)
   fightModeRadioGroup:addWidget(fightDefensiveBox)
   
   connect(LocalPlayer, { onInventoryChange = onInventoryChange,
                          onHealthChange = onHealthChange,
                          onManaChange = onManaChange,
                          onStatesChange = onStatesChange})
   connect(g_game, 'onTextMessage', onPokeHealthChange)
   connect(g_game, { onGameStart = refresh,
                     onGameEnd = hide,
                     onFightModeChange = update })
   connect(fightModeRadioGroup, { onSelectionChange = onSetFightMode })
   
   createPbs()
   
   barWindow:setup()
   --barWindow:open()
end

function terminate()
   disconnect(LocalPlayer, { onInventoryChange = onInventoryChange,
                             onHealthChange = onHealthChange,
                             onManaChange = onManaChange,
                             onStatesChange = onStatesChange})
   disconnect(g_game, 'onTextMessage', onPokeHealthChange)
   disconnect(g_game, { onGameStart = refresh,
                     onGameEnd = hide,
                     onFightModeChange = update })
   disconnect(fightModeRadioGroup, { onSelectionChange = onSetFightMode })
   
   fightModeRadioGroup:destroy()
   barPanel:destroy()
   barWindow:destroy()
end

--[[  OnChange  ]]--
function onHealthChange(localPlayer, health, maxHealth)
  healthBar:setText(health .. ' / ' .. maxHealth)
  barWindow:recursiveGetChildById("healthIcon"):setTooltip(tr(healthTooltip, health, maxHealth))
  healthBar:setValue(health, 0, maxHealth)
end

function onPokeHealthChange(mode, text)
if not g_game.isOnline() then return end
   if mode == MessageModes.Failure then 
      if string.find(text, '#ph#,') then
         local t = text:explode(',')
         local hp, maxHp = tonumber(t[2]), tonumber(t[3])
         pokeHealthBar:setText(hp .. ' / ' .. maxHp)
         barWindow:recursiveGetChildById("pokeHealthIcon"):setTooltip(tr(pokeHealthTooltip, hp, maxHp))
         pokeHealthBar:setValue(hp, 0, maxHp)
      end
   end
end 

function onManaChange(localPlayer, mana, maxMana)
  for i = 1, 6 do
      if i > tonumber(mana) then
         pbs[i]:setImageSource('/images/ui/pxg/pb_apagada')
      else
         pbs[i]:setImageSource('/images/ui/pxg/pb_acessa')
      end
  end
end    

function onInventoryChange(player, slot, item, oldItem)
  if slot >= InventorySlotPurse then return end
  local itemWidget = barPanel:getChildById('slot' .. slot)
  if itemWidget then
     if item then
        itemWidget:setStyle(InventorySlotStyles[slot])
        itemWidget:setItem(item)
     else
        itemWidget:setStyle(InventorySlotStyles[slot])
        itemWidget:setItem(nil)
     end
  end
end

function onStatesChange(localPlayer, now, old)
if now == old then return end

  local bitsChanged = bit32.bxor(now, old)
  for i = 1, 32 do
    local pow = math.pow(2, i-1)
    if pow > bitsChanged then break end
    local bitChanged = bit32.band(bitsChanged, pow)
    if bitChanged ~= 0 then
      if bitChanged == 128 then 
         toggleBattle()
      end
    end
  end
end

function onSetFightMode(self, selectedFightButton)
  if selectedFightButton == nil then return end
  local buttonId = selectedFightButton:getId()
  local fightMode
  if buttonId == 'fightOffensiveBox' then
    fightMode = FightOffensive
  elseif buttonId == 'fightBalancedBox' then
    fightMode = FightBalanced
  else
    fightMode = FightDefensive
  end
  g_game.setFightMode(fightMode)
  if g_game.isOnline() then g_game.talk('#f#ightmode '.. fightMode) end
end
--[[  End onChange  ]]--

function toggle()
   if barWindow:isVisible() then
      barButton:setIcon(path..'pokemon_icon_apagado')
      barWindow:close()
   else
      barButton:setIcon(path..'pokemon_icon')
      barWindow:open()
   end
end

function toggleBattle()
   if invButton:isVisible() then
      invButton:setVisible(false)
   else
      invButton:setVisible(true)
   end
end

function refresh()
  if barWindow:isVisible() then
     barButton:setIcon(path..'pokemon_icon')
  end
  online()
  local player = g_game.getLocalPlayer()
  for i=InventorySlotFirst,InventorySlotLast do
    if g_game.isOnline() then
      onInventoryChange(player, i, player:getInventoryItem(i))
    else
      onInventoryChange(player, i, nil)
    end
  end
end

function hide()
   barButton:setVisible(false)
end

function update()
  local fightMode = g_game.getFightMode()
  if fightMode == FightOffensive then
    fightModeRadioGroup:selectWidget(fightOffensiveBox)
  elseif fightMode == FightBalanced then
    fightModeRadioGroup:selectWidget(fightBalancedBox)
  else
    fightModeRadioGroup:selectWidget(fightDefensiveBox)
  end
end

function online()
  local player = g_game.getLocalPlayer()
  if player then
    local char = g_game.getCharacterName()

    local lastCombatControls = g_settings.getNode('LastCombatControls')

    if not table.empty(lastCombatControls) then
      if lastCombatControls[char] then
        g_game.setFightMode(lastCombatControls[char].fightMode)
      end
    end
  end
  if g_game.isOnline() then
     barButton:setVisible(true)
  end
  update()
end

function createPbs()
   for i = 1, 6 do
       pbs[i] = g_ui.createWidget((i == 1 and 'pbButtonIni' or 'pbButton'), barWindow)
       pbs[i]:setId('pb'..i)
   end 
end

function onMiniWindowClose()
end
-- End public functions