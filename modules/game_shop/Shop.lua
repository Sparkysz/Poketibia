local defaultOptions = {
}

local optionsWindow
local optionsButton
local optionsTabBar
local options = {}

function init()
  for k,v in pairs(defaultOptions) do
    g_settings.setDefault(k, v)
    options[k] = v
  end

  optionsWindow = g_ui.displayUI('options')
  optionsWindow:hide()

  optionsTabBar = optionsWindow:getChildById('optionsTabBar')
  optionsTabBar:setContentWidget(optionsWindow:getChildById('optionsTabContent'))

  marketPanel = g_ui.loadUI('market')
  optionsTabBar:addTab(tr(''), marketPanel, '/images/ui/shop/2')

  outfitsPanel = g_ui.loadUI('outfits')
  optionsTabBar:addTab(tr(''), outfitsPanel, '/images/ui/shop/4')

  addonsPanel = g_ui.loadUI('addons')
  optionsTabBar:addTab(tr(''), addonsPanel, '/images/ui/shop/6')

  clansPanel = g_ui.loadUI('clans')
  optionsTabBar:addTab(tr(''), clansPanel, '/images/ui/shop/8')

  donatePanel = g_ui.loadUI('donate')
  optionsTabBar:addTab(tr(''), donatePanel, '/images/ui/shop/9')

  ShopButton = modules.client_topmenu.addRightGameToggleButton('Shop', tr('Diamond Shop'), '/game_shop/img/Shop', toggle, true)
  ShopButton:setOn(true)
  
  local widget = g_ui.createWidget('LocalesButtons', optionsWindow)
  widget:setImageSource('/game_shop/img/shop_logo')

  addEvent(function() setup() end)
end

function terminate()
  g_keyboard.unbindKeyDown('Ctrl+Shift+F')
  g_keyboard.unbindKeyDown('Ctrl+N')
  optionsWindow:destroy()
  optionsButton:destroy()
  audioButton:destroy()
end

function setup()
  setupGraphicsEngines()

  for k,v in pairs(defaultOptions) do
    if type(v) == 'boolean' then
      setOption(k, g_settings.getBoolean(k), true)
    elseif type(v) == 'number' then
      setOption(k, g_settings.getNumber(k), true)
    end
  end
end

function toggle()
  if optionsWindow:isVisible() then
    hide()
  else
    show()
  end
end

function show()
  optionsWindow:show()
  optionsWindow:raise()
  optionsWindow:focus()
end

function hide()
  optionsWindow:hide()
end

function toggleOption(key)
  setOption(key, not getOption(key))
end

function setOption(key, value, force)
  if not force and options[key] == value then return end

  g_settings.set(key, value)
  options[key] = value
end

function getOption(key)
  return options[key]
end

function showMiniWindow()
  miniWindow = g_ui.displayUI('miniWindow')
  miniWindow:setVisible(true)
end

function hideMiniWindow()
  miniWindow:setVisible(false)
end

function showMiniWindowDone()
  miniWindow = g_ui.displayUI('miniWindowDone')
  miniWindow:setVisible(true)
end

function hideMiniWindowDone()
  miniWindow:setVisible(false)
end