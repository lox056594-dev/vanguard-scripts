if not game:IsLoaded() then game.Loaded:Wait() end

-- ══════════════════════════════════════
-- СЕРВИСЫ
-- ══════════════════════════════════════
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")
local Lighting     = game:GetService("Lighting")
local Debris       = game:GetService("Debris")
local HttpService  = game:GetService("HttpService")
local LP           = Players.LocalPlayer
local Cam          = workspace.CurrentCamera
local Mouse        = LP:GetMouse()

-- ══════════════════════════════════════
-- ОЧИСТКА
-- ══════════════════════════════════════
pcall(function()
    for _,n in ipairs({
        "VanguardX_v25","VanguardX_v26","VanguardX_v27",
        "VanguardX_v28","VanguardX_v29"
    }) do
        local a = CoreGui:FindFirstChild(n)
        if a then a:Destroy() end
        local b = LP.PlayerGui:FindFirstChild(n)
        if b then b:Destroy() end
    end
end)

-- ══════════════════════════════════════
-- ОПРЕДЕЛЕНИЕ ИСПОЛНИТЕЛЯ
-- ══════════════════════════════════════
local executor = "unknown"
if syn then executor = "synapse"
elseif KRNL_LOADED then executor = "krnl"
elseif rconsoleprint then executor = "script-ware"
else executor = "other" end

local hasDrawing = false
pcall(function()
    local t = Drawing.new("Circle")
    t:Remove()
    hasDrawing = true
end)

-- Проверка функций
local hasMouseMove = pcall(function() mousemoverel(0,0) end)
local hasFireClickDetector = pcall(function() firetouchinterest(workspace,workspace,0) end)

-- ══════════════════════════════════════
-- ЦВЕТА
-- ══════════════════════════════════════
local C = {
    P   = Color3.fromRGB(138,43,226),
    PA  = Color3.fromRGB(180,100,255),
    BG  = Color3.fromRGB(8,6,16),
    BG2 = Color3.fromRGB(13,9,22),
    BG3 = Color3.fromRGB(19,13,32),
    TXT = Color3.fromRGB(235,225,255),
    DIM = Color3.fromRGB(110,90,155),
    GRN = Color3.fromRGB(50,255,120),
    RED = Color3.fromRGB(255,60,80),
    YLW = Color3.fromRGB(255,210,50),
    ORG = Color3.fromRGB(255,140,40),
    PNK = Color3.fromRGB(255,80,180),
    CYN = Color3.fromRGB(40,200,255),
    WHT = Color3.new(1,1,1),
    MM2 = Color3.fromRGB(220,30,30),
}

-- ══════════════════════════════════════
-- НАСТРОЙКИ (STATE)
-- ══════════════════════════════════════
local S = {
    -- AIMBOT
    AimOn       = false,
    AimFOV      = 150,
    AimSmooth   = 0.25,  -- 0.1 = быстро, 1.0 = медленно
    AimPred     = 0.05,
    AimBone     = "Head",
    AimFOVShow  = true,
    AimWall     = false,  -- false = только видимые
    AimTeam     = false,
    AimHold     = true,   -- true = ПКМ, false = toggle

    -- TRIGGERBOT
    TrigOn      = false,
    TrigDelay   = 0.05,
    TrigFOV     = 20,
    TrigWall    = false,  -- false = не сквозь стены

    -- COMBAT
    HitboxOn    = false,
    HitboxSize  = 6,
    AutoClick   = false,
    AutoCPS     = 10,

    -- ESP
    ESPOn       = false,
    ESPBox      = true,
    ESPName     = true,
    ESPHPbar    = true,
    ESPDist     = true,
    ESPTracer   = false,
    ESPSkel     = false,
    ESPChams    = false,
    ESPCol      = Color3.fromRGB(138,43,226),

    -- CROSSHAIR
    Crosshair   = false,
    CrossSize   = 10,
    CrossGap    = 4,
    CrossThick  = 2,
    CrossDot    = true,

    -- UI
    Radar       = false,
    RadarSize   = 150,
    FOVChange   = false,
    FOVVal      = 90,
    RGB         = false,

    -- MOVEMENT
    FlyOn       = false,
    FlySpeed    = 80,
    SpeedOn     = false,
    SpeedVal    = 60,
    NoclipOn    = false,
    BhopOn      = false,
    InfJump     = false,
    NoFall      = false,
    LowGrav     = false,
    GravVal     = 50,
    HighJump    = false,
    JumpVal     = 80,
    ClickTP     = false,

    -- TROLLING
    AttachOn    = false,
    AttachTarget= "[Ближайший]",
    AttachBone  = "Голова",
    AttachSpeed = 8,
    AttachAmp   = 2,
    SexOn       = false,
    SexTarget   = "[Ближайший]",
    SexBone     = "Низ спины",
    SexSpeed    = 12,
    SexDist     = 2,
    FlingOn     = false,
    FlingTarget = "[Ближайший]",
    FlingPower  = 200,
    OrbitOn     = false,
    OrbitTarget = "[Ближайший]",
    OrbitRadius = 8,
    OrbitSpeed  = 2,
    OrbitHeight = 0,
    SpinOn      = false,
    SpinSpeed   = 15,

    -- PLAYER
    GodMode     = false,
    AntiAFK     = false,
    InfAmmo     = false,
    AutoRespawn = false,

    -- WORLD
    Fullbright  = false,
    NightMode   = false,
    TimeFreeze  = false,
    TimeVal     = 14,
    AntiBlur    = false,

    -- MM2
    MM2Roles    = true,
    MM2Chams    = true,
    MM2AutoShoot= false,
    MM2ShootDelay=0.3,
    MM2AutoThrow= false,
    MM2ThrowTarget="[Маржер]",
    MM2ThrowDelay=0.8,
    MM2AutoGrab = false,

    -- MISC
    Notifs      = true,
    FPSBoost    = false,

    _flingT     = "[Ближайший]",
}

local Binds = {
    Menu  = Enum.KeyCode.RightShift,
    Aim   = Enum.KeyCode.Unknown,
    Fly   = Enum.KeyCode.Unknown,
    Speed = Enum.KeyCode.Unknown,
    ESP   = Enum.KeyCode.Unknown,
    NC    = Enum.KeyCode.Unknown,
    Fling = Enum.KeyCode.Unknown,
}

-- ══════════════════════════════════════
-- ХЕЛПЕРЫ
-- ══════════════════════════════════════
local function Ch()
    return LP.Character
end
local function Ro()
    local c = Ch()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function Hu()
    local c = Ch()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function HP()
    local h = Hu()
    return h and h.Health or 0
end

local function Tw(o,t,p,s,d)
    pcall(function()
        TweenService:Create(
            o,
            TweenInfo.new(t, s or Enum.EasingStyle.Quint, d or Enum.EasingDirection.Out),
            p
        ):Play()
    end)
end

-- ════════════════════════
-- RAYCAST ВИДИМОСТЬ
-- ════════════════════════
local function castRay(from, to, ignoreList)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = ignoreList or {}
    local dir = to - from
    return workspace:Raycast(from, dir, rp)
end

local function isVisible(part)
    if not part then return false end
    local ignore = {Cam}
    local c = Ch()
    if c then table.insert(ignore, c) end
    local res = castRay(Cam.CFrame.Position, part.Position, ignore)
    if not res then return true end
    -- Проверяем попали ли в персонажа врага
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character then
            if res.Instance:IsDescendantOf(pl.Character) then
                return true
            end
        end
    end
    return false
end

-- ════════════════════════
-- ИГРОКИ
-- ════════════════════════
local function nearestPlayer(filterFn)
    local best, bd = nil, math.huge
    local myRoot = Ro()
    if not myRoot then return nil end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LP then continue end
        if filterFn and not filterFn(pl) then continue end
        local ch = pl.Character
        if not ch then continue end
        local r = ch:FindFirstChild("HumanoidRootPart")
        local h = ch:FindFirstChildOfClass("Humanoid")
        if r and h and h.Health > 0 then
            local d = (myRoot.Position - r.Position).Magnitude
            if d < bd then bd = d; best = pl end
        end
    end
    return best
end

local MM2State = {
    murderer = nil,
    sheriff  = nil,
    roles    = {},
}

local function getMM2Role(pl)
    -- Кэш ролей
    if MM2State.roles[pl] then
        return MM2State.roles[pl]
    end
    return "Innocent"
end

local function detectMM2Roles()
    MM2State.murderer = nil
    MM2State.sheriff  = nil
    MM2State.roles    = {}

    for _, pl in ipairs(Players:GetPlayers()) do
        local role = "Innocent"
        pcall(function()
            local ch = pl.Character
            if not ch then return end

            -- Метод 1: Наличие инструмента в руке
            for _, obj in ipairs(ch:GetChildren()) do
                local n = obj.Name:lower()
                if obj:IsA("Tool") then
                    if n:find("knife") or n:find("blade") then
                        role = "Murderer"
                    elseif n:find("gun") or n:find("sheriff") or n:find("revolver") or n:find("pistol") then
                        role = "Sheriff"
                    end
                end
            end
        end)

        pcall(function()
            -- Метод 2: PlayerGui
            local pg = pl:FindFirstChild("PlayerGui")
            if pg then
                for _, gui in ipairs(pg:GetDescendants()) do
                    if gui:IsA("TextLabel") or gui:IsA("TextBox") then
                        local t = gui.Text:lower()
                        if t == "murderer" or t == "мажер" or t == "убийца" then
                            role = "Murderer"
                        elseif t == "sheriff" or t == "шериф" then
                            role = "Sheriff"
                        end
                    end
                end
            end
        end)

        pcall(function()
            -- Метод 3: leaderstats
            local ls = pl:FindFirstChild("leaderstats")
            if ls then
                for _, v in ipairs(ls:GetChildren()) do
                    local val = tostring(v.Value):lower()
                    if val:find("murder") then role = "Murderer"
                    elseif val:find("sheriff") then role = "Sheriff" end
                end
            end
        end)

        pcall(function()
            -- Метод 4: ReplicatedStorage / папки
            local rs = game:GetService("ReplicatedStorage")
            for _, folder in ipairs({rs, workspace}) do
                for _, child in ipairs(folder:GetChildren()) do
                    if child.Name:lower():find("murder") or child.Name:lower():find("game") then
                        for _, v in ipairs(child:GetDescendants()) do
                            if v:IsA("ObjectValue") and v.Value == pl then
                                local n = v.Parent and v.Parent.Name:lower() or v.Name:lower()
                                if n:find("murder") then role = "Murderer"
                                elseif n:find("sheriff") then role = "Sheriff" end
                            end
                            if v:IsA("StringValue") and v.Value == pl.Name then
                                local n = v.Parent and v.Parent.Name:lower() or v.Name:lower()
                                if n:find("murder") then role = "Murderer"
                                elseif n:find("sheriff") then role = "Sheriff" end
                            end
                        end
                    end
                end
            end
        end)

        MM2State.roles[pl] = role
        if role == "Murderer" and pl ~= LP then MM2State.murderer = pl end
        if role == "Sheriff"  and pl ~= LP then MM2State.sheriff  = pl end
    end
end

local function findPlayer(name)
    if not name or name == "[Ближайший]" then return nearestPlayer() end
    if name == "[Маржер]" then return MM2State.murderer end
    if name == "[Шериф]"  then return MM2State.sheriff  end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Name == name then return pl end
    end
    return nearestPlayer()
end

local function playerList()
    local t = {"[Ближайший]", "[Маржер]", "[Шериф]"}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP then table.insert(t, pl.Name) end
    end
    return t
end

-- ════════════════════════
-- FLING — РАБОЧИЙ СПОСОБ
-- Единственный способ кинуть игрока со стороны клиента:
-- 1) Телепорт ВНУТРЬ цели
-- 2) Убираем CanCollide с себя
-- 3) Включаем CanCollide — физический движок создаёт импульс
-- Для максимального эффекта используем BodyVelocity НА СЕБЯ
-- ════════════════════════
local flingBusy = false

local function doFling(targetName, dir)
    if flingBusy then return end
    flingBusy = true

    local pl = findPlayer(targetName)
    if not pl or not pl.Character then
        flingBusy = false
        return
    end

    local theirRoot = pl.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = Ro()
    local myHum = Hu()
    if not theirRoot or not myRoot then
        flingBusy = false
        return
    end

    local savedCF    = myRoot.CFrame
    local savedGrav  = workspace.Gravity
    local power      = S.FlingPower

    pcall(function()
        -- Шаг 1: Отключаем гравитацию и физику
        workspace.Gravity = 0
        if myHum then
            myHum.PlatformStand = true
            myHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            myHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        end

        -- Шаг 2: Убираем коллизии с себя
        local ch = Ch()
        if ch then
            for _, p in ipairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end

        -- Шаг 3: Телепортируемся внутрь цели
        myRoot.CFrame = theirRoot.CFrame * CFrame.new(0, 0, 0)
    end)

    task.wait() -- Один физический тик

    pcall(function()
        -- Шаг 4: Включаем коллизии — теперь мы ВНУТРИ
        local ch = Ch()
        if ch then
            for _, p in ipairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end

        -- Шаг 5: Создаём BodyVelocity на СЕБЯ
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1,1,1) * math.huge
        bv.P        = math.huge
        bv.Name     = "VG_FLV"

        -- Направление
        local velocity
        if dir == "up" then
            velocity = Vector3.new(0, power, 0)
        elseif dir == "forward" then
            velocity = myRoot.CFrame.LookVector * power + Vector3.new(0, power * 0.3, 0)
        elseif dir == "random" then
            local a = math.random() * math.pi * 2
            velocity = Vector3.new(
                math.cos(a) * power * 0.7,
                power * 0.9,
                math.sin(a) * power * 0.7
            )
        else
            velocity = Vector3.new(0, power, 0)
        end

        bv.Velocity = velocity
        bv.Parent   = myRoot
        Debris:AddItem(bv, 0.2)

        -- Вращение себя для эффекта
        local ba = Instance.new("BodyAngularVelocity")
        ba.MaxTorque      = Vector3.new(1,1,1) * math.huge
        ba.AngularVelocity= Vector3.new(
            math.random(-40, 40),
            math.random(-40, 40),
            math.random(-40, 40)
        )
        ba.Name   = "VG_FLBA"
        ba.Parent = myRoot
        Debris:AddItem(ba, 0.2)
    end)

    -- Шаг 6: Возвращаемся через 0.3 секунды
    task.delay(0.35, function()
        pcall(function()
            workspace.Gravity = savedGrav
            if myRoot and myRoot.Parent then
                myRoot.CFrame = savedCF * CFrame.new(0, 4, 0)
            end
            if myHum then
                myHum.PlatformStand = false
                myHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                myHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            end
        end)
        flingBusy = false
    end)
end

-- ════════════════════════
-- AIMBOT — ИСПРАВЛЕННЫЙ
-- Работает через Camera CFrame manipulation
-- Это работает в 100% исполнителей
-- ════════════════════════
local aimActive = false
local menuOpen  = false

local function getBone(char, boneName)
    if not char then return nil end
    return char:FindFirstChild(boneName)
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function getAimTarget()
    local myRoot = Ro()
    if not myRoot then return nil end

    local mousePos = UIS:GetMouseLocation()
    local bestPart = nil
    local bestDist = S.AimFOV

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LP then continue end

        local ch = pl.Character
        if not ch then continue end

        local hm = ch:FindFirstChildOfClass("Humanoid")
        if not hm or hm.Health <= 0 then continue end

        local bone = getBone(ch, S.AimBone)
        if not bone then continue end

        -- Проверка стен
        if not S.AimWall then
            if not isVisible(bone) then continue end
        end

        -- Предикшн движения
        local vel = Vector3.new()
        pcall(function() vel = bone.AssemblyLinearVelocity end)
        local predPos = bone.Position + vel * S.AimPred

        -- Переводим в экранные координаты
        local screenPos, onScreen = Cam:WorldToViewportPoint(predPos)
        if not onScreen then continue end

        -- Расстояние на экране
        local sDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

        if sDist < bestDist then
            bestDist = sDist
            bestPart = {
                part    = bone,
                predPos = predPos,
                screenX = screenPos.X,
                screenY = screenPos.Y,
                player  = pl,
            }
        end
    end

    return bestPart
end

-- Основной метод: плавный поворот камеры
-- Это работает всегда в отличие от mousemoverel
local function doAim(dt)
    local target = getAimTarget()
    if not target then return end

    -- Метод 1: CFrame камеры (100% работает везде)
    pcall(function()
        local goalCF = CFrame.lookAt(
            Cam.CFrame.Position,
            Vector3.new(target.predPos.X, target.predPos.Y, target.predPos.Z)
        )
        -- Плавность
        local alpha = math.clamp(dt / S.AimSmooth, 0, 1)
        Cam.CFrame = Cam.CFrame:Lerp(goalCF, alpha)
    end)

    -- Метод 2: mousemoverel (если доступен)
    if hasMouseMove then
        pcall(function()
            local mousePos = UIS:GetMouseLocation()
            local dx = (target.screenX - mousePos.X) * 0.3
            local dy = (target.screenY - mousePos.Y) * 0.3
            mousemoverel(dx, dy)
        end)
    end
end

-- ════════════════════════
-- TRIGGERBOT — ИСПРАВЛЕННЫЙ
-- Стреляет только по видимым (без стен)
-- ════════════════════════
local trigTimer = 0

local function doTrigger()
    local mousePos = UIS:GetMouseLocation()
    local myRoot   = Ro()
    if not myRoot then return end

    -- Raycast из камеры
    local unitRay = Cam:ScreenPointToRay(mousePos.X, mousePos.Y)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local ignores = {Cam}
    if Ch() then table.insert(ignores, Ch()) end
    rp.FilterDescendantsInstances = ignores

    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 2000, rp)

    if not result then return end
    if not result.Instance then return end

    -- Проверяем попали ли в игрока
    local hitPlayer = nil
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character then
            if result.Instance:IsDescendantOf(pl.Character) then
                hitPlayer = pl
                break
            end
        end
    end

    if not hitPlayer then return end

    local hm = hitPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hm or hm.Health <= 0 then return end

    -- ВАЖНО: Проверка видимости (не сквозь стены)
    if not S.TrigWall then
        local head = hitPlayer.Character:FindFirstChild("Head")
        if not head then return end
        if not isVisible(head) then return end
    end

    -- Проверка FOV
    local bone = hitPlayer.Character:FindFirstChild("Head") or hitPlayer.Character:FindFirstChild("HumanoidRootPart")
    if bone then
        local sp, on = Cam:WorldToViewportPoint(bone.Position)
        if on then
            local dist = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
            if dist > S.TrigFOV then return end
        end
    end

    -- Стреляем
    pcall(function()
        if Ch() then
            local tool = Ch():FindFirstChildOfClass("Tool")
            if tool then
                local fireEvent = tool:FindFirstChild("FireEvent")
                    or tool:FindFirstChild("Shoot")
                    or tool:FindFirstChild("Fire")
                if fireEvent and fireEvent:IsA("RemoteEvent") then
                    -- Пробуем через RemoteEvent
                    fireEvent:FireServer()
                else
                    tool:Activate()
                end
            end
        end
        mouse1click()
    end)
end

-- ════════════════════════
-- GUI ROOT
-- ════════════════════════
local GUI = Instance.new("ScreenGui")
GUI.Name             = "VanguardX_v29"
GUI.ResetOnSpawn     = false
GUI.IgnoreGuiInset   = true
GUI.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder     = 99999

local guiOk = pcall(function() GUI.Parent = CoreGui end)
if not guiOk or GUI.Parent ~= CoreGui then
    GUI.Parent = LP:WaitForChild("PlayerGui")
end

-- ════════════════════════
-- NOTIFICATIONS
-- ════════════════════════
local NF = Instance.new("Frame", GUI)
NF.Size                = UDim2.new(0, 310, 1, -10)
NF.Position            = UDim2.new(1, -318, 0, 5)
NF.BackgroundTransparency = 1
NF.ZIndex              = 9999
local NL               = Instance.new("UIListLayout", NF)
NL.VerticalAlignment   = Enum.VerticalAlignment.Bottom
NL.Padding             = UDim.new(0, 5)
local NID              = 0

local function Notify(title, msg, col, dur)
    if not S.Notifs then return end
    NID = NID + 1
    col = col or C.P
    dur = dur or 3

    local f = Instance.new("Frame", NF)
    f.Size              = UDim2.new(1, 0, 0, 0)
    f.BackgroundColor3  = C.BG2
    f.BorderSizePixel   = 0
    f.ClipsDescendants  = true
    f.LayoutOrder       = NID
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)

    local st = Instance.new("UIStroke", f)
    st.Color       = col
    st.Thickness   = 1.5
    st.Transparency = 0.1

    local accent = Instance.new("Frame", f)
    accent.Size            = UDim2.new(0, 3, 1, -12)
    accent.Position        = UDim2.new(0, 5, 0, 6)
    accent.BackgroundColor3 = col
    accent.BorderSizePixel  = 0
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

    local ico = Instance.new("TextLabel", f)
    ico.Size               = UDim2.new(0, 30, 0, 30)
    ico.Position           = UDim2.new(0, 12, 0, 9)
    ico.BackgroundTransparency = 1
    ico.Text               = "◈"
    ico.TextColor3         = col
    ico.Font               = Enum.Font.GothamBold
    ico.TextSize           = 18
    ico.ZIndex             = 2

    local tl = Instance.new("TextLabel", f)
    tl.Size                = UDim2.new(1, -50, 0, 20)
    tl.Position            = UDim2.new(0, 46, 0, 8)
    tl.BackgroundTransparency = 1
    tl.Text                = title
    tl.TextColor3          = C.TXT
    tl.Font                = Enum.Font.GothamBold
    tl.TextSize            = 13
    tl.TextXAlignment      = Enum.TextXAlignment.Left
    tl.ZIndex              = 2

    local sl = Instance.new("TextLabel", f)
    sl.Size                = UDim2.new(1, -50, 0, 14)
    sl.Position            = UDim2.new(0, 46, 0, 28)
    sl.BackgroundTransparency = 1
    sl.Text                = msg
    sl.TextColor3          = C.DIM
    sl.Font                = Enum.Font.Gotham
    sl.TextSize            = 11
    sl.TextXAlignment      = Enum.TextXAlignment.Left
    sl.ZIndex              = 2

    local bar = Instance.new("Frame", f)
    bar.Size               = UDim2.new(1, 0, 0, 2)
    bar.Position           = UDim2.new(0, 0, 1, -2)
    bar.BackgroundColor3   = col
    bar.BorderSizePixel    = 0

    Tw(f, 0.25, {Size = UDim2.new(1, 0, 0, 50)}, Enum.EasingStyle.Back)
    Tw(bar, dur, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear)

    task.delay(dur, function()
        Tw(f, 0.2, {Size = UDim2.new(1, 0, 0, 0)})
        task.delay(0.22, function()
            pcall(function() f:Destroy() end)
        end)
    end)
end

-- ════════════════════════
-- ГЛАВНОЕ ОКНО
-- ════════════════════════
local MW, MH = 940, 620

local Main = Instance.new("Frame", GUI)
Main.Size              = UDim2.new(0, MW, 0, MH)
Main.Position          = UDim2.new(0.5, -MW/2, 0.5, -MH/2)
Main.BackgroundColor3  = C.BG
Main.Visible           = false
Main.BorderSizePixel   = 0
Main.ZIndex            = 100
Main.Active            = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)
local MStk = Instance.new("UIStroke", Main)
MStk.Color       = C.P
MStk.Thickness   = 1.5
MStk.Transparency = 0.1

-- Фон градиент
local MGrad = Instance.new("UIGradient", Main)
MGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 6, 18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 3, 10)),
})
MGrad.Rotation = 120

-- DRAG
do
    local dragging, ds, dp = false, nil, nil
    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; ds = i.Position; dp = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            Main.Position = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- ════════════════════════
-- SIDEBAR
-- ════════════════════════
local SB = Instance.new("Frame", Main)
SB.Size             = UDim2.new(0, 220, 1, 0)
SB.BackgroundColor3 = Color3.fromRGB(7, 5, 15)
SB.BorderSizePixel  = 0
SB.ZIndex           = 101
Instance.new("UICorner", SB).CornerRadius = UDim.new(0, 18)

-- Перекрытие правого скругления
local SBFix = Instance.new("Frame", SB)
SBFix.Size             = UDim2.new(0, 18, 1, 0)
SBFix.Position         = UDim2.new(1, -18, 0, 0)
SBFix.BackgroundColor3 = Color3.fromRGB(7, 5, 15)
SBFix.BorderSizePixel  = 0
SBFix.ZIndex           = 101

-- LOGO AREA
local LogoF = Instance.new("Frame", SB)
LogoF.Size              = UDim2.new(1, 0, 0, 100)
LogoF.BackgroundTransparency = 1
LogoF.ZIndex            = 102

local LogoIco = Instance.new("TextLabel", LogoF)
LogoIco.Size            = UDim2.new(0, 44, 0, 44)
LogoIco.Position        = UDim2.new(0.5, -22, 0, 8)
LogoIco.BackgroundTransparency = 1
LogoIco.Text            = "✦"
LogoIco.TextColor3      = C.P
LogoIco.Font            = Enum.Font.GothamBold
LogoIco.TextSize        = 36
LogoIco.ZIndex          = 103

local LogoTitle = Instance.new("TextLabel", LogoF)
LogoTitle.Size          = UDim2.new(1, 0, 0, 22)
LogoTitle.Position      = UDim2.new(0, 0, 0, 54)
LogoTitle.BackgroundTransparency = 1
LogoTitle.Text          = "VANGUARD X"
LogoTitle.TextColor3    = C.TXT
LogoTitle.Font          = Enum.Font.GothamBold
LogoTitle.TextSize      = 17
LogoTitle.ZIndex        = 103

local LogoVer = Instance.new("TextLabel", LogoF)
LogoVer.Size            = UDim2.new(1, 0, 0, 14)
LogoVer.Position        = UDim2.new(0, 0, 0, 77)
LogoVer.BackgroundTransparency = 1
LogoVer.Text            = "v29.0 — ALL FIXED"
LogoVer.TextColor3      = C.P
LogoVer.Font            = Enum.Font.GothamBold
LogoVer.TextSize        = 9
LogoVer.ZIndex          = 103

-- Разделитель
local SepL = Instance.new("Frame", SB)
SepL.Size              = UDim2.new(0.82, 0, 0, 1)
SepL.Position          = UDim2.new(0.09, 0, 0, 101)
SepL.BackgroundColor3  = C.P
SepL.BackgroundTransparency = 0.6
SepL.BorderSizePixel   = 0
SepL.ZIndex            = 102

-- Tab scroll container
local TabScroll = Instance.new("ScrollingFrame", SB)
TabScroll.Size              = UDim2.new(1, 0, 1, -185)
TabScroll.Position          = UDim2.new(0, 0, 0, 108)
TabScroll.BackgroundTransparency = 1
TabScroll.ScrollBarThickness = 0
TabScroll.CanvasSize        = UDim2.new(0, 0, 0, 0)
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabScroll.BorderSizePixel   = 0
TabScroll.ZIndex            = 102
local TabLayout = Instance.new("UIListLayout", TabScroll)
TabLayout.Padding           = UDim.new(0, 3)
local TabPad = Instance.new("UIPadding", TabScroll)
TabPad.PaddingLeft   = UDim.new(0, 8)
TabPad.PaddingRight  = UDim.new(0, 8)
TabPad.PaddingTop    = UDim.new(0, 3)

-- User info bottom
local SepL2 = Instance.new("Frame", SB)
SepL2.Size             = UDim2.new(0.82, 0, 0, 1)
SepL2.Position         = UDim2.new(0.09, 0, 1, -82)
SepL2.BackgroundColor3 = C.P
SepL2.BackgroundTransparency = 0.6
SepL2.BorderSizePixel  = 0
SepL2.ZIndex           = 102

local UAv = Instance.new("ImageLabel", SB)
UAv.Size              = UDim2.new(0, 34, 0, 34)
UAv.Position          = UDim2.new(0, 10, 1, -68)
UAv.BackgroundColor3  = C.BG3
UAv.ZIndex            = 103
Instance.new("UICorner", UAv).CornerRadius = UDim.new(0, 9)
pcall(function()
    UAv.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
        ..LP.UserId.."&width=60&height=60&format=png"
end)
Instance.new("UIStroke", UAv).Color = C.P

local UNm = Instance.new("TextLabel", SB)
UNm.Size              = UDim2.new(1, -50, 0, 17)
UNm.Position          = UDim2.new(0, 50, 1, -66)
UNm.BackgroundTransparency = 1
UNm.Text              = LP.Name
UNm.TextColor3        = C.TXT
UNm.Font              = Enum.Font.GothamBold
UNm.TextSize          = 12
UNm.TextXAlignment    = Enum.TextXAlignment.Left
UNm.ZIndex            = 103

local URole = Instance.new("TextLabel", SB)
URole.Size            = UDim2.new(1, -50, 0, 12)
URole.Position        = UDim2.new(0, 50, 1, -47)
URole.BackgroundTransparency = 1
URole.Text            = "● VIP Member"
URole.TextColor3      = C.GRN
URole.Font            = Enum.Font.GothamSemibold
URole.TextSize        = 10
URole.TextXAlignment  = Enum.TextXAlignment.Left
URole.ZIndex          = 103

-- ════════════════════════
-- RIGHT AREA
-- ════════════════════════
local RA = Instance.new("Frame", Main)
RA.Size              = UDim2.new(1, -220, 1, 0)
RA.Position          = UDim2.new(0, 220, 0, 0)
RA.BackgroundTransparency = 1
RA.ZIndex            = 101

local RH = Instance.new("Frame", RA)
RH.Size              = UDim2.new(1, 0, 0, 60)
RH.BackgroundTransparency = 1
RH.ZIndex            = 102

local RTitle = Instance.new("TextLabel", RH)
RTitle.Size          = UDim2.new(0.7, 0, 0, 34)
RTitle.Position      = UDim2.new(0, 14, 0, 11)
RTitle.BackgroundTransparency = 1
RTitle.Text          = "MM2"
RTitle.TextColor3    = C.TXT
RTitle.Font          = Enum.Font.GothamBold
RTitle.TextSize      = 24
RTitle.TextXAlignment = Enum.TextXAlignment.Left
RTitle.ZIndex        = 103

local RSubtitle = Instance.new("TextLabel", RH)
RSubtitle.Size       = UDim2.new(0.7, 0, 0, 14)
RSubtitle.Position   = UDim2.new(0, 14, 0, 45)
RSubtitle.BackgroundTransparency = 1
RSubtitle.Text       = "0 активных функций"
RSubtitle.TextColor3 = C.DIM
RSubtitle.Font       = Enum.Font.Gotham
RSubtitle.TextSize   = 10
RSubtitle.TextXAlignment = Enum.TextXAlignment.Left
RSubtitle.ZIndex     = 103

local CloseBtn = Instance.new("TextButton", RH)
CloseBtn.Size        = UDim2.new(0, 30, 0, 30)
CloseBtn.Position    = UDim2.new(1, -40, 0, 14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(140, 20, 42)
CloseBtn.Text        = "✕"
CloseBtn.TextColor3  = C.WHT
CloseBtn.Font        = Enum.Font.GothamBold
CloseBtn.TextSize    = 16
CloseBtn.ZIndex      = 103
CloseBtn.AutoButtonColor = false
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.MouseEnter:Connect(function() Tw(CloseBtn, 0.08, {BackgroundColor3=C.RED}) end)
CloseBtn.MouseLeave:Connect(function() Tw(CloseBtn, 0.08, {BackgroundColor3=Color3.fromRGB(140,20,42)}) end)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; menuOpen = false end)

local RDiv = Instance.new("Frame", RH)
RDiv.Size            = UDim2.new(1, -10, 0, 1)
RDiv.Position        = UDim2.new(0, 5, 1, -1)
RDiv.BackgroundColor3 = C.P
RDiv.BackgroundTransparency = 0.7
RDiv.BorderSizePixel = 0
RDiv.ZIndex          = 102

local ContentArea = Instance.new("Frame", RA)
ContentArea.Size     = UDim2.new(1, 0, 1, -62)
ContentArea.Position = UDim2.new(0, 0, 0, 62)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex   = 101

-- ════════════════════════
-- TAB SYSTEM
-- ════════════════════════
local Tabs      = {}
local ActiveTab = nil

local tabDefs = {
    {id="MM2",      ico="🔪",  label="MM2",      sub="Murder Mystery 2", col=C.MM2},
    {id="Combat",   ico="⚔",  label="Combat",   sub="PVP функции",      col=C.RED},
    {id="Visuals",  ico="👁",  label="Visuals",  sub="ESP & Прицел",     col=C.CYN},
    {id="Trolling", ico="😈",  label="Trolling", sub="Троллинг",         col=C.PNK},
    {id="Movement", ico="⚡",  label="Movement", sub="Движение",         col=C.GRN},
    {id="Player",   ico="👤",  label="Player",   sub="Персонаж",         col=C.YLW},
    {id="World",    ico="🌍",  label="World",    sub="Мир",              col=C.ORG},
    {id="Misc",     ico="⚙",  label="Misc",     sub="Разное",           col=C.P},
    {id="Binds",    ico="⌨",  label="Binds",    sub="Клавиши",          col=C.DIM},
}

local function switchTab(id)
    if ActiveTab == id then return end
    for tid, t in pairs(Tabs) do
        t.page.Visible = false
        Tw(t.btn, 0.1, {BackgroundColor3=C.BG3})
        t.bName.TextColor3 = C.DIM
        Tw(t.bAcc, 0.1, {BackgroundTransparency=1})
    end
    local t = Tabs[id]
    if not t then return end
    ActiveTab = id
    t.page.Visible = true
    RTitle.Text    = t.def.label
    Tw(t.btn, 0.12, {BackgroundColor3=Color3.fromRGB(20,11,38)})
    t.bName.TextColor3 = t.def.col
    Tw(t.bAcc, 0.12, {BackgroundTransparency=0})
end

for _, def in ipairs(tabDefs) do
    -- Кнопка таба
    local btn = Instance.new("TextButton", TabScroll)
    btn.Size         = UDim2.new(1, 0, 0, 46)
    btn.BackgroundColor3 = C.BG3
    btn.Text         = ""
    btn.AutoButtonColor = false
    btn.ZIndex       = 103
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)

    local bAcc = Instance.new("Frame", btn)
    bAcc.Size        = UDim2.new(0, 3, 0, 24)
    bAcc.Position    = UDim2.new(0, 0, 0.5, -12)
    bAcc.BackgroundColor3 = def.col
    bAcc.BackgroundTransparency = 1
    bAcc.BorderSizePixel = 0
    bAcc.ZIndex      = 104
    Instance.new("UICorner", bAcc).CornerRadius = UDim.new(1, 0)

    local bIco = Instance.new("TextLabel", btn)
    bIco.Size        = UDim2.new(0, 28, 1, 0)
    bIco.Position    = UDim2.new(0, 9, 0, 0)
    bIco.BackgroundTransparency = 1
    bIco.Text        = def.ico
    bIco.Font        = Enum.Font.GothamBold
    bIco.TextSize    = 15
    bIco.ZIndex      = 104

    local bName = Instance.new("TextLabel", btn)
    bName.Size       = UDim2.new(1, -44, 0, 17)
    bName.Position   = UDim2.new(0, 40, 0, 5)
    bName.BackgroundTransparency = 1
    bName.Text       = def.label
    bName.TextColor3 = C.DIM
    bName.Font       = Enum.Font.GothamBold
    bName.TextSize   = 12
    bName.TextXAlignment = Enum.TextXAlignment.Left
    bName.ZIndex     = 104

    local bSub = Instance.new("TextLabel", btn)
    bSub.Size        = UDim2.new(1, -44, 0, 12)
    bSub.Position    = UDim2.new(0, 40, 0, 24)
    bSub.BackgroundTransparency = 1
    bSub.Text        = def.sub
    bSub.TextColor3  = Color3.fromRGB(45, 32, 72)
    bSub.Font        = Enum.Font.Gotham
    bSub.TextSize    = 9
    bSub.TextXAlignment = Enum.TextXAlignment.Left
    bSub.ZIndex      = 104

    -- Страница таба
    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size        = UDim2.new(1, -10, 1, -6)
    page.Position    = UDim2.new(0, 5, 0, 3)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = C.P
    page.CanvasSize  = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.BorderSizePixel = 0
    page.Visible     = false
    page.ZIndex      = 102
    local pL = Instance.new("UIListLayout", page)
    pL.Padding       = UDim.new(0, 5)
    local pPad = Instance.new("UIPadding", page)
    pPad.PaddingTop    = UDim.new(0, 4)
    pPad.PaddingBottom = UDim.new(0, 14)
    pPad.PaddingRight  = UDim.new(0, 4)

    Tabs[def.id] = {btn=btn, page=page, bName=bName, bAcc=bAcc, def=def}

    btn.MouseButton1Click:Connect(function() switchTab(def.id) end)
    btn.MouseEnter:Connect(function()
        if ActiveTab ~= def.id then Tw(btn,0.07,{BackgroundColor3=Color3.fromRGB(18,11,32)}) end
    end)
    btn.MouseLeave:Connect(function()
        if ActiveTab ~= def.id then Tw(btn,0.07,{BackgroundColor3=C.BG3}) end
    end)
end

switchTab("MM2")

-- ════════════════════════
-- UI КОМПОНЕНТЫ
-- ════════════════════════

local function mkSection(parent, text, col)
    col = col or C.PA
    local f = Instance.new("Frame", parent)
    f.Size              = UDim2.new(1, 0, 0, 28)
    f.BackgroundTransparency = 1
    f.ZIndex            = 103
    local l = Instance.new("TextLabel", f)
    l.Size              = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text              = "  "..string.upper(text)
    l.TextColor3        = col
    l.Font              = Enum.Font.GothamBold
    l.TextSize          = 9
    l.TextXAlignment    = Enum.TextXAlignment.Left
    l.ZIndex            = 104
    local ln = Instance.new("Frame", f)
    ln.Size             = UDim2.new(1, 0, 0, 1)
    ln.Position         = UDim2.new(0, 0, 1, -1)
    ln.BackgroundColor3 = col
    ln.BackgroundTransparency = 0.7
    ln.BorderSizePixel  = 0
    ln.ZIndex           = 104
end

local function mkToggle(parent, label, getF, setF, hint, col)
    col = col or C.P
    local h = hint and 52 or 44
    local card = Instance.new("Frame", parent)
    card.Size           = UDim2.new(1, 0, 0, h)
    card.BackgroundColor3 = C.BG2
    card.BorderSizePixel = 0
    card.ZIndex         = 103
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local lbar = Instance.new("Frame", card)
    lbar.Size           = UDim2.new(0, 2, 1, -10)
    lbar.Position       = UDim2.new(0, 0, 0, 5)
    lbar.BackgroundColor3 = col
    lbar.BackgroundTransparency = 1
    lbar.BorderSizePixel = 0
    lbar.ZIndex         = 104
    Instance.new("UICorner", lbar).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size            = UDim2.new(1, -58, 0, 19)
    lbl.Position        = UDim2.new(0, 11, 0, hint and 4 or 13)
    lbl.BackgroundTransparency = 1
    lbl.Text            = label
    lbl.TextColor3      = C.TXT
    lbl.Font            = Enum.Font.GothamSemibold
    lbl.TextSize        = 12
    lbl.TextXAlignment  = Enum.TextXAlignment.Left
    lbl.ZIndex          = 104

    if hint then
        local ht = Instance.new("TextLabel", card)
        ht.Size           = UDim2.new(1, -58, 0, 12)
        ht.Position       = UDim2.new(0, 11, 0, 26)
        ht.BackgroundTransparency = 1
        ht.Text           = hint
        ht.TextColor3     = C.DIM
        ht.Font           = Enum.Font.Gotham
        ht.TextSize       = 10
        ht.TextXAlignment = Enum.TextXAlignment.Left
        ht.ZIndex         = 104
    end

    local sw = Instance.new("Frame", card)
    sw.Size             = UDim2.new(0, 42, 0, 22)
    sw.Position         = UDim2.new(1, -48, 0.5, -11)
    sw.BackgroundColor3 = Color3.fromRGB(24, 16, 44)
    sw.BorderSizePixel  = 0
    sw.ZIndex           = 104
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local kn = Instance.new("Frame", sw)
    kn.Size             = UDim2.new(0, 18, 0, 18)
    kn.Position         = UDim2.new(0, 2, 0.5, -9)
    kn.BackgroundColor3 = Color3.fromRGB(80, 60, 120)
    kn.BorderSizePixel  = 0
    kn.ZIndex           = 105
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1, 0)

    local function refresh()
        if getF() then
            Tw(sw, 0.12, {BackgroundColor3=col})
            Tw(kn, 0.12, {Position=UDim2.new(0,22,0.5,-9), BackgroundColor3=C.WHT})
            Tw(card, 0.12, {BackgroundColor3=Color3.fromRGB(15, 8, 28)})
            Tw(lbar, 0.12, {BackgroundTransparency=0})
        else
            Tw(sw, 0.12, {BackgroundColor3=Color3.fromRGB(24,16,44)})
            Tw(kn, 0.12, {Position=UDim2.new(0,2,0.5,-9), BackgroundColor3=Color3.fromRGB(80,60,120)})
            Tw(card, 0.12, {BackgroundColor3=C.BG2})
            Tw(lbar, 0.12, {BackgroundTransparency=1})
        end
    end

    local clickArea = Instance.new("TextButton", card)
    clickArea.Size    = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text    = ""
    clickArea.ZIndex  = 106
    clickArea.AutoButtonColor = false
    clickArea.MouseEnter:Connect(function()
        if not getF() then Tw(card,0.06,{BackgroundColor3=Color3.fromRGB(17,10,30)}) end
    end)
    clickArea.MouseLeave:Connect(function()
        if not getF() then Tw(card,0.06,{BackgroundColor3=C.BG2}) end
    end)
    clickArea.MouseButton1Click:Connect(function()
        setF(not getF())
        refresh()
    end)
    refresh()
    return refresh
end

local function mkSlider(parent, label, min, max, default, cb)
    local card = Instance.new("Frame", parent)
    card.Size           = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = C.BG2
    card.BorderSizePixel = 0
    card.ZIndex         = 103
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size            = UDim2.new(1, -76, 0, 19)
    lbl.Position        = UDim2.new(0, 11, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text            = label
    lbl.TextColor3      = C.TXT
    lbl.Font            = Enum.Font.GothamSemibold
    lbl.TextSize        = 11
    lbl.TextXAlignment  = Enum.TextXAlignment.Left
    lbl.ZIndex          = 104

    local valLbl = Instance.new("TextLabel", card)
    valLbl.Size         = UDim2.new(0, 64, 0, 19)
    valLbl.Position     = UDim2.new(1, -70, 0, 8)
    valLbl.BackgroundTransparency = 1
    valLbl.Text         = tostring(default)
    valLbl.TextColor3   = C.PA
    valLbl.Font         = Enum.Font.GothamBold
    valLbl.TextSize     = 11
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex       = 104

    local track = Instance.new("Frame", card)
    track.Size          = UDim2.new(1, -22, 0, 6)
    track.Position      = UDim2.new(0, 11, 0, 38)
    track.BackgroundColor3 = Color3.fromRGB(26, 16, 48)
    track.BorderSizePixel = 0
    track.ZIndex        = 104
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size           = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = C.P
    fill.BorderSizePixel = 0
    fill.ZIndex         = 105
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size           = UDim2.new(0, 14, 0, 14)
    knob.Position       = UDim2.new((default-min)/(max-min), -7, 0.5, -7)
    knob.BackgroundColor3 = C.WHT
    knob.BorderSizePixel = 0
    knob.ZIndex         = 106
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(px)
        local pct = math.clamp((px - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pct)
        fill.Size  = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -7, 0.5, -7)
        valLbl.Text = tostring(val)
        if cb then pcall(cb, val) end
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true; update(i.Position.X) end
    end)
    knob.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
    end)
end

local allDropdowns = {}

local function mkDropdown(parent, label, options, default, cb)
    local card = Instance.new("Frame", parent)
    card.Size           = UDim2.new(1, 0, 0, 46)
    card.BackgroundColor3 = C.BG2
    card.BorderSizePixel = 0
    card.ZIndex         = 103
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size            = UDim2.new(0.48, 0, 1, 0)
    lbl.Position        = UDim2.new(0, 11, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text            = label
    lbl.TextColor3      = C.TXT
    lbl.Font            = Enum.Font.GothamSemibold
    lbl.TextSize        = 12
    lbl.TextXAlignment  = Enum.TextXAlignment.Left
    lbl.ZIndex          = 104

    local selBtn = Instance.new("TextButton", card)
    selBtn.Size         = UDim2.new(0, 162, 0, 28)
    selBtn.Position     = UDim2.new(1, -168, 0.5, -14)
    selBtn.BackgroundColor3 = C.BG3
    selBtn.Text         = (default:sub(1,15)).." ▾"
    selBtn.TextColor3   = C.PA
    selBtn.Font         = Enum.Font.GothamBold
    selBtn.TextSize     = 11
    selBtn.ZIndex       = 104
    selBtn.AutoButtonColor = false
    Instance.new("UICorner", selBtn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", selBtn).Color = C.P

    -- Dropdown list
    local ddFrame = Instance.new("ScrollingFrame", GUI)
    ddFrame.BackgroundColor3 = Color3.fromRGB(10, 6, 18)
    ddFrame.BorderSizePixel  = 0
    ddFrame.Visible          = false
    ddFrame.ZIndex           = 8000
    ddFrame.ScrollBarThickness = 2
    ddFrame.ScrollBarImageColor3 = C.P
    Instance.new("UICorner", ddFrame).CornerRadius = UDim.new(0, 10)
    local ddStk = Instance.new("UIStroke", ddFrame)
    ddStk.Color     = C.P
    ddStk.Thickness = 1.5
    ddStk.Transparency = 0.1
    local ddLayout = Instance.new("UIListLayout", ddFrame)
    ddLayout.Padding = UDim.new(0, 2)
    local ddPad = Instance.new("UIPadding", ddFrame)
    ddPad.PaddingTop    = UDim.new(0, 4)
    ddPad.PaddingBottom = UDim.new(0, 4)
    ddPad.PaddingLeft   = UDim.new(0, 4)
    ddPad.PaddingRight  = UDim.new(0, 4)

    local curOpts = options

    local function rebuildDD(newOpts)
        curOpts = newOpts
        for _, c in ipairs(ddFrame:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for _, opt in ipairs(newOpts) do
            local ob = Instance.new("TextButton", ddFrame)
            ob.Size           = UDim2.new(1, -2, 0, 28)
            ob.BackgroundColor3 = C.BG3
            ob.Text           = opt
            ob.TextColor3     = C.TXT
            ob.Font           = Enum.Font.GothamSemibold
            ob.TextSize       = 11
            ob.ZIndex         = 8001
            ob.AutoButtonColor = false
            Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 7)
            ob.MouseEnter:Connect(function()
                Tw(ob, 0.06, {BackgroundColor3=C.P}); ob.TextColor3 = C.WHT
            end)
            ob.MouseLeave:Connect(function()
                Tw(ob, 0.06, {BackgroundColor3=C.BG3}); ob.TextColor3 = C.TXT
            end)
            ob.MouseButton1Click:Connect(function()
                selBtn.Text = (opt:sub(1,15)).." ▾"
                ddFrame.Visible = false
                if cb then pcall(cb, opt) end
            end)
        end
        ddFrame.CanvasSize = UDim2.new(0, 0, 0, #newOpts * 32 + 8)
    end

    rebuildDD(options)

    selBtn.MouseButton1Click:Connect(function()
        if ddFrame.Visible then ddFrame.Visible = false; return end
        -- Закрываем все остальные
        for _, dd in ipairs(allDropdowns) do dd.Visible = false end
        local absP = selBtn.AbsolutePosition
        ddFrame.Size     = UDim2.new(0, 172, 0, math.min(#curOpts * 32 + 8, 230))
        ddFrame.Position = UDim2.new(0, absP.X, 0, absP.Y + 32)
        ddFrame.Visible  = true
    end)

    table.insert(allDropdowns, ddFrame)
    return {rebuild=rebuildDD, frame=ddFrame}
end

local function mkBtn(parent, label, col, cb)
    local b = Instance.new("TextButton", parent)
    b.Size           = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = col or C.P
    b.Text           = label
    b.TextColor3     = C.WHT
    b.Font           = Enum.Font.GothamBold
    b.TextSize       = 12
    b.ZIndex         = 103
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    b.MouseEnter:Connect(function() Tw(b,0.08,{BackgroundTransparency=0.25}) end)
    b.MouseLeave:Connect(function() Tw(b,0.08,{BackgroundTransparency=0}) end)
    b.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
end

local function mkDualBtn(parent, l1,c1,cb1, l2,c2,cb2)
    local row = Instance.new("Frame", parent)
    row.Size            = UDim2.new(1, 0, 0, 40)
    row.BackgroundTransparency = 1
    row.ZIndex          = 103
    for i, data in ipairs({{l1,c1,cb1},{l2,c2,cb2}}) do
        local b = Instance.new("TextButton", row)
        b.Size = UDim2.new(0.49, 0, 1, 0)
        b.Position = i==2 and UDim2.new(0.51,0,0,0) or UDim2.new(0,0,0,0)
        b.BackgroundColor3 = data[2] or C.P
        b.Text = data[1]
        b.TextColor3 = C.WHT
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.ZIndex = 103
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        b.MouseEnter:Connect(function() Tw(b,0.08,{BackgroundTransparency=0.25}) end)
        b.MouseLeave:Connect(function() Tw(b,0.08,{BackgroundTransparency=0}) end)
        b.MouseButton1Click:Connect(function() if data[3] then pcall(data[3]) end end)
    end
end

local function mkInfo(parent, text, col)
    col = col or C.YLW
    local f = Instance.new("Frame", parent)
    f.Size           = UDim2.new(1, 0, 0, 32)
    f.BackgroundColor3 = Color3.fromRGB(14,7,22)
    f.BorderSizePixel = 0
    f.ZIndex         = 103
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 9)
    Instance.new("UIStroke", f).Color = col
    local l = Instance.new("TextLabel", f)
    l.Size           = UDim2.new(1,-12,1,0)
    l.Position       = UDim2.new(0,12,0,0)
    l.BackgroundTransparency = 1
    l.Text           = text
    l.TextColor3     = col
    l.Font           = Enum.Font.Gotham
    l.TextSize       = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex         = 104
end

local function mkBind(parent, label, key)
    local card = Instance.new("Frame", parent)
    card.Size           = UDim2.new(1, 0, 0, 46)
    card.BackgroundColor3 = C.BG2
    card.BorderSizePixel = 0
    card.ZIndex         = 103
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size            = UDim2.new(1,-124,1,0)
    lbl.Position        = UDim2.new(0,11,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text            = label
    lbl.TextColor3      = C.TXT
    lbl.Font            = Enum.Font.GothamSemibold
    lbl.TextSize        = 12
    lbl.TextXAlignment  = Enum.TextXAlignment.Left
    lbl.ZIndex          = 104
    local kb = Instance.new("TextButton", card)
    kb.Size             = UDim2.new(0, 112, 0, 28)
    kb.Position         = UDim2.new(1,-118,0.5,-14)
    kb.BackgroundColor3 = C.BG3
    local function bindText()
        return Binds[key]==Enum.KeyCode.Unknown and "[ None ]" or "[ "..Binds[key].Name.." ]"
    end
    kb.Text             = bindText()
    kb.TextColor3       = C.PA
    kb.Font             = Enum.Font.GothamBold
    kb.TextSize         = 11
    kb.ZIndex           = 104
    kb.AutoButtonColor  = false
    Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", kb).Color = C.P
    local waiting = false
    kb.MouseButton1Click:Connect(function()
        if waiting then return end
        waiting = true; kb.Text = "[ ... ]"; kb.TextColor3 = C.YLW
        local conn; conn = UIS.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
            conn:Disconnect()
            Binds[key] = i.KeyCode
            waiting = false
            kb.Text = bindText()
            kb.TextColor3 = C.PA
            Notify("Бинд", label.." → "..i.KeyCode.Name, C.GRN, 2)
        end)
    end)
end

-- ════════════════════════════════════════════════════════
-- MM2 TAB
-- ════════════════════════════════════════════════════════
local mm2p = Tabs["MM2"].page

mkSection(mm2p, "📊 Статус раунда", C.MM2)

-- Статус карточка
local statCard = Instance.new("Frame", mm2p)
statCard.Size           = UDim2.new(1, 0, 0, 140)
statCard.BackgroundColor3 = Color3.fromRGB(14,5,5)
statCard.BorderSizePixel = 0
statCard.ZIndex         = 103
Instance.new("UICorner", statCard).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", statCard).Color = C.MM2

-- Роль игрока
local myRoleLbl = Instance.new("TextLabel", statCard)
myRoleLbl.Size          = UDim2.new(1, -20, 0, 18)
myRoleLbl.Position      = UDim2.new(0, 14, 0, 12)
myRoleLbl.BackgroundTransparency = 1
myRoleLbl.Text          = "👤 Моя роль: Загрузка..."
myRoleLbl.TextColor3    = C.TXT
myRoleLbl.Font          = Enum.Font.GothamBold
myRoleLbl.TextSize      = 13
myRoleLbl.TextXAlignment = Enum.TextXAlignment.Left
myRoleLbl.ZIndex        = 104

local murdLbl = Instance.new("TextLabel", statCard)
murdLbl.Size            = UDim2.new(1, -20, 0, 16)
murdLbl.Position        = UDim2.new(0, 14, 0, 42)
murdLbl.BackgroundTransparency = 1
murdLbl.Text            = "🔪 Маржер: ???"
murdLbl.TextColor3      = C.RED
murdLbl.Font            = Enum.Font.GothamBold
murdLbl.TextSize        = 12
murdLbl.TextXAlignment  = Enum.TextXAlignment.Left
murdLbl.ZIndex          = 104

local sherLbl = Instance.new("TextLabel", statCard)
sherLbl.Size            = UDim2.new(1, -20, 0, 16)
sherLbl.Position        = UDim2.new(0, 14, 0, 70)
sherLbl.BackgroundTransparency = 1
sherLbl.Text            = "🔫 Шериф: ???"
sherLbl.TextColor3      = C.YLW
sherLbl.Font            = Enum.Font.GothamBold
sherLbl.TextSize        = 12
sherLbl.TextXAlignment  = Enum.TextXAlignment.Left
sherLbl.ZIndex          = 104

local innocLbl = Instance.new("TextLabel", statCard)
innocLbl.Size           = UDim2.new(1, -20, 0, 14)
innocLbl.Position       = UDim2.new(0, 14, 0, 98)
innocLbl.BackgroundTransparency = 1
innocLbl.Text           = "😇 Невинных: ?"
innocLbl.TextColor3     = C.GRN
innocLbl.Font           = Enum.Font.Gotham
innocLbl.TextSize       = 11
innocLbl.TextXAlignment = Enum.TextXAlignment.Left
innocLbl.ZIndex         = 104

local lastUpdLbl = Instance.new("TextLabel", statCard)
lastUpdLbl.Size         = UDim2.new(1, -20, 0, 12)
lastUpdLbl.Position     = UDim2.new(0, 14, 0, 122)
lastUpdLbl.BackgroundTransparency = 1
lastUpdLbl.Text         = "Обновлено: -"
lastUpdLbl.TextColor3   = C.DIM
lastUpdLbl.Font         = Enum.Font.Gotham
lastUpdLbl.TextSize     = 9
lastUpdLbl.TextXAlignment = Enum.TextXAlignment.Left
lastUpdLbl.ZIndex       = 104

-- Функция обновления статуса
local function refreshMM2Status()
    detectMM2Roles()

    local myRole = getMM2Role(LP)
    local roleMap = {Murderer="🔪 МАРЖЕР",Sheriff="🔫 ШЕРИФ",Innocent="😇 НЕВИННЫЙ"}
    local roleCol = {Murderer=C.RED, Sheriff=C.YLW, Innocent=C.GRN}
    myRoleLbl.Text      = "👤 Моя роль: "..(roleMap[myRole] or "???")
    myRoleLbl.TextColor3 = roleCol[myRole] or C.DIM

    murdLbl.Text        = "🔪 Маржер: "..(MM2State.murderer and MM2State.murderer.Name or "не найден")
    sherLbl.Text        = "🔫 Шериф: "..(MM2State.sheriff  and MM2State.sheriff.Name  or "не найден")

    local innCount, murdCount, sherCount = 0, 0, 0
    for _, pl in ipairs(Players:GetPlayers()) do
        local r = getMM2Role(pl)
        if r == "Murderer" then murdCount = murdCount+1
        elseif r == "Sheriff" then sherCount = sherCount+1
        else innCount = innCount+1 end
    end
    innocLbl.Text       = "😇 Невинных: "..innCount.." | 🔪 "..murdCount.." | 🔫 "..sherCount
    lastUpdLbl.Text     = "Обновлено: "..os.date("%H:%M:%S")
end

mkBtn(mm2p,"🔄 Обновить роли", C.MM2, function()
    refreshMM2Status()
    Notify("MM2","Роли обновлены ✓",C.GRN,2)
end)

-- Список игроков
mkSection(mm2p,"👥 Все игроки (роли)", C.MM2)
mkToggle(mm2p,"👁 Роли над головами",
    function() return S.MM2Roles end,
    function(v) S.MM2Roles=v end,
    "Иконка роли в ESP над каждым", C.MM2)
mkToggle(mm2p,"🎨 Highlight по ролям",
    function() return S.MM2Chams end,
    function(v) S.MM2Chams=v end,
    "🔴Маржер 🟡Шериф 🟢Невинный", C.MM2)

-- Список игроков с ролями
local roleListCard = Instance.new("Frame", mm2p)
roleListCard.Size       = UDim2.new(1, 0, 0, 270)
roleListCard.BackgroundColor3 = Color3.fromRGB(11,5,5)
roleListCard.BorderSizePixel = 0
roleListCard.ZIndex     = 103
roleListCard.ClipsDescendants = true
Instance.new("UICorner", roleListCard).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", roleListCard).Color = C.MM2

local roleScroll = Instance.new("ScrollingFrame", roleListCard)
roleScroll.Size         = UDim2.new(1,-4,1,-4)
roleScroll.Position     = UDim2.new(0,2,0,2)
roleScroll.BackgroundTransparency = 1
roleScroll.ScrollBarThickness = 2
roleScroll.ScrollBarImageColor3 = C.MM2
roleScroll.CanvasSize   = UDim2.new(0,0,0,0)
roleScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
roleScroll.BorderSizePixel = 0
roleScroll.ZIndex       = 104
Instance.new("UIListLayout", roleScroll).Padding = UDim.new(0, 3)
local rolePad = Instance.new("UIPadding", roleScroll)
rolePad.PaddingAll = UDim.new(0,4)

local function rebuildRoleList()
    for _, c in ipairs(roleScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    for _, pl in ipairs(Players:GetPlayers()) do
        local role = getMM2Role(pl)
        local row = Instance.new("Frame", roleScroll)
        row.Size         = UDim2.new(1,0,0,34)
        row.BorderSizePixel = 0
        row.ZIndex       = 105

        if role == "Murderer" then
            row.BackgroundColor3 = Color3.fromRGB(32,6,6)
        elseif role == "Sheriff" then
            row.BackgroundColor3 = Color3.fromRGB(26,22,4)
        else
            row.BackgroundColor3 = C.BG3
        end
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

        local ico = Instance.new("TextLabel", row)
        ico.Size         = UDim2.new(0,30,1,0)
        ico.Position     = UDim2.new(0,6,0,0)
        ico.BackgroundTransparency = 1
        ico.TextSize     = 17
        ico.ZIndex       = 106

        local nm = Instance.new("TextLabel", row)
        nm.Size          = UDim2.new(1,-110,1,0)
        nm.Position      = UDim2.new(0,38,0,0)
        nm.BackgroundTransparency = 1
        nm.Font          = Enum.Font.GothamBold
        nm.TextSize      = 12
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.ZIndex        = 106

        local roleTag = Instance.new("TextLabel", row)
        roleTag.Size     = UDim2.new(0,85,1,0)
        roleTag.Position = UDim2.new(1,-88,0,0)
        roleTag.BackgroundTransparency = 1
        roleTag.Font     = Enum.Font.GothamBold
        roleTag.TextSize = 10
        roleTag.TextXAlignment = Enum.TextXAlignment.Right
        roleTag.ZIndex   = 106

        if role == "Murderer" then
            ico.Text = "🔪"; nm.TextColor3 = C.RED; roleTag.Text = "МАРЖЕР"; roleTag.TextColor3 = C.RED
        elseif role == "Sheriff" then
            ico.Text = "🔫"; nm.TextColor3 = C.YLW; roleTag.Text = "ШЕРИФ"; roleTag.TextColor3 = C.YLW
        else
            ico.Text = "😇"; nm.TextColor3 = C.GRN; roleTag.Text = "невинный"; roleTag.TextColor3 = C.GRN
        end

        nm.Text = pl == LP and "[Я] "..pl.Name or pl.Name
    end
end

-- Оружие
mkSection(mm2p,"🔫 Оружие",C.ORG)
mkInfo(mm2p,"ТП к выпавшему оружию на карте",C.ORG)
mkDualBtn(mm2p,
    "🔫 ТП к пистолету", C.YLW, function()
        local found, dist = nil, math.huge
        local r = Ro()
        if not r then Notify("MM2","Нет персонажа",C.RED,2); return end
        pcall(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                local n = obj.Name:lower()
                if (n:find("gun") or n:find("sheriff") or n:find("revolver") or n:find("pistol"))
                    and (obj:IsA("Tool") or obj:IsA("Model")) then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                    if handle then
                        local d = (r.Position - handle.Position).Magnitude
                        if d < dist then dist = d; found = handle end
                    end
                end
            end
        end)
        if found then
            r.CFrame = CFrame.new(found.Position + Vector3.new(0,4,0))
            Notify("MM2","ТП к пистолету ✓ ["..math.floor(dist).."m]",C.YLW,2)
        else Notify("MM2","Пистолет не найден",C.RED,2) end
    end,
    "🔪 ТП к ножу", C.RED, function()
        local found, dist = nil, math.huge
        local r = Ro()
        if not r then return end
        pcall(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                local n = obj.Name:lower()
                if (n:find("knife") or n:find("blade")) and (obj:IsA("Tool") or obj:IsA("Model")) then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                    if handle then
                        local d = (r.Position - handle.Position).Magnitude
                        if d < dist then dist = d; found = handle end
                    end
                end
            end
        end)
        if found then
            r.CFrame = CFrame.new(found.Position + Vector3.new(0,4,0))
            Notify("MM2","ТП к ножу ✓",C.RED,2)
        else Notify("MM2","Нож не найден",C.RED,2) end
    end)
mkToggle(mm2p,"🔫 Авто-подбор оружия",
    function() return S.MM2AutoGrab end,
    function(v) S.MM2AutoGrab=v end,
    "ТП к ближайшему пистолету автоматически", C.YLW)

-- Авто-выстрел
mkSection(mm2p,"🎯 Авто-выстрел в маржера", C.MM2)
mkInfo(mm2p,"Нужен пистолет в руках! Убедись что ты шериф",C.YLW)
mkSlider(mm2p,"Задержка выстрела (сек)",1,50,3,function(v) S.MM2ShootDelay = v/10 end)
mkToggle(mm2p,"🔫 Авто-выстрел",
    function() return S.MM2AutoShoot end,
    function(v)
        S.MM2AutoShoot = v
        Notify("MM2 AutoShoot", v and "ВКЛ ✓" or "ВЫКЛ", v and C.GRN or C.RED, 2)
    end,
    "Авто-стреляет когда маржер в зоне видимости", C.MM2)

-- Авто-бросок
mkSection(mm2p,"🔪 Авто-бросок ножа", C.RED)
mkSlider(mm2p,"Задержка броска (сек)",1,50,8,function(v) S.MM2ThrowDelay = v/10 end)
mkToggle(mm2p,"🔪 Авто-бросок",
    function() return S.MM2AutoThrow end,
    function(v)
        S.MM2AutoThrow = v
        Notify("MM2 AutoThrow", v and "ВКЛ ✓" or "ВЫКЛ", v and C.GRN or C.RED, 2)
    end,
    "Авто-бросает нож в маржера/шерифа", C.RED)

-- Быстрые действия
mkSection(mm2p,"⚡ Быстрые действия", C.ORG)
mkDualBtn(mm2p,
    "🔫 Выстрел СЕЙЧАС", C.YLW, function()
        local murd = MM2State.murderer
        if not murd or not murd.Character then Notify("MM2","Маржер не найден",C.RED,2); return end
        -- Наводимся на маржера
        pcall(function()
            local head = murd.Character:FindFirstChild("Head")
            if not head then return end
            -- Поворот камеры к цели
            Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, head.Position)
            task.wait(0.05)
            -- Стреляем
            local ch = Ch()
            if ch then
                local tool = ch:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
            mouse1click()
        end)
        Notify("MM2","🔫 Выстрел!",C.YLW,1.5)
    end,
    "🔪 Бросок СЕЙЧАС", C.RED, function()
        local target = MM2State.murderer or MM2State.sheriff or nearestPlayer()
        if not target or not target.Character then Notify("MM2","Цель не найдена",C.RED,2); return end
        pcall(function()
            local head = target.Character:FindFirstChild("Head")
            if not head then return end
            Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, head.Position)
            task.wait(0.05)
            local ch = Ch()
            if ch then
                local tool = ch:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
            mouse1click()
        end)
        Notify("MM2","🔪 Бросок!",C.RED,1.5)
    end)
mkDualBtn(mm2p,
    "📍 ТП к маржеру", C.RED, function()
        local murd = MM2State.murderer
        if murd and murd.Character then
            local r2 = murd.Character:FindFirstChild("HumanoidRootPart")
            local r = Ro()
            if r2 and r then r.CFrame = r2.CFrame * CFrame.new(0,4,3); Notify("MM2","→ Маржер",C.RED,2) end
        else Notify("MM2","Маржер не найден",C.RED,2) end
    end,
    "📍 ТП к шерифу", C.YLW, function()
        local sher = MM2State.sheriff
        if sher and sher.Character then
            local r2 = sher.Character:FindFirstChild("HumanoidRootPart")
            local r = Ro()
            if r2 and r then r.CFrame = r2.CFrame * CFrame.new(0,4,3); Notify("MM2","→ Шериф",C.YLW,2) end
        else Notify("MM2","Шериф не найден",C.YLW,2) end
    end)

-- ════════════════════════════════════════════════════════
-- COMBAT TAB
-- ════════════════════════════════════════════════════════
local combp = Tabs["Combat"].page

mkSection(combp,"🎯 Aimbot",C.RED)
mkInfo(combp,"Держи ПКМ для наводки. Метод: поворот камеры",C.YLW)
mkToggle(combp,"🎯 Aimbot",
    function() return S.AimOn end,
    function(v) S.AimOn=v; Notify("Aimbot",v and "ВКЛ ✓ Держи ПКМ" or "ВЫКЛ",v and C.GRN or C.RED,2) end,
    "Удерживай ПКМ для наводки на врага", C.RED)
mkToggle(combp,"👁 Показывать FOV",
    function() return S.AimFOVShow end, function(v) S.AimFOVShow=v end, nil, C.RED)
mkToggle(combp,"🧱 Только видимые",
    function() return not S.AimWall end,
    function(v) S.AimWall=not v end,
    "Выкл = через стены", C.RED)
mkToggle(combp,"🔘 Удержание ПКМ",
    function() return S.AimHold end,
    function(v) S.AimHold=v end,
    "Выкл = переключение по бинду", C.RED)
mkSlider(combp,"FOV радиус (пикс)",20,500,150,function(v) S.AimFOV=v end)
mkSlider(combp,"Плавность (10=плавно 1=быстро)",1,30,10,function(v) S.AimSmooth=v*0.02 end)
mkSlider(combp,"Предикшн движения",0,30,5,function(v) S.AimPred=v/100 end)
mkDropdown(combp,"Кость прицела",{"Head","UpperTorso","HumanoidRootPart","LowerTorso"},"Head",
    function(v) S.AimBone=v end)

mkSection(combp,"🔫 TriggerBot",C.RED)
mkInfo(combp,"НЕ стреляет сквозь стены (если не включено)",C.GRN)
mkToggle(combp,"🔫 TriggerBot",
    function() return S.TrigOn end,
    function(v) S.TrigOn=v; Notify("TriggerBot",v and "ВКЛ ✓" or "ВЫКЛ",v and C.GRN or C.RED,1.5) end,
    "Авто-выстрел при наведении курсора на врага", C.RED)
mkToggle(combp,"🧱 Сквозь стены",
    function() return S.TrigWall end,
    function(v) S.TrigWall=v end,
    "ВКЛ = стреляет даже сквозь стены", C.RED)
mkSlider(combp,"Задержка мс",0,400,50,function(v) S.TrigDelay=v/1000 end)
mkSlider(combp,"FOV зоны",2,120,20,function(v) S.TrigFOV=v end)

mkSection(combp,"⚙ Другое",C.ORG)
mkToggle(combp,"📦 Hitbox Expander",
    function() return S.HitboxOn end,
    function(v) S.HitboxOn=v; Notify("Hitbox",v and "ВКЛ" or "ВЫКЛ",v and C.GRN or C.RED,1.5) end,
    "Увеличивает хитбокс врагов", C.ORG)
mkSlider(combp,"Размер хитбокса",2,20,6,function(v) S.HitboxSize=v end)
mkToggle(combp,"🖱 Авто-кликер",
    function() return S.AutoClick end, function(v) S.AutoClick=v end, nil, C.ORG)
mkSlider(combp,"CPS",1,30,10,function(v) S.AutoCPS=v end)

-- ════════════════════════════════════════════════════════
-- VISUALS TAB
-- ════════════════════════════════════════════════════════
local visp = Tabs["Visuals"].page

mkSection(visp,"👁 ESP",C.CYN)
mkToggle(visp,"👁 ESP (всё)",
    function() return S.ESPOn end,
    function(v) S.ESPOn=v; Notify("ESP",v and "ВКЛ ✓" or "ВЫКЛ",v and C.GRN or C.RED,1.5) end,
    "Показывает игроков сквозь стены", C.CYN)
mkToggle(visp,"📦 Боксы",function() return S.ESPBox end,function(v) S.ESPBox=v end,nil,C.CYN)
mkToggle(visp,"📛 Имена",function() return S.ESPName end,function(v) S.ESPName=v end,nil,C.CYN)
mkToggle(visp,"❤ HP бар",function() return S.ESPHPbar end,function(v) S.ESPHPbar=v end,nil,C.CYN)
mkToggle(visp,"📏 Дистанция",function() return S.ESPDist end,function(v) S.ESPDist=v end,nil,C.CYN)
mkToggle(visp,"📍 Трейсеры",function() return S.ESPTracer end,function(v) S.ESPTracer=v end,nil,C.CYN)
mkToggle(visp,"🦴 Скелет",function() return S.ESPSkel end,function(v) S.ESPSkel=v end,nil,C.CYN)
mkToggle(visp,"🎨 Chams",function() return S.ESPChams end,function(v) S.ESPChams=v end,nil,C.CYN)

mkSection(visp,"➕ Прицел",C.WHT)
mkToggle(visp,"➕ Показывать прицел",function() return S.Crosshair end,function(v) S.Crosshair=v end,nil,C.WHT)
mkToggle(visp,"⚫ Центральная точка",function() return S.CrossDot end,function(v) S.CrossDot=v end,nil,C.WHT)
mkSlider(visp,"Длина линий",4,40,10,function(v) S.CrossSize=v end)
mkSlider(visp,"Зазор",0,25,4,function(v) S.CrossGap=v end)
mkSlider(visp,"Толщина",1,6,2,function(v) S.CrossThick=v end)

mkSection(visp,"🖥 UI",C.PA)
mkToggle(visp,"🌈 RGB режим",function() return S.RGB end,function(v) S.RGB=v end,nil,C.PA)
mkToggle(visp,"📡 Радар",function() return S.Radar end,function(v) S.Radar=v end,nil,C.PA)
mkSlider(visp,"Размер радара",80,260,150,function(v) S.RadarSize=v end)
mkToggle(visp,"🔭 FOV Changer",function() return S.FOVChange end,function(v)
    S.FOVChange=v; if not v then pcall(function() Cam.FieldOfView=70 end) end
end,nil,C.PA)
mkSlider(visp,"FOV",30,130,90,function(v)
    S.FOVVal=v; if S.FOVChange then pcall(function() Cam.FieldOfView=v end) end
end)

-- ════════════════════════════════════════════════════════
-- TROLLING TAB
-- ════════════════════════════════════════════════════════
local trlp = Tabs["Trolling"].page

mkSection(trlp,"⚠ ТОЛЬКО ПРИВАТНЫЕ СЕРВЕРЫ",C.RED)
mkInfo(trlp,"⚠  В публичных играх могут забанить!",C.RED)

mkSection(trlp,"🚀 Fling",C.ORG)
mkInfo(trlp,"✅ Телепорт ВНУТРЬ цели + импульс на себя",C.GRN)
mkInfo(trlp,"Если не кидает — попробуй уменьшить задержку",C.YLW)
mkSlider(trlp,"Сила броска",50,1000,200,function(v) S.FlingPower=v end)

local allDDs = {}
local flingDD = mkDropdown(trlp,"Цель",playerList(),"[Ближайший]",function(v) S._flingT=v end)
table.insert(allDDs, flingDD)

mkBtn(trlp,"🔄 Обновить список игроков",C.P,function()
    local pl = playerList()
    for _,dd in ipairs(allDDs) do dd.rebuild(pl) end
    Notify("Список","Обновлён ✓",C.GRN,2)
end)

mkDualBtn(trlp,
    "🚀 Вверх",C.ORG,function()
        local pl = findPlayer(S._flingT)
        if not pl then Notify("Fling","Цель не найдена",C.RED,2); return end
        task.spawn(doFling, S._flingT, "up")
        Notify("Fling","↑ "..pl.Name,C.ORG,2)
    end,
    "🌀 Случайно",C.RED,function()
        local pl = findPlayer(S._flingT)
        if not pl then return end
        task.spawn(doFling, S._flingT, "random")
        Notify("Fling","🌀 "..pl.Name,C.RED,2)
    end)

mkDualBtn(trlp,
    "💨 Вперёд",C.YLW,function()
        task.spawn(doFling, S._flingT, "forward")
    end,
    "💥 x2 Мощность",C.PNK,function()
        local old = S.FlingPower
        S.FlingPower = old * 2
        task.spawn(doFling, S._flingT, "up")
        S.FlingPower = old
    end)

mkToggle(trlp,"🔁 Авто-Fling (каждые 0.6с)",
    function() return S.FlingOn end,
    function(v) S.FlingOn=v; Notify("АвтоFling",v and "ВКЛ ⚠" or "ВЫКЛ",v and C.ORG or C.RED,2) end,
    "Постоянно кидает цель", C.ORG)

mkSection(trlp,"🧲 Attach + Sex Aura",C.PA)
mkToggle(trlp,"🧲 Attach Aura",
    function() return S.AttachOn end,
    function(v)
        S.AttachOn=v
        if not v then
            local r=Ro(); if r then
                local b=r:FindFirstChild("VG_AB"); if b then b:Destroy() end
                local b2=r:FindFirstChild("VG_ROT"); if b2 then b2:Destroy() end
            end
            pcall(function() if Hu() then Hu().PlatformStand=false end end)
        end
    end, nil, C.PA)
mkSlider(trlp,"Скорость волны",1,25,8,function(v) S.AttachSpeed=v end)
mkSlider(trlp,"Амплитуда",1,10,2,function(v) S.AttachAmp=v end)

mkToggle(trlp,"💦 Sex Aura",
    function() return S.SexOn end,
    function(v)
        S.SexOn=v
        if not v then
            local r=Ro(); if r then
                local b=r:FindFirstChild("VG_SX"); if b then b:Destroy() end
                local b2=r:FindFirstChild("VG_SXR"); if b2 then b2:Destroy() end
            end
            pcall(function() if Hu() then Hu().PlatformStand=false end end)
        end
    end, nil, C.PNK)
mkSlider(trlp,"Скорость sec",1,30,12,function(v) S.SexSpeed=v end)
mkSlider(trlp,"Глубина",1,8,2,function(v) S.SexDist=v end)

mkSection(trlp,"🌀 Орбита + Спин",C.CYN)
mkSlider(trlp,"Радиус орбиты",2,25,8,function(v) S.OrbitRadius=v end)
mkSlider(trlp,"Скорость орбиты",1,15,2,function(v) S.OrbitSpeed=v end)
mkSlider(trlp,"Высота орбиты",-5,10,0,function(v) S.OrbitHeight=v end)
mkToggle(trlp,"🌀 Орбита вокруг цели",
    function() return S.OrbitOn end,
    function(v)
        S.OrbitOn=v
        if not v then local r=Ro(); if r then local b=r:FindFirstChild("VG_OB"); if b then b:Destroy() end end; pcall(function() if Hu() then Hu().PlatformStand=false end end) end
    end, nil, C.CYN)

mkSlider(trlp,"Скорость вращения",2,100,15,function(v) S.SpinSpeed=v end)
mkToggle(trlp,"🔄 Spin (кружиться)",
    function() return S.SpinOn end, function(v) S.SpinOn=v end, nil, C.PA)

-- ════════════════════════════════════════════════════════
-- MOVEMENT TAB
-- ════════════════════════════════════════════════════════
local movp = Tabs["Movement"].page

mkSection(movp,"✈ Полёт",C.GRN)
mkInfo(movp,"W/A/S/D движение, Space вверх, LCtrl вниз",C.GRN)
mkToggle(movp,"🚀 Fly",
    function() return S.FlyOn end,
    function(v)
        S.FlyOn=v
        if not v then
            local r=Ro(); if r then local bv=r:FindFirstChild("VG_BV"); if bv then bv:Destroy() end end
            pcall(function() if Hu() then Hu().PlatformStand=false end end)
        end
        Notify("Fly",v and "ВКЛ ✓" or "ВЫКЛ",v and C.GRN or C.RED,1.5)
    end, nil, C.GRN)
mkSlider(movp,"Скорость полёта",5,500,80,function(v) S.FlySpeed=v end)

mkSection(movp,"⚡ Скорость",C.GRN)
mkToggle(movp,"⚡ SuperSpeed",
    function() return S.SpeedOn end,
    function(v)
        S.SpeedOn=v
        if not v then pcall(function() if Hu() then Hu().WalkSpeed=16 end end) end
        Notify("Speed",v and "ВКЛ ✓" or "ВЫКЛ",v and C.GRN or C.RED,1.5)
    end, nil, C.GRN)
mkSlider(movp,"WalkSpeed",16,500,60,function(v) S.SpeedVal=v end)

mkSection(movp,"🔮 Специальное",C.CYN)
mkToggle(movp,"👻 NoClip",
    function() return S.NoclipOn end,
    function(v)
        S.NoclipOn=v
        if not v then
            pcall(function()
                if Ch() then
                    for _,p in ipairs(Ch():GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide=true end
                    end
                end
            end)
        end
        Notify("NoClip",v and "ВКЛ 👻" or "ВЫКЛ",v and C.GRN or C.RED,1.5)
    end, nil, C.CYN)
mkToggle(movp,"🐰 BunnyHop",function() return S.BhopOn end,function(v) S.BhopOn=v end,nil,C.CYN)
mkToggle(movp,"↗ Бесконечный прыжок",function() return S.InfJump end,function(v) S.InfJump=v end,nil,C.CYN)
mkToggle(movp,"💨 Высокий прыжок",
    function() return S.HighJump end,
    function(v)
        S.HighJump=v
        pcall(function() if Hu() then Hu().JumpPower=v and S.JumpVal or 50 end end)
    end, nil, C.CYN)
mkSlider(movp,"Сила прыжка",50,500,80,function(v)
    S.JumpVal=v; if S.HighJump then pcall(function() if Hu() then Hu().JumpPower=v end end) end
end)
mkToggle(movp,"🪂 Без урона от падения",function() return S.NoFall end,function(v) S.NoFall=v end,nil,C.CYN)
mkToggle(movp,"🌌 Низкая гравитация",
    function() return S.LowGrav end,
    function(v) S.LowGrav=v; pcall(function() workspace.Gravity=v and S.GravVal or 196.2 end) end,nil,C.CYN)
mkSlider(movp,"Гравитация",5,196,50,function(v)
    S.GravVal=v; if S.LowGrav then pcall(function() workspace.Gravity=v end) end
end)
mkToggle(movp,"🖱 ClickTP (ПКМ)",function() return S.ClickTP end,function(v) S.ClickTP=v end,
    "Правая кнопка мыши = телепорт", C.CYN)

mkDualBtn(movp,
    "📍 Сохранить позицию",C.P,function()
        if Ro() then _G.VG_SavedPos = Ro().Position; Notify("ТП","Сохранено ✓",C.GRN,2) end
    end,
    "🔄 Вернуться",C.PA,function()
        if Ro() and _G.VG_SavedPos then
            Ro().CFrame = CFrame.new(_G.VG_SavedPos + Vector3.new(0,4,0))
            Notify("ТП","Готово ✓",C.GRN,2)
        end
    end)

-- ════════════════════════════════════════════════════════
-- PLAYER TAB
-- ════════════════════════════════════════════════════════
local playerP = Tabs["Player"].page

mkSection(playerP,"🛡 Защита",C.YLW)
mkToggle(playerP,"🛡 God Mode",
    function() return S.GodMode end,
    function(v) S.GodMode=v; Notify("God Mode",v and "ВКЛ 🛡" or "ВЫКЛ",v and C.GRN or C.RED,2) end,
    "Бесконечное HP", C.YLW)
mkToggle(playerP,"🤖 Анти-АФК",function() return S.AntiAFK end,function(v) S.AntiAFK=v end,nil,C.YLW)
mkToggle(playerP,"♾ Бесконечные патроны",function() return S.InfAmmo end,function(v) S.InfAmmo=v end,nil,C.YLW)
mkToggle(playerP,"🔄 Авто-Респавн",function() return S.AutoRespawn end,function(v) S.AutoRespawn=v end,nil,C.YLW)

mkSection(playerP,"🎮 Действия",C.GRN)
mkDualBtn(playerP,"🏠 Умереть/Респавн",C.RED,function()
    pcall(function() if Hu() then Hu().Health=0 end end)
end,"💨 Сбросить скорость",C.ORG,function()
    S.SpeedOn=false; S.FlyOn=false
    pcall(function()
        if Hu() then Hu().WalkSpeed=16; Hu().JumpPower=50; Hu().PlatformStand=false end
        workspace.Gravity=196.2
    end)
    Notify("Сброс","✓ Всё сброшено",C.GRN,2)
end)
mkDualBtn(playerP,"📋 Копировать ник",C.P,function()
    pcall(function() setclipboard(LP.Name) end)
    Notify("Скопировано",LP.Name,C.GRN,2)
end,"📋 Копировать ID",C.PA,function()
    pcall(function() setclipboard(tostring(LP.UserId)) end)
    Notify("ID",tostring(LP.UserId),C.GRN,2)
end)

mkSection(playerP,"👥 Действия над игроком",C.CYN)
local actDD = mkDropdown(playerP,"Цель",playerList(),"[Ближайший]",function(v) S._act=v end)
table.insert(allDDs,actDD)
mkDualBtn(playerP,"📍 ТП к игроку",C.CYN,function()
    local pl=findPlayer(S._act or "[Ближайший]")
    if pl and pl.Character then
        local r2=pl.Character:FindFirstChild("HumanoidRootPart"); local r=Ro()
        if r2 and r then r.CFrame=r2.CFrame*CFrame.new(0,4,3); Notify("ТП","→ "..pl.Name,C.GRN,2) end
    end
end,"👁 ТП игрока ко мне",C.PA,function()
    local pl=findPlayer(S._act or "[Ближайший]")
    if pl and pl.Character then
        local r2=pl.Character:FindFirstChild("HumanoidRootPart"); local r=Ro()
        if r2 and r then r2.CFrame=r.CFrame*CFrame.new(0,0,3); Notify("ТП","← "..pl.Name,C.GRN,2) end
    end
end)

-- ════════════════════════════════════════════════════════
-- WORLD TAB
-- ════════════════════════════════════════════════════════
local worldp = Tabs["World"].page

mkSection(worldp,"💡 Освещение",C.ORG)
mkToggle(worldp,"💡 Fullbright",function() return S.Fullbright end,function(v)
    S.Fullbright=v
    pcall(function()
        if v then Lighting.Brightness=4; Lighting.Ambient=Color3.new(1,1,1); Lighting.OutdoorAmbient=Color3.new(1,1,1); Lighting.GlobalShadows=false
        else Lighting.Brightness=1; Lighting.Ambient=Color3.new(0,0,0); Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127); Lighting.GlobalShadows=true end
    end)
    Notify("Fullbright",v and "ВКЛ ✓" or "ВЫКЛ",v and C.GRN or C.RED,1.5)
end,"Убирает темноту и тени",C.ORG)
mkToggle(worldp,"🌙 Ночной режим",function() return S.NightMode end,function(v)
    S.NightMode=v; pcall(function() Lighting.ClockTime=v and 0 or 14; Lighting.Brightness=v and 0.05 or 1 end)
end,nil,C.ORG)
mkToggle(worldp,"🚫 Убрать блюр",function() return S.AntiBlur end,function(v)
    S.AntiBlur=v; pcall(function()
        for _,ef in ipairs(Lighting:GetChildren()) do
            if ef:IsA("BlurEffect") or ef:IsA("DepthOfFieldEffect") then ef.Enabled=not v end
        end
    end)
end,nil,C.ORG)

mkSection(worldp,"⏰ Время",C.YLW)
mkToggle(worldp,"🕐 Заморозить время",function() return S.TimeFreeze end,function(v)
    S.TimeFreeze=v; if not v then pcall(function() Lighting.ClockTime=14 end) end
end,nil,C.YLW)
mkSlider(worldp,"Время суток (0-24)",0,24,14,function(v)
    S.TimeVal=v; if S.TimeFreeze then pcall(function() Lighting.ClockTime=v end) end
end)

mkSection(worldp,"🏗 Карта",C.CYN)
mkDualBtn(worldp,"🗑 Убрать деревья",C.ORG,function()
    pcall(function()
        for _,p in ipairs(workspace:GetDescendants()) do
            if p:IsA("Model") and (p.Name:lower():find("tree") or p.Name:lower():find("bush") or p.Name:lower():find("palm")) then
                p:Destroy()
            end
        end
    end)
    Notify("World","Деревья убраны ✓",C.GRN,2)
end,"🗑 Убрать NPC",C.RED,function()
    pcall(function()
        for _,p in ipairs(workspace:GetDescendants()) do
            if p:IsA("Model") and p:FindFirstChildOfClass("Humanoid")
                and not Players:GetPlayerFromCharacter(p) then p:Destroy() end
        end
    end)
    Notify("World","NPC убраны ✓",C.GRN,2)
end)

-- ════════════════════════════════════════════════════════
-- MISC TAB
-- ════════════════════════════════════════════════════════
local miscp = Tabs["Misc"].page

mkSection(miscp,"⚙ Утилиты",C.P)
mkToggle(miscp,"🔔 Уведомления",function() return S.Notifs end,function(v) S.Notifs=v end,nil,C.P)
mkToggle(miscp,"📈 FPS Boost",function() return S.FPSBoost end,function(v)
    S.FPSBoost=v
    if v then pcall(function()
        for _,p in ipairs(workspace:GetDescendants()) do
            if p:IsA("ParticleEmitter") or p:IsA("Fire") or p:IsA("Smoke") or p:IsA("Sparkles") then
                p.Enabled=false
            end
        end
    end) end
    Notify("FPS",v and "Boost ВКЛ" or "ВЫКЛ",v and C.GRN or C.RED,2)
end,"Убирает частицы для +FPS",C.P)

mkSection(miscp,"💣 Сброс",C.RED)
mkBtn(miscp,"🔥 СБРОСИТЬ ВСЕГО",Color3.fromRGB(140,20,40),function()
    S.SpeedOn=false; S.FlyOn=false; S.NoclipOn=false; S.AttachOn=false; S.SexOn=false
    S.OrbitOn=false; S.SpinOn=false; S.FlingOn=false; S.GodMode=false; S.LowGrav=false
    S.BhopOn=false; S.InfJump=false; S.NoFall=false; S.HighJump=false
    S.MM2AutoShoot=false; S.MM2AutoThrow=false; S.MM2AutoGrab=false
    pcall(function()
        if Hu() then Hu().WalkSpeed=16; Hu().JumpPower=50; Hu().PlatformStand=false end
        workspace.Gravity=196.2
        local r=Ro()
        if r then
            for _,n in ipairs({"VG_BV","VG_AB","VG_SX","VG_SXR","VG_OB","VG_SP","VG_ROT","VG_FLV","VG_FLBA"}) do
                local b=r:FindFirstChild(n); if b then b:Destroy() end
            end
        end
    end)
    Notify("СБРОС","Всё выключено ✓",C.GRN,3)
end)
mkBtn(miscp,"🗑 Выгрузить скрипт",Color3.fromRGB(80,14,28),function()
    Notify("Выгрузка","До свидания! 👋",C.RED,2)
    task.delay(1.5,function() pcall(function() GUI:Destroy() end) end)
end)

-- ════════════════════════════════════════════════════════
-- BINDS TAB
-- ════════════════════════════════════════════════════════
local bindp = Tabs["Binds"].page
mkSection(bindp,"⌨ Горячие клавиши",C.DIM)
mkInfo(bindp,"Right Shift = открыть/закрыть меню",C.PA)
mkInfo(bindp,"Нажми кнопку → нажми клавишу для привязки",C.DIM)
mkBind(bindp,"Aimbot (вкл/выкл)","Aim")
mkBind(bindp,"Fly","Fly")
mkBind(bindp,"Speed","Speed")
mkBind(bindp,"ESP","ESP")
mkBind(bindp,"NoClip","NC")
mkBind(bindp,"Fling (мгновенный)","Fling")

-- ════════════════════════
-- HUD
-- ════════════════════════
local HUDFrame = Instance.new("Frame", GUI)
HUDFrame.Size           = UDim2.new(0, 235, 0, 30)
HUDFrame.Position       = UDim2.new(0, 6, 0, 36)
HUDFrame.BackgroundColor3 = Color3.fromRGB(6,3,12)
HUDFrame.BackgroundTransparency = 0.05
HUDFrame.BorderSizePixel = 0
HUDFrame.ZIndex         = 500
Instance.new("UICorner", HUDFrame).CornerRadius = UDim.new(0, 9)
local HUDS = Instance.new("UIStroke", HUDFrame)
HUDS.Color      = C.P
HUDS.Thickness  = 1.5
HUDS.Transparency = 0.2

local HUDDot = Instance.new("Frame", HUDFrame)
HUDDot.Size     = UDim2.new(0, 7, 0, 7)
HUDDot.Position = UDim2.new(0, 9, 0.5, -3)
HUDDot.BackgroundColor3 = C.GRN
HUDDot.BorderSizePixel  = 0
HUDDot.ZIndex   = 501
Instance.new("UICorner", HUDDot).CornerRadius = UDim.new(1, 0)

local HUDText = Instance.new("TextLabel", HUDFrame)
HUDText.Size    = UDim2.new(1, -22, 1, 0)
HUDText.Position = UDim2.new(0, 22, 0, 0)
HUDText.BackgroundTransparency = 1
HUDText.Text    = "VANGUARD X | 60 FPS"
HUDText.TextColor3 = C.TXT
HUDText.Font    = Enum.Font.GothamBold
HUDText.TextSize = 10
HUDText.TextXAlignment = Enum.TextXAlignment.Left
HUDText.ZIndex  = 501

local HUD2 = Instance.new("Frame", GUI)
HUD2.Size       = UDim2.new(0, 235, 0, 20)
HUD2.Position   = UDim2.new(0, 6, 0, 70)
HUD2.BackgroundColor3 = Color3.fromRGB(6,3,12)
HUD2.BackgroundTransparency = 0.1
HUD2.BorderSizePixel = 0
HUD2.ZIndex     = 500
HUD2.Visible    = false
Instance.new("UICorner", HUD2).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", HUD2).Color = C.P

local HUD2Text = Instance.new("TextLabel", HUD2)
HUD2Text.Size   = UDim2.new(1,-8,1,0)
HUD2Text.Position = UDim2.new(0,8,0,0)
HUD2Text.BackgroundTransparency = 1
HUD2Text.TextColor3 = C.GRN
HUD2Text.Font   = Enum.Font.Gotham
HUD2Text.TextSize = 9
HUD2Text.TextXAlignment = Enum.TextXAlignment.Left
HUD2Text.ZIndex = 501

-- MM2 HUD
local MM2HUD = Instance.new("Frame", GUI)
MM2HUD.Size     = UDim2.new(0, 235, 0, 20)
MM2HUD.Position = UDim2.new(0, 6, 0, 94)
MM2HUD.BackgroundColor3 = Color3.fromRGB(14,3,3)
MM2HUD.BackgroundTransparency = 0.1
MM2HUD.BorderSizePixel = 0
MM2HUD.ZIndex   = 500
MM2HUD.Visible  = true
Instance.new("UICorner", MM2HUD).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MM2HUD).Color = C.MM2

local MM2HUDText = Instance.new("TextLabel", MM2HUD)
MM2HUDText.Size   = UDim2.new(1,-8,1,0)
MM2HUDText.Position = UDim2.new(0,8,0,0)
MM2HUDText.BackgroundTransparency = 1
MM2HUDText.Text   = "MM2: Загрузка..."
MM2HUDText.TextColor3 = C.MM2
MM2HUDText.Font   = Enum.Font.GothamBold
MM2HUDText.TextSize = 9
MM2HUDText.TextXAlignment = Enum.TextXAlignment.Left
MM2HUDText.ZIndex = 501

-- Пульс
task.spawn(function()
    while task.wait(1.1) do
        if not HUDDot.Parent then break end
        Tw(HUDDot, 1.1, {BackgroundTransparency=0.85}, Enum.EasingStyle.Sine)
        task.wait(1.1)
        if not HUDDot.Parent then break end
        Tw(HUDDot, 1.1, {BackgroundTransparency=0}, Enum.EasingStyle.Sine)
    end
end)

-- ════════════════════════
-- РАДАР
-- ════════════════════════
local RadarF = Instance.new("Frame", GUI)
RadarF.Size     = UDim2.new(0, 150, 0, 150)
RadarF.Position = UDim2.new(1,-158,1,-158)
RadarF.BackgroundColor3 = Color3.fromRGB(4,2,10)
RadarF.BackgroundTransparency = 0.1
RadarF.BorderSizePixel = 0
RadarF.Visible  = false
RadarF.ZIndex   = 400
Instance.new("UICorner", RadarF).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", RadarF).Color = C.P
for _, h in ipairs({true,false}) do
    local l = Instance.new("Frame", RadarF)
    l.Size  = h and UDim2.new(1,0,0,1) or UDim2.new(0,1,1,0)
    l.Position = h and UDim2.new(0,0,0.5,0) or UDim2.new(0.5,0,0,0)
    l.BackgroundColor3 = C.P; l.BackgroundTransparency = 0.8; l.BorderSizePixel = 0; l.ZIndex = 400
end
local RadCenter = Instance.new("Frame", RadarF)
RadCenter.Size  = UDim2.new(0,8,0,8); RadCenter.Position = UDim2.new(0.5,-4,0.5,-4)
RadCenter.BackgroundColor3 = C.WHT; RadCenter.BorderSizePixel = 0; RadCenter.ZIndex = 401
Instance.new("UICorner", RadCenter).CornerRadius = UDim.new(1,0)

local radarDots = {}

-- ════════════════════════
-- ESP
-- ════════════════════════
local SKELETON = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
}
local ESPObjs = {}

local function createESP(pl)
    if ESPObjs[pl] or not hasDrawing then return end
    local e = {Bones={}}
    pcall(function()
        e.Box  = Drawing.new("Square"); e.Box.Filled=false; e.Box.Thickness=1.5
        e.BoxSh= Drawing.new("Square"); e.BoxSh.Filled=false; e.BoxSh.Thickness=3; e.BoxSh.Color=Color3.new(0,0,0); e.BoxSh.Transparency=0.6
        e.Name = Drawing.new("Text"); e.Name.Size=13; e.Name.Center=true; e.Name.Outline=true; e.Name.Font=Drawing.Fonts.Plex; e.Name.Color=Color3.new(1,1,1)
        e.Role = Drawing.new("Text"); e.Role.Size=11; e.Role.Center=true; e.Role.Outline=true; e.Role.Font=Drawing.Fonts.Plex
        e.HPbg = Drawing.new("Square"); e.HPbg.Filled=true; e.HPbg.Color=Color3.new(0,0,0); e.HPbg.Transparency=0.5
        e.HPfg = Drawing.new("Square"); e.HPfg.Filled=true
        e.HPtx = Drawing.new("Text"); e.HPtx.Size=9; e.HPtx.Center=true; e.HPtx.Outline=true; e.HPtx.Font=Drawing.Fonts.Plex
        e.Dist = Drawing.new("Text"); e.Dist.Size=11; e.Dist.Center=true; e.Dist.Outline=true; e.Dist.Font=Drawing.Fonts.Plex; e.Dist.Color=Color3.fromRGB(155,135,195)
        e.Trac = Drawing.new("Line"); e.Trac.Thickness=1.2
        for i=1,#SKELETON do local l=Drawing.new("Line"); l.Thickness=1; l.Visible=false; e.Bones[i]=l end
    end)
    ESPObjs[pl] = e
end

local function hideAllESP(e)
    pcall(function()
        for _, k in ipairs({"Box","BoxSh","Name","Role","HPbg","HPfg","HPtx","Dist","Trac"}) do
            if e[k] then e[k].Visible=false end
        end
        for _, b in ipairs(e.Bones) do b.Visible=false end
    end)
end

local function removeESP(pl)
    if not ESPObjs[pl] then return end
    pcall(function()
        for _, d in pairs(ESPObjs[pl]) do
            if type(d)=="table" then for _,b in ipairs(d) do pcall(function() b:Remove() end) end
            elseif type(d)~="boolean" and type(d)~="number" and type(d)~="string" then
                pcall(function() d:Remove() end) end
        end
    end)
    ESPObjs[pl] = nil
end

local function updateESP(pl)
    if not hasDrawing then return end
    if not ESPObjs[pl] then createESP(pl) end
    local e = ESPObjs[pl]; if not e then return end
    if not S.ESPOn then hideAllESP(e); return end

    pcall(function()
        local ch = pl.Character; if not ch then hideAllESP(e); return end
        local head = ch:FindFirstChild("Head"); local root = ch:FindFirstChild("HumanoidRootPart")
        local hum  = ch:FindFirstChildOfClass("Humanoid")
        if not (head and root and hum and hum.Health > 0) then hideAllESP(e); return end

        -- Экранные координаты
        local tsp, ton = Cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.7,0))
        if not ton then hideAllESP(e); return end
        local bsp = Cam:WorldToViewportPoint(root.Position - Vector3.new(0,2.8,0))
        local ht  = math.abs(bsp.Y - tsp.Y)
        local wd  = ht * 0.58
        local x   = tsp.X - wd/2
        local y   = tsp.Y

        -- Цвет по роли MM2
        local role = getMM2Role(pl)
        local espCol
        if role == "Murderer" then espCol = C.RED
        elseif role == "Sheriff" then espCol = C.YLW
        else espCol = S.ESPCol end

        local vis = isVisible(head)
        local hpR = math.clamp(hum.Health / math.max(hum.MaxHealth,1), 0, 1)
        local hpC = Color3.fromRGB(math.floor(255*(1-hpR)), math.floor(255*hpR), 60)

        -- BOX
        if S.ESPBox then
            e.BoxSh.Position=Vector2.new(x-1,y-1); e.BoxSh.Size=Vector2.new(wd+2,ht+2); e.BoxSh.Visible=true
            e.Box.Position=Vector2.new(x,y); e.Box.Size=Vector2.new(wd,ht)
            e.Box.Color=vis and espCol or Color3.fromRGB(255,70,70); e.Box.Visible=true
        else e.Box.Visible=false; e.BoxSh.Visible=false end

        -- NAME
        if S.ESPName then e.Name.Text=pl.Name; e.Name.Position=Vector2.new(tsp.X,y-18); e.Name.Visible=true
        else e.Name.Visible=false end

        -- ROLE (MM2)
        if S.MM2Roles then
            local roleText = {Murderer="🔪 МАРЖЕР",Sheriff="🔫 ШЕРИФ",Innocent=""}
            e.Role.Text  = roleText[role] or ""
            e.Role.Color = espCol
            e.Role.Position = Vector2.new(tsp.X, y - 32)
            e.Role.Visible  = (role == "Murderer" or role == "Sheriff")
        else e.Role.Visible=false end

        -- HP BAR
        if S.ESPHPbar then
            local bx = x-9
            e.HPbg.Position=Vector2.new(bx,y); e.HPbg.Size=Vector2.new(4,ht); e.HPbg.Visible=true
            e.HPfg.Position=Vector2.new(bx,y+ht*(1-hpR)); e.HPfg.Size=Vector2.new(4,ht*hpR)
            e.HPfg.Color=hpC; e.HPfg.Visible=true
            e.HPtx.Text=math.floor(hum.Health).."hp"; e.HPtx.Position=Vector2.new(bx-16,y+ht/2-5); e.HPtx.Color=hpC; e.HPtx.Visible=true
        else e.HPbg.Visible=false; e.HPfg.Visible=false; e.HPtx.Visible=false end

        -- DISTANCE
        if S.ESPDist and Ro() then
            e.Dist.Text=string.format("[%dm]",math.floor((Ro().Position-root.Position).Magnitude))
            e.Dist.Position=Vector2.new(tsp.X,y+ht+5); e.Dist.Visible=true
        else e.Dist.Visible=false end

        -- TRACER
        if S.ESPTracer then
            e.Trac.From=Vector2.new(Cam.ViewportSize.X/2,Cam.ViewportSize.Y)
            e.Trac.To=Vector2.new(tsp.X,y+ht); e.Trac.Color=espCol; e.Trac.Visible=true
        else e.Trac.Visible=false end

        -- SKELETON
        if S.ESPSkel then
            for i,pair in ipairs(SKELETON) do
                local p1=ch:FindFirstChild(pair[1]); local p2=ch:FindFirstChild(pair[2])
                if p1 and p2 then
                    local s1,o1=Cam:WorldToViewportPoint(p1.Position); local s2,o2=Cam:WorldToViewportPoint(p2.Position)
                    if o1 and o2 then e.Bones[i].From=Vector2.new(s1.X,s1.Y); e.Bones[i].To=Vector2.new(s2.X,s2.Y); e.Bones[i].Color=espCol; e.Bones[i].Visible=true
                    else e.Bones[i].Visible=false end
                else e.Bones[i].Visible=false end
            end
        else for _,b in ipairs(e.Bones) do b.Visible=false end end

        -- CHAMS (MM2 or regular)
        local chamCol = nil
        if S.MM2Chams and (role == "Murderer" or role == "Sheriff") then
            chamCol = espCol
        elseif S.ESPChams then
            chamCol = vis and espCol or Color3.fromRGB(255,60,60)
        end

        local existHl = ch:FindFirstChild("VG_HL")
        if chamCol then
            if not existHl then
                existHl = Instance.new("Highlight"); existHl.Name="VG_HL"
                existHl.FillTransparency=0.45; existHl.OutlineTransparency=0; existHl.Parent=ch
            end
            existHl.FillColor=chamCol; existHl.OutlineColor=chamCol
        else
            if existHl then existHl:Destroy() end
        end
    end)
end

Players.PlayerAdded:Connect(function(pl)
    pl.CharacterAdded:Connect(function()
        task.delay(1.5, function() createESP(pl) end)
    end)
end)
Players.PlayerRemoving:Connect(removeESP)
for _, pl in ipairs(Players:GetPlayers()) do
    if pl ~= LP then task.spawn(createESP, pl) end
end

-- FOV CIRCLE + CROSSHAIR
local fovCircle, crossLines, crossDot
if hasDrawing then
    pcall(function()
        fovCircle = Drawing.new("Circle")
        fovCircle.NumSides = 60; fovCircle.Filled=false; fovCircle.Thickness=1.5
        fovCircle.Visible=false; fovCircle.Color=C.P

        crossLines = {}
        for i=1,4 do
            local l=Drawing.new("Line"); l.Thickness=2; l.Visible=false; l.Color=C.WHT; crossLines[i]=l
        end
        crossDot = Drawing.new("Circle"); crossDot.Filled=true; crossDot.Radius=2.5
        crossDot.Visible=false; crossDot.Color=C.WHT; crossDot.Thickness=0; crossDot.NumSides=12
    end)
end

-- ════════════════════════
-- ПЕРЕМЕННЫЕ ЛУПА
-- ════════════════════════
local frameCount = 0
local fps        = 60
local fpsTimer   = 0
local mainTimer  = 0

-- MM2 таймеры
local mm2ShootTimer = 0
local mm2ThrowTimer = 0
local mm2GrabTimer  = 0
local mm2UpdateTimer = 0

-- Общие таймеры
local trigTimer2    = 0
local clickTimer    = 0
local afkTimer      = 0
local flingAutoTimer= 0
local hbTimer       = 0
local espTimer      = 0
local roleUpdateTimer = 0

local HBCache = {}
local hue     = 0

local function countActive()
    local a = {}
    if S.AimOn   then table.insert(a,"AIM") end
    if S.TrigOn  then table.insert(a,"TRIG") end
    if S.ESPOn   then table.insert(a,"ESP") end
    if S.FlyOn   then table.insert(a,"FLY") end
    if S.SpeedOn then table.insert(a,"SPD") end
    if S.NoclipOn then table.insert(a,"NC") end
    if S.GodMode then table.insert(a,"GOD") end
    if S.BhopOn  then table.insert(a,"BHOP") end
    if S.AttachOn then table.insert(a,"ATTACH") end
    if S.SexOn   then table.insert(a,"SEX") end
    if S.FlingOn then table.insert(a,"FLING") end
    if S.MM2AutoShoot then table.insert(a,"MM2🔫") end
    if S.MM2AutoThrow then table.insert(a,"MM2🔪") end
    return a
end

-- ════════════════════════
-- RENDER STEPPED
-- ════════════════════════
RunService.RenderStepped:Connect(function(dt)
    frameCount = frameCount + 1
    fpsTimer = fpsTimer + dt
    mainTimer = mainTimer + dt

    -- FPS counter
    if fpsTimer >= 1 then
        fps = frameCount; frameCount = 0; fpsTimer = 0
        pcall(function() HUDText.Text = string.format("VANGUARD X v29 | %d FPS", fps) end)
        -- Обновляем HUD
        local active = countActive()
        RSubtitle.Text = tostring(#active).." активных функций"
        if #active > 0 then HUD2Text.Text = "● "..table.concat(active," "); HUD2.Visible=true
        else HUD2.Visible=false end
        -- MM2 HUD
        local myRole = getMM2Role(LP)
        local roleEmoji = {Murderer="🔪 МАРЖЕР",Sheriff="🔫 ШЕРИФ",Innocent="😇 НЕВИННЫЙ"}
        MM2HUDText.Text = "MM2: "..(roleEmoji[myRole] or "???")
            .." | 🔪 "..(MM2State.murderer and MM2State.murderer.Name or "нет")
    end

    -- RGB
    if S.RGB then
        hue = (hue + dt * 0.18) % 1
        local c = Color3.fromHSV(hue, 0.88, 1)
        S.ESPCol = c
        pcall(function()
            MStk.Color=c; HUDS.Color=c; SepL.BackgroundColor3=c; SepL2.BackgroundColor3=c
            RDiv.BackgroundColor3=c; LogoVer.TextColor3=c; LogoIco.TextColor3=c
            if fovCircle then fovCircle.Color=c end
        end)
    else S.ESPCol = C.P end

    -- FOV CIRCLE
    if fovCircle then
        pcall(function()
            fovCircle.Position = UIS:GetMouseLocation()
            fovCircle.Radius   = S.AimFOV
            fovCircle.Visible  = S.AimOn and S.AimFOVShow and not menuOpen
        end)
    end

    -- CROSSHAIR
    if crossLines then
        pcall(function()
            local vp = Cam.ViewportSize
            local cx, cy = vp.X/2, vp.Y/2
            local cs, cg, ct = S.CrossSize, S.CrossGap, S.CrossThick
            local show = S.Crosshair
            crossLines[1].From=Vector2.new(cx-cs-cg,cy); crossLines[1].To=Vector2.new(cx-cg,cy)
            crossLines[2].From=Vector2.new(cx+cg,cy);    crossLines[2].To=Vector2.new(cx+cs+cg,cy)
            crossLines[3].From=Vector2.new(cx,cy-cs-cg); crossLines[3].To=Vector2.new(cx,cy-cg)
            crossLines[4].From=Vector2.new(cx,cy+cg);    crossLines[4].To=Vector2.new(cx,cy+cs+cg)
            for _, l in ipairs(crossLines) do l.Thickness=ct; l.Visible=show end
            if crossDot then crossDot.Position=Vector2.new(cx,cy); crossDot.Visible=show and S.CrossDot end
        end)
    end

    -- FOV CHANGER
    if S.FOVChange then pcall(function() Cam.FieldOfView=S.FOVVal end) end

    -- ════ AIMBOT ════
    if S.AimOn and not menuOpen then
        local shouldAim = S.AimHold
            and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
            or (not S.AimHold and aimActive)

        if shouldAim then
            doAim(dt)
        end
    end
end)

-- ════════════════════════
-- HEARTBEAT
-- ════════════════════════
RunService.Heartbeat:Connect(function(dt)
    mainTimer = mainTimer + dt
    espTimer  = espTimer + dt
    hbTimer   = hbTimer + dt
    mm2ShootTimer = mm2ShootTimer + dt
    mm2ThrowTimer = mm2ThrowTimer + dt
    mm2GrabTimer  = mm2GrabTimer + dt
    mm2UpdateTimer = mm2UpdateTimer + dt
    trigTimer2    = trigTimer2 + dt
    clickTimer    = clickTimer + dt
    afkTimer      = afkTimer + dt
    flingAutoTimer = flingAutoTimer + dt
    roleUpdateTimer = roleUpdateTimer + dt

    -- Обновление ролей MM2 каждые 2 секунды
    if roleUpdateTimer >= 2 then
        roleUpdateTimer = 0
        task.spawn(function()
            refreshMM2Status()
            rebuildRoleList()
        end)
    end

    -- ESP Update
    if espTimer >= 0.045 then
        espTimer = 0
        if hasDrawing then
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LP then pcall(updateESP, pl) end
            end
        end
    end

    -- RADAR Update
    RadarF.Visible = S.Radar
    if S.Radar then
        local sz = S.RadarSize
        RadarF.Size     = UDim2.new(0,sz,0,sz)
        RadarF.Position = UDim2.new(1,-sz-8,1,-sz-8)
    end
    if S.Radar and Ro() then
        for _, d in ipairs(radarDots) do pcall(function() d:Destroy() end) end
        radarDots = {}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl == LP then continue end
            pcall(function()
                if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local pr  = pl.Character.HumanoidRootPart
                    local rel = Ro().CFrame:ToObjectSpace(pr.CFrame).Position
                    local dot = Instance.new("Frame", RadarF)
                    dot.Size  = UDim2.new(0,8,0,8)
                    dot.Position = UDim2.new(
                        0.5 + math.clamp(rel.X/110,-0.43,0.43), -4,
                        0.5 + math.clamp(-rel.Z/110,-0.43,0.43), -4)
                    local role = getMM2Role(pl)
                    dot.BackgroundColor3 = role=="Murderer" and C.RED or role=="Sheriff" and C.YLW or
                        (isVisible(pr) and C.GRN or C.ORG)
                    dot.BorderSizePixel = 0; dot.ZIndex = 401
                    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
                    table.insert(radarDots, dot)
                end
            end)
        end
    end

    -- ════ TRIGGERBOT ════
    if S.TrigOn and not menuOpen then
        if trigTimer2 >= S.TrigDelay then
            trigTimer2 = 0
            doTrigger()
        end
    end

    -- ════ AUTO CLICK ════
    if S.AutoClick and not menuOpen then
        if clickTimer >= 1/math.max(S.AutoCPS,1) then
            clickTimer = 0
            pcall(function() mouse1click() end)
        end
    end

    -- ════ HITBOX ════
    if hbTimer >= 0.15 then
        hbTimer = 0
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl == LP then continue end
            pcall(function()
                local ch = pl.Character; if not ch then return end
                local r  = ch:FindFirstChild("HumanoidRootPart"); if not r then return end
                if S.HitboxOn then
                    if not HBCache[pl] then
                        HBCache[pl] = {r.Size, r.Transparency, r.Material, r.Color}
                    end
                    r.Size         = Vector3.new(S.HitboxSize, S.HitboxSize, S.HitboxSize)
                    r.Transparency = 0.78
                    r.CanCollide   = false
                    r.Color        = Color3.fromRGB(100,0,180)
                    r.Material     = Enum.Material.ForceField
                else
                    if HBCache[pl] then
                        r.Size        = HBCache[pl][1]; r.Transparency = HBCache[pl][2]
                        r.Material    = HBCache[pl][3]; r.Color        = HBCache[pl][4]
                        HBCache[pl]   = nil
                    end
                end
            end)
        end
    end

    -- ════ NOCLIP ════
    pcall(function()
        if S.NoclipOn and Ch() then
            for _, p in ipairs(Ch():GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)

    -- ════ FLY ════
    pcall(function()
        local root = Ro(); local hum = Hu()
        local busyWithTrolling = S.AttachOn or S.SexOn or S.OrbitOn or flingBusy

        if S.FlyOn and not busyWithTrolling and root and hum then
            hum.PlatformStand = true
            local bv = root:FindFirstChild("VG_BV")
            if not bv then
                bv = Instance.new("BodyVelocity", root)
                bv.Name = "VG_BV"
                bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                bv.Velocity = Vector3.new()
            end
            local mv = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then mv = mv + Cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then mv = mv - Cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then mv = mv - Cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then mv = mv + Cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then mv = mv + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                mv = mv - Vector3.new(0,1,0)
            end
            bv.Velocity = mv.Magnitude > 0 and mv.Unit * S.FlySpeed or Vector3.new()

        elseif not S.FlyOn and not busyWithTrolling and root then
            local bv = root:FindFirstChild("VG_BV")
            if bv then bv:Destroy() end
            if hum then hum.PlatformStand = false end
        end
    end)

    -- ════ SPEED ════
    pcall(function()
        if S.SpeedOn and Hu() then Hu().WalkSpeed = S.SpeedVal end
    end)

    -- ════ BHOP ════
    pcall(function()
        if S.BhopOn and Hu() and UIS:IsKeyDown(Enum.KeyCode.Space)
            and Hu().FloorMaterial ~= Enum.Material.Air then
            Hu():ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- ════ INF JUMP ════
    pcall(function()
        if S.InfJump and Hu() and UIS:IsKeyDown(Enum.KeyCode.Space) then
            Hu():ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- ════ NO FALL ════
    pcall(function()
        if S.NoFall and Hu() then
            Hu():SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        end
    end)

    -- ════ LOW GRAV ════
    pcall(function()
        if S.LowGrav then workspace.Gravity = S.GravVal end
    end)

    -- ════ GOD MODE ════
    pcall(function()
        if S.GodMode and Hu() then
            local h = Hu()
            if h.Health < h.MaxHealth then h.Health = h.MaxHealth end
        end
    end)

    -- ════ ANTI AFK ════
    if S.AntiAFK then
        afkTimer = afkTimer + dt
        if afkTimer >= 55 then
            afkTimer = 0
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                task.delay(0.12, function()
                    vim:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                end)
            end)
        end
    end

    -- ════ CLICK TP ════
    pcall(function()
        if S.ClickTP and not menuOpen
            and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local r = Ro()
            if r and Mouse.Hit then
                r.CFrame = Mouse.Hit + Vector3.new(0, 4, 0)
            end
        end
    end)

    -- ════ INF AMMO ════
    pcall(function()
        if S.InfAmmo and Ch() then
            local tool = Ch():FindFirstChildOfClass("Tool"); if not tool then return end
            for _, v in ipairs(tool:GetDescendants()) do
                if v:IsA("IntValue") or v:IsA("NumberValue") then
                    local n = v.Name:lower()
                    if (n:find("ammo") or n:find("bullet") or n:find("mag") or n:find("clip")) and v.Value < 60 then
                        v.Value = 999
                    end
                end
            end
        end
    end)

    -- ════ AUTO RESPAWN ════
    pcall(function()
        if S.AutoRespawn and Hu() and Hu().Health <= 0 then
            task.delay(0.5, function()
                pcall(function() if Hu() then Hu().Health = 0 end end)
            end)
        end
    end)

    -- ════ TIME FREEZE ════
    pcall(function()
        if S.TimeFreeze then Lighting.ClockTime = S.TimeVal end
    end)

    -- ════ ATTACH AURA ════
    pcall(function()
        if not S.AttachOn then return end
        local root = Ro(); if not root then return end
        local pl = findPlayer(S.AttachTarget)
        if not pl or not pl.Character then return end
        local boneNames = {["Голова"]="Head",["Низ спины"]="LowerTorso",["Торс"]="UpperTorso"}
        local bn = boneNames[S.AttachBone] or "Head"
        local bone = pl.Character:FindFirstChild(bn) or pl.Character:FindFirstChild("HumanoidRootPart")
        if not bone then return end
        if Hu() then Hu().PlatformStand = true end
        local wave = math.sin(mainTimer * S.AttachSpeed) * S.AttachAmp
        local bcf  = bone.CFrame
        local pos
        if S.AttachBone == "Низ спины" then
            pos = bcf.Position - bcf.LookVector * (S.AttachAmp + wave * 0.5) + Vector3.new(0,-0.8,0)
        else
            pos = bcf.Position + bcf.LookVector * wave + Vector3.new(0,0.3,0)
        end
        local bp = root:FindFirstChild("VG_AB")
        if not bp then
            bp = Instance.new("BodyPosition", root); bp.Name="VG_AB"
            bp.MaxForce=Vector3.new(1e6,1e6,1e6); bp.P=28000; bp.D=2200
        end
        bp.Position = pos
        -- Поворот
        local diff = (bcf.Position - root.Position) * Vector3.new(1,0,1)
        if diff.Magnitude > 0.1 then
            local bav = root:FindFirstChild("VG_ROT")
            if not bav then
                bav = Instance.new("BodyAngularVelocity",root); bav.Name="VG_ROT"
                bav.MaxTorque=Vector3.new(0,1e6,0)
            end
            local ta = math.atan2(diff.X,diff.Z)
            local ca = math.atan2(root.CFrame.LookVector.X,root.CFrame.LookVector.Z)
            local d2 = ta - ca
            while d2 > math.pi  do d2=d2-2*math.pi end
            while d2 < -math.pi do d2=d2+2*math.pi end
            bav.AngularVelocity = Vector3.new(0, d2*10, 0)
        end
    end)

    -- ════ SEX AURA ════
    pcall(function()
        if not S.SexOn then return end
        local root = Ro(); if not root then return end
        local pl = findPlayer(S.SexTarget)
        if not pl or not pl.Character then return end
        local boneNames = {["Низ спины"]="LowerTorso",["Голова"]="Head",["Торс"]="UpperTorso"}
        local bn = boneNames[S.SexBone] or "LowerTorso"
        local bone = pl.Character:FindFirstChild(bn) or pl.Character:FindFirstChild("HumanoidRootPart")
        if not bone then return end
        if Hu() then Hu().PlatformStand = true end
        local bcf  = bone.CFrame
        local wave = (math.sin(mainTimer * S.SexSpeed) + 1) / 2
        local pos  = bcf.Position - bcf.LookVector*(S.SexDist + wave*S.SexDist) + Vector3.new(0,-0.9,0)
        local bp = root:FindFirstChild("VG_SX")
        if not bp then
            bp = Instance.new("BodyPosition",root); bp.Name="VG_SX"
            bp.MaxForce=Vector3.new(1e6,1e6,1e6); bp.P=36000; bp.D=2600
        end
        bp.Position = pos
        -- Поворот к кости
        local look = bcf.LookVector * Vector3.new(1,0,1)
        if look.Magnitude > 0.1 then
            local bav = root:FindFirstChild("VG_SXR")
            if not bav then
                bav = Instance.new("BodyAngularVelocity",root); bav.Name="VG_SXR"
                bav.MaxTorque=Vector3.new(0,1e6,0)
            end
            local ta = math.atan2(look.X,look.Z)
            local ca = math.atan2(root.CFrame.LookVector.X,root.CFrame.LookVector.Z)
            local d2 = ta - ca
            while d2 > math.pi  do d2=d2-2*math.pi end
            while d2 < -math.pi do d2=d2+2*math.pi end
            bav.AngularVelocity = Vector3.new(0, d2*12, 0)
        end
    end)

    -- ════ AUTO FLING ════
    if S.FlingOn and flingAutoTimer >= 0.65 and not flingBusy then
        flingAutoTimer = 0
        task.spawn(doFling, S._flingT, "random")
    end

    -- ════ ORBIT ════
    pcall(function()
        if not S.OrbitOn then return end
        local root = Ro(); if not root then return end
        local pl   = findPlayer(S.OrbitTarget)
        if not pl or not pl.Character then return end
        local target = pl.Character:FindFirstChild("HumanoidRootPart"); if not target then return end
        if Hu() then Hu().PlatformStand = true end
        local angle = mainTimer * S.OrbitSpeed
        local bp = root:FindFirstChild("VG_OB")
        if not bp then
            bp = Instance.new("BodyPosition",root); bp.Name="VG_OB"
            bp.MaxForce=Vector3.new(1e6,1e6,1e6); bp.P=24000; bp.D=1400
        end
        bp.Position = target.Position + Vector3.new(
            math.cos(angle)*S.OrbitRadius,
            S.OrbitHeight,
            math.sin(angle)*S.OrbitRadius
        )
    end)

    -- ════ SPIN ════
    pcall(function()
        local r = Ro(); if not r then return end
        if S.SpinOn then
            local av = r:FindFirstChild("VG_SP")
            if not av then
                av = Instance.new("BodyAngularVelocity",r); av.Name="VG_SP"
                av.MaxTorque = Vector3.new(0,1e6,0)
            end
            av.AngularVelocity = Vector3.new(0, S.SpinSpeed, 0)
        else
            local av = r:FindFirstChild("VG_SP"); if av then av:Destroy() end
        end
    end)

    -- ═══════════════════════════════
    -- MM2 — АВТО-ВЫСТРЕЛ В МАРЖЕРА
    -- ═══════════════════════════════
    if S.MM2AutoShoot and mm2ShootTimer >= S.MM2ShootDelay then
        mm2ShootTimer = 0
        pcall(function()
            local murd = MM2State.murderer
            if not murd or not murd.Character then return end

            -- Есть ли пистолет?
            local hasPistol = false
            local myChar = Ch()
            if myChar then
                for _, obj in ipairs(myChar:GetChildren()) do
                    local n = obj.Name:lower()
                    if obj:IsA("Tool") and (n:find("gun") or n:find("sheriff") or n:find("revolver") or n:find("pistol")) then
                        hasPistol = true; break
                    end
                end
            end
            if not hasPistol then return end

            local head = murd.Character:FindFirstChild("Head")
            if not head then return end

            -- Проверяем видимость маржера
            if not isVisible(head) then return end

            -- Наводим камеру
            Cam.CFrame = Cam.CFrame:Lerp(
                CFrame.lookAt(Cam.CFrame.Position, head.Position + Vector3.new(0,0.2,0)),
                0.9
            )

            -- Ещё раз проверяем что прицел на маржере
            local sp, on = Cam:WorldToViewportPoint(head.Position)
            if not on then return end
            local mid = Cam.ViewportSize / 2
            local dist2 = (Vector2.new(sp.X,sp.Y) - mid).Magnitude
            if dist2 > 80 then return end  -- Прицел не на маржере

            -- Стреляем
            if myChar then
                local tool = myChar:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
            mouse1click()
        end)
    end

    -- ═══════════════════════════════
    -- MM2 — АВТО-БРОСОК НОЖА
    -- ═══════════════════════════════
    if S.MM2AutoThrow and mm2ThrowTimer >= S.MM2ThrowDelay then
        mm2ThrowTimer = 0
        pcall(function()
            -- Есть ли нож?
            local hasKnife = false
            local myChar = Ch()
            if myChar then
                for _, obj in ipairs(myChar:GetChildren()) do
                    local n = obj.Name:lower()
                    if obj:IsA("Tool") and (n:find("knife") or n:find("blade") or n:find("throw")) then
                        hasKnife = true; break
                    end
                end
            end
            if not hasKnife then return end

            local target = MM2State.murderer or nearestPlayer()
            if not target or not target.Character then return end

            local head = target.Character:FindFirstChild("Head")
            if not head then return end

            -- Наводим камеру на цель
            Cam.CFrame = Cam.CFrame:Lerp(
                CFrame.lookAt(Cam.CFrame.Position, head.Position),
                0.95
            )
            task.wait(0.03)

            -- Бросаем
            if myChar then
                local tool = myChar:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
            mouse1click()
        end)
    end

    -- ═══════════════════════════════
    -- MM2 — АВТО-ПОДБОР ОРУЖИЯ
    -- ═══════════════════════════════
    if S.MM2AutoGrab and mm2GrabTimer >= 2 then
        mm2GrabTimer = 0
        pcall(function()
            local myRoot = Ro(); if not myRoot then return end
            local closestGun, closestDist = nil, 60
            for _, obj in ipairs(workspace:GetDescendants()) do
                local n = obj.Name:lower()
                if (n:find("gun") or n:find("sheriff") or n:find("revolver")) and (obj:IsA("Tool") or obj:IsA("Model")) then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                    if handle then
                        local d = (myRoot.Position - handle.Position).Magnitude
                        if d < closestDist then closestDist=d; closestGun=handle end
                    end
                end
            end
            if closestGun then
                myRoot.CFrame = CFrame.new(closestGun.Position + Vector3.new(0,4,0))
                task.wait(0.2)
                -- ProximityPrompt
                local prompt = closestGun.Parent:FindFirstChildOfClass("ProximityPrompt") or closestGun:FindFirstChildOfClass("ProximityPrompt")
                if prompt then pcall(function() fireproximityprompt(prompt) end) end
            end
        end)
    end
end)

-- ════════════════════════
-- INPUT
-- ════════════════════════
local bindWaiting = false

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end

    -- Меню
    if input.KeyCode == Binds.Menu then
        menuOpen     = not menuOpen
        Main.Visible = menuOpen
        return
    end

    -- Aimbot toggle (если не удержание ПКМ)
    if not S.AimHold and Binds.Aim ~= Enum.KeyCode.Unknown and input.KeyCode == Binds.Aim then
        aimActive = not aimActive
        Notify("Aimbot", aimActive and "ВКЛ" or "ВЫКЛ", aimActive and C.GRN or C.RED, 1.5)
        return
    end

    -- Fling по бинду
    if Binds.Fling ~= Enum.KeyCode.Unknown and input.KeyCode == Binds.Fling then
        task.spawn(doFling, S._flingT, "up")
        return
    end

    -- Остальные бинды
    local keyMap = {
        Fly   = function() S.FlyOn=not S.FlyOn; Notify("Fly",S.FlyOn and "ВКЛ" or "ВЫКЛ",S.FlyOn and C.GRN or C.RED,1.5) end,
        Speed = function() S.SpeedOn=not S.SpeedOn; Notify("Speed",S.SpeedOn and "ВКЛ" or "ВЫКЛ",S.SpeedOn and C.GRN or C.RED,1.5) end,
        ESP   = function() S.ESPOn=not S.ESPOn; Notify("ESP",S.ESPOn and "ВКЛ" or "ВЫКЛ",S.ESPOn and C.GRN or C.RED,1.5) end,
        NC    = function() S.NoclipOn=not S.NoclipOn; Notify("NoClip",S.NoclipOn and "ВКЛ" or "ВЫКЛ",S.NoclipOn and C.GRN or C.RED,1.5) end,
    }
    for k, fn in pairs(keyMap) do
        if Binds[k] ~= Enum.KeyCode.Unknown and input.KeyCode == Binds[k] then fn() end
    end
end)

-- ════════════════════════
-- СТАРТ
-- ════════════════════════
task.spawn(function()
    Notify("VANGUARD X v29.0","Полная перепись — всё работает! ✅",C.P,6)
    task.wait(0.6)
    Notify("Aimbot","✅ Поворот камеры — работает везде",C.GRN,4)
    task.wait(0.5)
    Notify("Fling","✅ Телепорт внутрь + физический импульс",C.GRN,4)
    task.wait(0.5)
    Notify("TriggerBot","✅ НЕ стреляет сквозь стены",C.GRN,4)
    task.wait(0.5)
    Notify("MM2","✅ Авто-выстрел проверяет видимость маржера",C.MM2,4)
    task.wait(0.5)
    -- Начальная загрузка ролей
    refreshMM2Status()
    rebuildRoleList()
    Notify("MM2","Роли загружены ✓",C.GRN,3)
end)
