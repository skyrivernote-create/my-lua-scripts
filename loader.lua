if game.PlaceId ~= 142823291 then
    return
end

local userInputService = game:GetService("UserInputService")
local PlayersService = game:GetService("Players")
local player = PlayersService.LocalPlayer
local mouse = player:GetMouse()
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModMenu"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 500)
frame.Position = UDim2.new(0.5, -175, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true
frame.Parent = screenGui

-- Rainbow border colors
local rainbowColors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 127, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(75, 0, 130),
    Color3.fromRGB(148, 0, 211),
}

local function createRainbowBorder(parent, borderSize)
    local topBorder = Instance.new("Frame")
    topBorder.Size = UDim2.new(1, borderSize*2, 0, borderSize)
    topBorder.Position = UDim2.new(0, -borderSize, 0, -borderSize)
    topBorder.BackgroundColor3 = rainbowColors[1]
    topBorder.BorderSizePixel = 0
    topBorder.Parent = parent

    local bottomBorder = Instance.new("Frame")
    bottomBorder.Size = UDim2.new(1, borderSize*2, 0, borderSize)
    bottomBorder.Position = UDim2.new(0, -borderSize, 1, 0)
    bottomBorder.BackgroundColor3 = rainbowColors[4]
    bottomBorder.BorderSizePixel = 0
    bottomBorder.Parent = parent

    local leftBorder = Instance.new("Frame")
    leftBorder.Size = UDim2.new(0, borderSize, 1, 0)
    leftBorder.Position = UDim2.new(0, -borderSize, 0, 0)
    leftBorder.BackgroundColor3 = rainbowColors[7]
    leftBorder.BorderSizePixel = 0
    leftBorder.Parent = parent

    local rightBorder = Instance.new("Frame")
    rightBorder.Size = UDim2.new(0, borderSize, 1, 0)
    rightBorder.Position = UDim2.new(1, 0, 0, 0)
    rightBorder.BackgroundColor3 = rainbowColors[3]
    rightBorder.BorderSizePixel = 0
    rightBorder.Parent = parent

    local colorIndex = 1
    task.spawn(function()
        while frame.Visible do
            colorIndex = (colorIndex % #rainbowColors) + 1
            topBorder.BackgroundColor3 = rainbowColors[colorIndex]
            bottomBorder.BackgroundColor3 = rainbowColors[(colorIndex + 3) % #rainbowColors + 1]
            leftBorder.BackgroundColor3 = rainbowColors[(colorIndex + 5) % #rainbowColors + 1]
            rightBorder.BackgroundColor3 = rainbowColors[(colorIndex + 2) % #rainbowColors + 1]
            task.wait(0.1)
        end
    end)
end

createRainbowBorder(frame, 4)

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.Parent = frame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "MOD MENU v2.0"
titleText.TextColor3 = Color3.fromRGB(200, 200, 200)
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- UNDETECTED green text
local undetectedText = Instance.new("TextLabel")
undetectedText.Size = UDim2.new(0.3, 0, 1, 0)
undetectedText.Position = UDim2.new(0.7, -5, 0, 0)
undetectedText.BackgroundTransparency = 1
undetectedText.Text = "UNDETECTED"
undetectedText.TextColor3 = Color3.fromRGB(0, 255, 0)
undetectedText.TextSize = 11
undetectedText.Font = Enum.Font.GothamBold
undetectedText.TextXAlignment = Enum.TextXAlignment.Right
undetectedText.Parent = titleBar

-- Pulsing green effect
task.spawn(function()
    while undetectedText do
        undetectedText.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.wait(0.5)
        undetectedText.TextColor3 = Color3.fromRGB(0, 200, 0)
        task.wait(0.5)
    end
end)

local dragging, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

userInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local categories = {"Player", "Visual", "Combat", "Misc"}
local categoryButtons = {}
local categoryFrame = Instance.new("Frame")
categoryFrame.Size = UDim2.new(1, 0, 0, 35)
categoryFrame.Position = UDim2.new(0, 0, 0, 40)
categoryFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
categoryFrame.BorderSizePixel = 0
categoryFrame.Parent = frame

for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -2, 0.8, 0)
    btn.Position = UDim2.new((i-1) * 0.25, 1, 0.1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = categoryFrame
    categoryButtons[cat] = btn
end

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -75)
contentFrame.Position = UDim2.new(0, 0, 0, 75)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = frame

local function createToggle(parent, name, yPos, defaultState, onCallback, offCallback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
    toggleBtn.Text = defaultState and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = toggleFrame

    local enabled = defaultState
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
        toggleBtn.Text = enabled and "ON" or "OFF"
        if enabled then
            pcall(onCallback)
        else
            pcall(offCallback)
        end
    end)
end

-- Player tab
local playerContent = Instance.new("Frame")
playerContent.Size = UDim2.new(1, 0, 1, 0)
playerContent.BackgroundTransparency = 1
playerContent.Visible = true
playerContent.Parent = contentFrame

local speedConnection
createToggle(playerContent, "Speed Hack", 10, false, 
    function()
        speedConnection = player.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid")
            hum.WalkSpeed = 50
        end)
        if player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = 50 end
        end
    end,
    function()
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        if player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
)

local jumpConnection
createToggle(playerContent, "Jump Power", 55, false,
    function()
        jumpConnection = player.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid")
            hum.JumpPower = 100
        end)
        if player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum then hum.JumpPower = 100 end
        end
    end,
    function()
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
        if player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum then hum.JumpPower = 50 end
        end
    end
)

-- Visual tab
local visualContent = Instance.new("Frame")
visualContent.Size = UDim2.new(1, 0, 1, 0)
visualContent.BackgroundTransparency = 1
visualContent.Visible = false
visualContent.Parent = contentFrame

-- Global variables for ESP control
local espEnabled = false
local roleEspEnabled = false
local gunEspEnabled = false
local selfGunGlowEnabled = false
local glowEnabled = false

-- Function to remove all highlights from a player
local function removeAllHighlights(p)
    if p.Character then
        local highlights = {"ESP_Highlight", "MurderESP", "SheriffESP", "GunGlow"}
        for _, name in ipairs(highlights) do
            local h = p.Character:FindFirstChild(name)
            if h then h:Destroy() end
        end
    end
end

-- Function to remove all highlights from all players
local function removeAllPlayerHighlights()
    for _, p in ipairs(PlayersService:GetPlayers()) do
        if p ~= player then
            removeAllHighlights(p)
        end
    end
end

-- Function to add self gun glow + wallhack (visible only to you, through walls)
local function addSelfGunGlow()
    if player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool and tool.Name:lower() == "gun" then
            local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
            if handle then
                -- Remove old effects if exist
                local oldBillboard = tool:FindFirstChild("SelfGunGlow")
                if oldBillboard then oldBillboard:Destroy() end
                local oldLight = handle:FindFirstChild("SelfGunLight")
                if oldLight then oldLight:Destroy() end
                local oldWallhack = tool:FindFirstChild("SelfGunWallhack")
                if oldWallhack then oldWallhack:Destroy() end

                -- === WALLHACK NAME TAG (shows through walls) ===
                local wallhackBillboard = Instance.new("BillboardGui")
                wallhackBillboard.Name = "SelfGunWallhack"
                wallhackBillboard.Adornee = handle
                wallhackBillboard.Size = UDim2.new(5, 0, 3, 0)
                wallhackBillboard.StudsOffset = Vector3.new(0, 0, 0)
                wallhackBillboard.AlwaysOnTop = true
                wallhackBillboard.MaxDistance = 2000
                wallhackBillboard.Parent = tool

                -- Background frame for the tag
                local tagBg = Instance.new("Frame")
                tagBg.Size = UDim2.new(1, 0, 0.4, 0)
                tagBg.Position = UDim2.new(0, 0, 0.3, 0)
                tagBg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
                tagBg.BackgroundTransparency = 0.3
                tagBg.BorderSizePixel = 0
                tagBg.Parent = wallhackBillboard

                local tagBgCorner = Instance.new("UICorner")
                tagBgCorner.CornerRadius = UDim.new(0.2, 0)
                tagBgCorner.Parent = tagBg

                -- Gun icon (text)
                local gunIcon = Instance.new("TextLabel")
                gunIcon.Size = UDim2.new(0.2, 0, 1, 0)
                gunIcon.Position = UDim2.new(0.02, 0, 0, 0)
                gunIcon.BackgroundTransparency = 1
                gunIcon.Text = "🔫"
                gunIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
                gunIcon.TextSize = 20
                gunIcon.Font = Enum.Font.GothamBold
                gunIcon.Parent = tagBg

                -- Gun name text
                local gunName = Instance.new("TextLabel")
                gunName.Size = UDim2.new(0.5, 0, 1, 0)
                gunName.Position = UDim2.new(0.22, 0, 0, 0)
                gunName.BackgroundTransparency = 1
                gunName.Text = "GUN"
                gunName.TextColor3 = Color3.fromRGB(128, 0, 255)
                gunName.TextSize = 18
                gunName.Font = Enum.Font.GothamBold
                gunName.TextXAlignment = Enum.TextXAlignment.Left
                gunName.Parent = tagBg

                -- Distance text
                local distText = Instance.new("TextLabel")
                distText.Size = UDim2.new(0.26, 0, 1, 0)
                distText.Position = UDim2.new(0.72, 0, 0, 0)
                distText.BackgroundTransparency = 1
                distText.Text = "YOU"
                distText.TextColor3 = Color3.fromRGB(0, 255, 100)
                distText.TextSize = 14
                distText.Font = Enum.Font.GothamBold
                distText.TextXAlignment = Enum.TextXAlignment.Right
                distText.Parent = tagBg

                -- === GLOW EFFECT (pulsing purple) ===
                local glowBillboard = Instance.new("BillboardGui")
                glowBillboard.Name = "SelfGunGlow"
                glowBillboard.Adornee = handle
                glowBillboard.Size = UDim2.new(4, 0, 4, 0)
                glowBillboard.StudsOffset = Vector3.new(0, 0, 0)
                glowBillboard.AlwaysOnTop = true
                glowBillboard.MaxDistance = 1500
                glowBillboard.Parent = tool

                -- Outer glow circle
                local outerGlow = Instance.new("Frame")
                outerGlow.Size = UDim2.new(1, 0, 1, 0)
                outerGlow.Position = UDim2.new(0, 0, 0, 0)
                outerGlow.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
                outerGlow.BackgroundTransparency = 0.7
                outerGlow.BorderSizePixel = 0
                outerGlow.Parent = glowBillboard

                local outerCorner = Instance.new("UICorner")
                outerCorner.CornerRadius = UDim.new(0.5, 0)
                outerCorner.Parent = outerGlow

                -- Inner glow circle (brighter)
                local innerGlow = Instance.new("Frame")
                innerGlow.Size = UDim2.new(0.6, 0, 0.6, 0)
                innerGlow.Position = UDim2.new(0.2, 0, 0.2, 0)
                innerGlow.BackgroundColor3 = Color3.fromRGB(180, 50, 255)
                innerGlow.BackgroundTransparency = 0.5
                innerGlow.BorderSizePixel = 0
                innerGlow.Parent = glowBillboard

                local innerCorner = Instance.new("UICorner")
                innerCorner.CornerRadius = UDim.new(0.5, 0)
                innerCorner.Parent = innerGlow

                -- Point light for actual glow effect
                local light = Instance.new("PointLight")
                light.Name = "SelfGunLight"
                light.Brightness = 15
                light.Range = 30
                light.Color = Color3.fromRGB(128, 0, 255)
                light.Parent = handle

                -- Pulsing animation
                task.spawn(function()
                    local pulseUp = true
                    local transparency = 0.5
                    while glowBillboard and glowBillboard.Parent and selfGunGlowEnabled do
                        if pulseUp then
                            transparency = transparency - 0.02
                            if transparency <= 0.2 then pulseUp = false end
                        else
                            transparency = transparency + 0.02
                            if transparency >= 0.7 then pulseUp = true end
                        end
                        outerGlow.BackgroundTransparency = transparency
                        innerGlow.BackgroundTransparency = transparency - 0.2
                        task.wait(0.05)
                    end
                end)

                -- Update distance text
                task.spawn(function()
                    while wallhackBillboard and wallhackBillboard.Parent and selfGunGlowEnabled do
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local root = player.Character.HumanoidRootPart
                            local dist = (root.Position - handle.Position).Magnitude
                            distText.Text = string.format("%.0f studs", dist)
                        end
                        task.wait(0.2)
                    end
                end)
            end
        end
    end
end

-- Function to remove self gun glow and wallhack
local function removeSelfGunGlow()
    if player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            local billboard = tool:FindFirstChild("SelfGunGlow")
            if billboard then billboard:Destroy() end
            local wallhack = tool:FindFirstChild("SelfGunWallhack")
            if wallhack then wallhack:Destroy() end
            local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
            if handle then
                local light = handle:FindFirstChild("SelfGunLight")
                if light then light:Destroy() end
            end
        end
    end
    -- Also check backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local billboard = tool:FindFirstChild("SelfGunGlow")
                if billboard then billboard:Destroy() end
                local wallhack = tool:FindFirstChild("SelfGunWallhack")
                if wallhack then wallhack:Destroy() end
                local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                if handle then
                    local light = handle:FindFirstChild("SelfGunLight")
                    if light then light:Destroy() end
                end
            end
        end
    end
end

-- ESP toggle (Yellow)
local espConnection
createToggle(visualContent, "ESP", 10, false,
    function()
        espEnabled = true
        for _, p in ipairs(PlayersService:GetPlayers()) do
            if p ~= player and p.Character then
                removeAllHighlights(p)
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.FillColor = Color3.fromRGB(255, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(200, 200, 0)
                highlight.Parent = p.Character
            end
        end
        espConnection = PlayersService.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function(char)
                if espEnabled then
                    removeAllHighlights(newPlayer)
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_Highlight"
                    highlight.FillColor = Color3.fromRGB(255, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(200, 200, 0)
                    highlight.Parent = char
                end
            end)
        end)
    end,
    function()
        espEnabled = false
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        removeAllPlayerHighlights()
    end
)

createToggle(visualContent, "Fullbright", 55, false,
    function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.Brightness = 2
    end,
    function()
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.fromRGB(128, 128, 128)
        lighting.Brightness = 1
    end
)

-- Auto Role ESP (Murder = Red, Sheriff = Blue)
local roleDetectionRunning = false
createToggle(visualContent, "Auto Role ESP", 100, false,
    function()
        roleEspEnabled = true
        roleDetectionRunning = true
        task.spawn(function()
            while roleDetectionRunning do
                task.wait(0.3)
                
                local murderPlayer = nil
                local sheriffPlayer = nil
                
                for _, p in ipairs(PlayersService:GetPlayers()) do
                    if p ~= player then
                        if p.Character then
                            local tool = p.Character:FindFirstChildOfClass("Tool")
                            if tool then
                                local toolName = tool.Name:lower()
                                if toolName == "knife" then
                                    murderPlayer = p
                                elseif toolName == "gun" then
                                    sheriffPlayer = p
                                end
                            end
                        end
                        
                        local backpack = p:FindFirstChild("Backpack")
                        if backpack then
                            local tool = backpack:FindFirstChildOfClass("Tool")
                            if tool then
                                local toolName = tool.Name:lower()
                                if toolName == "knife" then
                                    murderPlayer = p
                                elseif toolName == "gun" then
                                    sheriffPlayer = p
                                end
                            end
                        end
                    end
                end
                
                if roleEspEnabled then
                    for _, p in ipairs(PlayersService:GetPlayers()) do
                        if p ~= player and p.Character then
                            local oldMurder = p.Character:FindFirstChild("MurderESP")
                            local oldSheriff = p.Character:FindFirstChild("SheriffESP")
                            if oldMurder then oldMurder:Destroy() end
                            if oldSheriff then oldSheriff:Destroy() end
                            
                            if p == murderPlayer then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "MurderESP"
                                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                                highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
                                highlight.FillTransparency = 0.3
                                highlight.Parent = p.Character
                            elseif p == sheriffPlayer then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "SheriffESP"
                                highlight.FillColor = Color3.fromRGB(0, 100, 255)
                                highlight.OutlineColor = Color3.fromRGB(0, 50, 200)
                                highlight.FillTransparency = 0.3
                                highlight.Parent = p.Character
                            end
                        end
                    end
                end
            end
        end)
    end,
    function()
        roleEspEnabled = false
        roleDetectionRunning = false
        removeAllPlayerHighlights()
        if espEnabled then
            for _, p in ipairs(PlayersService:GetPlayers()) do
                if p ~= player and p.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_Highlight"
                    highlight.FillColor = Color3.fromRGB(255, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(200, 200, 0)
                    highlight.Parent = p.Character
                end
            end
        end
    end
)

-- Gun ESP + Glow (purple, visible through walls) for OTHER players
local gunDetectionRunning = false
createToggle(visualContent, "Gun ESP + Glow", 145, false,
    function()
        gunEspEnabled = true
        glowEnabled = true
        gunDetectionRunning = true
        
        task.spawn(function()
            while gunDetectionRunning do
                task.wait(0.2)
                
                for _, p in ipairs(PlayersService:GetPlayers()) do
                    if p ~= player then
                        local gunTool = nil
                        local gunLocation = nil
                        
                        -- Check character tools
                        if p.Character then
                            local tool = p.Character:FindFirstChildOfClass("Tool")
                            if tool and tool.Name:lower() == "gun" then
                                gunTool = tool
                                gunLocation = "character"
                            end
                        end
                        
                        -- Check backpack
                        if not gunTool then
                            local backpack = p:FindFirstChild("Backpack")
                            if backpack then
                                local bpTool = backpack:FindFirstChildOfClass("Tool")
                                if bpTool and bpTool.Name:lower() == "gun" then
                                    gunTool = bpTool
                                    gunLocation = "backpack"
                                end
                            end
                        end
                        
                        -- Check for dropped gun on the ground
                        if not gunTool then
                            for _, obj in ipairs(workspace:GetChildren()) do
                                if obj:IsA("Tool") and obj.Name:lower() == "gun" then
                                    local parent = obj.Parent
                                    if parent ~= p.Character and parent ~= p:FindFirstChild("Backpack") then
                                        gunTool = obj
                                        gunLocation = "ground"
                                        break
                                    end
                                end
                            end
                        end
                        
                        if gunTool and gunEspEnabled then
                            local handle = gunTool:FindFirstChild("Handle") or gunTool:FindFirstChildWhichIsA("BasePart")
                            if handle then
                                local wallhackName = "GunWallhack_" .. p.Name
                                local existingWallhack = gunTool:FindFirstChild(wallhackName)
                                
                                if not existingWallhack then
                                    -- BillboardGui for wallhack
                                    local wallhackBillboard = Instance.new("BillboardGui")
                                    wallhackBillboard.Name = wallhackName
                                    wallhackBillboard.Adornee = handle
                                    wallhackBillboard.Size = UDim2.new(4, 0, 4, 0)
                                    wallhackBillboard.StudsOffset = Vector3.new(0, 0, 0)
                                    wallhackBillboard.AlwaysOnTop = true
                                    wallhackBillboard.MaxDistance = 1000
                                    wallhackBillboard.Parent = gunTool
                                    
                                    -- Gun barrel
                                    local barrel = Instance.new("Frame")
                                    barrel.Size = UDim2.new(1.5, 0, 0.3, 0)
                                    barrel.Position = UDim2.new(0, 0, 0.35, 0)
                                    barrel.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
                                    barrel.BackgroundTransparency = 0.1
                                    barrel.BorderSizePixel = 0
                                    barrel.Parent = wallhackBillboard
                                    
                                    -- Gun grip
                                    local grip = Instance.new("Frame")
                                    grip.Size = UDim2.new(0.4, 0, 0.6, 0)
                                    grip.Position = UDim2.new(-0.2, 0, 0.4, 0)
                                    grip.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
                                    grip.BackgroundTransparency = 0.1
                                    grip.BorderSizePixel = 0
                                    grip.Parent = wallhackBillboard
                                    
                                    local barrelCorner = Instance.new("UICorner")
                                    barrelCorner.CornerRadius = UDim.new(0.2, 0)
                                    barrelCorner.Parent = barrel
                                    
                                    local gripCorner = Instance.new("UICorner")
                                    gripCorner.CornerRadius = UDim.new(0.2, 0)
                                    gripCorner.Parent = grip
                                    
                                    -- Glow effect (existing)
                                    local glowBillboard = Instance.new("BillboardGui")
                                    glowBillboard.Name = "GunGlow"
                                    glowBillboard.Adornee = handle
                                    glowBillboard.Size = UDim2.new(2, 0, 2, 0)
                                    glowBillboard.StudsOffset = Vector3.new(0, 0, 0)
                                    glowBillboard.AlwaysOnTop = true
                                    glowBillboard.MaxDistance = 500
                                    glowBillboard.Parent = gunTool
                                    
                                    local glowFrame = Instance.new("Frame")
                                    glowFrame.Size = UDim2.new(1, 0, 1, 0)
                                    glowFrame.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
                                    glowFrame.BackgroundTransparency = 0.4
                                    glowFrame.BorderSizePixel = 0
                                    glowFrame.Parent = glowBillboard
                                    
                                    local glowCorner = Instance.new("UICorner")
                                    glowCorner.CornerRadius = UDim.new(0.5, 0)
                                    glowCorner.Parent = glowFrame
                                    
                                    local light = Instance.new("PointLight")
                                    light.Name = "GunLight"
                                    light.Brightness = 8
                                    light.Range = 15
                                    light.Color = Color3.fromRGB(128, 0, 255)
                                    light.Parent = handle
                                    
                                    task.spawn(function()
                                        local pulseUp = true
                                        while glowBillboard and glowBillboard.Parent and gunEspEnabled do
                                            if pulseUp then
                                                glowFrame.BackgroundTransparency = glowFrame.BackgroundTransparency - 0.02
                                                if glowFrame.BackgroundTransparency <= 0.1 then pulseUp = false end
                                            else
                                                glowFrame.BackgroundTransparency = glowFrame.BackgroundTransparency + 0.02
                                                if glowFrame.BackgroundTransparency >= 0.6 then pulseUp = true end
                                            end
                                            task.wait(0.05)
                                        end
                                    end)
                                end
                            end
                        else
                            -- Clean up
                            if p.Character then
                                local charTool = p.Character:FindFirstChildOfClass("Tool")
                                if charTool then
                                    for _, child in ipairs(charTool:GetChildren()) do
                                        if child.Name:find("GunWallhack_") or child.Name == "GunGlow" then
                                            child:Destroy()
                                        end
                                    end
                                    local handle = charTool:FindFirstChild("Handle") or charTool:FindFirstChildWhichIsA("BasePart")
                                    if handle then
                                        local l = handle:FindFirstChild("GunLight")
                                        if l then l:Destroy() end
                                    end
                                end
                            end
                            local backpack = p:FindFirstChild("Backpack")
                            if backpack then
                                local bpTool = backpack:FindFirstChildOfClass("Tool")
                                if bpTool then
                                    for _, child in ipairs(bpTool:GetChildren()) do
                                        if child.Name:find("GunWallhack_") or child.Name == "GunGlow" then
                                            child:Destroy()
                                        end
                                    end
                                    local handle = bpTool:FindFirstChild("Handle") or bpTool:FindFirstChildWhichIsA("BasePart")
                                    if handle then
                                        local l = handle:FindFirstChild("GunLight")
                                        if l then l:Destroy() end
                                    end
                                end
                            end
                            for _, obj in ipairs(workspace:GetChildren()) do
                                if obj:IsA("Tool") and obj.Name:lower() == "gun" then
                                    for _, child in ipairs(obj:GetChildren()) do
                                        if child.Name:find("GunWallhack_") or child.Name == "GunGlow" then
                                            child:Destroy()
                                        end
                                    end
                                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                                    if handle then
                                        local l = handle:FindFirstChild("GunLight")
                                        if l then l:Destroy() end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end,
    function()
        gunEspEnabled = false
        glowEnabled = false
        gunDetectionRunning = false
        
        for _, p in ipairs(PlayersService:GetPlayers()) do
            if p ~= player then
                if p.Character then
                    local tool = p.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        for _, child in ipairs(tool:GetChildren()) do
                            if child.Name:find("GunWallhack_") or child.Name == "GunGlow" then
                                child:Destroy()
                            end
                        end
                        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            local l = handle:FindFirstChild("GunLight")
                            if l then l:Destroy() end
                        end
                    end
                end
                local backpack = p:FindFirstChild("Backpack")
                if backpack then
                    local bpTool = backpack:FindFirstChildOfClass("Tool")
                    if bpTool then
                        for _, child in ipairs(bpTool:GetChildren()) do
                            if child.Name:find("GunWallhack_") or child.Name == "GunGlow" then
                                child:Destroy()
                            end
                        end
                        local handle = bpTool:FindFirstChild("Handle") or bpTool:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            local l = handle:FindFirstChild("GunLight")
                            if l then l:Destroy() end
                        end
                    end
                end
            end
        end
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Tool") and obj.Name:lower() == "gun" then
                for _, child in ipairs(obj:GetChildren()) do
                    if child.Name:find("GunWallhack_") or child.Name == "GunGlow" then
                        child:Destroy()
                    end
                end
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    local l = handle:FindFirstChild("GunLight")
                    if l then l:Destroy() end
                end
            end
        end
    end
)

-- SELF GUN GLOW + WALLHACK (visible only to you, through walls)
local selfGlowDetectionRunning = false
createToggle(visualContent, "Self Gun Glow + Wallhack", 190, false,
    function()
        selfGunGlowEnabled = true
        selfGlowDetectionRunning = true
        
        -- Add glow + wallhack immediately if you have a gun
        addSelfGunGlow()
        
        -- Monitor for gun changes
        task.spawn(function()
            while selfGlowDetectionRunning do
                task.wait(0.2)
                if selfGunGlowEnabled then
                    -- Check if we need to reapply
                    local hasGlow = false
                    if player.Character then
                        local tool = player.Character:FindFirstChildOfClass("Tool")
                        if tool and tool.Name:lower() == "gun" then
                            if tool:FindFirstChild("SelfGunGlow") and tool:FindFirstChild("SelfGunWallhack") then
                                hasGlow = true
                            else
                                addSelfGunGlow()
                                hasGlow = true
                            end
                        end
                    end
                end
            end
        end)
        
        -- Listen for tool equip
        player.CharacterAdded:Connect(function(char)
            if selfGunGlowEnabled then
                task.wait(0.5)
                addSelfGunGlow()
            end
        end)
    end,
    function()
        selfGunGlowEnabled = false
        selfGlowDetectionRunning = false
        removeSelfGunGlow()
    end
)

-- Combat tab
local combatContent = Instance.new("Frame")
combatContent.Size = UDim2.new(1, 0, 1, 0)
combatContent.BackgroundTransparency = 1
combatContent.Visible = false
combatContent.Parent = contentFrame

-- AIMBOT VARIABLES
local aimbotEnabled = false
local aimbotFov = 90 -- Default FOV in degrees
local aimbotFovCircle = nil
local aimbotConnection = nil
local aimbotFovConnection = nil

-- Create FOV circle (visible on screen)
local function createFovCircle()
    if aimbotFovCircle then
        aimbotFovCircle:Destroy()
    end
    
    aimbotFovCircle = Instance.new("ScreenGui")
    aimbotFovCircle.Name = "AimbotFovCircle"
    aimbotFovCircle.Parent = player:WaitForChild("PlayerGui")
    aimbotFovCircle.ResetOnSpawn = false
    
    local circle = Instance.new("ImageLabel")
    circle.Name = "Circle"
    circle.Size = UDim2.new(0, aimbotFov * 2, 0, aimbotFov * 2)
    circle.Position = UDim2.new(0.5, -aimbotFov, 0.5, -aimbotFov)
    circle.BackgroundTransparency = 1
    circle.Image = "rbxassetid://266543131" -- Circle image
    circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
    circle.ImageTransparency = 0.6
    circle.Parent = aimbotFovCircle
    
    return circle
end

-- Get the closest target within FOV
local function getClosestTarget()
    local closestTarget = nil
    local closestDistance = aimbotFov
    
    local camera = workspace.CurrentCamera
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    for _, p in ipairs(PlayersService:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = p.Character.HumanoidRootPart
            local head = p.Character:FindFirstChild("Head")
            local targetPart = head or rootPart
            
            -- Check if target is visible
            local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
            
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                
                if distance < closestDistance then
                    -- Check line of sight
                    local ray = Ray.new(camera.CFrame.Position, (targetPart.Position - camera.CFrame.Position).Unit * 1000)
                    local hit, hitPos = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
                    
                    if hit and hit:IsDescendantOf(p.Character) then
                        closestTarget = p
                        closestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestTarget
end

-- Aimbot main loop
local function startAimbot()
    aimbotConnection = runService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPart = target.Character:FindFirstChild("Head") or target.Character.HumanoidRootPart
            local camera = workspace.CurrentCamera
            
            -- Calculate the direction to the target
            local direction = (targetPart.Position - camera.CFrame.Position).Unit
            
            -- Smoothly rotate the camera towards the target
            local newCFrame = CFrame.lookAt(camera.CFrame.Position, targetPart.Position)
            camera.CFrame = camera.CFrame:Lerp(newCFrame, 0.5)
        end
    end)
end

-- FOV Slider
local function createFovSlider(parent, yPos)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    sliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 0.5, 0)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = "FOV: " .. aimbotFov
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.5, 0, 0, 6)
    sliderBg.Position = UDim2.new(0.4, 0, 0.7, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderFrame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(aimbotFov / 180, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new(aimbotFov / 180, -10, 0.5, -10)
    sliderButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sliderButton.Text = ""
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderFrame
    
    local dragging = false
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    userInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    userInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = userInputService:GetMouseLocation()
            local sliderPos = sliderBg.AbsolutePosition
            local sliderSize = sliderBg.AbsoluteSize.X
            
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize, 0, 1)
            aimbotFov = math.floor(relativeX * 180)
            aimbotFov = math.clamp(aimbotFov, 10, 180)
            
            label.Text = "FOV: " .. aimbotFov
            sliderFill.Size = UDim2.new(aimbotFov / 180, 0, 1, 0)
            sliderButton.Position = UDim2.new(aimbotFov / 180, -10, 0.5, -10)
            
            -- Update FOV circle
            if aimbotFovCircle then
                local circle = aimbotFovCircle:FindFirstChild("Circle")
                if circle then
                    circle.Size = UDim2.new(0, aimbotFov * 2, 0, aimbotFov * 2)
                    circle.Position = UDim2.new(0.5, -aimbotFov, 0.5, -aimbotFov)
                end
            end
        end
    end)
end

-- Aimbot toggle
createToggle(combatContent, "Aimbot", 10, false,
    function()
        aimbotEnabled = true
        
        -- Create FOV circle
        createFovCircle()
        
        -- Start aimbot
        startAimbot()
    end,
    function()
        aimbotEnabled = false
        
        -- Remove FOV circle
        if aimbotFovCircle then
            aimbotFovCircle:Destroy()
            aimbotFovCircle = nil
        end
        
        -- Stop aimbot
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
)

-- FOV slider
createFovSlider(combatContent, 55)

-- Misc tab
local miscContent = Instance.new("Frame")
miscContent.Size = UDim2.new(1, 0, 1, 0)
miscContent.BackgroundTransparency = 1
miscContent.Visible = false
miscContent.Parent = contentFrame

-- Category switching
local function switchCategory(cat)
    playerContent.Visible = (cat == "Player")
    visualContent.Visible = (cat == "Visual")
    combatContent.Visible = (cat == "Combat")
    miscContent.Visible = (cat == "Misc")
    
    for name, btn in pairs(categoryButtons) do
        btn.BackgroundColor3 = (name == cat) and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 55)
        btn.TextColor3 = (name == cat) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    end
end

for name, btn in pairs(categoryButtons) do
    btn.MouseButton1Click:Connect(function()
        switchCategory(name)
    end)
end

switchCategory("Player")

-- Toggle menu with Insert key
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)
