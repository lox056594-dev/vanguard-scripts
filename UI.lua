local UI = {}
local Themes = require(script.Parent.Themes) -- Если переделываешь под модули

function UI:CreateWindow(name)
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 400, 0, 300)
    Main.Position = UDim2.new(0.5, -200, 0.5, -150)
    Main.BackgroundColor3 = Themes.Bg
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    
    -- Главная фишка, чтобы не было "черного экрана"
    local Layout = Instance.new("UIListLayout", Main)
    Layout.Padding = UDim.new(0, 5)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    return Main
end

function UI:AddToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 350, 0, 40)
    btn.BackgroundColor3 = Themes.Card
    btn.Text = text
    btn.TextColor3 = Themes.Text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Themes.Accent or Themes.Card
        callback(active)
    end)
end

return UI
