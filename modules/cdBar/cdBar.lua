

--[[Coisas para saber!
local button = optionsWindow:recursiveGetChildById('Button'):setText("Fuu") == muda o nome do botao!
optionsWindow = g_ui.loadUI('bot.otui', modules.game_interface.getRightPanel()) == faz a janela ficar nos cantos!
local player = g_game.getLocalPlayer() == pega o player!
player:getInventoryItem(8):getId() == pega o id do item, id do .spr
]]

cdBar = {}
cdBar.options = {}

-- Private Variables
local optionsWindow_hori
local optionsWindow_vert
local optionsButton
local barra = 'Horizontal.otui'
local nameAtks = ""
local cdAtks = ""

local botoes = {
['Button1'] = {event = nil},
['Button2'] = {event = nil},
['Button3'] = {event = nil},
['Button4'] = {event = nil},
['Button5'] = {event = nil},
['Button6'] = {event = nil},
['Button7'] = {event = nil},
['Button8'] = {event = nil},
['Button9'] = {event = nil},
['Button10'] = {event = nil},
['Button11'] = {event = nil},
['Button12'] = {event = nil},
}

-- Private Functions

-- Public functions
function cdBar.init()
optionsWindow_hori = g_ui.displayUI(barra)
optionsWindow_vert = g_ui.displayUI('Vertical')
optionsWindow_hori:setVisible(false)
optionsWindow_vert:setVisible(false)

------
local pos = {x = 20, y = 20}
optionsWindow_hori:setPosition(pos)
optionsWindow_vert:setPosition(pos)
------
optionsButton = modules.client_topmenu.addLeftToggleButton('cdBarButton', 'cdBar', '/cdBar/cdBar.png', cdBar.changeBar)
--optionsButton:hide()
connect(g_game, { onGameStart = cdBar.online,
onGameEnd = cdBar.hide})
connect(g_game, 'onTextMessage', cdBar.barConfig)

cdBar.options = g_settings.getNode('cdBar') or {}

if g_game.isOnline() then
cdBar.online()
end
end

function cdBar.terminate()
disconnect(g_game, { onGameStart = cdBar.online,
onGameEnd = cdBar.hide})
disconnect(g_game, 'onTextMessage', cdBar.barConfig)

if g_game.isOnline() then
cdBar.offline()
end

optionsWindow_hori:destroy()
optionsWindow_hori = nil
optionsWindow_vert:destroy()
optionsWindow_vert = nil
optionsButton:destroy()
optionsButton = nil

cdBar.cleanEvents()

g_settings.setNode('cdBar', cdBar.options)
end

function cdBar.changeBar()
cdBar.hide()
if barra == 'Horizontal.otui' then
barra = 'Vertical.otui'
cdBar.show()
cdBar.toolTipChange()
g_game.talk('/reloadCDs')
elseif barra == 'Vertical.otui' then
barra = 'Horizontal.otui'
cdBar.show()
cdBar.toolTipChange()
g_game.talk('/reloadCDs')
end
end

function cdBar.barConfig(text)
if not g_game.isOnline() then return end
if string.find(text, '12//,') then
   local t1 = text:explode(",")
   
    if t1[2] == 'hide' then
       cdBar.hide()
    else
       cdBar.show()
    end
    
elseif string.find(text, '12|,') then
       cdBar.atualizarCDs(text)
       
elseif string.find(text, '12&,') then
       cdBar.toolTipChange(text)
end
end


function cdBar.barChange(but, num, lvl)
if not g_game.isOnline() then return end
if not cdBar.getWindow():isVisible() then return end

local player = g_game.getLocalPlayer()

if num and num >= 1 then

local button = cdBar.getWindow():recursiveGetChildById('Button' ..but)
local pathOff = "/cdBar/imagens/"..button:getTooltip().."_off.png"

button:setImageSource(pathOff)
button:setText(num)
button:setColor('#FF0000') --#000080(azul) #006400(verde)

botoes['Button'..but].event = scheduleEvent(function() cdBar.barChange(but, num-1) end, 1000)
else
if botoes['Button' ..but] then

local button = cdBar.getWindow():recursiveGetChildById('Button' ..but)
if button:getTooltip() then

local pathOn = "/cdBar/imagens/"..button:getTooltip().."_on.png"
local pathOff = "/cdBar/imagens/"..button:getTooltip().."_off.png"

if tonumber(lvl) ~= nil and player:getLevel() < lvl then
button:setImageSource(pathOff)
button:setText(lvl)
button:setColor('#FF0000')
else
button:setImageSource(pathOn)
button:setText("")
end

end
end
end
end

function cdBar.atualizarCDs(text)
if not g_game.isOnline() then return end
if not cdBar.getWindow():isVisible() then return end

local t = text:explode(",")
table.remove(t, 1)

local table = {}
  for j = 1, 12 do
    local t2 = t[j]:explode("|")
          table[j] = {t2[1], t2[2]}
   end

for i = 1, #table do
cdBar.barChange(i, tonumber(table[i][1]), tonumber(table[i][2]))
end
end

function cdBar.toolTipChange(text)
if barra == "Horizontal.otui" then
cdBar.getWindow():setHeight(460)
cdBar.getWindow():setWidth(65)
else
cdBar.getWindow():setWidth(480)
cdBar.getWindow():setHeight(80)
end
if not text then
text = nameAtks
else
nameAtks = text
end

local t2 = text:explode(",")
local count = 0
for i = 2, 13 do
if t2[i] == 'n/n' then
button = cdBar.getWindow():recursiveGetChildById('Button' ..(i-1)):hide()
count = count+1
else
button = cdBar.getWindow():recursiveGetChildById('Button' ..(i-1)):show()
button = cdBar.getWindow():recursiveGetChildById('Button' ..(i-1)):setTooltip(t2[i])
end
end
if count > 0 and count ~= 12 then
if barra == "Horizontal.otui" then
cdBar.getWindow():setHeight(490 - (count*38))
else
cdBar.getWindow():setWidth(480 - (count*38))
end
elseif count == 12 then
cdBar.getWindow():setHeight(40)
cdBar.getWindow():setWidth(50)
end
end

function cdBar.cleanEvents(button)
if button then
if botoes[button] then
if botoes[button].event ~= nil then
removeEvent(botoes[button].event)
botoes[button].event = nil
end
end
else
for i = 1, 12 do
removeEvent(botoes['Button'..i].event)
botoes['Button'..i].event = nil
end
end
end

function cdBar.getWindow()
if barra == 'Vertical.otui' then
return optionsWindow_vert
else
return optionsWindow_hori
end
end

function cdBar.toggle()
if cdBar.getWindow():isVisible() then
cdBar.changeBar()
end
end

function toggle()
if optionsButton:isOn() then
optionsWindow_hori:hide()
optionsButton:setOn(false)
else
optionsWindow_hori:show()
optionsButton:setOn(true)
end
end

function cdBar.show()
if g_game.isOnline() then
cdBar.getWindow():show()
end
end

function cdBar.hide()
scheduleEvent(cdBar.cleanEvents(), 100)
cdBar.getWindow():hide()
end

function cdBar.online()
if not g_game.isOnline() then
cdBar.hide()
end
end

function cdBar.offline()
if not g_game.isOnline() then
cdBar.hide()
end
end