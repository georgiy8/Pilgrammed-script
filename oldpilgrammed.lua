-- Полный GUI скрипт (Georgiy/8)
-- Вставь в LocalScript в StarterPlayerScripts или в место, где запускаются локальные скрипты

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- Настройки и глобальные переменные
local zoneGap, titleHeight, bottomHeight = 10, 40, 20
local active = false
local currentSpeed = 32
local autoFishing = false
local autoEquipRod = false

shared.SpeedControl = { active = false, value = 32 }
shared.AutoFishing = false
shared.PlayerName = player.Name
shared.SelectedRod = "Fishing Rod"
shared.AutoEquipRod = false

-- ScreenGui и основные зоны
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "Pilgrammed Script by Georgiy/8"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 420)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

-- Title bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, -2 * zoneGap, 0, titleHeight)
titleBar.Position = UDim2.new(0, zoneGap, 0, zoneGap)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.BorderSizePixel = 0
titleBar.Active = true
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 6)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -140, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Pilgrammed Script by Georgiy/8"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tab panel (left)
local tabPanel = Instance.new("ScrollingFrame", mainFrame)
tabPanel.Size = UDim2.new(0, 120, 1, -(titleHeight + bottomHeight + zoneGap * 4))
tabPanel.Position = UDim2.new(0, zoneGap, 0, titleHeight + zoneGap * 2)
tabPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tabPanel.BorderSizePixel = 0
tabPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
tabPanel.ScrollBarThickness = 6
tabPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabPanel.ScrollingDirection = Enum.ScrollingDirection.Y
Instance.new("UICorner", tabPanel).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", tabPanel)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content zone (right)
local contentZone = Instance.new("Frame", mainFrame)
contentZone.Size = UDim2.new(1, -(120 + zoneGap * 3), 1, -(titleHeight + bottomHeight + zoneGap * 4))
contentZone.Position = UDim2.new(0, 120 + zoneGap * 2, 0, titleHeight + zoneGap * 2)
contentZone.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentZone.BorderSizePixel = 0
Instance.new("UICorner", contentZone).CornerRadius = UDim.new(0, 6)

-- Bottom bar
local bottomBar = Instance.new("Frame", mainFrame)
bottomBar.Size = UDim2.new(1, -2 * zoneGap, 0, bottomHeight)
bottomBar.Position = UDim2.new(0, zoneGap, 1, -(bottomHeight + zoneGap))
bottomBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
bottomBar.BorderSizePixel = 0
Instance.new("UICorner", bottomBar).CornerRadius = UDim.new(0, 6)

-- Dragging
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Resize handle
local resizeHandle = Instance.new("Frame", bottomBar)
resizeHandle.Size = UDim2.new(0, 20, 0, bottomHeight)
resizeHandle.Position = UDim2.new(1, -20, 0, 0)
resizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
resizeHandle.BorderSizePixel = 0
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 4)

local resizing = false
resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = true end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
end)
UserInputService.InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local mouse = UserInputService:GetMouseLocation()
		local inset = GuiService:GetGuiInset()
		local newWidth = math.clamp(mouse.X - mainFrame.AbsolutePosition.X, 300, 1000)
		local newHeight = math.clamp(mouse.Y - mainFrame.AbsolutePosition.Y - inset.Y, 200, 1000)
		mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
	end
end)

-- Restore GUI button
local restoreGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
restoreGui.ResetOnSpawn = false
restoreGui.Name = "RestoreButtonGui"
restoreGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
restoreGui.DisplayOrder = 1000
restoreGui.Enabled = false

local restoreButton = Instance.new("TextButton", restoreGui)
restoreButton.Size = UDim2.new(0, 100, 0, 40)
restoreButton.Position = UDim2.new(0, 20, 1, -60)
restoreButton.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
restoreButton.Text = "Открыть GUI"
restoreButton.Font = Enum.Font.GothamBold
restoreButton.TextSize = 16
restoreButton.TextColor3 = Color3.fromRGB(0, 0, 0)
restoreButton.BorderSizePixel = 0
Instance.new("UICorner", restoreButton).CornerRadius = UDim.new(0, 6)

restoreButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	restoreGui.Enabled = false
end)

-- Title buttons
local isMaximized = false
local prevSize = mainFrame.Size
local prevPos = mainFrame.Position

local function createTitleButton(txt, offset, callback)
	local btn = Instance.new("TextButton", titleBar)
	btn.Size = UDim2.new(0, 30, 0, 30)
	btn.Position = UDim2.new(1, -offset, 0, 5)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = txt
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

createTitleButton("_", 100, function()
	mainFrame.Visible = false
	restoreGui.Enabled = true
end)

createTitleButton("□", 65, function()
	if not isMaximized then
		prevSize = mainFrame.Size
		prevPos = mainFrame.Position
		mainFrame.Size = UDim2.new(1, -40, 1, -40)
		mainFrame.Position = UDim2.new(0, 20, 0, 20)
		isMaximized = true
	else
		mainFrame.Size = prevSize
		mainFrame.Position = prevPos
		isMaximized = false
	end
end)

createTitleButton("X", 30, function()
	gui:Destroy()
	restoreGui:Destroy()
end)

-- Tabs
local tabs = {
	{ name = "Main", icon = "🧭" },
	{ name = "Movement", icon = "🏃" },
	{ name = "ESP", icon = "👁️" },
	{ name = "Float", icon = "🪶" },
	{ name = "Fishing", icon = "🎣" },
}

local tabFrames = {}

for i, tab in ipairs(tabs) do
	local btn = Instance.new("TextButton", tabPanel)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.LayoutOrder = i
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = tab.icon .. " " .. tab.name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

	local frame = Instance.new("Frame", contentZone)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	tabFrames[tab.name] = frame

	if tab.name == "Main" then
		local thanks = Instance.new("TextLabel", frame)
		thanks.Size = UDim2.new(1, -40, 0, 100)
		thanks.Position = UDim2.new(0, 20, 0, 20)
		thanks.BackgroundTransparency = 1
		thanks.Text = "🙏 im very thankful to Copilot, he saved a lot of my time!\nЭтот GUI — результат страсти, упорства и любви к чистому дизайну."
		thanks.Font = Enum.Font.GothamBold
		thanks.TextSize = 20
		thanks.TextColor3 = Color3.fromRGB(255, 255, 255)
		thanks.TextWrapped = true
		thanks.TextXAlignment = Enum.TextXAlignment.Center
		thanks.TextYAlignment = Enum.TextYAlignment.Top

		local nameLabel = Instance.new("TextLabel", frame)
		nameLabel.Size = UDim2.new(0, 220, 0, 24)
		nameLabel.Position = UDim2.new(1, -240, 1, -34)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = "Player: " .. shared.PlayerName
		nameLabel.Font = Enum.Font.Gotham
		nameLabel.TextSize = 14
		nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
		nameLabel.TextXAlignment = Enum.TextXAlignment.Right

	elseif tab.name == "Movement" then
		local container = Instance.new("Frame", frame)
		container.Size = UDim2.new(0, 320, 0, 160)
		container.Position = UDim2.new(0, 20, 0, 20)
		container.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		container.BorderSizePixel = 0
		Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

		local title = Instance.new("TextLabel", container)
		title.Size = UDim2.new(1, 0, 0, 30)
		title.Position = UDim2.new(0, 0, 0, 0)
		title.BackgroundTransparency = 1
		title.Text = "🏃 Speed Control"
		title.Font = Enum.Font.GothamBold
		title.TextSize = 18
		title.TextColor3 = Color3.fromRGB(255, 255, 255)

		local toggle = Instance.new("TextButton", container)
		toggle.Size = UDim2.new(0, 100, 0, 30)
		toggle.Position = UDim2.new(0, 10, 0, 100)
		toggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
		toggle.Text = "OFF"
		toggle.Font = Enum.Font.GothamBold
		toggle.TextSize = 16
		toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
		toggle.BorderSizePixel = 0
		Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 4)

		toggle.MouseButton1Click:Connect(function()
			active = not active
			toggle.Text = active and "ON" or "OFF"
			toggle.BackgroundColor3 = active and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(180, 60, 60)
			shared.SpeedControl.active = active
		end)

		local slider = Instance.new("Frame", container)
		slider.Size = UDim2.new(1, -40, 0, 20)
		slider.Position = UDim2.new(0, 20, 0, 40)
		slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		slider.BorderSizePixel = 0
		Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 4)

		local fill = Instance.new("Frame", slider)
		fill.Size = UDim2.new((currentSpeed - 16) / (100 - 16), 0, 1, 0)
		fill.Position = UDim2.new(0, 0, 0, 0)
		fill.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
		fill.BorderSizePixel = 0
		Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

		local knob = Instance.new("TextButton", slider)
		knob.Size = UDim2.new(0, 20, 0, 20)
		knob.Position = UDim2.new((currentSpeed - 16) / (100 - 16), -10, 0, 0)
		knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		knob.Text = ""
		knob.BorderSizePixel = 0
		Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 10)

		local speedLabel = Instance.new("TextLabel", container)
		speedLabel.Size = UDim2.new(1, 0, 0, 30)
		speedLabel.Position = UDim2.new(0, 0, 0, 70)
		speedLabel.BackgroundTransparency = 1
		speedLabel.Text = "Speed: " .. currentSpeed
		speedLabel.Font = Enum.Font.Gotham
		speedLabel.TextSize = 16
		speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		speedLabel.TextXAlignment = Enum.TextXAlignment.Center

		local draggingKnob = false

		knob.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				draggingKnob = true
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				draggingKnob = false
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if draggingKnob and input.UserInputType == Enum.UserInputType.MouseMovement then
				local mouseX = input.Position.X
				local sliderAbs = slider.AbsolutePosition.X
				local sliderSize = slider.AbsoluteSize.X
				local relativeX = math.clamp(mouseX - sliderAbs, 0, sliderSize)
				local percent = relativeX / sliderSize

				fill.Size = UDim2.new(percent, 0, 1, 0)
				knob.Position = UDim2.new(percent, -10, 0, 0)

				currentSpeed = math.floor(16 + percent * (100 - 16))
				speedLabel.Text = "Speed: " .. currentSpeed
				shared.SpeedControl.value = currentSpeed
			end
		end)

	elseif tab.name == "ESP" then
		local notice = Instance.new("TextLabel", frame)
		notice.Size = UDim2.new(1, -40, 0, 50)
		notice.Position = UDim2.new(0, 20, 0, 20)
		notice.BackgroundTransparency = 1
		notice.Text = "ESP не реализован. Могу добавить по запросу."
		notice.Font = Enum.Font.Gotham
		notice.TextSize = 16
		notice.TextColor3 = Color3.fromRGB(255,255,255)
		notice.TextWrapped = true

	elseif tab.name == "Float" then
		local notice = Instance.new("TextLabel", frame)
		notice.Size = UDim2.new(1, -40, 0, 50)
		notice.Position = UDim2.new(0, 20, 0, 20)
		notice.BackgroundTransparency = 1
		notice.Text = "Float не реализован. Могу добавить флай/анти-АФК."
		notice.Font = Enum.Font.Gotham
		notice.TextSize = 16
		notice.TextColor3 = Color3.fromRGB(255,255,255)
		notice.TextWrapped = true

	elseif tab.name == "Fishing" then
		local container = Instance.new("Frame", frame)
		container.Size = UDim2.new(0, 340, 0, 240)
		container.Position = UDim2.new(0, 20, 0, 20)
		container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		container.BorderSizePixel = 0
		Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

		local toggleButton = Instance.new("TextButton", container)
		toggleButton.Size = UDim2.new(1, -20, 0, 40)
		toggleButton.Position = UDim2.new(0, 10, 0, 10)
		toggleButton.Text = "Включить авто-рыбалку"
		toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		toggleButton.TextColor3 = Color3.new(1, 1, 1)
		toggleButton.Font = Enum.Font.GothamBold
		toggleButton.TextSize = 16
		Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 4)

		local statusLabel = Instance.new("TextLabel", container)
		statusLabel.Size = UDim2.new(1, -20, 0, 20)
		statusLabel.Position = UDim2.new(0, 10, 0, 60)
		statusLabel.Text = "Статус: 🔴 Выключено"
		statusLabel.BackgroundTransparency = 1
		statusLabel.TextColor3 = Color3.new(1, 1, 1)
		statusLabel.Font = Enum.Font.Gotham
		statusLabel.TextSize = 14

		local biteLabel = Instance.new("TextLabel", container)
		biteLabel.Size = UDim2.new(1, -20, 0, 20)
		biteLabel.Position = UDim2.new(0, 10, 0, 85)
		biteLabel.Text = "Поклёвка: ⚪ Нет"
		biteLabel.BackgroundTransparency = 1
		biteLabel.TextColor3 = Color3.new(1, 1, 1)
		biteLabel.Font = Enum.Font.Gotham
		biteLabel.TextSize = 14

		-- Rod selector
		local rodLabel = Instance.new("TextLabel", container)
		rodLabel.Size = UDim2.new(0, 120, 0, 20)
		rodLabel.Position = UDim2.new(0, 10, 0, 115)
		rodLabel.BackgroundTransparency = 1
		rodLabel.Text = "Удочка:"
		rodLabel.Font = Enum.Font.Gotham
		rodLabel.TextSize = 14
		rodLabel.TextColor3 = Color3.fromRGB(220,220,220)
		rodLabel.TextXAlignment = Enum.TextXAlignment.Left

		local rodButton = Instance.new("TextButton", container)
		rodButton.Size = UDim2.new(0, 200, 0, 28)
		rodButton.Position = UDim2.new(0, 130, 0, 111)
		rodButton.Text = shared.SelectedRod
		rodButton.Font = Enum.Font.Gotham
		rodButton.TextSize = 14
		rodButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
		rodButton.TextColor3 = Color3.fromRGB(255,255,255)
		rodButton.BorderSizePixel = 0
		Instance.new("UICorner", rodButton).CornerRadius = UDim.new(0,4)

		local dropdown = Instance.new("Frame", container)
		dropdown.Size = UDim2.new(0, 200, 0, 0)
		dropdown.Position = UDim2.new(0, 130, 0, 141)
		dropdown.BackgroundColor3 = Color3.fromRGB(50,50,50)
		dropdown.BorderSizePixel = 0
		Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0,4)
		dropdown.ClipsDescendants = true
		dropdown.Visible = false

		local rodOptions = { "Fishing Rod", "Advenced Rod", "Rod of Kings" }

		for idx, name in ipairs(rodOptions) do
			local opt = Instance.new("TextButton", dropdown)
			opt.Size = UDim2.new(1, 0, 0, 28)
			opt.Position = UDim2.new(0, 0, 0, (idx-1)*28)
			opt.Text = name
			opt.Font = Enum.Font.Gotham
			opt.TextSize = 14
			opt.BackgroundColor3 = Color3.fromRGB(60,60,60)
			opt.TextColor3 = Color3.fromRGB(255,255,255)
			opt.BorderSizePixel = 0
			Instance.new("UICorner", opt).CornerRadius = UDim.new(0,4)

			opt.MouseButton1Click:Connect(function()
				shared.SelectedRod = name
				rodButton.Text = name
				local tween = TweenService:Create(dropdown, TweenInfo.new(0.15), {Size = UDim2.new(0,200,0,0)})
				tween:Play()
				tween.Completed:Wait()
				dropdown.Visible = false
			end)
		end

		rodButton.MouseButton1Click:Connect(function()
			if dropdown.Visible then
				local tween = TweenService:Create(dropdown, TweenInfo.new(0.12), {Size = UDim2.new(0,200,0,0)})
				tween:Play()
				tween.Completed:Wait()
				dropdown.Visible = false
			else
				dropdown.Visible = true
				local targetSize = UDim2.new(0,200,0,#rodOptions * 28)
				local tween = TweenService:Create(dropdown, TweenInfo.new(0.12), {Size = targetSize})
				tween:Play()
			end
		end)

		-- Auto-equip toggle
		local equipLabel = Instance.new("TextLabel", container)
		equipLabel.Size = UDim2.new(0, 160, 0, 20)
		equipLabel.Position = UDim2.new(0, 10, 0, 160)
		equipLabel.BackgroundTransparency = 1
		equipLabel.Text = "Авто-экипировка удочки"
		equipLabel.Font = Enum.Font.Gotham
		equipLabel.TextSize = 14
		equipLabel.TextColor3 = Color3.fromRGB(220,220,220)
		equipLabel.TextXAlignment = Enum.TextXAlignment.Left

		local equipToggle = Instance.new("TextButton", container)
		equipToggle.Size = UDim2.new(0, 120, 0, 24)
		equipToggle.Position = UDim2.new(0, 170, 0, 156)
		equipToggle.Text = "OFF"
		equipToggle.Font = Enum.Font.GothamBold
		equipToggle.TextSize = 14
		equipToggle.BackgroundColor3 = Color3.fromRGB(180,60,60)
		equipToggle.TextColor3 = Color3.fromRGB(255,255,255)
		equipToggle.BorderSizePixel = 0
		Instance.new("UICorner", equipToggle).CornerRadius = UDim.new(0,4)

		-- tryEquipRod function
		local function tryEquipRod(rodName)
			if not rodName then return false end
			-- check Character first
			if player.Character then
				local inChar = player.Character:FindFirstChild(rodName)
				if inChar and inChar:IsA("Tool") then
					return true
				end
			end
			-- check Backpack
			local tool = backpack:FindFirstChild(rodName)
			if tool and tool:IsA("Tool") then
				tool.Parent = player.Character
				return true
			end
			-- wait for short spawn in backpack
			local found = false
			local conn
			conn = backpack.ChildAdded:Connect(function(child)
				if child.Name == rodName and child:IsA("Tool") then
					child.Parent = player.Character
					found = true
					if conn then conn:Disconnect() end
				end
			end)
			local t = 0
			while t < 3 and not found do
				task.wait(0.1)
				t = t + 0.1
			end
			if conn then conn:Disconnect() end
			return found
		end

		-- visual pulse for equip attempt
		local function playEquipPulse(success)
			local toColor = success and Color3.fromRGB(40,180,80) or Color3.fromRGB(200,60,60)
			local tweenIn = TweenService:Create(equipToggle, TweenInfo.new(0.12), {BackgroundColor3 = toColor})
			local tweenOut = TweenService:Create(equipToggle, TweenInfo.new(0.35), {BackgroundColor3 = Color3.fromRGB(60,60,60)})
			tweenIn:Play()
			tweenIn.Completed:Wait()
			tweenOut:Play()
		end

		equipToggle.MouseButton1Click:Connect(function()
			autoEquipRod = not autoEquipRod
			shared.AutoEquipRod = autoEquipRod
			equipToggle.Text = autoEquipRod and "ON" or "OFF"
			equipToggle.BackgroundColor3 = autoEquipRod and Color3.fromRGB(40,180,80) or Color3.fromRGB(180,60,60)
			if autoEquipRod then
				local ok = tryEquipRod(shared.SelectedRod)
				playEquipPulse(ok)
			end
		end)

		-- fishing logic
		toggleButton.MouseButton1Click:Connect(function()
			autoFishing = not autoFishing
			shared.AutoFishing = autoFishing
			toggleButton.Text = autoFishing and "Выключить авто-рыбалку" or "Включить авто-рыбалку"
		end)

		task.spawn(function()
			while true do
				if autoFishing then
					statusLabel.Text = "Статус: 🟢 Работает"
					biteLabel.Text = "Поклёвка: ⚪ Нет"

					-- ensure rod equipped if enabled
					if autoEquipRod then
						local equipped = false
						if player.Character and player.Character:FindFirstChild(shared.SelectedRod) then
							equipped = true
						end
						if not equipped then
							local ok = tryEquipRod(shared.SelectedRod)
							if ok then playEquipPulse(true) end
						end
					end

					-- initial click (cast)
					local mx, my = UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y
					VirtualInputManager:SendMouseButtonEvent(mx, my, 0, true, game, 0)
					task.wait(0.03)
					VirtualInputManager:SendMouseButtonEvent(mx, my, 0, false, game, 0)

					-- wait for bobber
					local bobber = nil
					local timeout = 5
					local t = 0
					repeat
						bobber = workspace:FindFirstChild("Bobber")
						task.wait(0.1)
						t = t + 0.1
					until bobber or t >= timeout

					if not bobber then
						task.wait(1)
						continue
					end

					local lastCenter = bobber.AssemblyCenterOfMass
					local noMoveTime = 0
					local heartbeatConn

					heartbeatConn = RunService.Heartbeat:Connect(function(dt)
						if not bobber or not bobber.Parent then return end
						local newCenter = bobber.AssemblyCenterOfMass
						local delta = (newCenter - lastCenter).Magnitude

						if delta > 0.01 then
							biteLabel.Text = "Поклёвка: ⚡ Есть!"
							local mx2, my2 = UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y
							VirtualInputManager:SendMouseButtonEvent(mx2, my2, 0, true, game, 0)
							task.wait(0.03)
							VirtualInputManager:SendMouseButtonEvent(mx2, my2, 0, false, game, 0)
							noMoveTime = 0
						else
							biteLabel.Text = "Поклёвка: ⚪ Нет"
							noMoveTime = noMoveTime + dt
						end

						if noMoveTime >= 10 then
							local mx3, my3 = UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y
							VirtualInputManager:SendMouseButtonEvent(mx3, my3, 0, true, game, 0)
							task.wait(0.03)
							VirtualInputManager:SendMouseButtonEvent(mx3, my3, 0, false, game, 0)
							noMoveTime = 0
						end

						lastCenter = newCenter
					end)

					repeat task.wait(0.2) until not bobber.Parent
					if heartbeatConn then heartbeatConn:Disconnect() end
				else
					statusLabel.Text = "Статус: 🔴 Выключено"
					biteLabel.Text = "Поклёвка: ⚪ Нет"
					task.wait(0.5)
				end
			end
		end)
	end

	-- tab button behaviour
	btn.MouseButton1Click:Connect(function()
		for _, f in pairs(tabFrames) do f.Visible = false end
		frame.Visible = true
	end)
end

-- Show Main by default
tabFrames["Main"].Visible = true

-- Apply WalkSpeed constantly
RunService.RenderStepped:Connect(function()
	if active then
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.WalkSpeed ~= currentSpeed then
				humanoid.WalkSpeed = currentSpeed
			end
		end
	end
end)
