if not game:IsLoaded() then
    game.Loaded:Wait()
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
-- CLEANUP
--====================================================
pcall(function()
    local old = CoreGui:FindFirstChild("VanguardUI")
    if old then old:Destroy() end
end)

--====================================================
-- SETTINGS
--====================================================
local Settings = {
    Notifications = true,

    Blur = true,
    Stars = true,
    RGB = false,
    Crosshair = true,

    FOVChanger = false,
    FOVValue = 80,

    FullBright = false,
    NoFog = false,

    LockTime = false,
    TimeValue = 14,

    FPSCounter = true,
}

local DefaultLighting = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
}

local DefaultFOV = Camera.FieldOfView

--====================================================
-- GUI ROOT
--====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanguardUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if ScreenGui.Parent ~= CoreGui then
    ScreenGui.Parent = LP:WaitForChild("PlayerGui")
end

--====================================================
-- THEME
--====================================================
local Theme = {
    Bg = Color3.fromRGB(10, 9, 18),
    Card = Color3.fromRGB(15, 14, 27),
    Card2 = Color3.fromRGB(18, 17, 32),
    Text = Color3.fromRGB(245, 240, 255),
    Dim = Color3.fromRGB(145, 135, 180),
    Accent = Color3.fromRGB(160, 110, 255),
    Accent2 = Color3.fromRGB(195, 155, 255),
    Red = Color3.fromRGB(255, 90, 110),
    Green = Color3.fromRGB(80, 255, 165),
    Yellow = Color3.fromRGB(255, 210, 80),
}

local Accent = Theme.Accent
local Refreshers = {}

local function tween(obj, t, props, style, dir)
    TweenService:Create(
        obj,
        TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function addRefresher(fn)
    table.insert(Refreshers, fn)
    return fn
end

local function refreshAccentUI()
    for _, fn in ipairs(Refreshers) do
        pcall(fn)
    end
end

--====================================================
-- BACKGROUND
--====================================================
local BG = Instance.new("Frame")
BG.Name = "BG"
BG.Parent = ScreenGui
BG.Size = UDim2.fromScale(1, 1)
BG.BackgroundColor3 = Theme.Bg
BG.BorderSizePixel = 0
BG.ZIndex = 1

local BGGrad = Instance.new("UIGradient", BG)
BGGrad.Rotation = 135
BGGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 18, 43)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 7, 18)),
})

local stars = {}
local function createStars()
    for _, s in ipairs(stars) do
        pcall(function() s:Destroy() end)
    end
    table.clear(stars)

    for i = 1, 110 do
        local star = Instance.new("ImageLabel")
        star.Name = "Star"
        star.Parent = BG
        star.BackgroundTransparency = 1
        star.Image = "rbxassetid://6031097222"
        star.ImageColor3 = Color3.new(1, 1, 1)
        star.ImageTransparency = math.random(35, 80) / 100
        star.Size = UDim2.new(0, math.random(2, 8), 0, math.random(2, 8))
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.ZIndex = 2

        table.insert(stars, star)

        task.spawn(function()
            while star.Parent do
                task.wait(math.random(10, 25) / 10)
                if not star.Parent then break end
                tween(star, 1.2, { ImageTransparency = math.random(20, 60) / 100 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            end
        end)
    end
end

createStars()

--====================================================
-- BLUR
--====================================================
local blur = Lighting:FindFirstChild("VanguardBlur")
if not blur then
    blur = Instance.new("BlurEffect")
    blur.Name = "VanguardBlur"
    blur.Parent = Lighting
end
blur.Size = Settings.Blur and 14 or 0

--====================================================
-- NOTIFICATIONS
--====================================================
local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "NotifHolder"
NotifHolder.Parent = ScreenGui
NotifHolder.AnchorPoint = Vector2.new(1, 1)
NotifHolder.Position = UDim2.new(1, -18, 1, -18)
NotifHolder.Size = UDim2.new(0, 320, 1, -36)
NotifHolder.BackgroundTransparency = 1
NotifHolder.ZIndex = 1000

local NotifLayout = Instance.new("UIListLayout", NotifHolder)
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder

local notifId = 0
local function Notify(title, msg, col, dur)
    if not Settings.Notifications then return end
    notifId += 1
    col = col or Accent
    dur = dur or 3

    local card = Instance.new("Frame")
    card.Parent = NotifHolder
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = Theme.Card
    card.BackgroundTransparency = 0.02
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.LayoutOrder = notifId
    card.ZIndex = 1001

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local st = Instance.new("UIStroke", card)
    st.Color = col
    st.Thickness = 1.2
    st.Transparency = 0.3

    local scale = Instance.new("UIScale", card)
    scale.Scale = 0.95

    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 14, 0, 8)
    titleLbl.Size = UDim2.new(1, -28, 0, 18)
    titleLbl.Text = title
    titleLbl.TextColor3 = Theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 1002

    local msgLbl = Instance.new("TextLabel", card)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Position = UDim2.new(0, 14, 0, 28)
    msgLbl.Size = UDim2.new(1, -28, 0, 16)
    msgLbl.Text = msg
    msgLbl.TextColor3 = Theme.Dim
    msgLbl.Font = Enum.Font.Gotham
    msgLbl.TextSize = 11
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.ZIndex = 1002

    local bar = Instance.new("Frame", card)
    bar.BorderSizePixel = 0
    bar.BackgroundColor3 = col
    bar.Size = UDim2.new(1, 0, 0, 2)
    bar.Position = UDim2.new(0, 0, 1, -2)
    bar.ZIndex = 1002

    tween(scale, 0.2, { Scale = 1 }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    tween(bar, dur, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

    task.delay(dur, function()
        if card.Parent then
            tween(scale, 0.2, { Scale = 0.95 }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            tween(card, 0.2, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            tween(st, 0.2, { Transparency = 1 }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            task.delay(0.22, function()
                pcall(function() card:Destroy() end)
            end)
        end
    end)
end

--====================================================
-- MAIN WINDOW
--====================================================
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Name = "Main"
Main.Size = UDim2.new(0, 860, 0, 560)
Main.Position = UDim2.new(0.5, -430, 0.5, -280)
Main.BackgroundColor3 = Color3.fromRGB(12, 11, 22)
Main.BorderSizePixel = 0
Main.Visible = true
Main.ZIndex = 10
Main.ClipsDescendants = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Accent
MainStroke.Thickness = 2
MainStroke.Transparency = 0.28

local MainGrad = Instance.new("UIGradient", Main)
MainGrad.Rotation = 120
MainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 13, 27)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 8, 18)),
})

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 190, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(11, 10, 21)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 11

local SideGrad = Instance.new("UIGradient", Sidebar)
SideGrad.Rotation = 90
SideGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 11, 24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 7, 16)),
})

local SideTitle = Instance.new("TextLabel", Sidebar)
SideTitle.BackgroundTransparency = 1
SideTitle.Position = UDim2.new(0, 18, 0, 16)
SideTitle.Size = UDim2.new(1, -36, 0, 28)
SideTitle.Text = "VANGUARD"
SideTitle.TextColor3 = Theme.Text
SideTitle.Font = Enum.Font.GothamBold
SideTitle.TextSize = 22
SideTitle.TextXAlignment = Enum.TextXAlignment.Left
SideTitle.ZIndex = 12

local SideSub = Instance.new("TextLabel", Sidebar)
SideSub.BackgroundTransparency = 1
SideSub.Position = UDim2.new(0, 18, 0, 42)
SideSub.Size = UDim2.new(1, -36, 0, 16)
SideSub.Text = "clean minimal menu"
SideSub.TextColor3 = Theme.Dim
SideSub.Font = Enum.Font.Gotham
SideSub.TextSize = 11
SideSub.TextXAlignment = Enum.TextXAlignment.Left
SideSub.ZIndex = 12

local SideLine = Instance.new("Frame", Sidebar)
SideLine.BackgroundColor3 = Accent
SideLine.BackgroundTransparency = 0.5
SideLine.BorderSizePixel = 0
SideLine.Position = UDim2.new(0, 18, 0, 66)
SideLine.Size = UDim2.new(0, 154, 0, 1)
SideLine.ZIndex = 12

local TabList = Instance.new("Frame", Sidebar)
TabList.BackgroundTransparency = 1
TabList.Position = UDim2.new(0, 12, 0, 82)
TabList.Size = UDim2.new(1, -24, 1, -92)
TabList.ZIndex = 12

local TabLayout = Instance.new("UIListLayout", TabList)
TabLayout.Padding = UDim.new(0, 8)

local Content = Instance.new("Frame", Main)
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 190, 0, 0)
Content.Size = UDim2.new(1, -190, 1, 0)
Content.ZIndex = 11

local Header = Instance.new("Frame", Content)
Header.Name = "Header"
Header.BackgroundTransparency = 1
Header.Position = UDim2.new(0, 0, 0, 0)
Header.Size = UDim2.new(1, 0, 0, 64)
Header.ZIndex = 12

local HeaderTitle = Instance.new("TextLabel", Header)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Position = UDim2.new(0, 18, 0, 14)
HeaderTitle.Size = UDim2.new(1, -160, 0, 24)
HeaderTitle.Text = "Home"
HeaderTitle.TextColor3 = Theme.Text
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 22
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 13

local HeaderSub = Instance.new("TextLabel", Header)
HeaderSub.BackgroundTransparency = 1
HeaderSub.Position = UDim2.new(0, 18, 0, 38)
HeaderSub.Size = UDim2.new(1, -160, 0, 16)
HeaderSub.Text = "simple, stable and clean"
HeaderSub.TextColor3 = Theme.Dim
HeaderSub.Font = Enum.Font.Gotham
HeaderSub.TextSize = 11
HeaderSub.TextXAlignment = Enum.TextXAlignment.Left
HeaderSub.ZIndex = 13

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -72, 0, 16)
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 28, 46)
MinBtn.Text = "–"
MinBtn.TextColor3 = Theme.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.AutoButtonColor = false
MinBtn.ZIndex = 13
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -36, 0, 16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(70, 24, 38)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 13
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

local HeaderLine = Instance.new("Frame", Header)
HeaderLine.BackgroundColor3 = Accent
HeaderLine.BackgroundTransparency = 0.65
HeaderLine.BorderSizePixel = 0
HeaderLine.Position = UDim2.new(0, 16, 1, -1)
HeaderLine.Size = UDim2.new(1, -32, 0, 1)
HeaderLine.ZIndex = 12

--====================================================
-- CROSSHAIR
--====================================================
local Cross = Instance.new("Frame", ScreenGui)
Cross.Name = "Crosshair"
Cross.BackgroundTransparency = 1
Cross.Size = UDim2.fromScale(1, 1)
Cross.ZIndex = 9000
Cross.Visible = Settings.Crosshair

local function makeLine(parent)
    local f = Instance.new("Frame", parent)
    f.BorderSizePixel = 0
    f.BackgroundColor3 = Accent
    f.ZIndex = 9001
    return f
end

local CHLeft = makeLine(Cross)
local CHRight = makeLine(Cross)
local CHTop = makeLine(Cross)
local CHBottom = makeLine(Cross)
local CHDot = Instance.new("Frame", Cross)
CHDot.BorderSizePixel = 0
CHDot.BackgroundColor3 = Accent
CHDot.ZIndex = 9001
Instance.new("UICorner", CHDot).CornerRadius = UDim.new(1, 0)

--====================================================
-- FPS COUNTER
--====================================================
local FPS = Instance.new("TextLabel", ScreenGui)
FPS.Name = "FPSCounter"
FPS.BackgroundTransparency = 1
FPS.Position = UDim2.new(0, 12, 0, 10)
FPS.Size = UDim2.new(0, 180, 0, 18)
FPS.Text = "FPS: 60"
FPS.TextColor3 = Accent
FPS.Font = Enum.Font.GothamBold
FPS.TextSize = 12
FPS.TextXAlignment = Enum.TextXAlignment.Left
FPS.ZIndex = 9002
FPS.Visible = Settings.FPSCounter

--====================================================
-- DRAG
--====================================================
do
    local dragging = false
    local dragStart
    local startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

--====================================================
-- COMPONENTS
--====================================================
local Pages = {}
local currentTab = nil

local function newPage()
    local p = Instance.new("ScrollingFrame", Content)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.Position = UDim2.new(0, 0, 0, 64)
    p.Size = UDim2.new(1, 0, 1, -64)
    p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = Accent
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.Visible = false
    p.ZIndex = 11

    local layout = Instance.new("UIListLayout", p)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", p)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingLeft = UDim.new(0, 18)
    pad.PaddingRight = UDim.new(0, 18)
    pad.PaddingBottom = UDim.new(0, 14)

    return p
end

local function section(parent, text, sub)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, sub and 42 or 28)
    f.BackgroundTransparency = 1
    f.ZIndex = 12

    local lbl = Instance.new("TextLabel", f)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 2, 0, 0)
    lbl.Size = UDim2.new(1, -4, 0, 18)
    lbl.Text = text
    lbl.TextColor3 = Accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 13

    if sub then
        local sl = Instance.new("TextLabel", f)
        sl.BackgroundTransparency = 1
        sl.Position = UDim2.new(0, 2, 0, 18)
        sl.Size = UDim2.new(1, -4, 0, 16)
        sl.Text = sub
        sl.TextColor3 = Theme.Dim
        sl.Font = Enum.Font.Gotham
        sl.TextSize = 10
        sl.TextXAlignment = Enum.TextXAlignment.Left
        sl.ZIndex = 13
    end
end

local function addCard(parent, height)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, 0, 0, height)
    card.BackgroundColor3 = Theme.Card
    card.BorderSizePixel = 0
    card.ZIndex = 12
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local st = Instance.new("UIStroke", card)
    st.Color = Accent
    st.Thickness = 1.1
    st.Transparency = 0.55

    return card, st
end

local function addToggle(parent, label, desc, get, set)
    local card = addCard(parent, desc and 60 or 44)
    local top = Instance.new("TextLabel", card)
    top.BackgroundTransparency = 1
    top.Position = UDim2.new(0, 14, 0, desc and 7 or 12)
    top.Size = UDim2.new(1, -90, 0, 18)
    top.Text = label
    top.TextColor3 = Theme.Text
    top.Font = Enum.Font.GothamSemibold
    top.TextSize = 13
    top.TextXAlignment = Enum.TextXAlignment.Left
    top.ZIndex = 13

    if desc then
        local d = Instance.new("TextLabel", card)
        d.BackgroundTransparency = 1
        d.Position = UDim2.new(0, 14, 0, 27)
        d.Size = UDim2.new(1, -90, 0, 14)
        d.Text = desc
        d.TextColor3 = Theme.Dim
        d.Font = Enum.Font.Gotham
        d.TextSize = 10
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.ZIndex = 13
    end

    local sw = Instance.new("Frame", card)
    sw.Size = UDim2.new(0, 46, 0, 24)
    sw.Position = UDim2.new(1, -58, 0.5, -12)
    sw.BackgroundColor3 = Color3.fromRGB(28, 24, 44)
    sw.BorderSizePixel = 0
    sw.ZIndex = 13
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local kn = Instance.new("Frame", sw)
    kn.Size = UDim2.new(0, 20, 0, 20)
    kn.Position = UDim2.new(0, 2, 0.5, -10)
    kn.BackgroundColor3 = Color3.fromRGB(85, 80, 105)
    kn.BorderSizePixel = 0
    kn.ZIndex = 14
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1, 0)

    local click = Instance.new("TextButton", card)
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.AutoButtonColor = false
    click.ZIndex = 15

    local function refresh()
        local on = get()
        if on then
            sw.BackgroundColor3 = Accent
            kn.Position = UDim2.new(0, 24, 0.5, -10)
            kn.BackgroundColor3 = Color3.new(1, 1, 1)
            st.Transparency = 0.25
        else
            sw.BackgroundColor3 = Color3.fromRGB(28, 24, 44)
            kn.Position = UDim2.new(0, 2, 0.5, -10)
            kn.BackgroundColor3 = Color3.fromRGB(85, 80, 105)
            st.Transparency = 0.55
        end
    end

    click.MouseButton1Click:Connect(function()
        set(not get())
        refresh()
        refreshAccentUI()
    end)

    refresh()
    addRefresher(refresh)

    return refresh
end

local function addSlider(parent, label, min, max, default, set)
    local card = addCard(parent, 56)

    local title = Instance.new("TextLabel", card)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 14, 0, 8)
    title.Size = UDim2.new(1, -90, 0, 18)
    title.Text = label
    title.TextColor3 = Theme.Text
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 13

    local valLbl = Instance.new("TextLabel", card)
    valLbl.BackgroundTransparency = 1
    valLbl.Position = UDim2.new(1, -72, 0, 8)
    valLbl.Size = UDim2.new(0, 56, 0, 18)
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = Accent
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 12
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 13

    local track = Instance.new("Frame", card)
    track.Position = UDim2.new(0, 14, 0, 36)
    track.Size = UDim2.new(1, -28, 0, 6)
    track.BackgroundColor3 = Color3.fromRGB(30, 25, 48)
    track.BorderSizePixel = 0
    track.ZIndex = 13
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 14
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 15
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local current = default

    local function applyFromX(x)
        local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        current = math.floor(min + (max - min) * pct + 0.5)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -7, 0.5, -7)
        valLbl.Text = tostring(current)
        set(current)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            applyFromX(input.Position.X)
        end
    end)

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            applyFromX(input.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    fill.Size = UDim2.new((default - min) / math.max((max - min), 1), 0, 1, 0)
    knob.Position = UDim2.new((default - min) / math.max((max - min), 1), -7, 0.5, -7)
    set(default)

    addRefresher(function()
        fill.BackgroundColor3 = Accent
        valLbl.TextColor3 = Accent
    end)
end

local function addButton(parent, label, desc, callback, col)
    local card = addCard(parent, desc and 52 or 42)
    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 15

    local top = Instance.new("TextLabel", card)
    top.BackgroundTransparency = 1
    top.Position = UDim2.new(0, 14, 0, desc and 7 or 12)
    top.Size = UDim2.new(1, -28, 0, 18)
    top.Text = label
    top.TextColor3 = col or Theme.Text
    top.Font = Enum.Font.GothamSemibold
    top.TextSize = 13
    top.TextXAlignment = Enum.TextXAlignment.Left
    top.ZIndex = 13

    if desc then
        local d = Instance.new("TextLabel", card)
        d.BackgroundTransparency = 1
        d.Position = UDim2.new(0, 14, 0, 24)
        d.Size = UDim2.new(1, -28, 0, 14)
        d.Text = desc
        d.TextColor3 = Theme.Dim
        d.Font = Enum.Font.Gotham
        d.TextSize = 10
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.ZIndex = 13
    end

    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
end

--====================================================
-- TABS
--====================================================
local function createTabButton(name)
    local b = Instance.new("TextButton", TabList)
    b.Size = UDim2.new(1, 0, 0, 42)
    b.BackgroundColor3 = Theme.Card
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.ZIndex = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", b)
    stroke.Color = Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.7

    local accentBar = Instance.new("Frame", b)
    accentBar.Size = UDim2.new(0, 3, 0, 22)
    accentBar.Position = UDim2.new(0, 0, 0.5, -11)
    accentBar.BackgroundColor3 = Accent
    accentBar.BackgroundTransparency = 1
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 13
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new("TextLabel", b)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.Size = UDim2.new(1, -28, 1, 0)
    lbl.Text = name
    lbl.TextColor3 = Theme.Dim
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 13

    return {
        Button = b,
        Label = lbl,
        Stroke = stroke,
        AccentBar = accentBar,
    }
end

local function switchTab(name)
    for tabName, info in pairs(Pages) do
        info.Page.Visible = false
        info.Button.Label.TextColor3 = Theme.Dim
        info.Button.AccentBar.BackgroundTransparency = 1
        info.Button.Stroke.Transparency = 0.7
        info.Button.BackgroundColor3 = Theme.Card
    end

    local info = Pages[name]
    if not info then return end
    info.Page.Visible = true
    currentTab = name

    info.Button.Label.TextColor3 = Theme.Text
    info.Button.AccentBar.BackgroundTransparency = 0
    info.Button.Stroke.Transparency = 0.35
    info.Button.BackgroundColor3 = Color3.fromRGB(22, 17, 40)

    HeaderTitle.Text = name
    HeaderSub.Text = ({
        Home = "menu overview and quick actions",
        Visuals = "visual settings and cosmetic effects",
        World = "lighting, time and atmosphere",
        UI = "interface, notifications and fps",
        Misc = "reset and utility actions",
    })[name] or ""
end

local function addPage(name)
    local tab = createTabButton(name)
    local page = newPage()
    Pages[name] = {
        Button = tab,
        Page = page,
    }

    tab.Button.MouseButton1Click:Connect(function()
        switchTab(name)
    end)

    return page
end

local Home = addPage("Home")
local Visuals = addPage("Visuals")
local World = addPage("World")
local UIPage = addPage("UI")
local Misc = addPage("Misc")

--====================================================
-- HOME TAB
--====================================================
section(Home, "WELCOME", "this is a clean and fully working menu shell")

addButton(Home, "Open/Close Menu", "RightShift toggles the menu", function()
    Main.Visible = not Main.Visible
end, Accent)

addButton(Home, "Test Notification", "checks notification system", function()
    Notify("Vanguard", "Notification system works", Accent, 2.5)
end, Theme.Green)

addButton(Home, "Reset Settings", "returns all visuals to defaults", function()
    Settings.Blur = true
    Settings.Stars = true
    Settings.RGB = false
    Settings.Crosshair = true
    Settings.FOVChanger = false
    Settings.FOVValue = 80
    Settings.FullBright = false
    Settings.NoFog = false
    Settings.LockTime = false
    Settings.TimeValue = 14
    Settings.FPSCounter = true

    blur.Size = 14
    Lighting.Brightness = DefaultLighting.Brightness
    Lighting.Ambient = DefaultLighting.Ambient
    Lighting.OutdoorAmbient = DefaultLighting.OutdoorAmbient
    Lighting.FogEnd = DefaultLighting.FogEnd
    Lighting.ClockTime = DefaultLighting.ClockTime
    Lighting.GlobalShadows = DefaultLighting.GlobalShadows
    Camera.FieldOfView = DefaultFOV

    if BG then BG.Visible = true end
    createStars()
    refreshAccentUI()
    Notify("Reset", "All settings restored", Theme.Yellow, 2.5)
end, Theme.Red)

section(Home, "IMPORTANT", "this file is intentionally safe and stable")
addButton(Home, "What works", "blur, rgb, crosshair, fov, bright, fog, time", function()
    Notify("Working", "Visual controls are active", Theme.Green, 2.5)
end)

--====================================================
-- VISUALS TAB
--====================================================
section(Visuals, "VISUAL EFFECTS", "these are cosmetic and safe")

addToggle(Visuals, "Blur", "soft background blur", function()
    return Settings.Blur
end, function(v)
    Settings.Blur = v
    blur.Size = v and 14 or 0
    Notify("Blur", v and "enabled" or "disabled", Accent, 2)
end)

addToggle(Visuals, "Stars Background", "animated star field", function()
    return Settings.Stars
end, function(v)
    Settings.Stars = v
    BG.Visible = v
    Notify("Stars", v and "enabled" or "disabled", Accent, 2)
end)

addToggle(Visuals, "RGB Accent", "cycles menu accent color", function()
    return Settings.RGB
end, function(v)
    Settings.RGB = v
    Notify("RGB", v and "enabled" or "disabled", Accent, 2)
end)

addToggle(Visuals, "Crosshair", "simple centered crosshair", function()
    return Settings.Crosshair
end, function(v)
    Settings.Crosshair = v
    Cross.Visible = v
    Notify("Crosshair", v and "enabled" or "disabled", Accent, 2)
end)

addToggle(Visuals, "FOV Changer", "changes camera fov", function()
    return Settings.FOVChanger
end, function(v)
    Settings.FOVChanger = v
    Camera.FieldOfView = v and Settings.FOVValue or DefaultFOV
    Notify("FOV", v and "enabled" or "disabled", Accent, 2)
end)

addSlider(Visuals, "FOV Value", 50, 120, 80, function(v)
    Settings.FOVValue = v
    if Settings.FOVChanger then
        Camera.FieldOfView = v
    end
end)

--====================================================
-- WORLD TAB
--====================================================
section(World, "LIGHTING", "adjust environment for your own game or testing")

addToggle(World, "FullBright", "max brightness and shadowless lighting", function()
    return Settings.FullBright
end, function(v)
    Settings.FullBright = v
    if v then
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = DefaultLighting.Brightness
        Lighting.Ambient = DefaultLighting.Ambient
        Lighting.OutdoorAmbient = DefaultLighting.OutdoorAmbient
        Lighting.GlobalShadows = DefaultLighting.GlobalShadows
    end
    Notify("FullBright", v and "enabled" or "disabled", Accent, 2)
end)

addToggle(World, "No Fog", "removes fog distance", function()
    return Settings.NoFog
end, function(v)
    Settings.NoFog = v
    Lighting.FogEnd = v and 100000 or DefaultLighting.FogEnd
    Notify("Fog", v and "removed" or "restored", Accent, 2)
end)

addToggle(World, "Lock Time", "keeps a fixed clock time", function()
    return Settings.LockTime
end, function(v)
    Settings.LockTime = v
    Lighting.ClockTime = v and Settings.TimeValue or DefaultLighting.ClockTime
    Notify("Time", v and "locked" or "unlocked", Accent, 2)
end)

addSlider(World, "Clock Time", 0, 24, 14, function(v)
    Settings.TimeValue = v
    if Settings.LockTime then
        Lighting.ClockTime = v
    end
end)

--====================================================
-- UI TAB
--====================================================
section(UIPage, "INTERFACE", "ui and helper features")

addToggle(UIPage, "Notifications", "popup messages on actions", function()
    return Settings.Notifications
end, function(v)
    Settings.Notifications = v
    Notify("Notifications", v and "enabled" or "disabled", Accent, 2)
end)

addToggle(UIPage, "FPS Counter", "top-left framerate label", function()
    return Settings.FPSCounter
end, function(v)
    Settings.FPSCounter = v
    FPS.Visible = v
    Notify("FPS", v and "shown" or "hidden", Accent, 2)
end)

addButton(UIPage, "Set Accent to Purple", "returns accent color to default", function()
    Accent = Theme.Accent
    MainStroke.Color = Accent
    HeaderLine.BackgroundColor3 = Accent
    SideLine.BackgroundColor3 = Accent
    FPS.TextColor3 = Accent
    CHLeft.BackgroundColor3 = Accent
    CHRight.BackgroundColor3 = Accent
    CHTop.BackgroundColor3 = Accent
    CHBottom.BackgroundColor3 = Accent
    CHDot.BackgroundColor3 = Accent
    refreshAccentUI()
    Notify("Accent", "default purple applied", Accent, 2)
end)

addButton(UIPage, "Hide Menu", "same as clicking close", function()
    Main.Visible = false
end, Theme.Yellow)

--====================================================
-- MISC TAB
--====================================================
section(Misc, "UTILITY", "simple control buttons")

addButton(Misc, "Show Menu", "open the interface again", function()
    Main.Visible = true
end, Theme.Green)

addButton(Misc, "Close Menu", "hide the interface", function()
    Main.Visible = false
end, Theme.Red)

addButton(Misc, "Rebuild Stars", "refresh star background", function()
    createStars()
    BG.Visible = Settings.Stars
    Notify("Stars", "background refreshed", Accent, 2)
end)

addButton(Misc, "Reset Lighting", "restore default lighting values", function()
    Settings.FullBright = false
    Settings.NoFog = false
    Settings.LockTime = false
    Lighting.Brightness = DefaultLighting.Brightness
    Lighting.Ambient = DefaultLighting.Ambient
    Lighting.OutdoorAmbient = DefaultLighting.OutdoorAmbient
    Lighting.FogEnd = DefaultLighting.FogEnd
    Lighting.ClockTime = DefaultLighting.ClockTime
    Lighting.GlobalShadows = DefaultLighting.GlobalShadows
    Notify("Lighting", "restored to defaults", Accent, 2)
end, Theme.Yellow)

--====================================================
-- DEFAULT TAB
--====================================================
switchTab("Home")

--====================================================
-- ACCENT RGB LOOP + CROSSHAIR / FPS / SETTINGS APPLY
--====================================================
local fpsCounter = 60
local fpsFrames = 0
local fpsTimer = 0
local hue = 0

RunService.RenderStepped:Connect(function(dt)
    -- FPS
    fpsFrames += 1
    fpsTimer += dt
    if fpsTimer >= 1 then
        fpsCounter = fpsFrames
        fpsFrames = 0
        fpsTimer = 0
        FPS.Text = "FPS: " .. tostring(fpsCounter)
    end
    FPS.Visible = Settings.FPSCounter

    -- RGB
    if Settings.RGB then
        hue = (hue + dt * 0.15) % 1
        Accent = Color3.fromHSV(hue, 0.9, 1)
    else
        Accent = Theme.Accent
    end

    -- Apply accent to main UI
    MainStroke.Color = Accent
    HeaderLine.BackgroundColor3 = Accent
    SideLine.BackgroundColor3 = Accent
    FPS.TextColor3 = Accent

    -- Crosshair
    Cross.Visible = Settings.Crosshair
    local vp = Camera.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2
    local size = 10
    local gap = 5
    local thick = 2

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

    CHLeft.BackgroundColor3 = Accent
    CHRight.BackgroundColor3 = Accent
    CHTop.BackgroundColor3 = Accent
    CHBottom.BackgroundColor3 = Accent
    CHDot.BackgroundColor3 = Accent

    -- Blur
    blur.Size = Settings.Blur and 14 or 0

    -- Lighting
    if Settings.FullBright then
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
    end
    if Settings.NoFog then
        Lighting.FogEnd = 100000
    end
    if Settings.LockTime then
        Lighting.ClockTime = Settings.TimeValue
    end

    -- FOV
    if Settings.FOVChanger then
        Camera.FieldOfView = Settings.FOVValue
    else
        Camera.FieldOfView = DefaultFOV
    end

    -- Update stars visibility
    BG.Visible = Settings.Stars

    -- Refresh accent-dependent UI
    refreshAccentUI()
end)

--====================================================
-- MENU KEY
--====================================================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

--====================================================
-- STARTUP NOTIF
--====================================================
task.spawn(function()
    task.wait(0.5)
    Notify("Vanguard", "Menu loaded successfully", Accent, 2.5)
    task.wait(0.4)
    Notify("Hint", "RightShift toggles the menu", Theme.Green, 2.5)
end)
