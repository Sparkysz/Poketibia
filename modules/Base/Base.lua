local window

function init()
   window = g_ui.displayUI('Base')
   window:destroy()
end
function init2(name, text, habilities, move1, move2, move3, move4, move5, move6, move7, move8, move9, move10, move11, move12, evo, pokes)
   window = g_ui.displayUI('Base', modules.game_interface.getRootPanel())
   window:setVisible(false)
   online2(name, text, habilities, move1, move2, move3, move4, move5, move6, move7, move8, move9, move10, move11, move12, evo, pokes)
   connect(g_game, {
                    onGameEnd = destroy })
end

function init4(names, text, habilities, move1, move2, move3, move4, move5, move6, move7, move8, move9, move10, move11, move12, evo, pokes)
   window = g_ui.displayUI('Base', modules.game_interface.getRootPanel())
   window:setVisible(false)
   online3(names, text, habilities, move1, move2, move3, move4, move5, move6, move7, move8, move9, move10, move11, move12, evo, pokes)
   connect(g_game, {
                    onGameEnd = destroy })
end

function init3(pokes)
   window = g_ui.displayUI('Base')
   window:hide()
   
   connect(g_game, {
                    onGameEnd = destroy })
  online(pokes)
end

function terminate()
   disconnect(g_game, {
                       onGameEnd = destroy })

  destroy()
end

local pokemons = {"Bulbasaur", "Ivysaur", "Venusaur", "Charmander", "Charmeleon", "Charizard", "Squirtle", "Wartortle", "Blastoise", "Caterpie",
"Metapod", "Butterfree", "Weedle", "Kakuna", "Beedrill", "Pidgey", "Pidgeotto", "Pidgeot", "Rattata", "Raticate", "Spearow",
"Fearow", "Ekans", "Arbok", "Pikachu", "Raichu", "Sandshrew", "Sandslash", "Nidoran Female", "Nidorina", "Nidoqueen",
"Nidoran Male", "Nidorino", "Nidoking", "Clefairy", "Clefable", "Vulpix", "Ninetales", "Jigglypuff", "Wigglytuff", "Zubat", "Golbat",
"Oddish", "Gloom", "Vileplume", "Paras", "Parasect", "Venonat", "Venomoth", "Diglett", "Dugtrio", "Meowth", "Persian",
"Psyduck", "Golduck", "Mankey", "Primeape", "Growlithe", "Arcanine", "Poliwag", "Poliwhirl", "Poliwrath", "Abra", "Kadabra", "Alakazam", "Machop", "Machoke", "Machamp", "Bellsprout", "Weepinbell",
"Victreebel", "Tentacool", "Tentacruel", "Geodude", "Graveler", "Golem", "Ponyta", "Rapidash", "Slowpoke", "Slowbro",
"Magnemite", "Magneton", "Farfetchd", "Doduo", "Dodrio", "Seel", "Dewgong", "Grimer", "Muk", "Shellder", "Cloyster", "Gastly", "Haunter", "Gengar", "Onix",
"Drowzee", "Hypno", "Krabby", "Kingler", "Voltorb", "Electrode", "Exeggcute", "Exeggutor", "Cubone", "Marowak", "Hitmonlee",
"Hitmonchan", "Lickitung", "Koffing", "Weezing", "Rhyhorn", "Rhydon", "Chansey", "Tangela", "Kangaskhan", "Horsea", "Seadra", "Goldeen",
"Seaking", "Staryu", "Starmie", "MrMime", "Scyther", "Jynx", "Electabuzz", "Magmar", "Pinsir", "Tauros", "Magikarp",
"Gyarados", "Lapras", "Ditto", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Porygon", "Omanyte", "Omastar", "Kabuto",
"Kabutops", "Aerodactyl", "Snorlax", "Articuno", "Zapdos", "Moltres", "Dratini", "Dragonair", "Dragonite", "Mewtwo", "Mew",
"Aipom", "Ampharos", "Ariados", "Bayleef", "Bellossom", "Bellossom", "Blissey", "Celebi", "Chikorita", "Chinchou", "Cleffa",
"Corsola", "Crobat", "Croconaw", "Cyndaquil", "Delibird", "Donphan", "Dunsparce", "Dunsparce", "Elekid", "Entei", "Espeon",
"Feraligatr", "Flaaffy", "Forretress", "Furret", "Gallade", "Girafarig", "Gligar", "Granbull", "Heracross", "Hitmontop",
"Ho oh", "Hoothoot", "Hoppip", "Houndoom", "Houndor", "Igglybuff", "Jumpluff", "Kingdra", "Lanturn", "Larvitar", "Ledian",
"Ledyba", "Lugia", "Magby", "Magcarbo", "Mantine", "Mareep", "Marill", "Meganium", "Miltank", "Misdreavus", "Murkrow",
"Natu", "Noctowl", "Octillery", "Phanpy", "Pichu", "Piloswine", "Pineco", "Politoed", "Porygon2", "Pupitar", "Quaqsire",
"Quilava", "Qwilfish", "Raikou", "Remoraid", "Scizor", "Shuckle", "Skarmory", "Skiploom", "Slowking", "Slugma", "Smeargle",
"Smoochum", "Sneasel", "Sentret", "Snubbull", "Spinarak", "Stantler", "Steelix", "Sudowoodo", "Suicune", "Sunflora",
"Sunkern", "Swinub", "Teddiursa", "Togepi", "Togetic", "Totodile", "Typhlosion", "Tyranitar", "Tyrogue", "Umbreon", "Unown a",
"Ursaring", "Wobbuffet", "Wooper", "Xatu", "Yanma"}


function online(pokes)
   window:setVisible(true)
   
   local choiceList = window:recursiveGetChildById('moduleList')
   for id, name in ipairs(pokemons) do
       local label = g_ui.createWidget('ModuleListLabel', choiceList) 
       
       if id < 10 then
         number = "#00"..id 
       elseif id > 9 and id < 100 then
         number = "#0"..id 
       else
         number = "#"..id 
       end
       
       local t = string.explode(pokes, "/")
       
         if string.find(t[id+2], 'none') then
            label:setText(number.." - ??????")
         else
            label:setText(number.." - "..name)
            label.onDoubleClick = function() DoubleClick(window, name) end
         end
       
                                  
   end
   
   connect(g_game, {onGameEnd = destroy})
end

function online2(names, text, habilities, move1, move2, move3, move4, move5, move6, move7, move8, move9, move10, move11, move12, evo, pokes) -- Chama a pokedex por pokemon
   window:setVisible(true)
   
   local choiceList = window:recursiveGetChildById('moduleList')
   for id, name in ipairs(pokemons) do
       local label = g_ui.createWidget('ModuleListLabel', choiceList)

       if id < 10 then
         number = "#00"..id 
       elseif id > 9 and id < 100 then
         number = "#0"..id 
       else
         number = "#"..id 
       end
       
       local t = string.explode(pokes, ",")
       
         if string.find(t[id+1], 'none') then
            label:setText(number.." - ??????")
         else
            label:setText(number.." - "..name)
            label.onDoubleClick = function() DoubleClick(window, name) end
         end
       
       
       if name == names then
          doShowPokedex(window, names, text, habilities, move1, move2, move3, move4, move5, move6, move7, move8, move9, move10, move11, move12, evo)
          label:setOn(true)
       end
                                  
   end
   
  connect(g_game, {onGameEnd = destroy})
end

function online3(names, text, habilities, move1, move2, move3, move4, move5, move6, move7, move8, move9, move10, move11, move12, evo, pokes) -- Chama a pokedex por pokemon
   window:setVisible(true)
   
   local choiceList = window:recursiveGetChildById('moduleList')
   for id, name in ipairs(pokemons) do
       local label = g_ui.createWidget('ModuleListLabel', choiceList)
       if id < 10 then
         number = "#00"..id 
       elseif id > 9 and id < 100 then
         number = "#0"..id 
       else
         number = "#"..id 
       end
       local t = string.explode(pokes, ",")
       
         if string.find(t[id+1], 'none') then
            label:setText(number.." - ??????")
         else
            label:setText(number.." - "..name)
            label.onDoubleClick = function() DoubleClick(window, name) end
         end
       
       
       if name == names then
          doShowPokedex(window, names, text, habilities, move1, move2, move3, move4, move5, move6, move7, move8, move9, move10, move11, move12, evo)
          label:setOn(true)
       end
                                  
   end
   connect(g_game, {onGameEnd = destroy})
end


function DoubleClick(window, name)
        terminate()
        g_game.talk("@pokedex "..name) 
end

function doShowPokedex(window, name, info, habilities, move1, move2, move3, move4, move5, move6, move7, move8, move9, move10, move11, move12, evo)
   local addImage = window:recursiveGetChildById('image')
         addImage:setImageSource('/images/pokeDesigners/'..name) 
         changelogText = window:recursiveGetChildById('text')
  local infos = string.explode(info, "/") 
  local txt = ""
  for i = 1, #pokemons do
      if name == pokemons[i] then
         txt = txt.."  • Nome: "..name.."\n".."  • Level: "..infos[1].."\n".."  • Habilidades Especiais: "..habilities.."\n"
         local table = {move1, move2, move3, move4, move5, move6, move7, move8, move9, move10, move11, move12}
         local enter = true
          txt = txt.."  • Movimentos:"
          for o = 1, #table do 
              if string.find(table[o], 'Fasio') then table[o] = "" enter = false end
                 txt = txt..(enter and "\n     " or "")..table[o]
          end
          txt = txt.."\n  • Evoluções: "..evo
      end
  end
  changelogText:setText(txt) 
  connect(g_game, {onGameEnd = destroy})
end

function hideWidonw()
   window:setVisible(false)
end

function destroy()
  if window then
    window:destroy()
    window = nil
  end
end