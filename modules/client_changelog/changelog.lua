local changelogWindow = nil
local changelogButton = nil

local changes = {
    [1] = {
        patch = "1.0",
        changes = {
            "- Cliente 1.0",
            "- Por fovor relatem os bugs, mandando Private Message para o usuário 'SmiX' do xTibia."
        }    
    },
}

function init()
  changelogWindow = g_ui.displayUI('changelog')
  changelogWindow:hide()

  changelogButton = modules.client_topmenu.addLeftButton('changelogButton', tr('Changelog'), 'changelog', toggle)
  
  changelogWindow:breakAnchors()
  changelogWindow:setPosition({x = 150, y = 150})
  changelogWindow.onEnter = hide
  changelogWindow.onEscape = hide
  
  changelogText = changelogWindow:recursiveGetChildById('text')
  local text = ""
  for i = 1, #changes do
    local tmp = changes[i]
    text = string.format("%s[Patch %s]\n", text, tmp.patch)
    for j = 1, #tmp.changes do
        text = string.format("%s%s\n", text, tmp.changes[j])
    end
    text = string.format("%s\n", text)
  end
  changelogText:setText(text)
  changelogButton:hide()
end

function terminate()
  changelogWindow:destroy()
  changelogButton:destroy()
end

function toggle()
    if changelogWindow:isVisible() then
        changelogWindow:hide()
        changelogButton:setOn(false)
    else
        changelogWindow:show()
        changelogButton:setOn(true)
        changelogWindow:focus()
    end
end

function hide()
    changelogWindow:hide()
    changelogButton:setOn(false)
end