repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local gui = Instance.new("ScreenGui")
gui.Name = "SerenityUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = playerGui

local fullSize = UDim2.new(0, 500, 0, 350)
local frame = Instance.new("Frame")
frame.Size = fullSize
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)
titleBar.ClipsDescendants = true

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

-- Body container
local bodyContainer = Instance.new("Frame")
bodyContainer.BackgroundTransparency = 1
bodyContainer.BorderSizePixel = 0
bodyContainer.Position = UDim2.new(0, 0, 0, 32)
bodyContainer.Size = UDim2.new(1, 0, 1, -32)
bodyContainer.Parent = frame

-- Minimize button
local minimized = false
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -60, 0.5, -12)
minBtn.BackgroundTransparency = 1
minBtn.Text = "-"
minBtn.Font = Enum.Font.Gotham
minBtn.TextSize = 16
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Parent = titleBar

-- Exit button
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
	gui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		title.Size = UDim2.new(1, -60, 1, 0)
		frame.Size = UDim2.new(0, 300, 0, 32)
		bodyContainer.Visible = false
		minBtn.Text = "+"
	else
		title.Size = UDim2.new(1, -80, 1, 0)
		frame.Size = fullSize
		bodyContainer.Visible = true
		minBtn.Text = "-"
	end
end)

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -32)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
sidebar.BackgroundTransparency = 0.1
sidebar.BorderSizePixel = 0
sidebar.Parent = bodyContainer

-- Tabs
local tabs = {"Main", "Shop", "Misc"}
local contentFrames = {}

local content = Instance.new("Frame")
content.Position = UDim2.new(0, 120, 0, 0)
content.Size = UDim2.new(1, -120, 1, 0)
content.BackgroundTransparency = 1
content.Parent = bodyContainer

for i, name in ipairs(tabs) do
	local button = Instance.new("TextButton")
	button.Position = UDim2.new(0, 10, 0, (i - 1) * 32)
	button.Size = UDim2.new(1, -10, 0, 30)
	button.BackgroundTransparency = 1
	button.Text = name
	button.TextColor3 = Color3.fromRGB(200, 200, 200)
	button.Font = Enum.Font.Gotham
	button.TextSize = 12
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = sidebar

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
  padding.PaddingTop = UDim.new(0, 20)
	padding.Parent = button

	local tabFrame = Instance.new("Frame")
	tabFrame.Size = UDim2.new(1, 0, 1, 0)
	tabFrame.BackgroundTransparency = 1
	tabFrame.Visible = (i == 1)
	tabFrame.Parent = content
	contentFrames[name] = tabFrame

	button.MouseButton1Click:Connect(function()
		for _, f in pairs(contentFrames) do f.Visible = false end
		tabFrame.Visible = true
	end)
end

-- Auto Sell (inside "Main" tab)
local mainTab = contentFrames["Main"]

local header = Instance.new("TextLabel")
header.Text = "Auto Sell"
header.Font = Enum.Font.GothamBold
header.TextSize = 20
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, -20, 0, 30)
header.Position = UDim2.new(0, 10, 0, 10)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = mainTab

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 100, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 50)
toggle.Text = "OFF"
toggle.Font = Enum.Font.GothamSemibold
toggle.TextSize = 14
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Parent = mainTab

local toggled = false
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
					hrP.CFrame = sellCFrame
					task.wait(1)
					pcall(function() sellRemote:FireServer() end)
					task.wait(0.5)
					hrP.CFrame = originalCFrame
				end
			end
		end
	end
end)

local dragging, dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)