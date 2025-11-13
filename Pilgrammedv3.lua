local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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
    bottomBar.Position = UDim2.new(0, zoneGap, 0, mainH - (bottomHeight + zoneGap))
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

-- Settings tab (без змінних у глобальному скопі)
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

-- Main Tab Module (обгорнутий у функцію)
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

-- Mining Tab Module (пуста)
local function createMiningTab()
    local miningTab = newTab("Mining", "⛏️", 2)
    
    local miningTitle = Instance.new("TextLabel", miningTab)
    miningTitle.Text = "⛏️ Mining"
    miningTitle.Size = UDim2.new(1, -20, 0, 40)
    miningTitle.BackgroundTransparency = 1
    miningTitle.TextColor3 = Color3.new(1, 1, 1)
    miningTitle.Font = Enum.Font.GothamBold
    miningTitle.TextSize = 20
    miningTitle.LayoutOrder = 1
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
    respawnBtn.Text = "🔴 Респавн: ВЫКЛ"
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
                respawnBtn.Text = "🟢 Респавн: ВКЛ"
                respawnBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            else
                respawnBtn.Text = "🔴 Респавн: ВЫКЛ"
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

-- Visuals Tab Module з повним Ore ESP
local function createVisualsTab()
    local visualsTab = newTab("Visuals", "👁️", 4)
    
    local visualsTitle = Instance.new("TextLabel", visualsTab)
    visualsTitle.Text = "👁️ Visuals"
    visualsTitle.Size = UDim2.new(1, -20, 0, 40)
    visualsTitle.BackgroundTransparency = 1
    visualsTitle.TextColor3 = Color3.new(1, 1, 1)
    visualsTitle.Font = Enum.Font.GothamBold
    visualsTitle.TextSize = 20
    visualsTitle.LayoutOrder = 1
    
    -- Локальні змінні для ESP
    local oreESPEnabled = false
    local oreHighlights = {}
    
    -- Кольори руд (без "Ore" суфіксу)
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
    
    -- За замовчуванням всі руди увімкнені
    local selectedOres = {}
    for oreName, _ in pairs(oreColors) do
        selectedOres[oreName] = true
    end
    
    -- Кнопка Ore ESP
    local oreESPButton = Instance.new("TextButton", visualsTab)
    oreESPButton.Text = "🔴 Ore ESP: OFF"
    oreESPButton.Size = UDim2.new(1, -20, 0, 50)
    oreESPButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    oreESPButton.TextColor3 = Color3.new(1, 1, 1)
    oreESPButton.Font = Enum.Font.GothamBold
    oreESPButton.TextSize = 18
    oreESPButton.LayoutOrder = 2
    Instance.new("UICorner", oreESPButton).CornerRadius = UDim.new(0, 6)
    
    -- Статус
    local oreStatus = Instance.new("TextLabel", visualsTab)
    oreStatus.Text = "Найдено руд: 0"
    oreStatus.Size = UDim2.new(1, -20, 0, 30)
    oreStatus.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    oreStatus.TextColor3 = Color3.new(1, 1, 1)
    oreStatus.Font = Enum.Font.Gotham
    oreStatus.TextSize = 14
    oreStatus.LayoutOrder = 3
    Instance.new("UICorner", oreStatus).CornerRadius = UDim.new(0, 6)
    
    -- Кнопка оновлення
    local refreshButton = Instance.new("TextButton", visualsTab)
    refreshButton.Text = "🔄 Обновить ESP"
    refreshButton.Size = UDim2.new(1, -20, 0, 45)
    refreshButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    refreshButton.TextColor3 = Color3.new(1, 1, 1)
    refreshButton.Font = Enum.Font.GothamBold
    refreshButton.TextSize = 16
    refreshButton.LayoutOrder = 4
    Instance.new("UICorner", refreshButton).CornerRadius = UDim.new(0, 6)
    
    -- Фрейм списку руд
    local oreListFrame = Instance.new("Frame", visualsTab)
    oreListFrame.Size = UDim2.new(1, -20, 0, 500)
    oreListFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    oreListFrame.BorderSizePixel = 0
    oreListFrame.LayoutOrder = 5
    Instance.new("UICorner", oreListFrame).CornerRadius = UDim.new(0, 6)
    
    local listTitle = Instance.new("TextLabel", oreListFrame)
    listTitle.Size = UDim2.new(1, -20, 0, 30)
    listTitle.Position = UDim2.new(0, 10, 0, 10)
    listTitle.BackgroundTransparency = 1
    listTitle.Text = "💎 Выбор руд:"
    listTitle.TextColor3 = Color3.new(1, 1, 1)
    listTitle.Font = Enum.Font.GothamBold
    listTitle.TextSize = 16
    listTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- ScrollingFrame
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
    
    -- Кнопки для кожної руди
    local oreButtons = {}
    for oreName, color in pairs(oreColors) do
        local oreFrame = Instance.new("Frame", scrollFrame)
        oreFrame.Size = UDim2.new(1, -10, 0, 35)
        oreFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        oreFrame.BorderSizePixel = 0
        Instance.new("UICorner", oreFrame).CornerRadius = UDim.new(0, 6)
        
        -- Індикатор (квадрат)
        local indicator = Instance.new("Frame", oreFrame)
        indicator.Size = UDim2.new(0, 25, 0, 25)
        indicator.Position = UDim2.new(0, 5, 0.5, -12.5)
        indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Зелений за замовчуванням
        indicator.BorderSizePixel = 0
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 4)
        
        -- Назва руди
        local nameLabel = Instance.new("TextLabel", oreFrame)
        nameLabel.Size = UDim2.new(1, -40, 1, 0)
        nameLabel.Position = UDim2.new(0, 35, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = oreName
        nameLabel.TextColor3 = color
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Кнопка (невидима)
        local button = Instance.new("TextButton", oreFrame)
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        
        oreButtons[oreName] = {frame = oreFrame, indicator = indicator, button = button}
        
        -- Обробник кліку
        button.MouseButton1Click:Connect(function()
            selectedOres[oreName] = not selectedOres[oreName]
            if selectedOres[oreName] then
                indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Зелений
            else
                indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Червоний
            end
            
            -- Оновлюємо ESP якщо увімкнено
            if oreESPEnabled then
                updateOreESP()
            end
        end)
    end
    
    -- Функція знаходження назви руди
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
    
    -- Функція створення ESP
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
    
    -- Функція видалення ESP
    local function clearOreESP()
        for _, data in pairs(oreHighlights) do
            if data.highlight then data.highlight:Destroy() end
            if data.billboard then data.billboard:Destroy() end
        end
        oreHighlights = {}
    end
    
    -- Функція оновлення ESP
    function updateOreESP()
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
    
    -- Toggle ESP
    oreESPButton.MouseButton1Click:Connect(function()
        oreESPEnabled = not oreESPEnabled
        oreESPButton.Text = oreESPEnabled and "🟢 Ore ESP: ON" or "🔴 Ore ESP: OFF"
        oreESPButton.BackgroundColor3 = oreESPEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        
        updateOreESP()
        oreStatus.Text = "Найдено руд: " .. #oreHighlights
    end)
    
    -- Оновлення ESP
    refreshButton.MouseButton1Click:Connect(function()
        if oreESPEnabled then
            updateOreESP()
            oreStatus.Text = "Найдено руд: " .. #oreHighlights
        end
    end)
    
    -- Автоматичне оновлення кожні 5 секунд
    task.spawn(function()
        while wait(5) do
            if oreESPEnabled then
                updateOreESP()
                oreStatus.Text = "Найдено руд: " .. #oreHighlights
            end
        end
    end)
end

-- Fishing Tab Module
local function createFishingTab()
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local fishingTab = newTab("Fishing", "🎣", 6)
    
    local title = Instance.new("TextLabel", fishingTab)
    title.Text = "🎣 Auto Fishing"
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
    
    local function getMousePos()
        local pos = UserInputService:GetMouseLocation()
        return pos.X, pos.Y
    end
    
    local function click()
        local x, y = getMousePos()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.03)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end
    
    local autoFishing = false
    
    toggleButton.MouseButton1Click:Connect(function()
        autoFishing = not autoFishing
        toggleButton.Text = autoFishing and "Выключить авто-рыбалку" or "Включить авто-рыбалку"
        statusLabel.Text = autoFishing and "Статус: 🟢 Работает" or "Статус: 🔴 Выключено"
    end)
    
    task.spawn(function()
        while true do
            if autoFishing then
                statusLabel.Text = "Статус: 🟢 Работает"
                biteLabel.Text = "Поклёвка: ⚪ Нет"
                click()
                
                local bobber = nil
                local timeout, t = 5, 0
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
                            noMoveTime = 0
                        else
                            biteLabel.Text = "Поклёвка: ⚪ Нет"
                            noMoveTime += dt
                        end
                        
                        if noMoveTime >= 10 then
                            click()
                            noMoveTime = 0
                        end
                        
                        lastCenter = newCenter
                    end)
                    
                    repeat task.wait(0.2) until not bobber.Parent
                    if heartbeatConn then heartbeatConn:Disconnect() end
                else
                    task.wait(1)
                end
            else
                biteLabel.Text = "Поклёвка: ⚪ Нет"
                task.wait(0.5)
            end
        end
    end)
end

-- Initialize all modules
wait()
createSettings()
createMainTab()
createMiningTab()
createFloatingTab()
createVisualsTab()
createFishingTab()

updateLayout()
contentZone.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
tabPanel.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)

if settingsTab then
    settingsTab.container.Visible = true
    contentZone.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end

print("✅ Pilgrammed Script v2 loaded!")
print("📦 All modules initialized")
