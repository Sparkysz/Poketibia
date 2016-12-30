local musicChannel = g_sounds.getChannel(1)



-- Public functions
function init()

   connect(g_game, 'onTextMessage', getParams)
   connect(g_game, { onGameEnd = terminate} )


end





function getParams(mode, text)
if not g_game.isOnline() then return end
if mode == MessageModes.Failure then

if string.sub(text, 1, 5) == "Audio" then
local ad = string.sub(text, 7, #text)
audio = "som/"..ad..""
musicChannel:play(audio)
 

end
end
end

