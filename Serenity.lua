-- mo run ra ang script kung "Grow a Garden" ang current game, og mo execute after ma fully loaded ang game 
repeat task.wait() until game:IsLoaded()
-- if game.PlaceId ~= 126884695634066 then return end

-- container sa gui
local gui = Instance.new("ScreenGui")
gui.Name = "SerenityUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- main frame
local fullSize = UDim2.new(0, 500, 0, 350)
local frame = Instance.new("Frame")
frame.Size = fullSize
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
titleBar.ClipsDescendants = true

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Text = "Serenity v1.0.1 by kiyaa"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamSemibold
title.TextSize = 14
title.BackgroundTransparency = 1
title.Parent = titleBar

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0, 100, 1, 0)
pingLabel.Position = UDim2.new(0, 200, 0, 0)
pingLabel.Font = Enum.Font.GothamSemibold
pingLabel.TextSize = 14
pingLabel.TextColor3 = Color3.new(1, 1, 1)
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "Ping: -- ms"
pingLabel.RichText = true
pingLabel.Visible = false
pingLabel.Parent = titleBar

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 60, 1, 0)
fpsLabel.Position = UDim2.new(0, 340, 0, 0)
fpsLabel.Font = Enum.Font.GothamSemibold
fpsLabel.TextSize = 14
fpsLabel.TextColor3 = Color3.new(1, 1, 1)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.RichText = true
fpsLabel.Visible = false
fpsLabel.Parent = titleBar

local timeLabel = Instance.new("TextLabel")
timeLabel.ZIndex = 5
timeLabel.Size = UDim2.new(0, 150, 1, 0)
timeLabel.Position = UDim2.new(0, 240, 0, 0)
timeLabel.Font = Enum.Font.GothamSemibold
timeLabel.TextSize = 14
timeLabel.TextColor3 = Color3.new(1, 1, 1)
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.BackgroundTransparency = 1
timeLabel.RichText = true
timeLabel.Parent = titleBar

local function updateTime()
	local t = os.date("*t")
	local monthName = os.date("%b", os.time(t))
	local day = string.format("%02d", t.day)
	local hour = t.hour % 12
	if hour == 0 then hour = 12 end
	local ampm = (t.hour < 12) and "am" or "pm"

	local formatted = string.format("%s %s     %d:%02d %s",
		monthName, day, hour, t.min, ampm)

	timeLabel.Text = formatted
end

task.spawn(function()
	while true do
		updateTime()
		task.wait(1)
	end
end)

local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")

task.spawn(function()
	while true do
		local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		local pingColor = (ping <= 100 and "rgb(100,255,100)") or (ping <= 500 and "rgb(255,255,100)") or "rgb(255,100,100)"
		pingLabel.Text = `Ping: <font color="{pingColor}">{ping} ms</font>`

		local fps = math.floor(1 / RunService.RenderStepped:Wait())
		local fpsColor = (fps >= 60 and "rgb(100,255,100)") or (fps >= 30 and "rgb(255,255,100)") or "rgb(255,100,100)"
		fpsLabel.Text = `FPS: <font color="{fpsColor}">{fps}</font>`

		pingLabel.RichText = true
		fpsLabel.RichText = true

		task.wait(1)
	end
end)

-- Body container
local bodyContainer = Instance.new("Frame")
bodyContainer.BackgroundTransparency = 1
bodyContainer.BorderSizePixel = 0
bodyContainer.Position = UDim2.new(0, 0, 0, 32)
bodyContainer.Size = UDim2.new(1, 0, 1, -32)
bodyContainer.Parent = frame

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -32)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
sidebar.BackgroundTransparency = 0.1
sidebar.BorderSizePixel = 0
sidebar.Parent = bodyContainer

-- bulshit animation
local TweenService = game:GetService("TweenService")
local function tweenFrameSize(targetSize, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(frame, tweenInfo, {Size = targetSize})
	tween:Play()
	return tween
end

-- Minimize button
local minimized = false
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.AnchorPoint = Vector2.new(1, 0.5)
minBtn.Position = UDim2.new(1, -40, 0.5, 0)
minBtn.BackgroundTransparency = 1
minBtn.Text = "-"
minBtn.Font = Enum.Font.Gotham
minBtn.TextSize = 16
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Parent = titleBar

-- Exit button
local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0, 25, 0, 25)
exitBtn.AnchorPoint = Vector2.new(1, 0.5)
exitBtn.Position = UDim2.new(1, -10, 0.5, 0)
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
	local tweenDuration = 0.3

	if minimized then
		pingLabel.Visible = true
		fpsLabel.Visible = true
		timeLabel.Visible = false
		bodyContainer.Visible = false
		
		title.Text = "Serenity v1.0.1"
		title.Size = UDim2.new(1, -60, 1, 0)
		minBtn.Text = "+"
		
		fpsLabel.Position = UDim2.new(0, 115, 0, 0)
		pingLabel.Position = UDim2.new(0, 180, 0, 0)
		
		tweenFrameSize(UDim2.new(0, 335, 0, 32), tweenDuration):Wait()
	else
		pingLabel.Visible = false
		fpsLabel.Visible = false
		timeLabel.Visible = true
		bodyContainer.Visible = true
		
		title.Text = "Serenity v1.0.1 by kiyaa"
		title.Size = UDim2.new(1, -80, 1, 0)
		minBtn.Text = "-"

		pingLabel.Position = UDim2.new(0, 200, 0, 0)
		fpsLabel.Position = UDim2.new(0, 340, 0, 0)
		
		tweenFrameSize(fullSize, tweenDuration):Wait()
	end
end)

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

-- Main Tab
local mainTab = contentFrames["Main"]

local header = Instance.new("TextLabel")
header.Text = "Auto Sell Inventory"
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.BackgroundTransparency = 1
header.Size = UDim2.new(0, 150, 0, 30)
header.Position = UDim2.new(0, 20, 0, 10)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = mainTab

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 60, 0, 20)
toggle.Position = UDim2.new(0, 300, 0, 15)
toggle.Text = "OFF"
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 14
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Parent = mainTab

local description = Instance.new("TextLabel")
description.Text = "Automatically sells items when your inventory is full."
description.Font = Enum.Font.Gotham
description.TextSize = 12
description.TextColor3 = Color3.fromRGB(200, 200, 200)
description.BackgroundTransparency = 1
description.Size = UDim2.new(1, -40, 0, 20)
description.Position = UDim2.new(0, 20, 0, 40)
description.TextXAlignment = Enum.TextXAlignment.Left
description.TextWrapped = true
description.Parent = mainTab

-- Shop Tab
local shopTab = contentFrames["Shop"]

local headerSeeds = Instance.new("TextLabel")
headerSeeds.Text = "Auto Buy Seeds"
headerSeeds.Font = Enum.Font.GothamBold
headerSeeds.TextSize = 14
headerSeeds.TextColor3 = Color3.fromRGB(255, 255, 255)
headerSeeds.BackgroundTransparency = 1
headerSeeds.Size = UDim2.new(0, 150, 0, 30)
headerSeeds.Position = UDim2.new(0, 20, 0, 10)
headerSeeds.TextXAlignment = Enum.TextXAlignment.Left
headerSeeds.Parent = shopTab

local toggleSeeds = Instance.new("TextButton")
toggleSeeds.Size = UDim2.new(0, 60, 0, 20)
toggleSeeds.Position = UDim2.new(0, 300, 0, 15)
toggleSeeds.Text = "OFF"
toggleSeeds.Font = Enum.Font.Gotham
toggleSeeds.TextSize = 14
toggleSeeds.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
toggleSeeds.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleSeeds.Parent = shopTab

local seeds = {
	"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato",
	"Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple",
	"Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango",
	"Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk",
	"Ember Lily", "Sugar Apple", "Burning Bud",
	"Giant Pinecone", "Elder Strawberry"
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local autoBuySeeds = false

toggleSeeds.MouseButton1Click:Connect(function()
	autoBuySeeds = not autoBuySeeds
	toggleSeeds.Text = autoBuySeeds and "ON" or "OFF"
	toggleSeeds.BackgroundColor3 = autoBuySeeds and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(50, 50, 60)

	if autoBuySeeds then
		task.spawn(function()
			while autoBuySeeds do
				for _, seed in ipairs(seeds) do
					ReplicatedStorage.GameEvents.BuySeedStock:FireServer(seed)
					logPurchase("Seed", seed)
					task.wait(0.1)
				end
				task.wait(0.1)
			end
		end)
	end
end)

local descSeeds = Instance.new("TextLabel")
descSeeds.Text = "Automatically buys all available seeds."
descSeeds.Font = Enum.Font.Gotham
descSeeds.TextSize = 12
descSeeds.TextColor3 = Color3.fromRGB(200, 200, 200)
descSeeds.BackgroundTransparency = 1
descSeeds.Size = UDim2.new(1, -40, 0, 20)
descSeeds.Position = UDim2.new(0, 20, 0, 40)
descSeeds.TextXAlignment = Enum.TextXAlignment.Left
descSeeds.TextWrapped = true
descSeeds.Parent = shopTab

local headerGears = Instance.new("TextLabel")
headerGears.Text = "Auto Buy Gears"
headerGears.Font = Enum.Font.GothamBold
headerGears.TextSize = 14
headerGears.TextColor3 = Color3.fromRGB(255, 255, 255)
headerGears.BackgroundTransparency = 1
headerGears.Size = UDim2.new(0, 150, 0, 30)
headerGears.Position = UDim2.new(0, 20, 0, 70)
headerGears.TextXAlignment = Enum.TextXAlignment.Left
headerGears.Parent = shopTab

local toggleGears = Instance.new("TextButton")
toggleGears.Size = UDim2.new(0, 60, 0, 20)
toggleGears.Position = UDim2.new(0, 300, 0, 75)
toggleGears.Text = "OFF"
toggleGears.Font = Enum.Font.Gotham
toggleGears.TextSize = 14
toggleGears.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
toggleGears.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGears.Parent = shopTab

local gears = {
	"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler",
	"Medium Toy", "Medium Treat", "Godly Sprinkler", "Magnifying Glass", "Tanning Mirror",
	"Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Harvest Tool",
	"Friendship Pot", "Levelup Lollipop"
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local autoBuyGears = false

toggleGears.MouseButton1Click:Connect(function()
	autoBuyGears = not autoBuyGears
	toggleGears.Text = autoBuyGears and "ON" or "OFF"
	toggleGears.BackgroundColor3 = autoBuyGears and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(50, 50, 60)

	if autoBuyGears then
		task.spawn(function()
			while autoBuyGears do
				for _, gear in ipairs(gears) do
					ReplicatedStorage.GameEvents.BuyGearStock:FireServer(gear)
					logPurchase("Gear", gear)
					task.wait(0.1)
				end
				task.wait(0.1)
			end
		end)
	end
end)

local descGears = Instance.new("TextLabel")
descGears.Text = "Automatically buys all available gears."
descGears.Font = Enum.Font.Gotham
descGears.TextSize = 12
descGears.TextColor3 = Color3.fromRGB(200, 200, 200)
descGears.BackgroundTransparency = 1
descGears.Size = UDim2.new(1, -40, 0, 20)
descGears.Position = UDim2.new(0, 20, 0, 100)
descGears.TextXAlignment = Enum.TextXAlignment.Left
descGears.TextWrapped = true
descGears.Parent = shopTab

-- Auto Buy Eggs
local headerEggs = Instance.new("TextLabel")
headerEggs.Text = "Auto Buy Eggs"
headerEggs.Font = Enum.Font.GothamBold
headerEggs.TextSize = 14
headerEggs.TextColor3 = Color3.fromRGB(255, 255, 255)
headerEggs.BackgroundTransparency = 1
headerEggs.Size = UDim2.new(0, 150, 0, 30)
headerEggs.Position = UDim2.new(0, 20, 0, 130)
headerEggs.TextXAlignment = Enum.TextXAlignment.Left
headerEggs.Parent = shopTab

local toggleEggs = Instance.new("TextButton")
toggleEggs.Size = UDim2.new(0, 60, 0, 20)
toggleEggs.Position = UDim2.new(0, 300, 0, 135)
toggleEggs.Text = "OFF"
toggleEggs.Font = Enum.Font.Gotham
toggleEggs.TextSize = 14
toggleEggs.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
toggleEggs.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleEggs.Parent = shopTab

local eggs = {
	"Common Egg", "Common Summer Egg", "Rare Summer Egg",
	"Mythical Egg", "Paradise Egg", "Bug Egg"
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local autoBuyEggs = false

toggleEggs.MouseButton1Click:Connect(function()
	autoBuyEggs = not autoBuyEggs
	toggleEggs.Text = autoBuyEggs and "ON" or "OFF"
	toggleEggs.BackgroundColor3 = autoBuyEggs and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(50, 50, 60)

	if autoBuyEggs then
		task.spawn(function()
			while autoBuyEggs do
				for _, egg in ipairs(eggs) do
					ReplicatedStorage.GameEvents.BuyEggStock:FireServer(egg)
					logPurchase("Egg", egg)
					task.wait(0.1)
				end
				task.wait(0.1)
			end
		end)
	end
end)

local descEggs = Instance.new("TextLabel")
descEggs.Text = "Automatically buys all available eggs."
descEggs.Font = Enum.Font.Gotham
descEggs.TextSize = 12
descEggs.TextColor3 = Color3.fromRGB(200, 200, 200)
descEggs.BackgroundTransparency = 1
descEggs.Size = UDim2.new(1, -40, 0, 20)
descEggs.Position = UDim2.new(0, 20, 0, 160)
descEggs.TextXAlignment = Enum.TextXAlignment.Left
descEggs.TextWrapped = true
descEggs.Parent = shopTab

-- Misc Tab
local miscTab = contentFrames["Misc"]

local jobIdTitle = Instance.new("TextLabel")
jobIdTitle.Text = "Current Job ID:"
jobIdTitle.Font = Enum.Font.GothamBold
jobIdTitle.TextSize = 12
jobIdTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
jobIdTitle.BackgroundTransparency = 1
jobIdTitle.Size = UDim2.new(0, 130, 0, 30)
jobIdTitle.Position = UDim2.new(0, 20, 0, 10)
jobIdTitle.TextXAlignment = Enum.TextXAlignment.Left
jobIdTitle.Parent = miscTab

local jobIdValue = Instance.new("TextLabel")
jobIdValue.Text = game.JobId
jobIdValue.Font = Enum.Font.Gotham
jobIdValue.TextSize = 12
jobIdValue.TextColor3 = Color3.fromRGB(255, 255, 255)
jobIdValue.BackgroundTransparency = 1
jobIdValue.Size = UDim2.new(0, 200, 0, 30)
jobIdValue.Position = UDim2.new(0, 110, 0, 10)
jobIdValue.TextXAlignment = Enum.TextXAlignment.Left
jobIdValue.Parent = miscTab

-- Status box frame
local statusBox = Instance.new("Frame")
statusBox.Size = UDim2.new(1, -40, 0, 100)
statusBox.Position = UDim2.new(0, 20, 0, 190)
statusBox.BackgroundTransparency = 0.2
statusBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statusBox.BorderSizePixel = 0
statusBox.Parent = shopTab

-- Layout for messages
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = statusBox

-- Log function
local function logPurchase(category, itemName)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 20)
	label.Text = "✔ [" .. category .. "] x1 " .. itemName .. " (" .. os.date("%X") .. ")"
	label.TextColor3 = Color3.fromRGB(180, 255, 180)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = statusBox

	local maxLines = 5
	local count = 0
	for _, child in ipairs(statusBox:GetChildren()) do
		if child:IsA("TextLabel") then
			count += 1
		end
	end
	if count > maxLines then
		for _, child in ipairs(statusBox:GetChildren()) do
			if child:IsA("TextLabel") then
				child:Destroy()
				break
			end
		end
	end
end


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
local UserInputService = game:GetService("UserInputService")

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)