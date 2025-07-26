local gui = Instance.new("ScreenGui")
local button = Instance.new("TextButton")

-- Parent GUI to the player's screen
gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
gui.Name = "MySimpleGui"

-- Configure the button
button.Parent = gui
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.Text = "Click Me!"

-- On click, print a message
button.MouseButton1Click:Connect(function()
    print("Button clicked!")
    button.Text = "Thanks!"
end)