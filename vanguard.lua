if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE = "https://raw.githubusercontent.com/lox056594-dev/vanguard-scripts/main/"

local function loadFile(name)
    local src, err = game:HttpGet(BASE .. name .. ".lua", true)
    if not src then
        warn("[Vanguard] HttpGet failed for " .. name .. ": " .. tostring(err))
        return nil
    end

    local fn, parseErr = loadstring(src)
    if not fn then
        warn("[Vanguard] loadstring failed for " .. name .. ": " .. tostring(parseErr))
        return nil
    end

    local ok, result = pcall(fn)
    if not ok then
        warn("[Vanguard] runtime failed for " .. name .. ": " .. tostring(result))
        return nil
    end

    return result
end

loadFile("Main")
