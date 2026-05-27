-- vanguard.lua
local BaseUrl = "https://raw.githubusercontent.com/lox056594-dev/vanguard-scripts/main/"

-- Загружаем модули (имитация require через loadstring)
local function loadModule(name)
    return loadstring(game:HttpGet(BaseUrl .. name .. ".lua"))()
end

-- В обычном скрипте модули не "видят" друг друга через require, 
-- поэтому лучше для загрузки использовать один файл-обертку, 
-- либо объединить всё в один vanguard.lua.
