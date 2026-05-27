if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE = "https://raw.githubusercontent.com/lox056594-dev/vanguard-scripts/main/"

local function loadFile(name)
    local ok, res = pcall(function()
        return loadstring(game:HttpGet(BASE .. name .. ".lua", true))()
    end)
    if not ok then
        warn("[Vanguard] " .. name .. " load error: " .. tostring(res))
        return nil
    end
    return res
end

local Themes = loadFile("Themes")
local UI = loadFile("UI")
local Functions = loadFile("Functions")

if not Themes or not UI or not Functions then
    warn("[Vanguard] Module load failed")
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
-- BACKGROUND STAR HELPER
--====================================================
local function rebuildStars()
    local backdrop = Window.Backdrop
    if not backdrop then return end

    local existingLayer = backdrop:FindFirstChild("StarLayer")
    if existingLayer then
        existingLayer:Destroy()
    end

    local starLayer = Instance.new("Frame", backdrop)
    starLayer.Name = "StarLayer"
    starLayer.Size = UDim2.fromScale(1, 1)
    starLayer.BackgroundTransparency = 1
    starLayer.BorderSizePixel = 0
    starLayer.ZIndex = 2

    for i = 1, 100 do
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
    local holder = Window.ScreenGui:FindFirstChild("NotifHolder")
    if not holder then return end
    if not State.Notifications then return end

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

-- Add notif holder if UI module didn't create it yet
if not Window.ScreenGui:FindFirstChild("NotifHolder") then
    local holder = Instance.new("Frame")
    holder.Name = "NotifHolder"
    holder.Parent = Window.ScreenGui
    holder.AnchorPoint = Vector2.new(1, 1)
    holder.Position = UDim2.new(1, -16, 1, -16)
    holder.Size = UDim2.new(0, 320, 1, -32)
    holder.BackgroundTransparency = 1
    holder.ZIndex = 1000

    local lay = Instance.new("UIListLayout", holder)
    lay.Padding = UDim.new(0, 8)
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Right
    lay.VerticalAlignment = Enum.VerticalAlignment.Bottom
    lay.SortOrder = Enum.SortOrder.LayoutOrder
end

--====================================================
-- TABS
--====================================================
local Pages = {}
local Buttons = {}

local function makeTab(name, title, subtitle)
    local btn = UI.CreateTabButton(Window.TabList, Themes, name)
    local page = UI.CreatePage(Window.Content)
    Pages[name] = page
    Buttons[name] = btn

    btn.Button.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do
            p.Visible = false
        end
        for _, b in pairs(Buttons) do
            b.Label.TextColor3 = Themes.Dim
            b.Bar.BackgroundTransparency = 1
            b.Stroke.Transparency = 0.7
            b.Button.BackgroundColor3 = Themes.Card
        end

        page.Visible = true
        btn.Label.TextColor3 = Themes.Text
        btn.Bar.BackgroundTransparency = 0
        btn.Stroke.Transparency = 0.35
        btn.Button.BackgroundColor3 = Color3.fromRGB(22, 17, 40)

        Window:SetTitle(title, subtitle)
    end)

    return page
end

local Home = makeTab("Home", "Home", "menu overview and quick actions")
local Visuals = makeTab("Visuals", "Visuals", "visual settings and cosmetic effects")
local World = makeTab("World", "World", "lighting, time and atmosphere")
local UIP = makeTab("UI", "UI", "interface and helper settings")
local Misc = makeTab("Misc", "Misc", "reset and utility actions")

-- default tab
Pages["Home"].Visible = true
Buttons["Home"].Label.TextColor3 = Themes.Text
Buttons["Home"].Bar.BackgroundTransparency = 0
Buttons["Home"].Stroke.Transparency = 0.35
Buttons["Home"].Button.BackgroundColor3 = Color3.fromRGB(22, 17, 40)
Window:SetTitle("Home", "menu overview and quick actions")

--====================================================
-- CROSSHAIR + FPS
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

--====================================================
-- HOME TAB
--====================================================
UI.CreateSection(Home, Themes, "WELCOME", "this menu stays functional after closing")

UI.CreateButton(Home, Themes, "Open / Close Menu", "RightShift toggles the window", function()
    Window:SetOpen(not Window.Main.Visible, Window.ScreenGui:FindFirstChild("VanguardMenuBlur") or nil, State.MenuBlur)
end, Themes.Accent)

UI.CreateButton(Home, Themes, "Test Notification", "checks notification system", function()
    Notify("Vanguard", "notification system works", Themes.Green, 2.5)
end, Themes.Green)

UI.CreateButton(Home, Themes, "Rebuild Stars", "refresh star background", function()
    rebuildStars()
    Notify("Backdrop", "stars rebuilt", Themes.Yellow, 2.5)
end, Themes.Yellow)

UI.CreateButton(Home, Themes, "Hide Menu", "features keep running", function()
    Window:SetOpen(false, Window.ScreenGui:FindFirstChild("VanguardMenuBlur") or nil, State.MenuBlur)
end, Themes.Red)

--====================================================
-- VISUALS TAB
--====================================================
UI.CreateSection(Visuals, Themes, "VISUALS", "purely cosmetic and safe")

UI.CreateToggle(Visuals, Themes, "RGB Accent", "cycles menu accent color",
    function() return State.RGB end,
    function(v) State.RGB = v end
)

UI.CreateToggle(Visuals, Themes, "Stars Background", "animated star field",
    function() return State.Stars end,
    function(v) State.Stars = v end
)

UI.CreateToggle(Visuals, Themes, "Crosshair", "simple centered crosshair",
    function() return State.Crosshair end,
    function(v) State.Crosshair = v end
)

UI.CreateSlider(Visuals, Themes, "Cross Size", 4, 26, State.CrossSize,
    function(v) State.CrossSize = v end
)

UI.CreateSlider(Visuals, Themes, "Cross Gap", 0, 20, State.CrossGap,
    function(v) State.CrossGap = v end
)

UI.CreateSlider(Visuals, Themes, "Cross Thickness", 1, 6, State.CrossThick,
    function(v) State.CrossThick = v end
)

UI.CreateToggle(Visuals, Themes, "FOV Changer", "changes camera field of view",
    function() return State.FOVChanger end,
    function(v) State.FOVChanger = v end
)

UI.CreateSlider(Visuals, Themes, "FOV Value", 50, 120, State.FOVValue,
    function(v) State.FOVValue = v end
)

--====================================================
-- WORLD TAB
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
-- UI TAB
--====================================================
UI.CreateSection(UIP, Themes, "INTERFACE", "ui and helper options")

UI.CreateToggle(UIP, Themes, "Notifications", "popup messages on actions",
    function() return State.Notifications end,
    function(v) State.Notifications = v end
)

UI.CreateToggle(UIP, Themes, "FPS Counter", "top-left framerate label",
    function() return State.FPSCounter end,
    function(v) State.FPSCounter = v end
)

UI.CreateToggle(UIP, Themes, "Menu Blur", "blur when menu is open",
    function() return State.MenuBlur end,
    function(v) State.MenuBlur = v end
)

UI.CreateButton(UIP, Themes, "Reset Accent", "returns to default purple", function()
    Notify("Accent", "reset to default", Themes.Accent, 2)
end, Themes.Yellow)

--====================================================
-- MISC TAB
--====================================================
UI.CreateSection(Misc, Themes, "UTILITY", "simple action buttons")

UI.CreateButton(Misc, Themes, "Show Menu", "open the interface again", function()
    Window:SetOpen(true, Window.ScreenGui:FindFirstChild("VanguardMenuBlur") or nil, State.MenuBlur)
end, Themes.Green)

UI.CreateButton(Misc, Themes, "Close Menu", "hide the interface", function()
    Window:SetOpen(false, Window.ScreenGui:FindFirstChild("VanguardMenuBlur") or nil, State.MenuBlur)
end, Themes.Red)

UI.CreateButton(Misc, Themes, "Reset All", "restores all visual defaults", function()
    Functions.Reset(State)
    Camera.FieldOfView = Defaults.FOV
    Functions.ApplyLighting(State, Defaults, Lighting)
    rebuildStars()
    Notify("Reset", "all settings restored", Themes.Yellow, 2.5)
end, Themes.Red)

UI.CreateButton(Misc, Themes, "Rebuild Stars", "refresh star background", function()
    rebuildStars()
    Notify("Backdrop", "stars rebuilt", Themes.Accent, 2.5)
end)

--====================================================
-- STARS / BLUR / LAYOUT HELPERS
--====================================================
local blur = Lighting:FindFirstChild("VanguardMenuBlur")
if not blur then
    blur = Instance.new("BlurEffect")
    blur.Name = "VanguardMenuBlur"
    blur.Parent = Lighting
end
blur.Size = 0

--====================================================
-- INPUT
--====================================================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Window:SetOpen(not Window.Main.Visible, blur, State.MenuBlur)
    end
end)

--====================================================
-- MAIN LOOP
--====================================================
local hue = 0
local fpsFrames = 0
local fpsTimer = 0
local fpsValue = 60

RunService.RenderStepped:Connect(function(dt)
    fpsFrames += 1
    fpsTimer += dt
    if fpsTimer >= 1 then
        fpsValue = fpsFrames
        fpsFrames = 0
        fpsTimer = 0
        FPS.Text = "FPS: " .. tostring(fpsValue)
    end
    FPS.Visible = State.FPSCounter

    local accent
    accent, hue = Functions.UpdateAccent(State, Themes, dt, hue)

    -- apply accent
    Window.MainStroke.Color = accent
    Window.HeaderLine.BackgroundColor3 = accent
    Window.SideLine.BackgroundColor3 = accent
    FPS.TextColor3 = accent
    CHLeft.BackgroundColor3 = accent
    CHRight.BackgroundColor3 = accent
    CHTop.BackgroundColor3 = accent
    CHBottom.BackgroundColor3 = accent
    CHDot.BackgroundColor3 = accent

    -- crosshair
    Cross.Visible = State.Crosshair
    local vp = Camera.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2
    local size = State.CrossSize
    local gap = State.CrossGap
    local thick = State.CrossThick

    CHLeft.Size = UDim2.fromOffset(size, thick)
    CHLeft.Position = UDim2.fromOffset(cx - gap - size, cy - thick / 2)

    CHRight.Size = UDim2.fromOffset(size, thick)
    CHRight.Position = UDim2.fromOffset(cx + gap, cy - thick / 2)

    CHTop.Size = UDim2.fromOffset(thick, size)
    CHTop.Position = UDim2.fromOffset(cx - thick / 2, cy - gap - size)

    CHBottom.Size = UDim2.fromOffset(thick, size)
    CHBottom.Position = UDim2.fromOffset(cx - thick / 2, cy + gap)

    CHDot.Size = UDim2.fromOffset(4, 4)
    CHDot.Position = UDim2.fromOffset(cx - 2, cy - 2)

    -- lighting / camera
    Functions.ApplyLighting(State, Defaults, Lighting)

    if State.FOVChanger then
        Camera.FieldOfView = State.FOVValue
    else
        Camera.FieldOfView = Defaults.FOV
    end

    -- menu blur / backdrop
    blur.Size = Window.Main.Visible and State.MenuBlur and 12 or 0
    Window.Backdrop.Visible = Window.Main.Visible and State.Stars or false

    -- keep star background up to date
    if not Window.Main.Visible then
        blur.Size = 0
    end
end)

--====================================================
-- START
--====================================================
task.spawn(function()
    task.wait(0.5)
    Notify("Vanguard", "loaded successfully", Themes.Accent, 2.5)
    task.wait(0.4)
    Notify("Hint", "RightShift toggles the menu", Themes.Green, 2.5)
end)
