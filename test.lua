local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    warn("LocalPlayer not available")
    return
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "Main_GUI"
mainGui.IgnoreGuiInset = true
mainGui.ResetOnSpawn = false
mainGui.DisplayOrder = 10
mainGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
