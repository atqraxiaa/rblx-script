-- Wait until game is fully loaded
repeat task.wait() until game:IsLoaded()

-- Create the GUI container
local gui = Instance.new("ScreenGui")
gui.Name = "MinimalGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = game:GetService("CoreGui") -- <- CoreGui works better for executors

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = gui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

-- Round title bar top only
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar
titleBar.ClipsDescendants = true

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -60, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
minBtn.Text = "-"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minBtn.Parent = titleBar

-- Exit button
local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0, 25, 0, 25)
exitBtn.Position = UDim2.new(1, -30, 0.5, -12)
exitBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
exitBtn.Text = "X"
exitBtn.Font = Enum.Font.SourceSansBold
exitBtn.TextSize = 14
exitBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
exitBtn.Parent = titleBar

-- Exit function
exitBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
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
	frame.Size = minimized and UDim2.new(0, 300, 0, 30) or UDim2.new(0, 300, 0, 180)
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
