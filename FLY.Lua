local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "FlyUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,120)
frame.Position = UDim2.new(0.4,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Text = "Fly Controller"
title.BackgroundColor3 = Color3.fromRGB(25,25,25)
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8,0,0,35)
button.Position = UDim2.new(0.1,0,0.45,0)
button.Text = "Fly (F)"
button.BackgroundColor3 = Color3.fromRGB(60,60,60)
button.TextColor3 = Color3.new(1,1,1)
button.Parent = frame

-- FLY SYSTEM
local flying = false
local speed = 70
local flyKey = Enum.KeyCode.F

local velocity
local orientation
local attachment

local function getRoot()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

local function startFly()

	local root = getRoot()

	attachment = Instance.new("Attachment")
	attachment.Parent = root

	velocity = Instance.new("LinearVelocity")
	velocity.Attachment0 = attachment
	velocity.MaxForce = math.huge
	velocity.VectorVelocity = Vector3.zero
	velocity.Parent = root

	orientation = Instance.new("AlignOrientation")
	orientation.Attachment0 = attachment
	orientation.MaxTorque = math.huge
	orientation.Responsiveness = 15
	orientation.Parent = root

	RunService:BindToRenderStep("FlyMove", Enum.RenderPriority.Character.Value, function()

		local cam = workspace.CurrentCamera
		local move = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

		if move.Magnitude > 0 then
			velocity.VectorVelocity = move.Unit * speed
		else
			velocity.VectorVelocity = Vector3.zero
		end

		orientation.CFrame = cam.CFrame

	end)

end

local function stopFly()

	RunService:UnbindFromRenderStep("FlyMove")

	if velocity then velocity:Destroy() end
	if orientation then orientation:Destroy() end
	if attachment then attachment:Destroy() end

end

local function toggleFly()

	flying = not flying

	if flying then
		button.Text = "Unfly (F)"
		startFly()
	else
		button.Text = "Fly (F)"
		stopFly()
	end

end

button.MouseButton1Click:Connect(toggleFly)

UIS.InputBegan:Connect(function(input,gp)

	if gp then return end

	if input.KeyCode == flyKey then
		toggleFly()
	end

end)
