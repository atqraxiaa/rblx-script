-- Wait until game is fully loaded
repeat task.wait() until game:IsLoaded()

local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

-- Create the GUI container
local gui = Instance.new("ScreenGui")
gui.Name = "MinimalGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- Main frame
local frame = Instance.new("Frame")
local fullSize = UDim2.new(0.4, 0, 0.5, 0)
local minimizedSize = UDim2.new(0.4, 0, 0, 30)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.Size = fullSize
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BackgroundTransparency = 1 -- start fully transparent for fade
frame.BorderSizePixel = 0
frame.Parent = gui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(34, 35, 39)
titleBar.BackgroundTransparency = 1 -- start transparent
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

-- Round title bar top only
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar
titleBar.ClipsDescendants = true

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -60, 0.5, -12)
minBtn.BackgroundColor3 = titleBar.BackgroundColor3
minBtn.BackgroundTransparency = 1
minBtn.SelectionImageObject = nil
minBtn.Text = "-"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextTransparency = 1 -- start transparent
minBtn.Parent = titleBar

-- Exit button
local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0, 25, 0, 25)
exitBtn.Position = UDim2.new(1, -30, 0.5, -12)
exitBtn.BackgroundColor3 = titleBar.BackgroundColor3
exitBtn.BackgroundTransparency = 1
exitBtn.SelectionImageObject = nil
exitBtn.Text = "X"
exitBtn.Font = Enum.Font.SourceSansBold
exitBtn.TextSize = 14
exitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exitBtn.TextTransparency = 1 -- start transparent
exitBtn.Parent = titleBar

-- Exit function
exitBtn.MouseButton1Click:Connect(function()
	local TweenService = game:GetService("TweenService")
	local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Create fade-out tweens
	local frameTween = TweenService:Create(frame, fadeInfo, {BackgroundTransparency = 1})
	local titleTween = TweenService:Create(titleBar, fadeInfo, {BackgroundTransparency = 1})
	local minTextTween = TweenService:Create(minBtn, fadeInfo, {TextTransparency = 1})
	local exitTextTween = TweenService:Create(exitBtn, fadeInfo, {TextTransparency = 1})

	-- Play them
	frameTween:Play()
	titleTween:Play()
	minTextTween:Play()
	exitTextTween:Play()

	-- Destroy GUI after fade
	task.delay(0.4, function()
		gui:Destroy()
	end)
end)

-- Minimize logic
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized

	for _, child in ipairs(frame:GetChildren()) do
		if child ~= titleBar and child:IsA("GuiObject") then
			child.Visible = not minimized
		end
	end

	frame.Size = minimized and minimizedSize or fullSize
end)

-- Draggable support
local UIS = game:GetService("UserInputService")
local dragging, dragInput, startPos, startDrag

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		startPos = input.Position
		startDrag = frame.Position

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

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - startPos
		frame.Position = UDim2.new(startDrag.X.Scale, startDrag.X.Offset + delta.X, startDrag.Y.Scale, startDrag.Y.Offset + delta.Y)
	end
end)

-- Fade-in effect
local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(frame, fadeInfo, {BackgroundTransparency = 0.2}):Play()
TweenService:Create(titleBar, fadeInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(minBtn, fadeInfo, {TextTransparency = 0}):Play()
TweenService:Create(exitBtn, fadeInfo, {TextTransparency = 0}):Play()