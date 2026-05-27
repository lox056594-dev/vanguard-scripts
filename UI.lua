local UI = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = obj
    return c
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
    main.BorderSizePixel = 0
    main.Visible = false
    main.ClipsDescendants = true
    main.ZIndex = 10
    corner(main, 16)

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
        Backdrop = backdrop,
        Main = main,
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

    -- drag only while menu open
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
    page.ScrollBarImageColor3 = parent.Parent and parent.Parent:FindFirstChildWhichIsA("UIStroke") and parent.Parent:FindFirstChildWhichIsA("UIStroke").Color or Color3.new(1,1,1)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.ZIndex = 11

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

function UI.CreateTabButton(parent, theme, name)
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

    local lbl = Instance.new("TextLabel", b)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.Size = UDim2.new(1, -28, 1, 0)
    lbl.Text = name
    lbl.TextColor3 = theme.Dim
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 13

    return {
        Button = b,
        Label = lbl,
        Stroke = stroke,
        Bar = bar,
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

    return card, st
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

    click.MouseButton1Click:Connect(function()
        set(not get())
        refresh()
    end)

    refresh()
    return refresh
end

function UI.CreateSlider(parent, theme, label, min, max, default, set)
    local card = mkCard(parent, theme, 56)

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

    return card
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

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return card
end

return UI
