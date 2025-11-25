local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

local zoneGap, titleHeight, bottomHeight = 10, 40, 20
local tabPanelWidth = 120

shared.PlayerName = player.Name

-- Color System
local Colors = {
    DarkGray = Color3.fromRGB(35, 35, 35),
    MediumGray = Color3.fromRGB(50, 50, 50),
    LightGray = Color3.fromRGB(60, 60, 60),
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 100, 255),
    Yellow = Color3.fromRGB(255, 255, 0),
    Purple = Color3.fromRGB(128, 0, 128),
    Orange = Color3.fromRGB(255, 165, 0),
    Pink = Color3.fromRGB(255, 105, 180),
    Cyan = Color3.fromRGB(0, 255, 255),
}

local colorNames = {"DarkGray", "MediumGray", "LightGray", "Red", "Green", "Blue", "Yellow", "Purple", "Orange", "Pink", "Cyan"}

local currentSettings = {
    color1 = "DarkGray",
    color2 = "Blue",
    gradientEnabled = false,
    gradientRotation = 90
}

local function brightenColor(color, amount)
    amount = amount or 0.2
    local h, s, v = color:ToHSV()
    v = math.clamp(v + amount, 0, 1)
    return Color3.fromHSV(h, s, v)
end

-- GUI Base
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "Pilgrammed Script by Georgiy/8"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, -2 * zoneGap, 0, titleHeight)
titleBar.Position = UDim2.new(0, zoneGap, 0, zoneGap)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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

local tabPanel = Instance.new("ScrollingFrame", mainFrame)
tabPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tabPanel.BorderSizePixel = 0
tabPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
tabPanel.ScrollBarThickness = 6
tabPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabPanel.ScrollingDirection = Enum.ScrollingDirection.Y
Instance.new("UICorner", tabPanel).CornerRadius = UDim.new(0, 6)

local padding = Instance.new("UIPadding", tabPanel)
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingBottom = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", tabPanel)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.VerticalAlignment = Enum.VerticalAlignment.Top

local contentZone = Instance.new("ScrollingFrame", mainFrame)
contentZone.Name = "ContentZone"
contentZone.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentZone.BorderSizePixel = 0
contentZone.CanvasSize = UDim2.new(0, 0, 0, 0)
contentZone.ScrollBarThickness = 6
contentZone.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentZone.ScrollingDirection = Enum.ScrollingDirection.Y
Instance.new("UICorner", contentZone).CornerRadius = UDim.new(0, 6)

local contentLayout = Instance.new("UIListLayout", contentZone)
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

local contentConstraint = Instance.new("UISizeConstraint", contentZone)
contentConstraint.MaxSize = Vector2.new(2000, 2000)

local bottomBar = Instance.new("Frame", mainFrame)
bottomBar.Size = UDim2.new(1, -2 * zoneGap, 0, bottomHeight)
bottomBar.Position = UDim2.new(0, zoneGap, 1, -(bottomHeight + zoneGap))
bottomBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
bottomBar.BorderSizePixel = 0
Instance.new("UICorner", bottomBar).CornerRadius = UDim.new(0, 6)

local guiElements = {}
local tabButtons = {}

local function applyColors()
    if currentSettings.gradientEnabled then
        for _, elem in ipairs(guiElements) do
            local gradient = elem:FindFirstChildOfClass("UIGradient")
            if not gradient then
                gradient = Instance.new("UIGradient")
                gradient.Parent = elem
            end
            
            local brighterColor1 = brightenColor(Colors[currentSettings.color1], 0.15)
            local brighterColor2 = brightenColor(Colors[currentSettings.color2], 0.15)
            
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, brighterColor1),
                ColorSequenceKeypoint.new(1, brighterColor2)
            })
            
            gradient.Rotation = currentSettings.gradientRotation
        end
        
        for _, btn in ipairs(tabButtons) do
            local gradient = btn:FindFirstChildOfClass("UIGradient")
            if not gradient then
                gradient = Instance.new("UIGradient")
                gradient.Parent = btn
            end
            
            local brighterColor1 = brightenColor(Colors[currentSettings.color1], 0.25)
            local brighterColor2 = brightenColor(Colors[currentSettings.color2], 0.25)
            
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, brighterColor1),
                ColorSequenceKeypoint.new(1, brighterColor2)
            })
            
            gradient.Rotation = currentSettings.gradientRotation
        end
    else
        for _, elem in ipairs(guiElements) do
            local gradient = elem:FindFirstChildOfClass("UIGradient")
            if gradient then gradient:Destroy() end
            elem.BackgroundColor3 = brightenColor(Colors[currentSettings.color1], 0.15)
        end
        
        for _, btn in ipairs(tabButtons) do
            local gradient = btn:FindFirstChildOfClass("UIGradient")
            if gradient then gradient:Destroy() end
            btn.BackgroundColor3 = brightenColor(Colors[currentSettings.color1], 0.25)
        end
    end
end

table.insert(guiElements, mainFrame)
table.insert(guiElements, titleBar)
table.insert(guiElements, tabPanel)
table.insert(guiElements, contentZone)
table.insert(guiElements, bottomBar)

local function updateLayout()
    RunService.Heartbeat:Wait()
    local mainW, mainH = mainFrame.AbsoluteSize.X, mainFrame.AbsoluteSize.Y
    local tabW = tabPanelWidth
    local leftOffset = tabW + zoneGap * 2
    local contentWidth = math.max(0, mainW - leftOffset - zoneGap)
    local contentHeight = math.max(0, mainH - (titleHeight + bottomHeight + zoneGap * 4))

    tabPanel.Size = UDim2.new(0, tabW, 0, contentHeight)
    tabPanel.Position = UDim2.new(0, zoneGap, 0, titleHeight + zoneGap * 2)
    titleBar.Size = UDim2.new(1, -2 * zoneGap, 0, titleHeight)
    titleBar.Position = UDim2.new(0, zoneGap, 0, zoneGap)
    bottomBar.Size = UDim2.new(0, mainW - 2 * zoneGap, 0, bottomHeight)
    bottomBar.Position = UDim2.new(0, zoneGap, 1, -(bottomHeight + zoneGap))
    contentZone.Position = UDim2.new(0, leftOffset, 0, titleHeight + zoneGap * 2)
    contentZone.Size = UDim2.new(0, contentWidth, 0, contentHeight)
    contentZone.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    tabPanel.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
end

mainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)
tabPanel:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)

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

local resizeHandle = Instance.new("Frame", bottomBar)
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
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
        local newHeight = math.clamp(mouse.Y - mainFrame.AbsolutePosition.Y - inset.Y, 200, 800)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

local restoreGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
restoreGui.ResetOnSpawn = false
restoreGui.Name = "RestoreButtonGui"
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

local function clearContentZone()
    for _, child in ipairs(contentZone:GetChildren()) do
        if child ~= contentLayout and child ~= contentConstraint then
            if child:IsA("GuiObject") then
                child.Visible = false
            end
        end
    end
end

local tabOrder = 0
local tabs = {}
local settingsTab = nil
local settingsOrder = 9999

function newTab(name, icon, position)
    local currentOrder
    if name == "Settings" then
        currentOrder = settingsOrder
    else
        if position and position >= 1 and position <= 10 then
            currentOrder = position
        else
            tabOrder = tabOrder + 1
            currentOrder = tabOrder
        end
    end
    
    local tabData = {
        name = name,
        icon = icon,
        order = currentOrder,
        container = nil,
        button = nil
    }
    
    local btn = Instance.new("TextButton", tabPanel)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = icon .. " " .. name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.LayoutOrder = currentOrder
    
    tabData.button = btn
    table.insert(tabButtons, btn)
    
    local container = Instance.new("Frame", contentZone)
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.LayoutOrder = 1
    container.Visible = false
    container.AutomaticSize = Enum.AutomaticSize.Y
    
    local containerLayout = Instance.new("UIListLayout", container)
    containerLayout.Padding = UDim.new(0, 10)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    tabData.container = container
    
    if name == "Settings" then
        settingsTab = tabData
    end
    
    btn.MouseButton1Click:Connect(function()
        clearContentZone()
        container.Visible = true
        contentZone.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    table.insert(tabs, tabData)
    return container
end

-- Settings tab
local function createSettings()
    local settingsContainer = newTab("Settings", "⚙️")
    local padding = Instance.new("UIPadding", settingsContainer)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    
    local titleLabel = Instance.new("TextLabel", settingsContainer)
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎨 Color Settings"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.LayoutOrder = 1
    
    local color1Frame = Instance.new("Frame", settingsContainer)
    color1Frame.Size = UDim2.new(1, -20, 0, 200)
    color1Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    color1Frame.BorderSizePixel = 0
    color1Frame.LayoutOrder = 2
    Instance.new("UICorner", color1Frame).CornerRadius = UDim.new(0, 6)
    
    local color1Title = Instance.new("TextLabel", color1Frame)
    color1Title.Size = UDim2.new(1, -20, 0, 25)
    color1Title.Position = UDim2.new(0, 10, 0, 10)
    color1Title.BackgroundTransparency = 1
    color1Title.Text = "Primary Color"
    color1Title.Font = Enum.Font.GothamBold
    color1Title.TextSize = 16
    color1Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    color1Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local color1Grid = Instance.new("Frame", color1Frame)
    color1Grid.Size = UDim2.new(1, -20, 0, 155)
    color1Grid.Position = UDim2.new(0, 10, 0, 40)
    color1Grid.BackgroundTransparency = 1
    
    local gridLayout1 = Instance.new("UIGridLayout", color1Grid)
    gridLayout1.CellSize = UDim2.new(0, 45, 0, 45)
    gridLayout1.CellPadding = UDim2.new(0, 5, 0, 5)
    
    local color2Frame = Instance.new("Frame", settingsContainer)
    color2Frame.Size = UDim2.new(1, -20, 0, 200)
    color2Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    color2Frame.BorderSizePixel = 0
    color2Frame.LayoutOrder = 3
    Instance.new("UICorner", color2Frame).CornerRadius = UDim.new(0, 6)
    
    local color2Title = Instance.new("TextLabel", color2Frame)
    color2Title.Size = UDim2.new(1, -20, 0, 25)
    color2Title.Position = UDim2.new(0, 10, 0, 10)
    color2Title.BackgroundTransparency = 1
    color2Title.Text = "Secondary Color (Gradient)"
    color2Title.Font = Enum.Font.GothamBold
    color2Title.TextSize = 16
    color2Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    color2Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local color2Grid = Instance.new("Frame", color2Frame)
    color2Grid.Size = UDim2.new(1, -20, 0, 155)
    color2Grid.Position = UDim2.new(0, 10, 0, 40)
    color2Grid.BackgroundTransparency = 1
    
    local gridLayout2 = Instance.new("UIGridLayout", color2Grid)
    gridLayout2.CellSize = UDim2.new(0, 45, 0, 45)
    gridLayout2.CellPadding = UDim2.new(0, 5, 0, 5)
    
    local gradientButton = Instance.new("TextButton", settingsContainer)
    gradientButton.Size = UDim2.new(1, -20, 0, 50)
    gradientButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    gradientButton.Text = "🎨 Gradient Mode: OFF"
    gradientButton.Font = Enum.Font.GothamBold
    gradientButton.TextSize = 18
    gradientButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    gradientButton.BorderSizePixel = 0
    gradientButton.LayoutOrder = 4
    Instance.new("UICorner", gradientButton).CornerRadius = UDim.new(0, 6)
    
    local selectedButtons1, selectedButtons2 = {}, {}
    
    for i, colorName in ipairs(colorNames) do
        local btn1 = Instance.new("TextButton", color1Grid)
        btn1.BackgroundColor3 = Colors[colorName]
        btn1.Text = ""
        btn1.BorderSizePixel = colorName == currentSettings.color1 and 4 or 2
        btn1.BorderColor3 = Color3.fromRGB(255, 255, 255)
        btn1.BorderMode = Enum.BorderMode.Inset
        Instance.new("UICorner", btn1).CornerRadius = UDim.new(0, 6)
        selectedButtons1[colorName] = btn1
        
        btn1.MouseButton1Click:Connect(function()
            for name, button in pairs(selectedButtons1) do
                button.BorderSizePixel = 2
            end
            btn1.BorderSizePixel = 4
            currentSettings.color1 = colorName
            applyColors()
        end)
        
        local btn2 = Instance.new("TextButton", color2Grid)
        btn2.BackgroundColor3 = Colors[colorName]
        btn2.Text = ""
        btn2.BorderSizePixel = colorName == currentSettings.color2 and 4 or 2
        btn2.BorderColor3 = Color3.fromRGB(255, 255, 255)
        btn2.BorderMode = Enum.BorderMode.Inset
        Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 6)
        selectedButtons2[colorName] = btn2
        
        btn2.MouseButton1Click:Connect(function()
            for name, button in pairs(selectedButtons2) do
                button.BorderSizePixel = 2
            end
            btn2.BorderSizePixel = 4
            currentSettings.color2 = colorName
            if currentSettings.gradientEnabled then
                applyColors()
            end
        end)
    end
    
    gradientButton.MouseButton1Click:Connect(function()
        currentSettings.gradientEnabled = not currentSettings.gradientEnabled
        if currentSettings.gradientEnabled then
            gradientButton.Text = "🎨 Gradient Mode: ON"
            gradientButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        else
            gradientButton.Text = "🎨 Gradient Mode: OFF"
            gradientButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        end
        applyColors()
    end)
end

-- Main Tab Module
local function createMainTab()
    local mainTab = newTab("Main", "🌐", 1)
    
    local mainTitle = Instance.new("TextLabel", mainTab)
    mainTitle.Text = "🌐 Main Functions"
    mainTitle.Size = UDim2.new(1, -20, 0, 40)
    mainTitle.BackgroundTransparency = 1
    mainTitle.TextColor3 = Color3.new(1, 1, 1)
    mainTitle.Font = Enum.Font.GothamBold
    mainTitle.TextSize = 20
    mainTitle.LayoutOrder = 1
    
    local infoFrame = Instance.new("Frame", mainTab)
    infoFrame.Size = UDim2.new(1, -20, 0, 120)
    infoFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    infoFrame.BorderSizePixel = 0
    infoFrame.LayoutOrder = 2
    Instance.new("UICorner", infoFrame).CornerRadius = UDim.new(0, 6)
    
    local infoPadding = Instance.new("UIPadding", infoFrame)
    infoPadding.PaddingLeft = UDim.new(0, 10)
    infoPadding.PaddingTop = UDim.new(0, 10)
    
    local playerInfo = Instance.new("TextLabel", infoFrame)
    playerInfo.Text = "👤 Player: " .. player.Name
    playerInfo.Size = UDim2.new(1, -20, 0, 25)
    playerInfo.Position = UDim2.new(0, 0, 0, 0)
    playerInfo.BackgroundTransparency = 1
    playerInfo.TextColor3 = Color3.new(1, 1, 1)
    playerInfo.Font = Enum.Font.Gotham
    playerInfo.TextSize = 14
    playerInfo.TextXAlignment = Enum.TextXAlignment.Left
    
    local fpsLabel = Instance.new("TextLabel", infoFrame)
    fpsLabel.Text = "📊 FPS: Calculating..."
    fpsLabel.Size = UDim2.new(1, -20, 0, 25)
    fpsLabel.Position = UDim2.new(0, 0, 0, 30)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.TextColor3 = Color3.new(1, 1, 1)
    fpsLabel.Font = Enum.Font.Gotham
    fpsLabel.TextSize = 14
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local pingLabel = Instance.new("TextLabel", infoFrame)
    pingLabel.Text = "📡 Ping: Calculating..."
    pingLabel.Size = UDim2.new(1, -20, 0, 25)
    pingLabel.Position = UDim2.new(0, 0, 0, 60)
    pingLabel.BackgroundTransparency = 1
    pingLabel.TextColor3 = Color3.new(1, 1, 1)
    pingLabel.Font = Enum.Font.Gotham
    pingLabel.TextSize = 14
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local timeLabel = Instance.new("TextLabel", infoFrame)
    timeLabel.Text = "⏰ Time: " .. os.date("%H:%M:%S")
    timeLabel.Size = UDim2.new(1, -20, 0, 25)
    timeLabel.Position = UDim2.new(0, 0, 0, 90)
    timeLabel.BackgroundTransparency = 1
    timeLabel.TextColor3 = Color3.new(1, 1, 1)
    timeLabel.Font = Enum.Font.Gotham
    timeLabel.TextSize = 14
    timeLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local lastTime = tick()
    local frameCount = 0
    RunService.Heartbeat:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frameCount / (currentTime - lastTime))
            fpsLabel.Text = "📊 FPS: " .. fps
            frameCount = 0
            lastTime = currentTime
        end
        timeLabel.Text = "⏰ Time: " .. os.date("%H:%M:%S")
    end)
    
    task.spawn(function()
        while wait(2) do
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            pingLabel.Text = "📡 Ping: " .. ping
        end
    end)
    
    local wsFrame = Instance.new("Frame", mainTab)
    wsFrame.Size = UDim2.new(1, -20, 0, 80)
    wsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    wsFrame.BorderSizePixel = 0
    wsFrame.LayoutOrder = 3
    Instance.new("UICorner", wsFrame).CornerRadius = UDim.new(0, 6)
    
    local wsTitle = Instance.new("TextLabel", wsFrame)
    wsTitle.Text = "🏃 Walk Speed"
    wsTitle.Size = UDim2.new(1, -20, 0, 25)
    wsTitle.Position = UDim2.new(0, 10, 0, 5)
    wsTitle.BackgroundTransparency = 1
    wsTitle.TextColor3 = Color3.new(1, 1, 1)
    wsTitle.Font = Enum.Font.GothamBold
    wsTitle.TextSize = 16
    wsTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local wsSlider = Instance.new("TextButton", wsFrame)
    wsSlider.Size = UDim2.new(1, -20, 0, 30)
    wsSlider.Position = UDim2.new(0, 10, 0, 40)
    wsSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    wsSlider.Text = "Speed: 16"
    wsSlider.Font = Enum.Font.Gotham
    wsSlider.TextSize = 14
    wsSlider.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", wsSlider).CornerRadius = UDim.new(0, 6)
    
    local currentSpeed = 16
    wsSlider.MouseButton1Click:Connect(function()
        currentSpeed = currentSpeed + 4
        if currentSpeed > 100 then currentSpeed = 16 end
        wsSlider.Text = "Speed: " .. currentSpeed
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = currentSpeed
        end
    end)
end

-- Floating Tab Module
local function createFloatingTab()
    local floatingTab = newTab("Floating", "🎈", 3)
    
    local floatingTitle = Instance.new("TextLabel", floatingTab)
    floatingTitle.Text = "🎈 Object Explorer"
    floatingTitle.Size = UDim2.new(1, -20, 0, 40)
    floatingTitle.BackgroundTransparency = 1
    floatingTitle.TextColor3 = Color3.new(1, 1, 1)
    floatingTitle.Font = Enum.Font.GothamBold
    floatingTitle.TextSize = 20
    floatingTitle.LayoutOrder = 1
    
    local mouse = player:GetMouse()
    local selectedPart, selecting, highlight = nil, false, nil
    local respawnEnabled, respawnPosition = false, nil
    
    local indicator = Instance.new("TextLabel", floatingTab)
    indicator.Text = "⛔ Нет объекта"
    indicator.Size = UDim2.new(1, -20, 0, 30)
    indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    indicator.TextColor3 = Color3.fromRGB(255, 100, 100)
    indicator.Font = Enum.Font.Gotham
    indicator.TextSize = 16
    indicator.LayoutOrder = 2
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 6)
    
    local selectBtn = Instance.new("TextButton", floatingTab)
    selectBtn.Text = "🔍 Выбрать объект"
    selectBtn.Size = UDim2.new(1, -20, 0, 45)
    selectBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    selectBtn.TextColor3 = Color3.new(1, 1, 1)
    selectBtn.Font = Enum.Font.GothamBold
    selectBtn.TextSize = 16
    selectBtn.LayoutOrder = 3
    Instance.new("UICorner", selectBtn).CornerRadius = UDim.new(0, 6)
    
    local confirmBtn = Instance.new("TextButton", floatingTab)
    confirmBtn.Text = "⚓ Подтвердить Anchored"
    confirmBtn.Size = UDim2.new(1, -20, 0, 45)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    confirmBtn.TextColor3 = Color3.new(1, 1, 1)
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.TextSize = 16
    confirmBtn.LayoutOrder = 4
    Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 6)
    
    local teleportObjBtn = Instance.new("TextButton", floatingTab)
    teleportObjBtn.Text = "📦 Телепортировать объект"
    teleportObjBtn.Size = UDim2.new(1, -20, 0, 45)
    teleportObjBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    teleportObjBtn.TextColor3 = Color3.new(1, 1, 1)
    teleportObjBtn.Font = Enum.Font.GothamBold
    teleportObjBtn.TextSize = 16
    teleportObjBtn.LayoutOrder = 5
    Instance.new("UICorner", teleportObjBtn).CornerRadius = UDim.new(0, 6)
    
    local teleportToObjBtn = Instance.new("TextButton", floatingTab)
    teleportToObjBtn.Text = "🚶 Телепорт на объект"
    teleportToObjBtn.Size = UDim2.new(1, -20, 0, 45)
    teleportToObjBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    teleportToObjBtn.TextColor3 = Color3.new(1, 1, 1)
    teleportToObjBtn.Font = Enum.Font.GothamBold
    teleportToObjBtn.TextSize = 16
    teleportToObjBtn.LayoutOrder = 6
    Instance.new("UICorner", teleportToObjBtn).CornerRadius = UDim.new(0, 6)
    
    local respawnBtn = Instance.new("TextButton", floatingTab)
    respawnBtn.Text = "🔴 Respawn: ВЫКЛ"
    respawnBtn.Size = UDim2.new(1, -20, 0, 45)
    respawnBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    respawnBtn.TextColor3 = Color3.new(1, 1, 1)
    respawnBtn.Font = Enum.Font.GothamBold
    respawnBtn.TextSize = 16
    respawnBtn.LayoutOrder = 7
    Instance.new("UICorner", respawnBtn).CornerRadius = UDim.new(0, 6)
    
    selectBtn.MouseButton1Click:Connect(function()
        selecting = true
        selectedPart = nil
        indicator.Text = "🟡 Ожидание клика..."
        indicator.TextColor3 = Color3.fromRGB(255, 255, 0)
        if highlight then highlight:Destroy() end
    end)
    
    mouse.Button1Down:Connect(function()
        if selecting then
            local target = mouse.Target
            if target and target:IsA("BasePart") then
                selectedPart = target
                selecting = false
                indicator.Text = "🟠 Выбран: " .. target.Name
                indicator.TextColor3 = Color3.fromRGB(255, 165, 0)
                if highlight then highlight:Destroy() end
                highlight = Instance.new("Highlight", target)
                highlight.Adornee = target
                highlight.FillColor = Color3.fromRGB(255, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
        end
    end)
    
    confirmBtn.MouseButton1Click:Connect(function()
        if selectedPart then
            selectedPart.Anchored = true
            indicator.Text = "🟢 Подтверждён: " .. selectedPart.Name
            indicator.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end)
    
    teleportObjBtn.MouseButton1Click:Connect(function()
        if selectedPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            selectedPart.CFrame = root.CFrame * CFrame.new(0, -3, 0)
            indicator.Text = "📦 Объект под тобой"
            indicator.TextColor3 = Color3.fromRGB(0, 200, 255)
        end
    end)
    
    teleportToObjBtn.MouseButton1Click:Connect(function()
        if selectedPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            root.CFrame = selectedPart.CFrame + Vector3.new(0, 5, 0)
            indicator.Text = "🚶 Ты на объекте"
            indicator.TextColor3 = Color3.fromRGB(0, 200, 255)
        end
    end)
    
    respawnBtn.MouseButton1Click:Connect(function()
        if selectedPart then
            respawnEnabled = not respawnEnabled
            if respawnEnabled then
                respawnPosition = selectedPart.CFrame + Vector3.new(0, 5, 0)
                respawnBtn.Text = "🟢 Respawn: ВКЛ"
                respawnBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            else
                respawnBtn.Text = "🔴 Respawn: ВЫКЛ"
                respawnBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
        end
    end)
    
    player.CharacterAdded:Connect(function(char)
        if respawnEnabled and respawnPosition then
            local root = char:WaitForChild("HumanoidRootPart")
            root.CFrame = respawnPosition
        end
    end)
end

-- Fishing Tab Module (улучшенная версия с списком удочек)
local function createFishingTab()
    local fishingTab = newTab("Fishing", "🎣", 6)
    
    local title = Instance.new("TextLabel", fishingTab)
    title.Text = "🎣 Auto Fishing (Optimized)"
    title.Size = UDim2.new(1, -20, 0, 40)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.LayoutOrder = 1
    
    local toggleButton = Instance.new("TextButton", fishingTab)
    toggleButton.Text = "Включить авто-рыбалку"
    toggleButton.Size = UDim2.new(1, -20, 0, 40)
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 16
    toggleButton.LayoutOrder = 2
    Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)
    
    local statusLabel = Instance.new("TextLabel", fishingTab)
    statusLabel.Text = "Статус: 🔴 Выключено"
    statusLabel.Size = UDim2.new(1, -20, 0, 20)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 14
    statusLabel.LayoutOrder = 3
    
    local biteLabel = Instance.new("TextLabel", fishingTab)
    biteLabel.Text = "Поклёвка: ⚪ Нет"
    biteLabel.Size = UDim2.new(1, -20, 0, 20)
    biteLabel.BackgroundTransparency = 1
    biteLabel.TextColor3 = Color3.new(1, 1, 1)
    biteLabel.Font = Enum.Font.Gotham
    biteLabel.TextSize = 14
    biteLabel.LayoutOrder = 4
    
    local fishCountLabel = Instance.new("TextLabel", fishingTab)
    fishCountLabel.Text = "Поймано рыбы: 0"
    fishCountLabel.Size = UDim2.new(1, -20, 0, 20)
    fishCountLabel.BackgroundTransparency = 1
    fishCountLabel.TextColor3 = Color3.new(1, 1, 1)
    fishCountLabel.Font = Enum.Font.Gotham
    fishCountLabel.TextSize = 14
    fishCountLabel.LayoutOrder = 5
    
    local delaySlider = Instance.new("TextButton", fishingTab)
    delaySlider.Text = "Задержка клика: 0.03 сек"
    delaySlider.Size = UDim2.new(1, -20, 0, 40)
    delaySlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    delaySlider.TextColor3 = Color3.new(1, 1, 1)
    delaySlider.Font = Enum.Font.GothamBold
    delaySlider.TextSize = 16
    delaySlider.LayoutOrder = 6
    Instance.new("UICorner", delaySlider).CornerRadius = UDim.new(0, 6)
    
    local currentDelay = 0.03
    delaySlider.MouseButton1Click:Connect(function()
        currentDelay = currentDelay + 0.02
        if currentDelay > 0.1 then currentDelay = 0.03 end
        delaySlider.Text = "Задержка клика: " .. currentDelay .. " сек"
    end)
    
    -- Новый блок: Auto Rod Toggle
    local autoRodButton = Instance.new("TextButton", fishingTab)
    autoRodButton.Text = "🔴 Auto Rod: OFF"
    autoRodButton.Size = UDim2.new(1, -20, 0, 50)
    autoRodButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    autoRodButton.TextColor3 = Color3.new(1, 1, 1)
    autoRodButton.Font = Enum.Font.GothamBold
    autoRodButton.TextSize = 18
    autoRodButton.LayoutOrder = 7
    Instance.new("UICorner", autoRodButton).CornerRadius = UDim.new(0, 6)
    
    -- Статус удочки
    local rodStatus = Instance.new("TextLabel", fishingTab)
    rodStatus.Text = "Удочка: Не выбрана"
    rodStatus.Size = UDim2.new(1, -20, 0, 30)
    rodStatus.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    rodStatus.TextColor3 = Color3.new(1, 1, 1)
    rodStatus.Font = Enum.Font.Gotham
    rodStatus.TextSize = 14
    rodStatus.LayoutOrder = 8
    Instance.new("UICorner", rodStatus).CornerRadius = UDim.new(0, 6)
    
    -- Кнопка обновления списка удочек
    local refreshRodsButton = Instance.new("TextButton", fishingTab)
    refreshRodsButton.Text = "🔄 Обновить список"
    refreshRodsButton.Size = UDim2.new(1, -20, 0, 45)
    refreshRodsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    refreshRodsButton.TextColor3 = Color3.new(1, 1, 1)
    refreshRodsButton.Font = Enum.Font.GothamBold
    refreshRodsButton.TextSize = 16
    refreshRodsButton.LayoutOrder = 9
    Instance.new("UICorner", refreshRodsButton).CornerRadius = UDim.new(0, 6)
    
    -- Фрейм списка удочек
    local rodListFrame = Instance.new("Frame", fishingTab)
    rodListFrame.Size = UDim2.new(1, -20, 0, 300)
    rodListFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    rodListFrame.BorderSizePixel = 0
    rodListFrame.LayoutOrder = 10
    Instance.new("UICorner", rodListFrame).CornerRadius = UDim.new(0, 6)
    
    local listTitleRods = Instance.new("TextLabel", rodListFrame)
    listTitleRods.Size = UDim2.new(1, -20, 0, 30)
    listTitleRods.Position = UDim2.new(0, 10, 0, 10)
    listTitleRods.BackgroundTransparency = 1
    listTitleRods.Text = "🎣 Доступные удочки:"
    listTitleRods.TextColor3 = Color3.new(1, 1, 1)
    listTitleRods.Font = Enum.Font.GothamBold
    listTitleRods.TextSize = 16
    listTitleRods.TextXAlignment = Enum.TextXAlignment.Left
    
    local scrollFrameRods = Instance.new("ScrollingFrame", rodListFrame)
    scrollFrameRods.Size = UDim2.new(1, -20, 1, -50)
    scrollFrameRods.Position = UDim2.new(0, 10, 0, 40)
    scrollFrameRods.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    scrollFrameRods.BorderSizePixel = 0
    scrollFrameRods.ScrollBarThickness = 4
    scrollFrameRods.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrameRods.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", scrollFrameRods).CornerRadius = UDim.new(0, 6)
    
    local listLayoutRods = Instance.new("UIListLayout", scrollFrameRods)
    listLayoutRods.Padding = UDim.new(0, 5)
    listLayoutRods.SortOrder = Enum.SortOrder.LayoutOrder
    
    local listPaddingRods = Instance.new("UIPadding", scrollFrameRods)
    listPaddingRods.PaddingLeft = UDim.new(0, 5)
    listPaddingRods.PaddingRight = UDim.new(0, 5)
    listPaddingRods.PaddingTop = UDim.new(0, 5)
    listPaddingRods.PaddingBottom = UDim.new(0, 5)
    
    local rodList = {}
    local selectedRod = nil
    local autoRodEnabled = false
    
    -- Функция поиска удочек
    local function findFishingRods()
        rodList = {}
        local backpack = player:FindFirstChild("Backpack")
        
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():match("rod") then
                    table.insert(rodList, tool)
                end
            end
        end
        
        if player.Character then
            for _, tool in pairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():match("rod") then
                    local alreadyListed = false
                    for _, listedTool in pairs(rodList) do
                        if listedTool.Name == tool.Name then
                            alreadyListed = true
                            break
                        end
                    end
                    if not alreadyListed then
                        table.insert(rodList, tool)
                    end
                end
            end
        end
        
        return rodList
    end
    
    -- Функция экипировки удочки
    local function equipRod(tool)
        if not tool then return false end
        
        if tool.Parent == player.Backpack then
            player.Character.Humanoid:EquipTool(tool)
            return true
        end
        
        if tool.Parent == player.Character then
            return true
        end
        
        return false
    end
    
    -- Функция обновления списка удочек
    local function updateRodList()
        for _, child in pairs(scrollFrameRods:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        findFishingRods()
        
        if #rodList == 0 then
            local noRodsLabel = Instance.new("TextLabel", scrollFrameRods)
            noRodsLabel.Size = UDim2.new(1, -10, 0, 40)
            noRodsLabel.BackgroundTransparency = 1
            noRodsLabel.Text = "⚠️ Удочки не найдены"
            noRodsLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            noRodsLabel.Font = Enum.Font.Gotham
            noRodsLabel.TextSize = 14
            return
        end
        
        for _, tool in pairs(rodList) do
            local rodFrame = Instance.new("Frame", scrollFrameRods)
            rodFrame.Size = UDim2.new(1, -10, 0, 40)
            rodFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            rodFrame.BorderSizePixel = 0
            Instance.new("UICorner", rodFrame).CornerRadius = UDim.new(0, 6)
            
            local indicator = Instance.new("Frame", rodFrame)
            indicator.Size = UDim2.new(0, 8, 1, -10)
            indicator.Position = UDim2.new(0, 5, 0, 5)
            indicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            indicator.BorderSizePixel = 0
            Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 4)
            
            local rodLabel = Instance.new("TextLabel", rodFrame)
            rodLabel.Size = UDim2.new(1, -60, 1, 0)
            rodLabel.Position = UDim2.new(0, 20, 0, 0)
            rodLabel.BackgroundTransparency = 1
            rodLabel.Text = "🎣 " .. tool.Name
            rodLabel.TextColor3 = Color3.new(1, 1, 1)
            rodLabel.Font = Enum.Font.Gotham
            rodLabel.TextSize = 14
            rodLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local selectButton = Instance.new("TextButton", rodFrame)
            selectButton.Size = UDim2.new(0, 45, 0, 30)
            selectButton.Position = UDim2.new(1, -50, 0.5, -15)
            selectButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            selectButton.Text = "✓"
            selectButton.TextColor3 = Color3.new(1, 1, 1)
            selectButton.Font = Enum.Font.GothamBold
            selectButton.TextSize = 18
            Instance.new("UICorner", selectButton).CornerRadius = UDim.new(0, 6)
            
            if selectedRod and selectedRod.Name == tool.Name then
                indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                selectButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            end
            
            selectButton.MouseButton1Click:Connect(function()
                selectedRod = tool
                rodStatus.Text = "Удочка: " .. tool.Name
                updateRodList()
            end)
        end
    end
    
    -- Toggle Auto Rod
    autoRodButton.MouseButton1Click:Connect(function()
        autoRodEnabled = not autoRodEnabled
        autoRodButton.Text = autoRodEnabled and "🟢 Auto Rod: ON" or "🔴 Auto Rod: OFF"
        autoRodButton.BackgroundColor3 = autoRodEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        
        if autoRodEnabled and selectedRod then
            equipRod(selectedRod)
        end
    end)
    
    -- Обновить список удочек
    refreshRodsButton.MouseButton1Click:Connect(function()
        updateRodList()
    end)
    
    local autoFishing = false
    local fishCount = 0
    
    local function isRodEquipped()
        if player.Character then
            for _, tool in pairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():match("rod") then
                    return true
                end
            end
        end
        return false
    end
    
    local function click()
        mouse1press()
        task.wait(currentDelay)
        mouse1release()
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        autoFishing = not autoFishing
        toggleButton.Text = autoFishing and "Выключить авто-рыбалку" or "Включить авто-рыбалку"
        statusLabel.Text = autoFishing and "Статус: 🟢 Работает" or "Статус: 🔴 Выключено"
    end)
    
    task.spawn(function()
        while task.wait(0.5) do
            if autoFishing then
                if not isRodEquipped() then
                    statusLabel.Text = "⚠️ Удочка не экипирована!"
                    if autoRodEnabled and selectedRod then
                        equipRod(selectedRod)
                    end
                    task.wait(2)
                    continue
                end
                
                statusLabel.Text = "Статус: 🟢 Работает"
                biteLabel.Text = "Поклёвка: ⚪ Нет"
                click()
                
                local bobber = nil
                local timeout = 5
                local t = 0
                repeat
                    bobber = workspace:FindFirstChild("Bobber")
                    task.wait(0.1)
                    t += 0.1
                until bobber or t >= timeout
                
                if bobber then
                    local lastCenter = bobber.AssemblyCenterOfMass
                    local noMoveTime = 0
                    local heartbeatConn
                    heartbeatConn = RunService.Heartbeat:Connect(function(dt)
                        if not bobber or not bobber.Parent then return end
                        local newCenter = bobber.AssemblyCenterOfMass
                        local delta = (newCenter - lastCenter).Magnitude
                        
                        if delta > 0.01 then
                            biteLabel.Text = "Поклёвка: ⚡ Есть!"
                            click()
                            fishCount = fishCount + 1
                            fishCountLabel.Text = "Поймано рыбы: " .. fishCount
                            noMoveTime = 0
                        else
                            biteLabel.Text = "Поклёвка: ⚪ Нет"
                            noMoveTime += dt
                        end
                        
                        if noMoveTime >= 10 then
                            click()  -- Авто-перезапуск если застряло
                            noMoveTime = 0
                        end
                        
                        lastCenter = newCenter
                    end)
                    
                    repeat task.wait(0.2) until not bobber.Parent
                    if heartbeatConn then heartbeatConn:Disconnect() end
                else
                    statusLabel.Text = "⚠️ Боббер не найден — перезапуск!"
                    click()  -- Авто-перезапуск если боббер не появился
                end
            else
                biteLabel.Text = "Поклёвка: ⚪ Нет"
            end
        end
    end)
    
    -- Инициализация списка удочек
    wait(0.5)
    updateRodList()
    
    -- Фикс после смерти для удочки
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        task.wait(0.5)
        if autoRodEnabled and selectedRod then
            equipRod(selectedRod)
        end
    end)
end

-- Mining Tab Module with combined Ore ESP and Auto Mining
local function createMiningTab()
    local miningTab = newTab("Mining", "⛏️", 2)
    
    local miningTitle = Instance.new("TextLabel", miningTab)
    miningTitle.Text = "⛏️ Mining & Visuals"
    miningTitle.Size = UDim2.new(1, -20, 0, 40)
    miningTitle.BackgroundTransparency = 1
    miningTitle.TextColor3 = Color3.new(1, 1, 1)
    miningTitle.Font = Enum.Font.GothamBold
    miningTitle.TextSize = 20
    miningTitle.LayoutOrder = 1
    
    -- Local variables for ESP and Mining (shared)
    local oreESPEnabled = false
    local oreHighlights = {}
    local autoToolEnabled = false
    local autoMiningEnabled = false
    local autoWalkEnabled = false
    local selectedToolName = nil  -- Теперь храним имя, а не объект
    local toolList = {}
    local currentTargetOre = nil
    
    -- Ore colors (without "Ore" suffix)
    local oreColors = {
        ["Copper"] = Color3.fromRGB(184, 115, 51),
        ["Tin"] = Color3.fromRGB(180, 180, 180),
        ["Iron"] = Color3.fromRGB(200, 200, 200),
        ["Zinc"] = Color3.fromRGB(220, 220, 230),
        ["Silver"] = Color3.fromRGB(192, 192, 192),
        ["Brass"] = Color3.fromRGB(181, 166, 66),
        ["Bronze"] = Color3.fromRGB(205, 127, 50),
        ["Demetal"] = Color3.fromRGB(150, 50, 50),
        ["Mithril"] = Color3.fromRGB(100, 200, 255),
        ["Emerald"] = Color3.fromRGB(0, 255, 0),
        ["Diamond"] = Color3.fromRGB(0, 200, 255),
        ["Sapphire"] = Color3.fromRGB(0, 100, 255),
        ["Ruby"] = Color3.fromRGB(255, 0, 0),
        ["Sulfur"] = Color3.fromRGB(255, 255, 0),
    }
    
    -- All ores enabled by default
    local selectedOres = {}
    for oreName, _ in pairs(oreColors) do
        selectedOres[oreName] = true
    end
    
    -- Shared functions for ESP and Mining
    local function getOreName(obj)
        local base = obj:FindFirstChild("Base")
        if base then
            local part = base:FindFirstChild("Part")
            if part and part.Name then
                return part.Name
            end
        end
        
        for _, child in pairs(obj:GetDescendants()) do
            if child:IsA("BasePart") and child.Name ~= "Base" and child.Name ~= "Part" then
                for oreName, _ in pairs(oreColors) do
                    if string.find(child.Name, oreName) then
                        return oreName
                    end
                end
            end
        end
        
        return nil
    end
    
    -- Function to find nearest ore (considers selectedOres)
    local function findNearestOre()
        local oresFolder = workspace:FindFirstChild("Ores") or workspace:FindFirstChild("ores")
        local nearestOre = nil
        local shortestDistance = math.huge
        
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return nil
        end
        
        local playerPos = player.Character.HumanoidRootPart.Position
        
        if oresFolder then
            for _, ore in pairs(oresFolder:GetChildren()) do
                if ore:IsA("Model") or ore:IsA("Folder") then
                    local oreName = getOreName(ore)
                    if oreName and selectedOres[oreName] then
                        local orePart = ore:FindFirstChildWhichIsA("BasePart", true)
                        if orePart then
                            local distance = (orePart.Position - playerPos).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestOre = ore
                            end
                        end
                    end
                end
            end
        end
        
        return nearestOre
    end
    
    -- Function to teleport to ore (side and looking at ore)
    local function teleportToOre(ore)
        if not ore or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return false
        end
        
        local orePart = ore:FindFirstChildWhichIsA("BasePart", true)
        if orePart then
            local sideOffset = Vector3.new(3, 0, 0)  -- Side by X (can change)
            local pos = orePart.Position + sideOffset
            local lookAt = orePart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(pos, lookAt)
            return true
        end
        
        return false
    end
    
    -- Function to walk to ore (for walk mode, no rotation)
    local function walkToOre(ore)
        if not ore or not player.Character or not player.Character:FindFirstChild("Humanoid") then
            return false
        end
        
        local orePart = ore:FindFirstChildWhichIsA("BasePart", true)
        if orePart then
            local sideOffset = Vector3.new(3, 0, 0)
            local pos = orePart.Position + sideOffset
            player.Character.Humanoid:MoveTo(pos)
            return true
        end
        
        return false
    end
    
    -- Function to create ESP
    local function createOreESP(ore)
        local oreName = getOreName(ore)
        if not oreName or not selectedOres[oreName] then return end
        
        local color = oreColors[oreName] or Color3.fromRGB(255, 255, 255)
        
        local mainPart = ore:FindFirstChildWhichIsA("BasePart", true)
        if not mainPart then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Parent = ore
        highlight.Adornee = ore
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        local billboard = Instance.new("BillboardGui")
        billboard.Parent = mainPart
        billboard.Adornee = mainPart
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        
        local textLabel = Instance.new("TextLabel", billboard)
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = oreName
        textLabel.TextColor3 = color
        textLabel.TextStrokeTransparency = 0.5
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 14
        
        table.insert(oreHighlights, {highlight = highlight, billboard = billboard})
    end
    
    -- Function to clear ESP
    local function clearOreESP()
        for _, data in pairs(oreHighlights) do
            if data.highlight then data.highlight:Destroy() end
            if data.billboard then data.billboard:Destroy() end
        end
        oreHighlights = {}
    end
    
    -- Function to update ESP
    local function updateOreESP()
        clearOreESP()
        
        if oreESPEnabled then
            local oresFolder = workspace:FindFirstChild("Ores") or workspace:FindFirstChild("ores")
            
            if oresFolder then
                for _, ore in pairs(oresFolder:GetChildren()) do
                    if ore:IsA("Model") or ore:IsA("Folder") then
                        createOreESP(ore)
                    end
                end
            else
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name:match("%d+") then
                        local oreName = getOreName(obj)
                        if oreName then
                            createOreESP(obj)
                        end
                    end
                end
            end
        end
    end
    
    -- Function to find mining tools
    local function findMiningTools()
        toolList = {}
        local backpack = player:FindFirstChild("Backpack")
        
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local toolName = tool.Name:lower()
                    if toolName:match("pick") or toolName:match("axe") or toolName:match("drill") or 
                       toolName:match("shovel") or toolName:match("hammer") or toolName:match("mining") then
                        table.insert(toolList, tool)
                    end
                end
            end
        end
        
        if player.Character then
            for _, tool in pairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local toolName = tool.Name:lower()
                    if toolName:match("pick") or toolName:match("axe") or toolName:match("drill") or 
                       toolName:match("shovel") or toolName:match("hammer") or toolName:match("mining") then
                        local alreadyListed = false
                        for _, listedTool in pairs(toolList) do
                            if listedTool.Name == tool.Name then
                                alreadyListed = true
                                break
                            end
                        end
                        if not alreadyListed then
                            table.insert(toolList, tool)
                        end
                    end
                end
            end
        end
        
        return toolList
    end
    
    -- Function to equip tool by name
    local function equipTool(toolName)
        if not toolName then return false end
        
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == toolName then
                    player.Character.Humanoid:EquipTool(tool)
                    return true
                end
            end
        end
        
        return false
    end
    
    -- Function to activate tool by name
    local function activateTool(toolName)
        if player.Character then
            for _, tool in pairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == toolName then
                    tool:Activate()
                    return true
                end
            end
        end
        return false
    end
    
    -- Function to check if tool is equipped by name
    local function isToolEquipped(toolName)
        if player.Character then
            for _, tool in pairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == toolName then
                    return true
                end
            end
        end
        return false
    end
    
    -- Ore ESP Button
    local oreESPButton = Instance.new("TextButton", miningTab)
    oreESPButton.Text = "🔴 Ore ESP: OFF"
    oreESPButton.Size = UDim2.new(1, -20, 0, 50)
    oreESPButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    oreESPButton.TextColor3 = Color3.new(1, 1, 1)
    oreESPButton.Font = Enum.Font.GothamBold
    oreESPButton.TextSize = 18
    oreESPButton.LayoutOrder = 2
    Instance.new("UICorner", oreESPButton).CornerRadius = UDim.new(0, 6)
    
    -- Ore status (shared for ESP and Mining)
    local oreStatus = Instance.new("TextLabel", miningTab)
    oreStatus.Text = "Найдено руд: 0"
    oreStatus.Size = UDim2.new(1, -20, 0, 30)
    oreStatus.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    oreStatus.TextColor3 = Color3.new(1, 1, 1)
    oreStatus.Font = Enum.Font.Gotham
    oreStatus.TextSize = 14
    oreStatus.LayoutOrder = 3
    Instance.new("UICorner", oreStatus).CornerRadius = UDim.new(0, 6)
    
    -- Refresh ESP button
    local refreshButton = Instance.new("TextButton", miningTab)
    refreshButton.Text = "🔄 Обновить ESP"
    refreshButton.Size = UDim2.new(1, -20, 0, 45)
    refreshButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    refreshButton.TextColor3 = Color3.new(1, 1, 1)
    refreshButton.Font = Enum.Font.GothamBold
    refreshButton.TextSize = 16
    refreshButton.LayoutOrder = 4
    Instance.new("UICorner", refreshButton).CornerRadius = UDim.new(0, 6)
    
    -- Ore list frame (shared)
    local oreListFrame = Instance.new("Frame", miningTab)
    oreListFrame.Size = UDim2.new(1, -20, 0, 500)
    oreListFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    oreListFrame.BorderSizePixel = 0
    oreListFrame.LayoutOrder = 5
    Instance.new("UICorner", oreListFrame).CornerRadius = UDim.new(0, 6)
    
    local listTitle = Instance.new("TextLabel", oreListFrame)
    listTitle.Size = UDim2.new(1, -20, 0, 30)
    listTitle.Position = UDim2.new(0, 10, 0, 10)
    listTitle.BackgroundTransparency = 1
    listTitle.Text = "💎 Выбор руд (для ESP и Mining):"
    listTitle.TextColor3 = Color3.new(1, 1, 1)
    listTitle.Font = Enum.Font.GothamBold
    listTitle.TextSize = 16
    listTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local scrollFrame = Instance.new("ScrollingFrame", oreListFrame)
    scrollFrame.Size = UDim2.new(1, -20, 1, -50)
    scrollFrame.Position = UDim2.new(0, 10, 0, 40)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 6)
    
    local listLayout = Instance.new("UIListLayout", scrollFrame)
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local listPadding = Instance.new("UIPadding", scrollFrame)
    listPadding.PaddingLeft = UDim.new(0, 5)
    listPadding.PaddingRight = UDim.new(0, 5)
    listPadding.PaddingTop = UDim.new(0, 5)
    listPadding.PaddingBottom = UDim.new(0, 5)
    
    -- Buttons for each ore (shared)
    local oreButtons = {}
    for oreName, color in pairs(oreColors) do
        local oreFrame = Instance.new("Frame", scrollFrame)
        oreFrame.Size = UDim2.new(1, -10, 0, 35)
        oreFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        oreFrame.BorderSizePixel = 0
        Instance.new("UICorner", oreFrame).CornerRadius = UDim.new(0, 6)
        
        local indicator = Instance.new("Frame", oreFrame)
        indicator.Size = UDim2.new(0, 25, 0, 25)
        indicator.Position = UDim2.new(0, 5, 0.5, -12.5)
        indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Зеленый по умолчанию
        indicator.BorderSizePixel = 0
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 4)
        
        local nameLabel = Instance.new("TextLabel", oreFrame)
        nameLabel.Size = UDim2.new(1, -40, 1, 0)
        nameLabel.Position = UDim2.new(0, 35, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = oreName
        nameLabel.TextColor3 = color
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local button = Instance.new("TextButton", oreFrame)
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        
        oreButtons[oreName] = {frame = oreFrame, indicator = indicator, button = button}
        
        button.MouseButton1Click:Connect(function()
            selectedOres[oreName] = not selectedOres[oreName]
            if selectedOres[oreName] then
                indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            else
                indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
            
            if oreESPEnabled then
                updateOreESP()
            end
        end)
    end
    
    -- Auto Tool Toggle
    local autoToolButton = Instance.new("TextButton", miningTab)
    autoToolButton.Text = "🔴 Auto Tool: OFF"
    autoToolButton.Size = UDim2.new(1, -20, 0, 50)
    autoToolButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    autoToolButton.TextColor3 = Color3.new(1, 1, 1)
    autoToolButton.Font = Enum.Font.GothamBold
    autoToolButton.TextSize = 18
    autoToolButton.LayoutOrder = 6
    Instance.new("UICorner", autoToolButton).CornerRadius = UDim.new(0, 6)
    
    -- Tool status
    local toolStatus = Instance.new("TextLabel", miningTab)
    toolStatus.Text = "Инструмент: Не выбран"
    toolStatus.Size = UDim2.new(1, -20, 0, 30)
    toolStatus.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toolStatus.TextColor3 = Color3.new(1, 1, 1)
    toolStatus.Font = Enum.Font.Gotham
    toolStatus.TextSize = 14
    toolStatus.LayoutOrder = 7
    Instance.new("UICorner", toolStatus).CornerRadius = UDim.new(0, 6)
    
    -- Refresh tools button
    local refreshToolsButton = Instance.new("TextButton", miningTab)
    refreshToolsButton.Text = "🔄 Обновить список"
    refreshToolsButton.Size = UDim2.new(1, -20, 0, 45)
    refreshToolsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    refreshToolsButton.TextColor3 = Color3.new(1, 1, 1)
    refreshToolsButton.Font = Enum.Font.GothamBold
    refreshToolsButton.TextSize = 16
    refreshToolsButton.LayoutOrder = 8
    Instance.new("UICorner", refreshToolsButton).CornerRadius = UDim.new(0, 6)
    
    -- Auto Mining Toggle
    local autoMiningButton = Instance.new("TextButton", miningTab)
    autoMiningButton.Text = "🔴 Auto Mining: OFF"
    autoMiningButton.Size = UDim2.new(1, -20, 0, 50)
    autoMiningButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    autoMiningButton.TextColor3 = Color3.new(1, 1, 1)
    autoMiningButton.Font = Enum.Font.GothamBold
    autoMiningButton.TextSize = 18
    autoMiningButton.LayoutOrder = 9
    Instance.new("UICorner", autoMiningButton).CornerRadius = UDim.new(0, 6)
    
    -- Auto Walk Toggle
    local autoWalkButton = Instance.new("TextButton", miningTab)
    autoWalkButton.Text = "Режим: Телепорт"
    autoWalkButton.Size = UDim2.new(1, -20, 0, 45)
    autoWalkButton.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
    autoWalkButton.TextColor3 = Color3.new(1, 1, 1)
    autoWalkButton.Font = Enum.Font.GothamBold
    autoWalkButton.TextSize = 16
    autoWalkButton.LayoutOrder = 10
    Instance.new("UICorner", autoWalkButton).CornerRadius = UDim.new(0, 6)
    
    -- Mining Status
    local miningStatus = Instance.new("TextLabel", miningTab)
    miningStatus.Text = "Статус: Ожидание..."
    miningStatus.Size = UDim2.new(1, -20, 0, 30)
    miningStatus.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    miningStatus.TextColor3 = Color3.new(1, 1, 1)
    miningStatus.Font = Enum.Font.Gotham
    miningStatus.TextSize = 14
    miningStatus.LayoutOrder = 11
    Instance.new("UICorner", miningStatus).CornerRadius = UDim.new(0, 6)
    
    -- Tool list frame
    local toolListFrame = Instance.new("Frame", miningTab)
    toolListFrame.Size = UDim2.new(1, -20, 0, 300)
    toolListFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    toolListFrame.BorderSizePixel = 0
    toolListFrame.LayoutOrder = 12
    Instance.new("UICorner", toolListFrame).CornerRadius = UDim.new(0, 6)
    
    local listTitleTools = Instance.new("TextLabel", toolListFrame)
    listTitleTools.Size = UDim2.new(1, -20, 0, 30)
    listTitleTools.Position = UDim2.new(0, 10, 0, 10)
    listTitleTools.BackgroundTransparency = 1
    listTitleTools.Text = "🔨 Доступные инструменты:"
    listTitleTools.TextColor3 = Color3.new(1, 1, 1)
    listTitleTools.Font = Enum.Font.GothamBold
    listTitleTools.TextSize = 16
    listTitleTools.TextXAlignment = Enum.TextXAlignment.Left
    
    local scrollFrameTools = Instance.new("ScrollingFrame", toolListFrame)
    scrollFrameTools.Size = UDim2.new(1, -20, 1, -50)
    scrollFrameTools.Position = UDim2.new(0, 10, 0, 40)
    scrollFrameTools.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    scrollFrameTools.BorderSizePixel = 0
    scrollFrameTools.ScrollBarThickness = 4
    scrollFrameTools.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrameTools.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", scrollFrameTools).CornerRadius = UDim.new(0, 6)
    
    local listLayoutTools = Instance.new("UIListLayout", scrollFrameTools)
    listLayoutTools.Padding = UDim.new(0, 5)
    listLayoutTools.SortOrder = Enum.SortOrder.LayoutOrder
    
    local listPaddingTools = Instance.new("UIPadding", scrollFrameTools)
    listPaddingTools.PaddingLeft = UDim.new(0, 5)
    listPaddingTools.PaddingRight = UDim.new(0, 5)
    listPaddingTools.PaddingTop = UDim.new(0, 5)
    listPaddingTools.PaddingBottom = UDim.new(0, 5)
    
    -- Function to update tool list
    local function updateToolList()
        for _, child in pairs(scrollFrameTools:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        findMiningTools()
        
        if #toolList == 0 then
            local noToolsLabel = Instance.new("TextLabel", scrollFrameTools)
            noToolsLabel.Size = UDim2.new(1, -10, 0, 40)
            noToolsLabel.BackgroundTransparency = 1
            noToolsLabel.Text = "⚠️ Инструменты не найдены"
            noToolsLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            noToolsLabel.Font = Enum.Font.Gotham
            noToolsLabel.TextSize = 14
            return
        end
        
        for _, tool in pairs(toolList) do
            local toolFrame = Instance.new("Frame", scrollFrameTools)
            toolFrame.Size = UDim2.new(1, -10, 0, 40)
            toolFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toolFrame.BorderSizePixel = 0
            Instance.new("UICorner", toolFrame).CornerRadius = UDim.new(0, 6)
            
            local indicator = Instance.new("Frame", toolFrame)
            indicator.Size = UDim2.new(0, 8, 1, -10)
            indicator.Position = UDim2.new(0, 5, 0, 5)
            indicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            indicator.BorderSizePixel = 0
            Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 4)
            
            local toolLabel = Instance.new("TextLabel", toolFrame)
            toolLabel.Size = UDim2.new(1, -60, 1, 0)
            toolLabel.Position = UDim2.new(0, 20, 0, 0)
            toolLabel.BackgroundTransparency = 1
            toolLabel.Text = "⛏️ " .. tool.Name
            toolLabel.TextColor3 = Color3.new(1, 1, 1)
            toolLabel.Font = Enum.Font.Gotham
            toolLabel.TextSize = 14
            toolLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local selectButton = Instance.new("TextButton", toolFrame)
            selectButton.Size = UDim2.new(0, 45, 0, 30)
            selectButton.Position = UDim2.new(1, -50, 0.5, -15)
            selectButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            selectButton.Text = "✓"
            selectButton.TextColor3 = Color3.new(1, 1, 1)
            selectButton.Font = Enum.Font.GothamBold
            selectButton.TextSize = 18
            Instance.new("UICorner", selectButton).CornerRadius = UDim.new(0, 6)
            
            if selectedToolName and selectedToolName == tool.Name then
                indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                selectButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            end
            
            selectButton.MouseButton1Click:Connect(function()
                selectedToolName = tool.Name
                toolStatus.Text = "Инструмент: " .. tool.Name
                updateToolList()
            end)
        end
    end
    
    -- Toggle Ore ESP
    oreESPButton.MouseButton1Click:Connect(function()
        oreESPEnabled = not oreESPEnabled
        oreESPButton.Text = oreESPEnabled and "🟢 Ore ESP: ON" or "🔴 Ore ESP: OFF"
        oreESPButton.BackgroundColor3 = oreESPEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        
        updateOreESP()
        oreStatus.Text = "Найдено руд: " .. #oreHighlights
    end)
    
    -- Refresh ESP
    refreshButton.MouseButton1Click:Connect(function()
        if oreESPEnabled then
            updateOreESP()
            oreStatus.Text = "Найдено руд: " .. #oreHighlights
        end
    end)
    
    -- Auto update ESP every 5 sec
    task.spawn(function()
        while wait(5) do
            if oreESPEnabled then
                updateOreESP()
                oreStatus.Text = "Найдено руд: " .. #oreHighlights
            end
        end
    end)
    
    -- Toggle Auto Tool
    autoToolButton.MouseButton1Click:Connect(function()
        autoToolEnabled = not autoToolEnabled
        autoToolButton.Text = autoToolEnabled and "🟢 Auto Tool: ON" or "🔴 Auto Tool: OFF"
        autoToolButton.BackgroundColor3 = autoToolEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        
        if autoToolEnabled and selectedToolName then
            equipTool(selectedToolName)
        end
    end)
    
    -- Toggle Auto Mining
    autoMiningButton.MouseButton1Click:Connect(function()
        autoMiningEnabled = not autoMiningEnabled
        autoMiningButton.Text = autoMiningEnabled and "🟢 Auto Mining: ON" or "🔴 Auto Mining: OFF"
        autoMiningButton.BackgroundColor3 = autoMiningEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)
    
    -- Toggle Walk Mode
    autoWalkButton.MouseButton1Click:Connect(function()
        autoWalkEnabled = not autoWalkEnabled
        autoWalkButton.Text = autoWalkEnabled and "Режим: Ходьба" or "Режим: Телепорт"
        autoWalkButton.BackgroundColor3 = autoWalkEnabled and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(50, 100, 255)
    end)
    
    -- Refresh tool list
    refreshToolsButton.MouseButton1Click:Connect(function()
        updateToolList()
    end)
    
    -- Auto equip tool
    task.spawn(function()
        while wait(0.5) do
            if autoToolEnabled and selectedToolName then
                if player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild(selectedToolName) and player.Character then
                    equipTool(selectedToolName)
                end
            end
        end
    end)
    
    -- Auto Mining Loop
    task.spawn(function()
        while wait(1) do
            if autoMiningEnabled then
                if not selectedToolName then
                    miningStatus.Text = "⚠️ Выберите инструмент!"
                else
                    currentTargetOre = findNearestOre()
                    
                    if currentTargetOre then
                        local oreName = getOreName(currentTargetOre)
                        miningStatus.Text = "⛏️ Копаем: " .. (oreName or "Руду")
                        
                        if autoWalkEnabled then
                            walkToOre(currentTargetOre)
                            wait(2)
                        else
                            teleportToOre(currentTargetOre)
                            wait(0.5)
                        end
                        
                        if selectedToolName then
                            if player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild(selectedToolName) and player.Character then
                                equipTool(selectedToolName)
                                wait(0.3)
                            end
                            
                            for i = 1, 5 do
                                if not currentTargetOre or not currentTargetOre.Parent then
                                    break
                                end
                                activateTool(selectedToolName)
                                wait(0.5)
                            end
                        end
                    else
                        miningStatus.Text = "🔍 Поиск руд..."
                    end
                end
            else
                miningStatus.Text = "Статус: Выключено"
            end
        end
    end)
    
    -- Фикс после смерти для инструмента
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        task.wait(0.5)
        if autoToolEnabled and selectedToolName then
            equipTool(selectedToolName)
        end
    end)
    
    -- Initialization
    wait(0.5)
    updateToolList()
end

-- Initialize all modules
wait()
createSettings()
createMainTab()
createFloatingTab()
createFishingTab()
createMiningTab()

updateLayout()
contentZone.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
tabPanel.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)

if settingsTab then
    settingsTab.container.Visible = true
    contentZone.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end

print("✅ Pilgrammed Script v3 loaded!")
print("📦 All modules initialized")
