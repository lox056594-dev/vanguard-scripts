local Functions = {}

function Functions.NewState()
    return {
        Notifications = true,
        FPSCounter = true,

        RGB = false,
        Stars = true,
        Crosshair = true,

        FOVChanger = false,
        FOVValue = 80,

        FullBright = false,
        NoFog = false,

        LockTime = false,
        TimeValue = 14,

        MenuBlur = true,

        CrossSize = 10,
        CrossGap = 5,
        CrossThick = 2,
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
    state.RGB = false
    state.Stars = true
    state.Crosshair = true
    state.FOVChanger = false
    state.FOVValue = 80
    state.FullBright = false
    state.NoFog = false
    state.LockTime = false
    state.TimeValue = 14
    state.MenuBlur = true
    state.CrossSize = 10
    state.CrossGap = 5
    state.CrossThick = 2
end

function Functions.ApplyLighting(state, defaults, lighting)
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
end

function Functions.UpdateAccent(state, theme, dt, hue)
    if state.RGB then
        hue = (hue + dt * 0.15) % 1
        return Color3.fromHSV(hue, 0.9, 1), hue
    end
    return theme.Accent, hue
end

return Functions
