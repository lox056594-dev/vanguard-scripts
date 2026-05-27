local UI = require(script.Parent.UI)
local Functions = require(script.Parent.Functions)

local Window = UI:CreateWindow("Vanguard")

UI:AddToggle(Window, "Fly", function(v) Functions:Fly(v) end)
UI:AddToggle(Window, "ESP", function(v) Functions:ESP(v) end)
