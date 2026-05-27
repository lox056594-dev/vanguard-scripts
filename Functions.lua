local Functions = {}

function Functions.NewState()
    return {
        -- general
        Notifications = true,
        FPSCounter = true,
        Watermark = true,
        WatermarkText = "VANGUARD",
        ShowTime = true,
        ShowUser = true,
        ClickSounds = false,

        -- menu
        RGB = false,
        Stars = true,
        StarCount = 100,
        MenuBlur = true,
        MenuScale = 1,
        MenuTransparency = 0.02,
        AccentSpeed = 1,
        AnimationSpeed = 1,
        CompactMode = false,
        MenuKey = Enum.KeyCode.RightShift,
        ThemePreset = "Purple",

        -- crosshair / camera
        Crosshair = true,
        CrossSize = 10,
        CrossGap = 5,
        CrossThick = 2,
        FOVChanger = false,
        FOVValue = 80,

        -- lighting
        FullBright = false,
        NoFog = false,
        LockTime = false,
        TimeValue = 14,

        -- post effects
        Bloom = true,
        BloomIntensity = 1.2,
        BloomSize = 24,

        SunRays = false,
        SunRaysIntensity = 0.08,
        SunRaysSpread = 0.85,

        ColorCorrection = true,
        Saturation = 0.05,
        Contrast = 0.03,
        Brightness = 0,

        DepthOfField = false,
        DOFFarIntensity = 0.15,
        DOFNearIntensity = 0.05,

        Vignette = false,
        LowPerformance = false,
    }
end

function Functions.NewDefaults(camera, lighting)
    return {
        FOV = camera.FieldOfView,
        Brightness = lighting.Brightness,
        Ambient = lighting.Ambient,
        OutdoorAmbient = lighting.OutdoorAmbient,
        FogEnd = lighting.FogEnd,
        ClockTime = lighting.ClockTime,
        GlobalShadows = lighting.GlobalShadows,
    }
end

function Functions.Reset(state)
    state.Notifications = true
    state.FPSCounter = true
    state.Watermark = true
    state.WatermarkText = "VANGUARD"
    state.ShowTime = true
    state.ShowUser = true
    state.ClickSounds = false

    state.RGB = false
    state.Stars = true
    state.StarCount = 100
    state.MenuBlur = true
    state.MenuScale = 1
    state.MenuTransparency = 0.02
    state.AccentSpeed = 1
    state.AnimationSpeed = 1
    state.CompactMode = false
    state.MenuKey = Enum.KeyCode.RightShift
    state.ThemePreset = "Purple"

    state.Crosshair = true
    state.CrossSize = 10
    state.CrossGap = 5
    state.CrossThick = 2
    state.FOVChanger = false
    state.FOVValue = 80

    state.FullBright = false
    state.NoFog = false
    state.LockTime = false
    state.TimeValue = 14

    state.Bloom = true
    state.BloomIntensity = 1.2
    state.BloomSize = 24

    state.SunRays = false
    state.SunRaysIntensity = 0.08
    state.SunRaysSpread = 0.85

    state.ColorCorrection = true
    state.Saturation = 0.05
    state.Contrast = 0.03
    state.Brightness = 0

    state.DepthOfField = false
    state.DOFFarIntensity = 0.15
    state.DOFNearIntensity = 0.05

    state.Vignette = false
    state.LowPerformance = false
end

function Functions.ApplyLighting(state, defaults, lighting, effects)
    if state.FullBright then
        lighting.Brightness = 3
        lighting.Ambient = Color3.new(1, 1, 1)
        lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        lighting.GlobalShadows = false
    else
        lighting.Brightness = defaults.Brightness
        lighting.Ambient = defaults.Ambient
        lighting.OutdoorAmbient = defaults.OutdoorAmbient
        lighting.GlobalShadows = defaults.GlobalShadows
    end

    if state.NoFog then
        lighting.FogEnd = 100000
    else
        lighting.FogEnd = defaults.FogEnd
    end

    if state.LockTime then
        lighting.ClockTime = state.TimeValue
    else
        lighting.ClockTime = defaults.ClockTime
    end

    if effects then
        local lp = state.LowPerformance

        if effects.Bloom then
            effects.Bloom.Enabled = state.Bloom and not lp
            effects.Bloom.Intensity = state.BloomIntensity
            effects.Bloom.Size = state.BloomSize
            effects.Bloom.Threshold = 0.9
        end

        if effects.SunRays then
            effects.SunRays.Enabled = state.SunRays and not lp
            effects.SunRays.Intensity = state.SunRaysIntensity
            effects.SunRays.Spread = state.SunRaysSpread
        end

        if effects.ColorCorrection then
            effects.ColorCorrection.Enabled = state.ColorCorrection and not lp
            effects.ColorCorrection.Saturation = state.Saturation
            effects.ColorCorrection.Contrast = state.Contrast
            effects.ColorCorrection.Brightness = state.Brightness
            effects.ColorCorrection.TintColor = Color3.fromRGB(255, 245, 255)
        end

        if effects.DOF then
            effects.DOF.Enabled = state.DepthOfField and not lp
            effects.DOF.FarIntensity = state.DOFFarIntensity
            effects.DOF.NearIntensity = state.DOFNearIntensity
            effects.DOF.FocusDistance = 30
            effects.DOF.InFocusRadius = 10
        end

        if effects.Vignette then
            effects.Vignette.Visible = state.Vignette and not lp
            effects.Vignette.ImageTransparency = 0.35
        end
    end
end

function Functions.UpdateAccent(state, theme, dt, hue)
    if state.RGB then
        hue = (hue + dt * (0.12 * state.AccentSpeed)) % 1
        return Color3.fromHSV(hue, 0.9, 1), hue
    end
    return theme.Accent, hue
end

function Functions.GetThemePreset(name)
    local presets = {
        Purple = Color3.fromRGB(160, 110, 255),
        Cyan   = Color3.fromRGB(80, 200, 255),
        Red    = Color3.fromRGB(255, 90, 110),
        Green  = Color3.fromRGB(85, 255, 165),
        Orange = Color3.fromRGB(255, 160, 80),
        Pink   = Color3.fromRGB(255, 120, 200),
        White  = Color3.fromRGB(240, 240, 255),
    }
    return presets[name] or presets.Purple
end

return Functions
