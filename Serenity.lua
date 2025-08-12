-- mo run ra ang script kung "Grow a Garden" ang current game, og mo execute after ma fully loaded ang game 
repeat task.wait() until game:IsLoaded()
-- if game.PlaceId ~= 126884695634066 then return end

local CONFIG_FILE = "SerenityConfig.json"
local HttpService = game:GetService("HttpService")
local config = {
	autoAfk = false,
	autoReconnect = false,
	autoServerHop = false,
	desiredGameVersion = ""
}

local function saveConfig()
	if writefile then
		writefile(CONFIG_FILE, HttpService:JSONEncode(config))
	end
end

local function loadConfig()
	if isfile and isfile(CONFIG_FILE) then
		local success, data = pcall(function()
			return HttpService:JSONDecode(readfile(CONFIG_FILE))
		end)
		if success and type(data) == "table" then
			for k, v in pairs(data) do
				config[k] = v
			end
		end
	end
end

loadConfig()

-- variables needed para sa script
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

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

-- title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
titleBar.ClipsDescendants = true
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Text = "Serenity v1.0.2 by kiyaa"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamMedium
title.TextSize = 14
title.BackgroundTransparency = 1
title.Parent = titleBar

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0, 100, 1, 0)
pingLabel.Position = UDim2.new(0, 200, 0, 0)
pingLabel.Font = Enum.Font.GothamMedium
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
fpsLabel.Font = Enum.Font.GothamMedium
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
timeLabel.Font = Enum.Font.GothamMedium
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

local bodyContainer = Instance.new("Frame")
bodyContainer.BackgroundTransparency = 1
bodyContainer.BorderSizePixel = 0
bodyContainer.Position = UDim2.new(0, 0, 0, 32)
bodyContainer.Size = UDim2.new(1, 0, 1, -32)
bodyContainer.Parent = frame

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -32)
sidebar.Position = UDim2.new(0, 0, 0, 10)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
sidebar.BackgroundTransparency = 0
sidebar.BorderSizePixel = 0
sidebar.Parent = bodyContainer

-- animation pang minimize/maximize
local function tweenFrameSize(targetSize, duration)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(frame, tweenInfo, {Size = targetSize})
	tween:Play()
	return tween
end

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

local minimized = true

minBtn.MouseButton1Click:Connect(function()
	local tweenDuration = 0.3

	minimized = not minimized
	if minimized then
		pingLabel.Visible = true
		fpsLabel.Visible = true
		timeLabel.Visible = false
		bodyContainer.Visible = false

		title.Text = "Serenity v1.0.2"
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

		title.Text = "Serenity v1.0.2 by kiyaa"
		title.Size = UDim2.new(1, -80, 1, 0)
		minBtn.Text = "-"

		pingLabel.Position = UDim2.new(0, 200, 0, 0)
		fpsLabel.Position = UDim2.new(0, 340, 0, 0)

		tweenFrameSize(fullSize, tweenDuration):Wait()
	end
end)

exitBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local tabs = {"Home", "Shop", "Misc"}
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
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	button.BackgroundTransparency = 1
	button.Text = name
	button.TextColor3 = Color3.fromRGB(200, 200, 200)
	button.Font = Enum.Font.Gotham
	button.TextSize = 12
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = sidebar

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)	
	padding.Parent = button

	local border = Instance.new("Frame")
	border.Name = "Border"
	border.Size = UDim2.new(1, 0, 1, 0)
	border.Position = UDim2.new(0, 0, 0, 0)
	border.BackgroundTransparency = 1
	border.BorderColor3 = Color3.fromRGB(150, 150, 150)
	border.BorderSizePixel = 1
	border.ZIndex = button.ZIndex + 1
	border.Parent = button

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = button

	local borderCorner = Instance.new("UICorner")
	borderCorner.CornerRadius = UDim.new(0, 6)
	borderCorner.Parent = border

	local tabFrame = Instance.new("Frame")
	tabFrame.Size = UDim2.new(1, 0, 1, 0)
	tabFrame.BackgroundTransparency = 1
	tabFrame.Visible = (i == 1)
	tabFrame.Parent = content
	contentFrames[name] = tabFrame

	if i == 1 then
		border.BackgroundTransparency = 1
		button.BackgroundTransparency = 0
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		button.TextColor3 = Color3.new(1, 1, 1)
	else
		border.BackgroundTransparency = 1
		button.BackgroundTransparency = 0
		button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		button.TextColor3 = Color3.fromRGB(200, 200, 200)
	end

	button.MouseButton1Click:Connect(function()
		for _, f in pairs(contentFrames) do
			f.Visible = false
		end

		for _, btn in pairs(sidebar:GetChildren()) do
			if btn:IsA("TextButton") then
				local b = btn:FindFirstChild("Border")
				if b then
					b.BackgroundTransparency = 1
				end
				btn.BackgroundTransparency = 1
				btn.TextColor3 = Color3.fromRGB(200, 200, 200)
			end
		end

		tabFrame.Visible = true

		border.BackgroundTransparency = 1
		button.BackgroundTransparency = 0
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		button.TextColor3 = Color3.new(1, 1, 1)
	end)
end

-- Main Tab
local mainTab = contentFrames["Home"]

local mainHeader = Instance.new("TextLabel")
mainHeader.Text = "──────────     Server Properties     ──────────"
mainHeader.Font = Enum.Font.GothamBold
mainHeader.TextSize = 14
mainHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
mainHeader.BackgroundTransparency = 1
mainHeader.Size = UDim2.new(0, 150, 0, 30)
mainHeader.AnchorPoint = Vector2.new(0.5, 0.5)
mainHeader.Position = UDim2.new(0.5, 0, 0.07, 0)
mainHeader.TextXAlignment = Enum.TextXAlignment.Center
mainHeader.Parent = mainTab

local jobIdTitle = Instance.new("TextLabel")
jobIdTitle.Text = "Job ID:"
jobIdTitle.Font = Enum.Font.GothamBold
jobIdTitle.TextSize = 12
jobIdTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
jobIdTitle.BackgroundTransparency = 1
jobIdTitle.Size = UDim2.new(0, 130, 0, 30)
jobIdTitle.Position = UDim2.new(0, 20, 0, 35)
jobIdTitle.TextXAlignment = Enum.TextXAlignment.Left
jobIdTitle.Parent = mainTab

local jobIdValue = Instance.new("TextLabel")
jobIdValue.Text = game.JobId
jobIdValue.Font = Enum.Font.Gotham
jobIdValue.TextSize = 12
jobIdValue.TextColor3 = Color3.fromRGB(255, 255, 255)
jobIdValue.BackgroundTransparency = 1
jobIdValue.Size = UDim2.new(0, 200, 0, 30)
jobIdValue.Position = UDim2.new(0, 110, 0, 35)
jobIdValue.TextXAlignment = Enum.TextXAlignment.Left
jobIdValue.Parent = mainTab

local gameVerTitle = Instance.new("TextLabel")
gameVerTitle.Text = "Game Version:"
gameVerTitle.Font = Enum.Font.GothamBold
gameVerTitle.TextSize = 12
gameVerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
gameVerTitle.BackgroundTransparency = 1
gameVerTitle.Size = UDim2.new(0, 130, 0, 30)
gameVerTitle.Position = UDim2.new(0, 20, 0, 55)
gameVerTitle.TextXAlignment = Enum.TextXAlignment.Left
gameVerTitle.Parent = mainTab

local gameVerValue = Instance.new("TextLabel")
gameVerValue.Text = game.PlaceVersion
gameVerValue.Font = Enum.Font.Gotham
gameVerValue.TextSize = 12
gameVerValue.TextColor3 = Color3.fromRGB(255, 255, 255)
gameVerValue.BackgroundTransparency = 1
gameVerValue.Size = UDim2.new(0, 200, 0, 30)
gameVerValue.Position = UDim2.new(0, 110, 0, 55)
gameVerValue.TextXAlignment = Enum.TextXAlignment.Left
gameVerValue.Parent = mainTab

local copyIdButton = Instance.new("TextButton")
copyIdButton.Size = UDim2.new(0, 160, 0, 20)
copyIdButton.Position = UDim2.new(0, 20, 0, 90)
copyIdButton.Text = "Copy Job ID"
copyIdButton.Font = Enum.Font.Gotham
copyIdButton.TextSize = 12
copyIdButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
copyIdButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyIdButton.Parent = mainTab
Instance.new("UICorner", copyIdButton).CornerRadius = UDim.new(0, 8)

copyIdButton.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(game.JobId)
		copyIdButton.Text = "Copied!"
		task.delay(1.5, function()
			copyIdButton.Text = "Copy Job ID"
		end)
	else
		warn("Your executor does not support setclipboard.")
	end
end)

local serverHopButton = Instance.new("TextButton")
serverHopButton.Size = UDim2.new(0, 160, 0, 20)
serverHopButton.Position = UDim2.new(0, 200, 0, 90)
serverHopButton.Text = "Random Server Hop"
serverHopButton.Font = Enum.Font.Gotham
serverHopButton.TextSize = 12
serverHopButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
serverHopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
serverHopButton.Parent = mainTab
Instance.new("UICorner", serverHopButton).CornerRadius = UDim.new(0, 8)

serverHopButton.MouseButton1Click:Connect(function()
	local HttpService = game:GetService("HttpService")
	local TeleportService = game:GetService("TeleportService")
	local Players = game:GetService("Players")

	local currentJobId = game.JobId
	local placeId = game.PlaceId

	local function getRandomServer()
		local servers = {}
		local cursor = ""
		local foundServer = nil

		repeat
			local url = string.format(
				"https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s",
				placeId,
				cursor ~= "" and "&cursor=" .. cursor or ""
			)

			local success, response = pcall(function()
				return HttpService:JSONDecode(game:HttpGet(url))
			end)

			if success and response and response.data then
				for _, server in ipairs(response.data) do
					if server.id ~= currentJobId and server.playing < server.maxPlayers then
						table.insert(servers, server.id)
					end
				end
				cursor = response.nextPageCursor or ""
			else
				break
			end
		until cursor == "" or #servers >= 1

		if #servers > 0 then
			foundServer = servers[math.random(1, #servers)]
		end

		return foundServer
	end

	local newServerId = getRandomServer()
	if newServerId then
		TeleportService:TeleportToPlaceInstance(placeId, newServerId, Players.LocalPlayer)
	else
		warn("No available servers found.")
	end
end)

local inputGameVersion = Instance.new("TextLabel")
inputGameVersion.Text = "Desired Game Version"
inputGameVersion.Font = Enum.Font.GothamBold
inputGameVersion.TextSize = 12
inputGameVersion.TextColor3 = Color3.fromRGB(255, 255, 255)
inputGameVersion.BackgroundTransparency = 1
inputGameVersion.Size = UDim2.new(0, 130, 0, 30)
inputGameVersion.Position = UDim2.new(0, 20, 0, 118)
inputGameVersion.TextXAlignment = Enum.TextXAlignment.Left
inputGameVersion.Parent = mainTab

local gameVersionBox = Instance.new("TextBox")	
gameVersionBox.Size = UDim2.new(0, 100, 0, 20)
gameVersionBox.Position = UDim2.new(0, 260, 0, 123)
gameVersionBox.Font = Enum.Font.Gotham
gameVersionBox.TextSize = 12
gameVersionBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
gameVersionBox.TextColor3 = Color3.fromRGB(255, 255, 255)
gameVersionBox.ClearTextOnFocus = true
gameVersionBox.Text = ""
gameVersionBox.PlaceholderText = ""
gameVersionBox.Parent = mainTab

Instance.new("UICorner", gameVersionBox).CornerRadius = UDim.new(0, 6)
gameVersionBox.FocusLost:Connect(function(enterPressed)
	config.desiredGameVersion = gameVersionBox.Text
	saveConfig()
end)

gameVersionBox.Text = config.desiredGameVersion or ""

local autoServerHopLabel = Instance.new("TextLabel")
autoServerHopLabel.Text = "Auto Server Hop until Desired Version"
autoServerHopLabel.Font = Enum.Font.GothamBold
autoServerHopLabel.TextSize = 12
autoServerHopLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
autoServerHopLabel.BackgroundTransparency = 1
autoServerHopLabel.Size = UDim2.new(0, 130, 0, 30)
autoServerHopLabel.Position = UDim2.new(0, 20, 0, 149)
autoServerHopLabel.TextXAlignment = Enum.TextXAlignment.Left
autoServerHopLabel.Parent = mainTab

local autoServerHopTrack = Instance.new("Frame")
autoServerHopTrack.Size = UDim2.new(0, 30, 0, 12)
autoServerHopTrack.AnchorPoint = Vector2.new(0.5, 0.5)
autoServerHopTrack.Position = UDim2.new(0, 345, 0, 165)
autoServerHopTrack.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
autoServerHopTrack.BorderSizePixel = 0
autoServerHopTrack.Parent = mainTab

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 16, 0, 16)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0, 7, 0.5, 0)
knob.BackgroundColor3 = Color3.new(1, 1, 1)
knob.BorderSizePixel = 0
knob.Parent = autoServerHopTrack

local cornerTrack = Instance.new("UICorner")
cornerTrack.CornerRadius = UDim.new(1, 0)
cornerTrack.Parent = autoServerHopTrack

local cornerKnob = Instance.new("UICorner")
cornerKnob.CornerRadius = UDim.new(1, 0)
cornerKnob.Parent = knob

local hopToggled = config.autoServerHop or false
local hopLoop

local function updateHopToggleVisual(state)
	if state then
		TweenService:Create(knob, TweenInfo.new(0.2), {
			Position = UDim2.new(1, -7, 0.5, 0)
		}):Play()
		TweenService:Create(autoServerHopTrack, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		}):Play()
	else
		TweenService:Create(knob, TweenInfo.new(0.2), {
			Position = UDim2.new(0, 7, 0.5, 0)
		}):Play()
		TweenService:Create(autoServerHopTrack, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(220, 20, 60)
		}):Play()
	end
end

updateHopToggleVisual(hopToggled)

autoServerHopTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		hopToggled = not hopToggled
		config.autoServerHop = hopToggled
		saveConfig()

		updateHopToggleVisual(hopToggled)

		if hopToggled then
			local HttpService = game:GetService("HttpService")
			local TeleportService = game:GetService("TeleportService")
			local Players = game:GetService("Players")
			local desiredVersion = tonumber(gameVersionBox.Text)
			local placeId = game.PlaceId

			hopLoop = task.spawn(function()
				while hopToggled do
					if game.PlaceVersion == desiredVersion then
						warn("[Auto Hop] Found desired version:", desiredVersion)
						break
					end

					local servers = {}
					local cursor = ""

					repeat
						local url = string.format(
							"https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s",
							placeId,
							cursor ~= "" and "&cursor=" .. cursor or ""
						)

						local success, response = pcall(function()
							return HttpService:JSONDecode(game:HttpGet(url))
						end)

						if success and response and response.data then
							for _, server in ipairs(response.data) do
								if server.id ~= game.JobId and server.playing < server.maxPlayers then
									table.insert(servers, server.id)
								end
							end
							cursor = response.nextPageCursor or ""
						else
							break
						end
					until cursor == "" or #servers >= 1

					if #servers > 0 then
						local newServerId = servers[math.random(1, #servers)]
						warn("[Auto Hop] Hopping to new server:", newServerId)
						TeleportService:TeleportToPlaceInstance(placeId, newServerId, Players.LocalPlayer)
					else
						warn("[Auto Hop] No available servers found, retrying...")
						task.wait(3)
					end
				end
			end)

		else
			if hopLoop then
				task.cancel(hopLoop)
				hopLoop = nil
				warn("[Auto Hop] Stopped.")
			end
		end
	end
end)

local mainHeader = Instance.new("TextLabel")
mainHeader.Text = "───────────     Script Settings     ───────────"
mainHeader.Font = Enum.Font.GothamBold
mainHeader.TextSize = 14
mainHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
mainHeader.BackgroundTransparency = 1
mainHeader.Size = UDim2.new(0, 150, 0, 30)
mainHeader.AnchorPoint = Vector2.new(0.5, 0.5)
mainHeader.Position = UDim2.new(0.5, 0, 0.6, 0)
mainHeader.TextXAlignment = Enum.TextXAlignment.Center
mainHeader.Parent = mainTab

local autoReconTitle = Instance.new("TextLabel")
autoReconTitle.Text = "Auto Reconnect"
autoReconTitle.Font = Enum.Font.GothamBold
autoReconTitle.TextSize = 12
autoReconTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoReconTitle.BackgroundTransparency = 1
autoReconTitle.Size = UDim2.new(0, 130, 0, 30)
autoReconTitle.Position = UDim2.new(0, 20, 0, 205)
autoReconTitle.TextXAlignment = Enum.TextXAlignment.Left
autoReconTitle.Parent = mainTab

local autoReconToggleTrack = Instance.new("Frame")
autoReconToggleTrack.Size = UDim2.new(0, 30, 0, 12)
autoReconToggleTrack.AnchorPoint = Vector2.new(0.5, 0.5)
autoReconToggleTrack.Position = UDim2.new(0, 345, 0, 221)
autoReconToggleTrack.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
autoReconToggleTrack.BorderSizePixel = 0
autoReconToggleTrack.Parent = mainTab

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 16, 0, 16)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0, 7, 0.5, 0)
knob.BackgroundColor3 = Color3.new(1, 1, 1)
knob.BorderSizePixel = 0
knob.Parent = autoReconToggleTrack

local cornerTrack = Instance.new("UICorner")
cornerTrack.CornerRadius = UDim.new(1, 0)
cornerTrack.Parent = autoReconToggleTrack

local cornerKnob = Instance.new("UICorner")
cornerKnob.CornerRadius = UDim.new(1, 0)
cornerKnob.Parent = knob

local toggled = config.autoReconnect or false

local function updateReconToggleVisual(state)
	if state then
		TweenService:Create(knob, TweenInfo.new(0.2), {
			Position = UDim2.new(1, -7, 0.5, 0)
		}):Play()
		TweenService:Create(autoReconToggleTrack, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		}):Play()
	else
		TweenService:Create(knob, TweenInfo.new(0.2), {
			Position = UDim2.new(0, 7, 0.5, 0)
		}):Play()
		TweenService:Create(autoReconToggleTrack, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(220, 20, 60)
		}):Play()
	end
end

updateReconToggleVisual(toggled)

autoReconToggleTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		toggled = not toggled
		config.autoReconnect = toggled
		saveConfig()

		updateReconToggleVisual(toggled)
	end
end)

local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

local function clickReconnect()
	local promptOverlay = CoreGui:FindFirstChild("RobloxPromptGui", true)
	if not promptOverlay then return end

	local reconnectButton = promptOverlay:FindFirstChild("TextButton", true)
	if reconnectButton and reconnectButton.Text:lower():find("reconnect") then
		local absPos = reconnectButton.AbsolutePosition
		local absSize = reconnectButton.AbsoluteSize
		VirtualInputManager:SendMouseButtonEvent(
			absPos.X + absSize.X / 2,
			absPos.Y + absSize.Y / 2,
			0, true, nil, 0
		)
		VirtualInputManager:SendMouseButtonEvent(
			absPos.X + absSize.X / 2,
			absPos.Y + absSize.Y / 2,
			0, false, nil, 0
		)
		warn("[Auto Reconnect] Reconnect button clicked!")
	end
end

task.spawn(function()
	while true do
		task.wait(1)
		if toggled then
			local prompt = CoreGui:FindFirstChild("RobloxPromptGui", true)
			if prompt and prompt:FindFirstChild("LostConnectionPrompt", true) then
				clickReconnect()
			end
		end
	end
end)

local antiAfkTitle = Instance.new("TextLabel")
antiAfkTitle.Text = "Anti AFK"
antiAfkTitle.Font = Enum.Font.GothamBold
antiAfkTitle.TextSize = 12
antiAfkTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
antiAfkTitle.BackgroundTransparency = 1
antiAfkTitle.Size = UDim2.new(0, 130, 0, 30)
antiAfkTitle.Position = UDim2.new(0, 20, 0, 235)
antiAfkTitle.TextXAlignment = Enum.TextXAlignment.Left
antiAfkTitle.Parent = mainTab

local antiAfkToggleTrack = Instance.new("Frame")
antiAfkToggleTrack.Size = UDim2.new(0, 30, 0, 12)
antiAfkToggleTrack.AnchorPoint = Vector2.new(0.5, 0.5)
antiAfkToggleTrack.Position = UDim2.new(0, 345, 0, 251)
antiAfkToggleTrack.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
antiAfkToggleTrack.BorderSizePixel = 0
antiAfkToggleTrack.Parent = mainTab

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 16, 0, 16)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0, 7, 0.5, 0)
knob.BackgroundColor3 = Color3.new(1, 1, 1)
knob.BorderSizePixel = 0
knob.Parent = antiAfkToggleTrack

local cornerTrack = Instance.new("UICorner")
cornerTrack.CornerRadius = UDim.new(1, 0)
cornerTrack.Parent = antiAfkToggleTrack

local cornerKnob = Instance.new("UICorner")
cornerKnob.CornerRadius = UDim.new(1, 0)
cornerKnob.Parent = knob

local toggled = config.autoAfk or false
local antiAfkLoop

local function updateAntiAfkVisual(state)
	if state then
		TweenService:Create(knob, TweenInfo.new(0.2), {
			Position = UDim2.new(1, -7, 0.5, 0)
		}):Play()
		TweenService:Create(antiAfkToggleTrack, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		}):Play()
	else
		TweenService:Create(knob, TweenInfo.new(0.2), {
			Position = UDim2.new(0, 7, 0.5, 0)
		}):Play()
		TweenService:Create(antiAfkToggleTrack, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(220, 20, 60)
		}):Play()
	end
end

updateAntiAfkVisual(toggled)

local function startAntiAfkLoop()
	if antiAfkLoop then return end
	antiAfkLoop = task.spawn(function()
		local VirtualUser = game:GetService("VirtualUser")
		while toggled do
			task.wait(60)
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
			print("[Anti AFK] Activity signal sent.")
		end
	end)
end

local function stopAntiAfkLoop()
	if antiAfkLoop then
		task.cancel(antiAfkLoop)
		antiAfkLoop = nil
		print("[Anti AFK] Stopped.")
	end
end

antiAfkToggleTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		toggled = not toggled
		config.autoAfk = toggled
		saveConfig()

		updateAntiAfkVisual(toggled)

		if toggled then
			startAntiAfkLoop()
		else
			stopAntiAfkLoop()
		end
	end
end)

if toggled then
	startAntiAfkLoop()
end

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

local header = Instance.new("TextLabel")
header.Text = "Auto Sell Inventory"
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.BackgroundTransparency = 1
header.Size = UDim2.new(0, 150, 0, 30)
header.Position = UDim2.new(0, 20, 0, 10)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = miscTab

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 60, 0, 20)
toggle.Position = UDim2.new(0, 300, 0, 15)
toggle.Text = "OFF"
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 14
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Parent = miscTab

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
description.Parent = miscTab

local toggled = false
local sellRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory")
local sellCFrame = CFrame.new(86.5844193, 2.99999976, 0.426782995)

toggle.MouseButton1Click:Connect(function()
	toggled = not toggled
	toggle.Text = toggled and "ON" or "OFF"
end)

local player = game:GetService("Players").LocalPlayer

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