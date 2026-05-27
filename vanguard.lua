-- =====================================================
-- VANGUARD X | Minimal Premium Edition (Fully Working)
-- =====================================================

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки функций
local S = {
    Aimbot = false, ESP = false, Fly = false, Speed = false, Noclip = false,
    FlySpeed = 80, WalkSpeed = 60,
}

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 400)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 14, 27)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(160, 110, 255)

-- Драг (возможность двигать окно)
local dragToggle, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end end)

-- Создание кнопок
local function AddToggle(name, setting)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0, 180, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 28, 50)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        S[setting] = not S[setting]
        btn.BackgroundColor3 = S[setting] and Color3.fromRGB(160, 110, 255) or Color3.fromRGB(30, 28, 50)
    end)
end

AddToggle("Aimbot", "Aimbot")
AddToggle("ESP", "ESP")
AddToggle("Fly", "Fly")
AddToggle("Speed", "Speed")
AddToggle("Noclip", "Noclip")

-- =====================================================
-- ЛОГИКА ФУНКЦИЙ (Heartbeat)
-- =====================================================
RunService.Heartbeat:Connect(function()
    -- Fly
    if S.Fly then
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = root:FindFirstChild("FlyBV")
            if not bv then
                bv = Instance.new("BodyVelocity", root); bv.Name = "FlyBV"; bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            end
            local move = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
            bv.Velocity = move * S.FlySpeed
        end
    else
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character.HumanoidRootPart:FindFirstChild("FlyBV") then
            LP.Character.HumanoidRootPart.FlyBV:Destroy()
        end
    end
    
    -- Speed
    if S.Speed and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = S.WalkSpeed
    elseif LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = 16
    end
    
    -- Noclip
    if S.Noclip and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ESP Drawing
local EspObjects = {}
RunService.RenderStepped:Connect(function()
    if not S.ESP then
        for _, v in pairs(EspObjects) do v:Remove() end
        EspObjects = {}
        return
    end
    
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            if not EspObjects[pl] then
                local box = Drawing.new("Square")
                box.Visible = true; box.Color = Color3.new(1,1,1); box.Filled = false; box.Thickness = 2
                EspObjects[pl] = box
            end
            local pos, vis = Camera:WorldToViewportPoint(pl.Character.HumanoidRootPart.Position)
            if vis then
                EspObjects[pl].Position = Vector2.new(pos.X - 25, pos.Y - 25)
                EspObjects[pl].Size = Vector2.new(50, 50)
            else
                EspObjects[pl].Visible = false
            end
        end
    end
end)

-- Открытие по RightShift
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)
