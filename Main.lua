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

local Themes = loadFile("Themes")
local UI = loadFile("UI")
local Functions = loadFile("Functions")

if not Themes or not UI or not Functions then
    warn("[Vanguard] failed to load modules")
    return
end

--====================================================
-- SERVICES
--====================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--====================================================
-- STATE / DEFAULTS
--====================================================
local State = Functions.NewState()
local Defaults = Functions.NewDefaults(Camera, Lighting)

--====================================================
-- WINDOW
--====================================================
local Window = UI.CreateWindow(Themes, { Name = "VanguardUI" })
Window:SetOpen(false)

--====================================================
-- BLUR
--====================================================
local blur = Lighting:FindFirstChild("VanguardMenuBlur")
if not blur then
    blur = Instance.new("BlurEffect")
    blur.Name = "VanguardMenuBlur"
    blur.Parent = Lighting
end
blur.Size = 0

--====================================================
-- EFFECTS FOLDER / POST EFFECTS
--====================================================
local effectsFolder = Lighting:FindFirstChild("VanguardEffects")
if not effectsFolder then
    effectsFolder = Instance.new("Folder")
    effectsFolder.Name = "VanguardEffects"
    effectsFolder.Parent = Lighting
end

local function getOrCreateEffect(className, name)
    local obj = effectsFolder:FindFirstChild(name)
    if not obj then
        obj = Instance.new(className)
        obj.Name = name
        obj.Parent = effectsFolder
    end
    return obj
end

local Effects = {
    Bloom = getOrCreateEffect("BloomEffect", "Bloom"),
    SunRays = getOrCreateEffect("SunRaysEffect", "SunRays"),
    ColorCorrection = getOrCreateEffect("ColorCorrectionEffect", "ColorCorrection"),
    DOF = getOrCreateEffect("DepthOfFieldEffect", "DepthOfField"),
}

local Vignette = Window.ScreenGui:FindFirstChild("VanguardVignette")
if not Vignette then
    Vignette = Instance.new("ImageLabel")
    Vignette.Name = "VanguardVignette"
    Vignette.Parent = Window.ScreenGui
    Vignette.BackgroundTransparency = 1
    Vignette.Size = UDim2.fromScale(1, 1)
    Vignette.Image = "rbxassetid://4576475446"
    Vignette.ImageColor3 = Color3.new(0, 0, 0)
    Vignette.ImageTransparency = 1
    Vignette.ZIndex = 9998
end
Effects.Vignette = Vignette

--====================================================
-- STAR BACKGROUND
--====================================================
local starLayer

local function rebuildStars()
    local backdrop = Window.Backdrop
    if not backdrop then return end

    if starLayer then
        starLayer:Destroy()
        starLayer = nil
    end

    starLayer = Instance.new("Frame")
    starLayer.Name = "StarLayer"
    starLayer.Parent = backdrop
    starLayer.Size = UDim2.fromScale(1, 1)
    starLayer.BackgroundTransparency = 1
    starLayer.BorderSizePixel = 0
    starLayer.ZIndex = 2

    local count = math.clamp(State.StarCount or 100, 20, 220)

    for i = 1, count do
        local star = Instance.new("ImageLabel")
        star.Parent = starLayer
        star.BackgroundTransparency = 1
        star.Image = "rbxassetid://6031097222"
        star.ImageColor3 = Color3.new(1, 1, 1)
        star.ImageTransparency = math.random(35, 80) / 100
        star.Size = UDim2.new(0, math.random(2, 8), 0, math.random(2, 8))
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.ZIndex = 3

        task.spawn(function()
            while star.Parent do
                task.wait(math.random(10, 25) / 10)
                if not star.Parent then break end
                TweenService:Create(
                    star,
                    TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    { ImageTransparency = math.random(20, 60) / 100 }
                ):Play()
            end
        end)
    end
end

rebuildStars()

--====================================================
-- NOTIFY
--====================================================
local function Notify(title, msg, col, dur)
    if not State.Notifications then return end
    local holder = Window.NotifHolder
    if not holder then return end

    local notifId = (holder:GetAttribute("notifId") or 0) + 1
    holder:SetAttribute("notifId", notifId)

    col = col or Themes.Accent
    dur = dur or 3

    local card = Instance.new("Frame")
    card.Parent = holder
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = Themes.Card
    card.BorderSizePixel = 0
    card.LayoutOrder = notifId
    card.ClipsDescendants = true
    card.ZIndex = 1001
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = col
    stroke.Thickness = 1.2
    stroke.Transparency = 0.35

    local scale = Instance.new("UIScale", card)
    scale.Scale = 0.96

    local t = Instance.new("TextLabel", card)
    t.BackgroundTransparency = 1
    t.Position = UDim2.new(0, 14, 0, 8)
    t.Size = UDim2.new(1, -28, 0, 18)
    t.Text = title
    t.TextColor3 = Themes.Text
    t.Font = Enum.Font.GothamBold
    t.TextSize = 13
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.ZIndex = 1002

    local m = Instance.new("TextLabel", card)
    m.BackgroundTransparency = 1
    m.Position = UDim2.new(0, 14, 0, 28)
    m.Size = UDim2.new(1, -28, 0, 16)
    m.Text = msg
    m.TextColor3 = Themes.Dim
    m.Font = Enum.Font.Gotham
    m.TextSize = 11
    m.TextXAlignment = Enum.TextXAlignment.Left
    m.ZIndex = 1002

    local bar = Instance.new("Frame", card)
    bar.BorderSizePixel = 0
    bar.BackgroundColor3 = col
    bar.Size = UDim2.new(1, 0, 0, 2)
    bar.Position = UDim2.new(0, 0, 1, -2)
    bar.ZIndex = 1002

    TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Scale = 1}):Play()
    TweenService:Create(bar, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()

    task.delay(dur, function()
        if card.Parent then
            TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Scale = 0.95}):Play()
            TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundTransparency = 1}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Transparency = 1}):Play()
            task.delay(0.22, function()
                pcall(function() card:Destroy() end)
            end)
        end
    end)
end

--====================================================
-- WRAP OPEN / CLOSE
--====================================================
local function setMenu(open)
    Window:SetOpen(open, blur, State.MenuBlur)
    Window.Backdrop.Visible = open and State.Stars or false
    blur.Size = open and (State.MenuBlur and 12 or 0) or 0
end

setMenu(false)

--====================================================
-- CROSSHAIR + FPS + WATERMARK
--====================================================
local Cross = Instance.new("Frame", Window.ScreenGui)
Cross.Name = "Crosshair"
Cross.BackgroundTransparency = 1
Cross.Size = UDim2.fromScale(1, 1)
Cross.ZIndex = 9000

local function mkLine(parent)
    local f = Instance.new("Frame", parent)
    f.BorderSizePixel = 0
    f.BackgroundColor3 = Themes.Accent
    f.ZIndex = 9001
    return f
end

local CHLeft = mkLine(Cross)
local CHRight = mkLine(Cross)
local CHTop = mkLine(Cross)
local CHBottom = mkLine(Cross)
local CHDot = Instance.new("Frame", Cross)
CHDot.BorderSizePixel = 0
CHDot.BackgroundColor3 = Themes.Accent
CHDot.ZIndex = 9001
Instance.new("UICorner", CHDot).CornerRadius = UDim.new(1, 0)

local FPS = Instance.new("TextLabel", Window.ScreenGui)
FPS.Name = "FPSCounter"
FPS.BackgroundTransparency = 1
FPS.Position = UDim2.new(0, 12, 0, 10)
FPS.Size = UDim2.new(0, 180, 0, 18)
FPS.Text = "FPS: 60"
FPS.TextColor3 = Themes.Accent
FPS.Font = Enum.Font.GothamBold
FPS.TextSize = 12
FPS.TextXAlignment = Enum.TextXAlignment.Left
FPS.ZIndex = 9002

local Watermark = Instance.new("Frame")
Watermark.Name = "VanguardWatermark"
Watermark.Parent = Window.ScreenGui
Watermark.Size = UDim2.new(0, 300, 0, 44)
Watermark.Position = UDim2.new(0, 12, 0, 12)
Watermark.BackgroundColor3 = Themes.Card
Watermark.BackgroundTransparency = 0.08
Watermark.BorderSizePixel = 0
Watermark.ZIndex = 9005
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 12)

local WMStroke = Instance.new("UIStroke", Watermark)
WMStroke.Color = Themes.Accent
WMStroke.Thickness = 1.2
WMStroke.Transparency = 0.35

local WMText = Instance.new("TextLabel", Watermark)
WMText.BackgroundTransparency = 1
WMText.Position = UDim2.new(0, 12, 0, 4)
WMText.Size = UDim2.new(1, -24, 0, 16)
WMText.Text = State.WatermarkText
WMText.TextColor3 = Themes.Text
WMText.Font = Enum.Font.GothamBold
WMText.TextSize = 13
WMText.TextXAlignment = Enum.TextXAlignment.Left
WMText.ZIndex = 9006

local WMSub = Instance.new("TextLabel", Watermark)
WMSub.BackgroundTransparency = 1
WMSub.Position = UDim2.new(0, 12, 0, 20)
WMSub.Size = UDim2.new(1, -24, 0, 14)
WMSub.Text = "UI • FPS • VISUALS"
WMSub.TextColor3 = Themes.Dim
WMSub.Font = Enum.Font.Gotham
WMSub.TextSize = 10
WMSub.TextXAlignment = Enum.TextXAlignment.Left
WMSub.ZIndex = 9006

--====================================================
-- TABS
--====================================================
local Pages = {}
local Buttons = {}

local function makeTab(name, icon, title, subtitle)
    local tab = UI.CreateTabButton(Window.TabList, Themes, name, icon)
    local page = UI.CreatePage(Window.Content)
    Pages[name] = page
    Buttons[name] = tab

    tab.Button.MouseButton1Click:Connect(function()
        UI.PlayClickSound(tab.Button, UI.ClickSoundsEnabled)

        for _, p in pairs(Pages) do
            p.Visible = false
            local ps = p:FindFirstChild("PageScale")
            if ps then ps.Scale = 0.98 end
        end

        for _, b in pairs(Buttons) do
            UI.AnimateTab(b.Button, false, Themes)
            b.Label.TextColor3 = Themes.Dim
            b.Bar.BackgroundTransparency = 1
            b.Stroke.Transparency = 0.7
        end

        page.Visible = true
        local ps = page:FindFirstChild("PageScale")
        if ps then
            TweenService:Create(ps, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {Scale = 1}):Play()
        end

        UI.AnimateTab(tab.Button, true, Themes)
        tab.Label.TextColor3 = Themes.Text
        tab.Bar.BackgroundTransparency = 0
        tab.Stroke.Transparency = 0.35

        Window:SetTitle(title, subtitle)
    end)

    return page
end

local Home = makeTab("Home", "⌂", "Home", "menu overview and quick actions")
local Appearance = makeTab("Appearance", "◌", "Appearance", "window size, accent and layout")
local EffectsTab = makeTab("Effects", "✦", "Effects", "bloom, rays, color and blur")
local ThemesTab = makeTab("Themes", "◈", "Themes", "accent presets and palette")
local HUDTab = makeTab("HUD", "▣", "HUD", "watermark, fps and helper ui")
local World = makeTab("World", "☾", "World", "lighting, time and atmosphere")
local Performance = makeTab("Performance", "⚡", "Performance", "lightweight mode and cleanup")
local Info = makeTab("Info", "i", "Info", "status, details and links")
local Misc = makeTab("Misc", "⚙", "Misc", "reset and utility actions")

-- default tab
Pages["Home"].Visible = true
Buttons["Home"].Label.TextColor3 = Themes.Text
Buttons["Home"].Bar.BackgroundTransparency = 0
Buttons["Home"].Stroke.Transparency = 0.35
Buttons["Home"].Button.BackgroundColor3 = Color3.fromRGB(22, 17, 40)
Window:SetTitle("Home", "menu overview and quick actions")

--====================================================
-- HOME
--====================================================
UI.CreateSection(Home, Themes, "WELCOME", "this menu stays functional after closing")
UI.CreateButton(Home, Themes, "Open / Close Menu", "RightShift toggles the window", function()
    setMenu(not Window.Main.Visible)
end, Themes.Accent)

UI.CreateButton(Home, Themes, "Test Notification", "checks notification system", function()
    Notify("Vanguard", "notification system works", Themes.Green, 2.5)
end, Themes.Green)

UI.CreateButton(Home, Themes, "Rebuild Stars", "refresh star background", function()
    rebuildStars()
    Notify("Backdrop", "stars rebuilt", Themes.Yellow, 2.5)
end, Themes.Yellow)

UI.CreateButton(Home, Themes, "Reset All", "restore every visual setting", function()
    Functions.Reset(State)
    Themes.Accent = Functions.GetThemePreset(State.ThemePreset)
    rebuildStars()
    Notify("Reset", "all settings restored", Themes.Yellow, 2.5)
end, Themes.Red)

UI.CreateLabel(Home, Themes, "Loaded successfully", Themes.Green, "menu and visual system are active")

--====================================================
-- APPEARANCE
--====================================================
UI.CreateSection(Appearance, Themes, "APPEARANCE", "menu looks and feel")

UI.CreateToggle(Appearance, Themes, "Menu Blur", "blur when menu is open",
    function() return State.MenuBlur end,
    function(v) State.MenuBlur = v end
)

UI.CreateToggle(Appearance, Themes, "Title Gradient", "gradient title text",
    function() return State.TitleGradient or true end,
    function(v) State.TitleGradient = v end
)

UI.CreateToggle(Appearance, Themes, "Watermark", "top-left status panel",
    function() return State.Watermark end,
    function(v) State.Watermark = v end
)

UI.CreateSlider(Appearance, Themes, "Menu Scale", 85, 125, math.floor(State.MenuScale * 100),
    function(v) State.MenuScale = v / 100 end
)

UI.CreateSlider(Appearance, Themes, "Menu Transparency", 0, 35, math.floor(State.MenuTransparency * 100),
    function(v) State.MenuTransparency = v / 100 end
)

UI.CreateSlider(Appearance, Themes, "Accent Speed", 1, 5, State.AccentSpeed,
    function(v) State.AccentSpeed = v end
)

UI.CreateSlider(Appearance, Themes, "Animation Speed", 1, 5, State.AnimationSpeed,
    function(v) State.AnimationSpeed = v end
)

UI.CreateSlider(Appearance, Themes, "Star Count", 20, 220, State.StarCount,
    function(v) State.StarCount = v end
)

UI.CreateTextBox(Appearance, Themes, "Watermark Text", "type title here", State.WatermarkText,
    function(text)
        if text and #text > 0 then
            State.WatermarkText = text
        end
    end
)

UI.CreateButton(Appearance, Themes, "Compact Mode", "slightly smaller menu", function()
    State.CompactMode = not State.CompactMode
    Notify("Appearance", State.CompactMode and "compact mode on" or "compact mode off", Themes.Accent, 2)
end, Themes.Accent)

--====================================================
-- EFFECTS
--====================================================
UI.CreateSection(EffectsTab, Themes, "POST EFFECTS", "extra game visuals")

UI.CreateToggle(EffectsTab, Themes, "Bloom", "soft glow effect",
    function() return State.Bloom end,
    function(v) State.Bloom = v end
)

UI.CreateSlider(EffectsTab, Themes, "Bloom Intensity", 0, 300, math.floor(State.BloomIntensity * 100),
    function(v) State.BloomIntensity = v / 100 end
)

UI.CreateSlider(EffectsTab, Themes, "Bloom Size", 0, 56, State.BloomSize,
    function(v) State.BloomSize = v end
)

UI.CreateToggle(EffectsTab, Themes, "Sun Rays", "light rays through camera",
    function() return State.SunRays end,
    function(v) State.SunRays = v end
)

UI.CreateSlider(EffectsTab, Themes, "Sun Rays Intensity", 0, 25, math.floor(State.SunRaysIntensity * 100),
    function(v) State.SunRaysIntensity = v / 100 end
)

UI.CreateSlider(EffectsTab, Themes, "Sun Rays Spread", 0, 100, math.floor(State.SunRaysSpread * 100),
    function(v) State.SunRaysSpread = v / 100 end
)

UI.CreateToggle(EffectsTab, Themes, "Color Correction", "sat/contrast adjustment",
    function() return State.ColorCorrection end,
    function(v) State.ColorCorrection = v end
)

UI.CreateSlider(EffectsTab, Themes, "Saturation", -50, 50, math.floor(State.Saturation * 100),
    function(v) State.Saturation = v / 100 end
)

UI.CreateSlider(EffectsTab, Themes, "Contrast", -50, 50, math.floor(State.Contrast * 100),
    function(v) State.Contrast = v / 100 end
)

UI.CreateSlider(EffectsTab, Themes, "Brightness", -50, 50, math.floor(State.Brightness * 100),
    function(v) State.Brightness = v / 100 end
)

UI.CreateToggle(EffectsTab, Themes, "Depth of Field", "background blur depth",
    function() return State.DepthOfField end,
    function(v) State.DepthOfField = v end
)

UI.CreateSlider(EffectsTab, Themes, "DOF Far", 0, 100, math.floor(State.DOFFarIntensity * 100),
    function(v) State.DOFFarIntensity = v / 100 end
)

UI.CreateSlider(EffectsTab, Themes, "DOF Near", 0, 100, math.floor(State.DOFNearIntensity * 100),
    function(v) State.DOFNearIntensity = v / 100 end
)

UI.CreateToggle(EffectsTab, Themes, "Vignette", "dark screen edges",
    function() return State.Vignette end,
    function(v) State.Vignette = v end
)

UI.CreateToggle(EffectsTab, Themes, "Low Performance", "disable heavy effects",
    function() return State.LowPerformance end,
    function(v) State.LowPerformance = v end
)

--====================================================
-- THEMES
--====================================================
UI.CreateSection(ThemesTab, Themes, "THEME PRESETS", "quick palette switching")

UI.CreateDropdown(ThemesTab, Themes, "Theme Preset",
    {"Purple", "Cyan", "Red", "Green", "Orange", "Pink", "White"},
    State.ThemePreset,
    function(v)
        State.ThemePreset = v
        Themes.Accent = Functions.GetThemePreset(v)
        UI.RefreshAll()
        Notify("Theme", "preset: " .. v, Themes.Accent, 2)
    end
)

UI.CreateButton(ThemesTab, Themes, "Purple", "default preset", function()
    State.ThemePreset = "Purple"
    Themes.Accent = Functions.GetThemePreset("Purple")
    UI.RefreshAll()
end, Functions.GetThemePreset("Purple"))

UI.CreateButton(ThemesTab, Themes, "Cyan", "cool blue accent", function()
    State.ThemePreset = "Cyan"
    Themes.Accent = Functions.GetThemePreset("Cyan")
    UI.RefreshAll()
end, Functions.GetThemePreset("Cyan"))

UI.CreateButton(ThemesTab, Themes, "Red", "hot accent", function()
    State.ThemePreset = "Red"
    Themes.Accent = Functions.GetThemePreset("Red")
    UI.RefreshAll()
end, Functions.GetThemePreset("Red"))

UI.CreateButton(ThemesTab, Themes, "Green", "fresh neon accent", function()
    State.ThemePreset = "Green"
    Themes.Accent = Functions.GetThemePreset("Green")
    UI.RefreshAll()
end, Functions.GetThemePreset("Green"))

UI.CreateButton(ThemesTab, Themes, "Orange", "warm accent", function()
    State.ThemePreset = "Orange"
    Themes.Accent = Functions.GetThemePreset("Orange")
    UI.RefreshAll()
end, Functions.GetThemePreset("Orange"))

UI.CreateButton(ThemesTab, Themes, "Pink", "soft neon accent", function()
    State.ThemePreset = "Pink"
    Themes.Accent = Functions.GetThemePreset("Pink")
    UI.RefreshAll()
end, Functions.GetThemePreset("Pink"))

UI.CreateButton(ThemesTab, Themes, "White", "clean pale accent", function()
    State.ThemePreset = "White"
    Themes.Accent = Functions.GetThemePreset("White")
    UI.RefreshAll()
end, Functions.GetThemePreset("White"))

--====================================================
-- HUD
--====================================================
UI.CreateSection(HUDTab, Themes, "HUD", "watermark and helper ui")

UI.CreateToggle(HUDTab, Themes, "Notifications", "popup messages on actions",
    function() return State.Notifications end,
    function(v) State.Notifications = v end
)

UI.CreateToggle(HUDTab, Themes, "FPS Counter", "top-left framerate label",
    function() return State.FPSCounter end,
    function(v) State.FPSCounter = v end
)

UI.CreateToggle(HUDTab, Themes, "Show Time", "display clock in watermark",
    function() return State.ShowTime end,
    function(v) State.ShowTime = v end
)

UI.CreateToggle(HUDTab, Themes, "Show Username", "display your name in watermark",
    function() return State.ShowUser end,
    function(v) State.ShowUser = v end
)

UI.CreateToggle(HUDTab, Themes, "Click Sounds", "play soft UI clicks",
    function() return State.ClickSounds end,
    function(v)
        State.ClickSounds = v
        UI.ClickSoundsEnabled = v
    end
)

UI.CreateKeybind(HUDTab, Themes, "Menu Key", State.MenuKey,
    function(key)
        State.MenuKey = key
        Notify("Bind", "menu key: " .. key.Name, Themes.Accent, 2)
    end
)

UI.CreateButton(HUDTab, Themes, "Show Loaded Status", "quick status test", function()
    Notify("Vanguard", "UI and effects are active", Themes.Green, 2.5)
end, Themes.Green)

--====================================================
-- WORLD
--====================================================
UI.CreateSection(World, Themes, "LIGHTING", "simple environment controls")

UI.CreateToggle(World, Themes, "FullBright", "max brightness and shadows off",
    function() return State.FullBright end,
    function(v) State.FullBright = v end
)

UI.CreateToggle(World, Themes, "No Fog", "removes fog distance",
    function() return State.NoFog end,
    function(v) State.NoFog = v end
)

UI.CreateToggle(World, Themes, "Lock Time", "keeps a fixed clock time",
    function() return State.LockTime end,
    function(v) State.LockTime = v end
)

UI.CreateSlider(World, Themes, "Clock Time", 0, 24, State.TimeValue,
    function(v) State.TimeValue = v end
)

--====================================================
-- PERFORMANCE
--====================================================
UI.CreateSection(Performance, Themes, "PERFORMANCE", "lighter look for low-end devices")

UI.CreateToggle(Performance, Themes, "Disable Stars", "hide animated background",
    function() return not State.Stars end,
    function(v) State.Stars = not v end
)

UI.CreateToggle(Performance, Themes, "Disable Blur", "turn off menu blur",
    function() return not State.MenuBlur end,
    function(v) State.MenuBlur = not v end
)

UI.CreateToggle(Performance, Themes, "Disable Bloom", "turn off bloom effect",
    function() return not State.Bloom end,
    function(v) State.Bloom = not v end
)

UI.CreateToggle(Performance, Themes, "Disable Rays", "turn off sun rays",
    function() return not State.SunRays end,
    function(v) State.SunRays = not v end
)

UI.CreateToggle(Performance, Themes, "Disable DOF", "turn off depth of field",
    function() return not State.DepthOfField end,
    function(v) State.DepthOfField = not v end
)

UI.CreateToggle(Performance, Themes, "Disable Vignette", "turn off screen edge darkening",
    function() return not State.Vignette end,
    function(v) State.Vignette = not v end
)

UI.CreateButton(Performance, Themes, "Compact Mode", "shrinks the menu a bit", function()
    State.CompactMode = true
    State.MenuScale = 0.92
    Notify("Performance", "compact mode enabled", Themes.Yellow, 2)
end, Themes.Yellow)

UI.CreateButton(Performance, Themes, "Full Reset", "restore visuals and ui", function()
    Functions.Reset(State)
    Themes.Accent = Functions.GetThemePreset(State.ThemePreset)
    Camera.FieldOfView = Defaults.FOV
    rebuildStars()
    UI.RefreshAll()
    Notify("Reset", "all settings restored", Themes.Yellow, 2.5)
end, Themes.Red)

--====================================================
-- INFO
--====================================================
UI.CreateSection(Info, Themes, "STATUS", "simple info panel")

UI.CreateLabel(Info, Themes, "Loaded successfully", Themes.Green, "menu and visual system are active")
UI.CreateLabel(Info, Themes, "Current preset: " .. tostring(State.ThemePreset), Themes.Accent, "theme changes update live")
UI.CreateLabel(Info, Themes, "Key: " .. State.MenuKey.Name, Themes.Yellow, "menu can be rebound")
UI.CreateLabel(Info, Themes, "FPS: shown in top-left when enabled", Themes.Text, "performance monitor")

UI.CreateButton(Info, Themes, "Show Theme", "display current preset", function()
    Notify("Theme", "current preset: " .. tostring(State.ThemePreset), Themes.Accent, 2.5)
end, Themes.Accent)

UI.CreateButton(Info, Themes, "Close Menu", "hide interface", function()
    setMenu(false)
end, Themes.Red)

--====================================================
-- MISC
--====================================================
UI.CreateSection(Misc, Themes, "UTILITY", "simple action buttons")

UI.CreateButton(Misc, Themes, "Show Menu", "open the interface again", function()
    setMenu(true)
end, Themes.Green)

UI.CreateButton(Misc, Themes, "Hide Menu", "hide the interface", function()
    setMenu(false)
end, Themes.Red)

UI.CreateButton(Misc, Themes, "Rebuild Stars", "refresh star layer", function()
    rebuildStars()
    Notify("Backdrop", "stars rebuilt", Themes.Accent, 2.5)
end)

UI.CreateButton(Misc, Themes, "Reset All", "restore every setting", function()
    Functions.Reset(State)
    Themes.Accent = Functions.GetThemePreset(State.ThemePreset)
    Camera.FieldOfView = Defaults.FOV
    rebuildStars()
    UI.RefreshAll()
    Notify("Reset", "all 
