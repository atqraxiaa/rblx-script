local mainGui = Instance.new("ScreenGui")
mainGui.Name = "Main_GUI"
mainGui.ClipToDeviceSafeArea = true
mainGui.IgnoreGuiInset = true
mainGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
mainGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar
titleBar.ClipsDescendants = true

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -60, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
minBtn.Text = "-"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minBtn.Parent = titleBar

-- Exit Button
local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0, 25, 0, 25)
exitBtn.Position = UDim2.new(1, -30, 0.5, -12)
exitBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
exitBtn.Text = "X"
exitBtn.Font = Enum.Font.SourceSansBold
exitBtn.TextSize = 14
exitBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
exitBtn.Parent = titleBar

-- Exit Function
exitBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Minimize Logic
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
