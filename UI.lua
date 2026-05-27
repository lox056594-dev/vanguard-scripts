local UI = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer

UI.ClickSoundsEnabled = false

local refreshers = {}
local accentRegistry = {}

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = obj
    return c
end

function UI.RegisterRefresher(fn)
    table.insert(refreshers, fn)
    return fn
end

function UI.RefreshAll()
    for i = #refreshers, 1, -1 do
        local fn = refreshers[i]
        if type(fn) == "function" then
            pcall(fn)
        else
            table.remove(refreshers, i)
        end
    end
end

function UI.TrackAccent(obj, property)
    if obj and property then
        table.insert(accentRegistry, {obj = obj, prop = property})
    end
end

function UI.SetAccent(color)
    for i = #accentRegistry, 1, -1 do
        local item = accentRegistry[i]
        if not item.obj or not item.obj.Parent then
            table.remove(accentRegistry, i)
        else
            pcall(function()
                item.obj[item.prop] = color
            end)
        end
    end
end

function UI.ApplyTitleGradient(textLabel, enabled)
    local grad = textLabel:FindFirstChildOfClass("UIGradient")
    if enabled then
        if not grad then
            grad = Instance.new("UIGradient")
            grad.Parent = textLabel
        end
        grad.Rotation = 0
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180,140,255)),
        })
    else
        if grad then grad:Destroy() end
    end
end

function UI.PlayClickSound(parent, enabled)
    if not enabled then return end
    local s = Instance.new("Sound")
    s.Parent = parent
    s.SoundId = "rbxassetid://12222124"
    s.Volume = 0.35
    s.PlayOnRemove = true
    s:Destroy()
end

function UI.AnimateTab(button, state, theme)
    if state then
        TweenService:Create(button, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Color3.fromRGB(22, 17, 40)
        }):Play()
    else
        TweenService:Create(button, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
            BackgroundColor3 = theme.Card
        }):Play()
    end
end

function UI.CreateWindow(theme, opts)
    opts = opts or {}

    local gui = Instance.new("ScreenGui")
    gui.Name = opts.Name or "VanguardUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui

    local notifHolder = Instance.new("Frame")
    notifHolder.Name = "NotifHolder"
    notifHolder.Parent = gui
    notifHolder.AnchorPoint = Vector2.new(1, 1)
    notifHolder.Position = UDim2.new(1, -16, 1, -16)
    notifHolder.Size = UDim2.new(0, 320, 1, -32)
    notifHolder.BackgroundTransparency = 1
    notifHolder.ZIndex = 1000
    notifHolder:SetAttribute("notifId", 0)

    local notifLayout = Instance.new("UIListLayout", notifHolder)
    notifLayout.Padding = UDim.new(0, 8)
    notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local backdrop = Instance.new("Frame")
    backdrop.Name = "Backdrop"
    backdrop.Parent = gui
    backdrop.Size = UDim2.fromScale(1, 1)
    backdrop.BackgroundColor3 = Color3.fromRGB(4, 4, 8)
    backdrop.BackgroundTransparency = 0.42
    backdrop.BorderSizePixel = 0
    backdrop.Visible = false
    backdrop.ZIndex = 1

    local bgGrad = Instance.new("UIGradient", backdrop)
    bgGrad.Rotation = 135
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 16, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 14)),
    })

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Parent = gui
    main.Size = UDim2.new(0, 860, 0, 560)
    main.Position = UDim2.new(0.5, -430, 0.5, -280)
    main.BackgroundColor3 = Color3.fromRGB(12, 11, 22)
    main.BackgroundTransparency = 0.02
    main.BorderSizePixel = 0
    main.Visible = false
    main.ClipsDescendants = true
    main.ZIndex = 10
    corner(main, 16)

    local mainScale = Instance.new("UIScale", main)
    mainScale.Scale = 1

    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = theme.Accent
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.28

    local mainGrad = Instance.new("UIGradient", main)
    mainGrad.Rotation = 120
    mainGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 13, 27)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 7, 16)),
    })

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0, 190, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(11, 10, 21)
    sidebar.BackgroundTransparency = 0.02
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 11

    local sideGrad = Instance.new("UIGradient", sidebar)
    sideGrad.Rotation = 90
    sideGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 11, 24)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 7, 16)),
    })

    local sideTitle = Instance.new("TextLabel", sidebar)
    sideTitle.BackgroundTransparency = 1
    sideTitle.Position = UDim2.new(0, 18, 0, 16)
    sideTitle.Size = UDim2.new(1, -36, 0, 28)
    sideTitle.Text = "VANGUARD"
    sideTitle.TextColor3 = theme.Text
    sideTitle.Font = Enum.Font.GothamBold
    sideTitle.TextSize = 22
    sideTitle.TextXAlignment = Enum.TextXAlignment.Left
    sideTitle.ZIndex = 12

    local sideSub = Instance.new("TextLabel", sidebar)
    sideSub.BackgroundTransparency = 1
    sideSub.Position = UDim2.new(0, 18, 0, 42)
    sideSub.Size = UDim2.new(1, -36, 0, 16)
    sideSub.Text = "clean minimal menu"
    sideSub.TextColor3 = theme.Dim
    sideSub.Font = Enum.Font.Gotham
    sideSub.TextSize = 11
    sideSub.TextXAlignment = Enum.TextXAlignment.Left
    sideSub.ZIndex = 12

    local sideLine = Instance.new("Frame", sidebar)
    sideLine.BackgroundColor3 = theme.Accent
    sideLine.BackgroundTransparency = 0.5
    sideLine.BorderSizePixel = 0
    sideLine.Position = UDim2.new(0, 18, 0, 66)
    sideLine.Size = UDim2.new(0, 154, 0, 1)
    sideLine.ZIndex = 12

    local tabList = Instance.new("Frame", sidebar)
    tabList.BackgroundTransparency = 1
    tabList.Position = UDim2.new(0, 12, 0, 82)
    tabList.Size = UDim2.new(1, -24, 1, -92)
    tabList.ZIndex = 12

    local tabLayout = Instance.new("UIListLayout", tabList)
    tabLayout.Padding = UDim.new(0, 8)

    local content = Instance.new("Frame", main)
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 190, 0, 0)
    content.Size = UDim2.new(1, -190, 1, 0)
    content.ZIndex = 11

    local header = Instance.new("Frame", content)
    header.Name = "Header"
    header.BackgroundTransparency = 1
    header.Position = UDim2.new(0, 0, 0, 0)
    header.Size = UDim2.new(1, 0, 0, 64)
    header.ZIndex = 12

    local headerTitle = Instance.new("TextLabel", header)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Position = UDim2.new(0, 18, 0, 14)
    headerTitle.Size = UDim2.new(1, -160, 0, 24)
    headerTitle.Text = "Home"
    headerTitle.TextColor3 = theme.Text
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.TextSize = 22
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.ZIndex = 13

    local headerSub = Instance.new("TextLabel", header)
    headerSub.BackgroundTransparency = 1
    headerSub.Position = UDim2.new(0, 18, 0, 38)
    headerSub.Size = UDim2.new(1, -160, 0, 16)
    headerSub.Text = "simple, stable and clean"
    headerSub.TextColor3 = theme.Dim
    headerSub.Font = Enum.Font.Gotham
    headerSub.TextSize = 11
    headerSub.TextXAlignment = Enum.TextXAlignment.Left
    headerSub.ZIndex = 13

    local minBtn = Instance.new("TextButton", header)
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -72, 0, 16)
    minBtn.BackgroundColor3 = Color3.fromRGB(30, 28, 46)
    minBtn.Text = "–"
    minBtn.TextColor3 = theme.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 18
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 13
    corner(minBtn, 8)

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -36, 0, 16)
    closeBtn.BackgroundColor3 = Color3.fromRGB(70, 24, 38)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = theme.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 13
    corner(closeBtn, 8)

    local headerLine = Instance.new("Frame", header)
    headerLine.BackgroundColor3 = theme.Accent
    headerLine.BackgroundTransparency = 0.65
    headerLine.BorderSizePixel = 0
    headerLine.Position = UDim2.new(0, 16, 1, -1)
    headerLine.Size = UDim2.new(1, -32, 0, 1)
    headerLine.ZIndex = 12

    local api = {
        ScreenGui = gui,
        NotifHolder = notifHolder,
        Backdrop = backdrop,
        Main = main,
        MainScale = mainScale,
        Sidebar = sidebar,
        TabList = tabList,
        Content = content,
        Header = header,
        HeaderTitle = headerTitle,
        HeaderSub = headerSub,
        MainStroke = mainStroke,
        SideLine = sideLine,
        HeaderLine = headerLine,
    }

    function api:SetOpen(state, blurObj, blurEnabled)
        main.Visible = state
        backdrop.Visible = state
        if blurObj then
            blurObj.Size = state and (blurEnabled and 12 or 0) or 0
        end
    end

    function api:SetTitle(title, sub)
        headerTitle.Text = title or "Home"
        headerSub.Text = sub or ""
    end

    function api:Destroy()
        gui:Destroy()
    end

    do
        local dragging = false
        local dragStart
        local startPos

        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(
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

    closeBtn.MouseButton1Click:Connect(function()
        api:SetOpen(false)
    end)

    minBtn.MouseButton1Click:Connect(function()
        api:SetOpen(false)
    end)

    return api
end

function UI.CreatePage(parent)
    local page = Instance.new("ScrollingFrame", parent)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Position = UDim2.new(0, 0, 0, 64)
    page.Size = UDim2.new(1, 0, 1, -64)
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(160, 110, 255)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.ZIndex = 11

    local scale = Instance.new("UIScale", page)
    scale.Name = "PageScale"
    scale.Scale = 0.98

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingLeft = UDim.new(0, 18)
    pad.PaddingRight = UDim.new(0, 18)
    pad.PaddingBottom = UDim.new(0, 14)

    return page
end

function UI.CreateTabButton(parent, theme, name, icon)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 42)
    b.BackgroundColor3 = theme.Card
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.ZIndex = 12
    corner(b, 12)

    local stroke = Instance.new("UIStroke", b)
    stroke.Color = theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.7

    local bar = Instance.new("Frame", b)
    bar.Size = UDim2.new(0, 3, 0, 22)
    bar.Position = UDim2.new(0, 0, 0.5, -11)
    bar.BackgroundColor3 = theme.Accent
    bar.BackgroundTransparency = 1
    bar.BorderSizePixel = 0
    bar.ZIndex = 13
    corner(bar, 1)

    local ico = Instance.new("TextLabel", b)
    ico.BackgroundTransparency = 1
    ico.Position = UDim2.new(0, 10, 0, 0)
    ico.Size = UDim2.new(0, 20, 1, 0)
    ico.Text = icon or "•"
    ico.TextColor3 = theme.Dim
    ico.Font = Enum.Font.GothamBold
    ico.TextSize = 14
    ico.ZIndex = 13

    local lbl = Instance.new("TextLabel", b)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 34, 0, 0)
    lbl.Size = UDim2.new(1, -40, 1, 0)
    lbl.Text = name
    lbl.TextColor3 = theme.Dim
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 13

    local function refresh()
        stroke.Color = theme.Accent
        bar.BackgroundColor3 = theme.Accent
    end

    UI.RegisterRefresher(refresh)
    refresh()

    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Color3.fromRGB(18, 14, 32)
        }):Play()
    end)

    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12, Enum.EasingStyle.Quart), {
            BackgroundColor3 = theme.Card
        }):Play()
    end)

    return {
        Button = b,
        Label = lbl,
        Stroke = stroke,
        Bar = bar,
        Icon = ico,
        Refresh = refresh,
    }
end

function UI.CreateSection(parent, theme, text, sub)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, sub and 42 or 28)
    f.BackgroundTransparency = 1
    f.ZIndex = 12

    local lbl = Instance.new("TextLabel", f)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 2, 0, 0)
    lbl.Size = UDim2.new(1, -4, 0, 18)
    lbl.Text = text
    lbl.TextColor3 = theme.Accent
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
        sl.TextColor3 = theme.Dim
        sl.Font = Enum.Font.Gotham
        sl.TextSize = 10
        sl.TextXAlignment = Enum.TextXAlignment.Left
        sl.ZIndex = 13
    end

    local ln = Instance.new("Frame", f)
    ln.Size = UDim2.new(1, 0, 0, 1)
    ln.Position = UDim2.new(0, 0, 1, -1)
    ln.BackgroundColor3 = theme.Accent
    ln.BackgroundTransparency = 0.75
    ln.BorderSizePixel = 0
    ln.ZIndex = 13

    UI.TrackAccent(ln, "BackgroundColor3")
    return f
end

local function mkCard(parent, theme, height)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, 0, 0, height)
    card.BackgroundColor3 = theme.Card
    card.BorderSizePixel = 0
    card.ZIndex = 12
    corner(card, 12)

    local st = Instance.new("UIStroke", card)
    st.Color = theme.Accent
    st.Thickness = 1.1
    st.Transparency = 0.55

    UI.TrackAccent(st, "Color")
    return card, st
end

function UI.CreateLabel(parent, theme, label, color, desc)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, 0, 0, desc and 44 or 34)
    card.BackgroundColor3 = theme.Card
    card.BorderSizePixel = 0
    card.ZIndex = 12
    corner(card, 12)

    local st = Instance.new("UIStroke", card)
    st.Color = color or theme.Accent
    st.Thickness = 1.1
    st.Transparency = 0.65

    local txt = Instance.new("TextLabel", card)
    txt.BackgroundTransparency = 1
    txt.Position = UDim2.new(0, 14, 0, desc and 6 or 0)
    txt.Size = UDim2.new(1, -28, 0, 18)
    txt.Text = label
    txt.TextColor3 = color or theme.Text
    txt.Font = Enum.Font.GothamSemibold
    txt.TextSize = 12
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.ZIndex = 13

    if desc then
        local d = Instance.new("TextLabel", card)
        d.BackgroundTransparency = 1
        d.Position = UDim2.new(0, 14, 0, 22)
        d.Size = UDim2.new(1, -28, 0, 14)
        d.Text = desc
        d.TextColor3 = theme.Dim
        d.Font = Enum.Font.Gotham
        d.TextSize = 10
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.ZIndex = 13
    end

    return card
end

function UI.CreateDivider(parent, theme, color)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 1)
    f.BackgroundColor3 = color or theme.Accent
    f.BackgroundTransparency = 0.7
    f.BorderSizePixel = 0
    f.ZIndex = 12
    UI.TrackAccent(f, "BackgroundColor3")
    return f
end

function UI.CreateButton(parent, theme, label, desc, callback, col)
    local card, _ = mkCard(parent, theme, desc and 52 or 42)

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
    top.TextColor3 = col or theme.Text
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
        d.TextColor3 = theme.Dim
        d.Font = Enum.Font.Gotham
        d.TextSize = 10
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.ZIndex = 13
    end

    btn.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Color3.fromRGB(20, 16, 34)
        }):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12, Enum.EasingStyle.Quart), {
            BackgroundColor3 = theme.Card
        }):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        UI.PlayClickSound(card, UI.ClickSoundsEnabled)
        if callback then callback() end
    end)

    return card
end

function UI.CreateToggle(parent, theme, label, desc, get, set)
    local card, stroke = mkCard(parent, theme, desc and 60 or 44)

    local top = Instance.new("TextLabel", card)
    top.BackgroundTransparency = 1
    top.Position = UDim2.new(0, 14, 0, desc and 7 or 12)
    top.Size = UDim2.new(1, -90, 0, 18)
    top.Text = label
    top.TextColor3 = theme.Text
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
        d.TextColor3 = theme.Dim
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
    corner(sw, 1)

    local kn = Instance.new("Frame", sw)
    kn.Size = UDim2.new(0, 20, 0, 20)
    kn.Position = UDim2.new(0, 2, 0.5, -10)
    kn.BackgroundColor3 = Color3.fromRGB(85, 80, 105)
    kn.BorderSizePixel = 0
    kn.ZIndex = 14
    corner(kn, 1)

    local click = Instance.new("TextButton", card)
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.AutoButtonColor = false
    click.ZIndex = 15

    local function refresh()
        local on = get()
        if on then
            sw.BackgroundColor3 = theme.Accent
            kn.Position = UDim2.new(0, 24, 0.5, -10)
            kn.BackgroundColor3 = Color3.new(1, 1, 1)
            stroke.Transparency = 0.25
        else
            sw.BackgroundColor3 = Color3.fromRGB(28, 24, 44)
            kn.Position = UDim2.new(0, 2, 0.5, -10)
            kn.BackgroundColor3 = Color3.fromRGB(85, 80, 105)
            stroke.Transparency = 0.55
        end
    end

    click.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Color3.fromRGB(18, 14, 32)
        }):Play()
    end)

    click.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12, Enum.EasingStyle.Quart), {
            BackgroundColor3 = theme.Card
        }):Play()
    end)

    click.MouseButton1Click:Connect(function()
        UI.PlayClickSound(card, UI.ClickSoundsEnabled)
        set(not get())
        refresh()
    end)

    refresh()
    UI.RegisterRefresher(refresh)
    return refresh
end

function UI.CreateSlider(parent, theme, label, min, max, default, set)
    local card, _ = mkCard(parent, theme, 56)

    local title = Instance.new("TextLabel", card)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 14, 0, 8)
    title.Size = UDim2.new(1, -90, 0, 18)
    title.Text = label
    title.TextColor3 = theme.Text
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 13

    local valLbl = Instance.new("TextLabel", card)
    valLbl.BackgroundTransparency = 1
    valLbl.Position = UDim2.new(1, -72, 0, 8)
    valLbl.Size = UDim2.new(0, 56, 0, 18)
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = theme.Accent
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
    corner(track, 1)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = theme.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 14
    corner(fill, 1)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 15
    corner(knob, 1)

    local dragging = false

    local function applyFromX(x)
        local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local current = math.floor(min + (max - min) * pct + 0.5)
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

    local ratio = (default - min) / math.max((max - min), 1)
    fill.Size = UDim2.new(ratio, 0, 1, 0)
    knob.Position = UDim2.new(ratio, -7, 0.5, -7)
    set(default)

    local function refresh()
        fill.BackgroundColor3 = theme.Accent
        valLbl.TextColor3 = theme.Accent
    end
    refresh()
    UI.RegisterRefresher(refresh)

    return card
end

function UI.CreateTextBox(parent, theme, label, placeholder, defaultText, callback)
    local card, _ = mkCard(parent, theme, 50)

    local lbl = Instance.new("TextLabel", card)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 14, 0, 8)
    lbl.Size = UDim2.new(0.45, 0, 0, 18)
    lbl.Text = label
    lbl.TextColor3 = theme.Text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 13

    local box = Instance.new("TextBox", card)
    box.Size = UDim2.new(0.52, -16, 0, 26)
    box.Position = UDim2.new(0.48, 0, 0.5, -13)
    box.BackgroundColor3 = theme.Card2
    box.Text = defaultText or ""
    box.PlaceholderText = placeholder or ""
    box.TextColor3 = theme.Text
    box.PlaceholderColor3 = theme.Dim
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.ClearTextOnFocus = false
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ZIndex = 14
    corner(box, 8)

    local st = Instance.new("UIStroke", box)
    st.Color = theme.Accent
    st.Thickness = 1
    st.Transparency = 0.6
    UI.TrackAccent(st, "Color")

    box.FocusLost:Connect(function()
        if callback then
            callback(box.Text)
        end
    end)

    box.Focused:Connect(function()
        box.BackgroundColor3 = Color3.fromRGB(26, 22, 40)
        st.Transparency = 0.25
    end)

    box.FocusLost:Connect(function()
        box.BackgroundColor3 = theme.Card2
        st.Transparency = 0.6
    end)

    return card, box
end

function UI.CreateDropdown(parent, theme, label, options, default, callback)
    local screen = parent:FindFirstAncestorOfClass("ScreenGui") or CoreGui

    local card, _ = mkCard(parent, theme, 46)

    local lbl = Instance.new("TextLabel", card)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.Size = UDim2.new(0.48, 0, 1, 0)
    lbl.Text = label
    lbl.TextColor3 = theme.Text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 13

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0, 180, 0, 28)
    btn.Position = UDim2.new(1, -194, 0.5, -14)
    btn.BackgroundColor3 = theme.Card2
    btn.Text = tostring(default or options[1] or "None") .. " ▾"
    btn.TextColor3 = theme.Accent
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.AutoButtonColor = false
    btn.ZIndex = 14
    corner(btn, 8)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.55
    UI.TrackAccent(stroke, "Color")

    local ddFrame = Instance.new("Frame", screen)
    ddFrame.Visible = false
    ddFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 16)
    ddFrame.BorderSizePixel = 0
    ddFrame.ZIndex = 8000
    corner(ddFrame, 10)

    local ddStroke = Instance.new("UIStroke", ddFrame)
    ddStroke.Color = theme.Accent
    ddStroke.Thickness = 1.2
    ddStroke.Transparency = 0.25
    UI.TrackAccent(ddStroke, "Color")

    local ddScroll = Instance.new("ScrollingFrame", ddFrame)
    ddScroll.Size = UDim2.new(1, -8, 1, -8)
    ddScroll.Position = UDim2.new(0, 4, 0, 4)
    ddScroll.BackgroundTransparency = 1
    ddScroll.BorderSizePixel = 0
    ddScroll.ScrollBarThickness = 3
    ddScroll.ScrollBarImageColor3 = theme.Accent
    ddScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ddScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ddScroll.ZIndex = 8001

    local ddLayout = Instance.new("UIListLayout", ddScroll)
    ddLayout.Padding = UDim.new(0, 3)

    local ddPad = Instance.new("UIPadding", ddScroll)
    ddPad.PaddingTop = UDim.new(0, 2)
    ddPad.PaddingBottom = UDim.new(0, 2)

    local current = default or options[1] or "None"

    local function rebuild(opts)
        for _, c in ipairs(ddScroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end

        for _, opt in ipairs(opts) do
            local ob = Instance.new("TextButton", ddScroll)
            ob.Size = UDim2.new(1, 0, 0, 28)
            ob.BackgroundColor3 = Color3.fromRGB(24, 19, 36)
            ob.Text = tostring(opt)
            ob.TextColor3 = theme.Text
            ob.Font = Enum.Font.GothamSemibold
            ob.TextSize = 11
            ob.AutoButtonColor = false
            ob.ZIndex = 8002
            corner(ob, 7)

            ob.MouseEnter:Connect(function()
                TweenService:Create(ob, TweenInfo.new(0.08, Enum.EasingStyle.Quart), {
                    BackgroundColor3 = theme.Accent
                }):Play()
                ob.TextColor3 = Color3.new(1, 1, 1)
            end)

            ob.MouseLeave:Connect(function()
                TweenService:Create(ob, TweenInfo.new(0.08, Enum.EasingStyle.Quart), {
                    BackgroundColor3 = Color3.fromRGB(24, 19, 36)
                }):Play()
                ob.TextColor3 = theme.Text
            end)

            ob.MouseButton1Click:Connect(function()
                UI.PlayClickSound(ob, UI.ClickSoundsEnabled)
                current = tostring(opt)
                btn.Text = current .. " ▾"
                ddFrame.Visible = false
                if callback then callback(current) end
            end)
        end
    end

    rebuild(options)

    btn.MouseButton1Click:Connect(function()
        UI.PlayClickSound(btn, UI.ClickSoundsEnabled)

        if ddFrame.Visible then
            ddFrame.Visible = false
            return
        end

        local abs = btn.AbsolutePosition
        ddFrame.Size = UDim2.new(0, 194, 0, math.min(#options * 31 + 8, 220))
        ddFrame.Position = UDim2.new(0, abs.X, 0, abs.Y + 32)
        ddFrame.Visible = true
    end)

    return {
        Frame = ddFrame,
        Rebuild = rebuild,
        SetValue = function(v)
            current = tostring(v)
            btn.Text = current .. " ▾"
            if callback then callback(current) end
        end
    }
end

function UI.CreateKeybind(parent, theme, label, defaultKey, callback)
    local card, _ = mkCard(parent, theme, 46)

    local lbl = Instance.new("TextLabel", card)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.Size = UDim2.new(0.55, 0, 1, 0)
    lbl.Text = label
    lbl.TextColor3 = theme.Text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 13

    local kb = Instance.new("TextButton", card)
    kb.Size = UDim2.new(0, 112, 0, 28)
    kb.Position = UDim2.new(1, -126, 0.5, -14)
    kb.BackgroundColor3 = theme.Card2
    kb.Text = defaultKey and ("[ " .. defaultKey.Name .. " ]") or "[ None ]"
    kb.TextColor3 = theme.Accent
    kb.Font = Enum.Font.GothamBold
    kb.TextSize = 11
    kb.AutoButtonColor = false
    kb.ZIndex = 14
    corner(kb, 8)

    local stroke = Instance.new("UIStroke", kb)
    stroke.Color = theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.55
    UI.TrackAccent(stroke, "Color")

    local waiting = false
    local conn

    kb.MouseButton1Click:Connect(function()
        UI.PlayClickSound(kb, UI.ClickSoundsEnabled)
        if waiting then return end
        waiting = true
        kb.Text = "[ ... ]"
        kb.TextColor3 = theme.Yellow

        if conn then conn:Disconnect() end
        conn = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

            conn:Disconnect()
            conn = nil
            waiting = false

            local key = input.KeyCode
            kb.Text = key == Enum.KeyCode.Unknown and "[ None ]" or ("[ " .. key.Name .. " ]")
            kb.TextColor3 = theme.Accent
            if callback then callback(key) end
        end)
    end)

    return {
        SetKey = function(key)
            kb.Text = key == Enum.KeyCode.Unknown and "[ None ]" or ("[ " .. key.Name .. " ]")
            if callback then callback(key) end
        end
    }
end

return UI
