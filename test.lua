-- Wait for game to fully load
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "SerenityUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Fade in main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 350)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 0.1}):Play()

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)
titleBar.ClipsDescendants = true

-- Title text
local title = Instance.new("TextLabel")
title.Text = "Serenity v1.0 by kiyaa"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamSemibold
title.TextSize = 14
title.BackgroundTransparency = 1
title.Parent = titleBar

-- Exit Button
local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0, 25, 0, 25)
exitBtn.Position = UDim2.new(1, -30, 0.5, -12)
exitBtn.BackgroundTransparency = 1
exitBtn.Text = "X"
exitBtn.Font = Enum.Font.Gotham
exitBtn.TextSize = 12
exitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exitBtn.Parent = titleBar

exitBtn.MouseButton1Click:Connect(function()
	TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	task.wait(0.3)
	gui:Destroy()
end)

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -32)
sidebar.Position = UDim2.new(0, 0, 0, 32)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
sidebar.BorderSizePixel = 0
sidebar.Parent = frame

local tabs = {"Main", "Shop", "Misc"}

for i, name in ipairs(tabs) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 30)
	button.Position = UDim2.new(0, 0, 0, (i - 1) * 32)
	button.BackgroundTransparency = 1
	button.Text = name
	button.TextColor3 = Color3.fromRGB(200, 200, 200)
	button.Font = Enum.Font.Gotham
	button.TextSize = 12
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = sidebar
end

-- Main content area
local content = Instance.new("Frame")
content.Position = UDim2.new(0, 120, 0, 32)
content.Size = UDim2.new(1, -120, 1, -32)
content.BackgroundTransparency = 1
content.Parent = frame

-- Example: Auto Sell section
local header = Instance.new("TextLabel")
header.Text = "Auto Sell"
header.Font = Enum.Font.GothamBold
header.TextSize = 20
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, -20, 0, 30)
header.Position = UDim2.new(0, 10, 0, 10)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = content

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 100, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 50)
toggle.Text = "OFF"
toggle.Font = Enum.Font.GothamSemibold
toggle.TextSize = 14
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Parent = content

local toggled = false
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sellRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory")
local sellCFrame = CFrame.new(86.5844193, 2.99999976, 0.426782995)

toggle.MouseButton1Click:Connect(function()
	toggled = not toggled
	toggle.Text = toggled and "ON" or "OFF"
end)

task.spawn(function()
	while true do
		task.wait(10)
		if toggled then
			if player.Character then
				local hrp = player.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					local originalCFrame = hrp.CFrame

					hrp.CFrame = sellCFrame
					task.wait(1)

					pcall(function()
						sellRemote:FireServer()
					end)

					task.wait(0.5)
					hrp.CFrame = originalCFrame
				end
			end
		end
	end
end)