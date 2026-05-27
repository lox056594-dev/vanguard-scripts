local BASE = "https://raw.githubusercontent.com/lox056594-dev/vanguard-scripts/main/"

local function loadFile(name)
    local ok, res = pcall(function()
        return loadstring(game:HttpGet(BASE .. name .. ".lua", true))()
    end)
    if not ok then
        warn("[Vanguard] Failed to load " .. name .. ": " .. tostring(res))
    end
    return res
end

loadFile("Main")
