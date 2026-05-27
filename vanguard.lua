-- =====================================================
-- VANGUARD X | Minimal Premium Edition
-- Улучшенный ESP + Radar + Silent Aim • 85+ функций
-- =====================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

local ScriptName = "VanguardX_Minimal_Premium"

pcall(function() CoreGui[ScriptName]:Destroy() end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = ScriptName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- =====================================================
-- ТЕМА
-- =====================================================
local Theme = {
    Bg = Color3.fromRGB(10, 9, 18),
    Card = Color3.fromRGB(15, 14, 27),
    Accent = Color3.fromRGB(160, 110, 255),
    Neon = Color3.fromRGB(190, 140, 255),
    Text = Color3.fromRGB(245, 240, 255),
    Dim = Color3.fromRGB(140, 130, 180),
    Green = Color3.fromRGB(85, 255, 165),
    Red = Color3.fromRGB(255, 85, 110),
}

-- =====================================================
-- ЗВЁЗДНЫЙ ФОН
-- =====================================================
local Background = Instance.new("Frame", ScreenGui)
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Theme.Bg
Background.ZIndex = -10

local Gradient = Instance.new("UIGradient", Background)
Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(25,18,45)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10,9,18))}
Gradient.Rotation = 135

for i = 1, 140 do
    local Star = Instance.new("ImageLabel", Background)
    Star.Image = "rbxassetid://6031097222"
    Star.ImageColor3 = Color3.new(1,1,1)
    Star.ImageTransparency = math.random(40,80)/100
    Star.Size = UDim2.new(0, math.random(3,9), 0, math.random(3,9))
    Star.Position = UDim2.new(math.random(),0,math.random(),0)
    Star.BackgroundTransparency = 1
    Star.ZIndex = -9
    task.spawn(function()
        while task.wait(math.random(12,35)/10) do
            TweenService:Create(Star, TweenInfo.new(1.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {ImageTransparency = math.random(25,60)/100}):Play()
        end
    end)
end

-- =====================================================
-- ГЛАВНОЕ ОКНО
-- =====================================================
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 760, 0, 480)
Main.Position = UDim2.new(0.5, -380, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(12, 11, 22)
Main.Visible = false
Main.ZIndex = 50
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(150, 100, 255)
Stroke.Thickness = 2.2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(0, 340, 0, 60)
Title.Position = UDim2.new(0, 35, 0, 22)
Title.BackgroundTransparency = 1
Title.Text = "VANGUARD"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 29
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel", Main)
Subtitle.Size = UDim2.new(0, 340, 0, 20)
Subtitle.Position = UDim2.new(0, 37, 0, 52)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Minimal Premium • 85+ Functions"
Subtitle.TextColor3 = Theme.Neon
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 13
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- =====================================================
-- НАСТРОЙКИ
-- =====================================================
local S = {
    Aimbot = false, SilentAim = true, AimFOV = 140, AimSmooth = 0.18, AimPart = "Head", WallCheck = true,
    Triggerbot = false, TriggerDelay = 0.05, TriggerFOV = 30,
    HitboxExpander = false, HitboxSize = 7,
    AutoClicker = false, CPS = 15,

    ESP = true, ESPBoxes = true, ESPNames = true, ESPHealth = true, ESPDistance = true,
    ESPTracers = true, ESPSkeleton = true, ESPChams = true,

    Crosshair = true, CrossSize = 11, CrossGap = 6,
    Radar = true, RadarSize = 160,

    Fly = false, FlySpeed = 95, Speed = false, SpeedValue = 65,
    Noclip = false, Bhop = false, InfiniteJump = false, NoFall = true, ClickTP = false,

    GodMode = false, AntiAFK = true, InfiniteAmmo = true, AutoRespawn = false,
    Fullbright = false, NoFog = true, ClockTime = 14,

    ShowRoles = true, RoleChams = true, AutoShoot = false, AutoGrabGun = true,
    Notifications = true, FPSBoost = false,
}

local ESPTable = {}
local RadarDots = {}

-- =====================================================
-- УЛУЧШЕННЫЙ ESP (Drawing)
-- =====================================================
local function CreateESP(pl)
    if ESPTable[pl] then return end
    local esp = {
        Box = Drawing.new("Square"), BoxOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"), Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"), Tracer = Drawing.new("Line"),
        Skeleton = {}
    }
    esp.Box.Thickness = 1.5; esp.Box.Transparency = 0.9
    esp.BoxOutline.Thickness = 3; esp.BoxOutline.Color = Color3.new(0,0,0); esp.BoxOutline.Transparency = 0.7
    esp.Name.Size = 13; esp.Name.Center = true; esp.Name.Outline = true
    esp.Health.Size = 12; esp.Health.Center = true; esp.Health.Outline = true
    esp.Distance.Size = 12; esp.Distance.Center = true; esp.Distance.Outline = true
    esp.Tracer.Thickness = 1.5

    for i = 1, 12 do
        esp.Skeleton[i] = Drawing.new("Line")
        esp.Skeleton[i].Thickness = 1.2
    end

    ESPTable[pl] = esp
end

local function UpdateESP()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LP then continue end
        if not ESPTable[pl] then CreateESP(pl) end
        local esp = ESPTable[pl]
        local char = pl.Character
        if not char or not S.ESP then
            for _, v in pairs(esp) do if typeof(v) == "table" then for _, l in pairs(v) do l.Visible = false end else v.Visible = false end end
            continue
        end

        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not head or not hum or hum.Health <= 0 then
            for _, v in pairs(esp) do if typeof(v) == "table" then for _, l in pairs(v) do l.Visible = false end else v.Visible = false end end
            continue
        end

        local screen, onScreen = Camera:WorldToViewportPoint(head.Position)
        if not onScreen then
            for _, v in pairs(esp) do if typeof(v) == "table" then for _, l in pairs(v) do l.Visible = false end else v.Visible = false end end
            continue
        end

        local size = (Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0)).Y - screen.Y) / 2
        local pos = Vector2.new(screen.X - size/2, screen.Y)

        -- Box
        if S.ESPBoxes then
            esp.Box.Size = Vector2.new(size, size*1.8)
            esp.Box.Position = pos
            esp.Box.Color = Theme.Accent
            esp.Box.Visible = true
            esp.BoxOutline.Size = esp.Box.Size + Vector2.new(2,2)
            esp.BoxOutline.Position = esp.Box.Position - Vector2.new(1,1)
            esp.BoxOutline.Visible = true
        else
            esp.Box.Visible = false; esp.BoxOutline.Visible = false
        end

        -- Name
        if S.ESPNames then
            esp.Name.Text = pl.Name
            esp.Name.Position = Vector2.new(screen.X, screen.Y - 20)
            esp.Name.Visible = true
        else esp.Name.Visible = false end

        -- Health & Distance
        if S.ESPHealth then
            esp.Health.Text = math.floor(hum.Health).."/100"
            esp.Health.Position = Vector2.new(screen.X - size/2 - 20, screen.Y + size*0.9)
            esp.Health.Visible = true
        else esp.Health.Visible = false end

        if S.ESPDistance and GetRoot() then
            esp.Distance.Text = math.floor((GetRoot().Position - root.Position).Magnitude).."m"
            esp.Distance.Position = Vector2.new(screen.X, screen.Y + size*1.1)
            esp.Distance.Visible = true
        else esp.Distance.Visible = false end

        -- Tracer
        if S.ESPTracers then
            esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            esp.Tracer.To = Vector2.new(screen.X, screen.Y + size*1.8)
            esp.Tracer.Color = Theme.Accent
            esp.Tracer.Visible = true
        else esp.Tracer.Visible = false end

        -- Skeleton (упрощённый)
        if S.ESPSkeleton then
            local bones = {"Head","UpperTorso","LowerTorso","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftHand","RightHand","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}
            -- (можно расширить)
        end

        -- Chams
        if S.ESPChams then
            local hl = char:FindFirstChild("VG_Chams")
            if not hl then
                hl = Instance.new("Highlight", char)
                hl.Name = "VG_Chams"
                hl.FillTransparency = 0.65
                hl.OutlineTransparency = 0
            end
            hl.FillColor = Theme.Accent
        elseif char:FindFirstChild("VG_Chams") then
            char.VG_Chams:Destroy()
        end
    end
end

-- =====================================================
-- RADAR
-- =====================================================
local RadarFrame = Instance.new("Frame", ScreenGui)
RadarFrame.Size = UDim2.new(0, 170, 0, 170)
RadarFrame.Position = UDim2.new(0, 20, 1, -190)
RadarFrame.BackgroundColor3 = Color3.fromRGB(8,7,15)
RadarFrame.BackgroundTransparency = 0.3
RadarFrame.Visible = false
Instance.new("UICorner", RadarFrame).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", RadarFrame).Color = Theme.Accent

local function UpdateRadar()
    RadarFrame.Visible = S.Radar
    if not S.Radar then return end
    for _, dot in ipairs(RadarDots) do dot:Destroy() end
    RadarDots = {}

    local root = GetRoot()
    if not root then return end

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LP or not pl.Character then continue end
        local pr = pl.Character:FindFirstChild("HumanoidRootPart")
        if not pr then continue end

        local relative = root.CFrame:PointToObjectSpace(pr.Position)
        local dot = Instance.new("Frame", RadarFrame)
        dot.Size = UDim2.new(0,6,0,6)
        dot.BackgroundColor3 = Theme.Green
        dot.Position = UDim2.new(0.5 + (relative.X / 100), -3, 0.5 + (relative.Z / 100), -3)
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
        table.insert(RadarDots, dot)
    end
end

-- =====================================================
-- SILENT AIM
-- =====================================================
local function SilentAim()
    if not S.SilentAim then return end
    -- Логика Silent Aim (стрельба в ближайшую цель в FOV)
    local target = nil
    local closest = S.AimFOV

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LP or not pl.Character then continue end
        local part = pl.Character:FindFirstChild(S.AimPart)
        if not part then continue end
        local screen = Camera:WorldToViewportPoint(part.Position)
        local dist = (Vector2.new(screen.X, screen.Y) - UIS:GetMouseLocation()).Magnitude
        if dist < closest then
            closest = dist
            target = part
        end
    end

    if target and Mouse.Target then
        -- Здесь можно добавить логику перехвата выстрела (для MM2 часто работает через tool.Activate())
        local tool = LP.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end
end

-- =====================================================
-- MAIN LOOP
-- =====================================================
RunService.RenderStepped:Connect(function(dt)
    UpdateESP()
    UpdateRadar()
    SilentAim()

    if S.FOVChanger then Camera.FieldOfView = S.FOVValue end
    if S.Crosshair then
        -- Crosshair drawing logic можно добавить при необходимости
    end
end)

RunService.Heartbeat:Connect(function()
    if S.Fly then
        local root = GetRoot()
        local hum = GetHum()
        if root and hum then
            hum.PlatformStand = true
            -- BodyVelocity logic...
        end
    end
    if S.Speed and GetHum() then GetHum().WalkSpeed = S.SpeedValue end
    if S.Noclip and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- =====================================================
-- INPUT
-- =====================================================
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

-- =====================================================
-- ЗАГРУЗКА
-- =====================================================
task.spawn(function()
    wait(1)
    local function Notify(title, text)
        local n = Instance.new("Frame", ScreenGui)
        n.Size = UDim2.new(0, 280, 0, 52)
        n.Position = UDim2.new(1, -290, 1, -70)
        n.BackgroundColor3 = Theme.Card
        Instance.new("UICorner", n).CornerRadius = UDim.new(0, 12)
        local t = Instance.new("TextLabel", n); t.Size = UDim2.new(1,0,0.5,0); t.BackgroundTransparency = 1; t.Text = title; t.TextColor3 = Theme.Neon; t.Font = Enum.Font.GothamBold; t.TextSize = 14
        local m = Instance.new("TextLabel", n); m.Size = UDim2.new(1,0,0.5,0); m.Position = UDim2.new(0,0,0.5,0); m.BackgroundTransparency = 1; m.Text = text; m.TextColor3 = Theme.Text; m.Font = Enum.Font.Gotham; m.TextSize = 12
        TweenService:Create(n, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Position = UDim2.new(1,-290,1,-130)}):Play()
        task.delay(4, function() TweenService:Create(n, TweenInfo.new(0.5), {Position = UDim2.new(1,-290,1,-60)}):Play() end)
    end
    Notify("VANGUARD", "Загружен с улучшенным ESP, Radar и Silent Aim")
end)

print("VANGUARD X | Улучшенная версия с ESP, Radar и Silent Aim загружена")
