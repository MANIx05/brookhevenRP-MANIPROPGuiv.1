-- Client-Side Avatar Spawner GUI — ULTRA
-- Features: Minimize, D-pad, Follow, Emotes (Sit/Hug/Dance/etc),
--           Tasks, Fake Message Scheduler, Teleport.
-- PC + Mobile executors.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- CONFIG
-- ============================================================
local CONFIG = {
    DefaultSpawnPosition = Vector3.new(0, 5, 0),
    DummyName = "ClientAvatarDummy",
    MoveStep = 3,
    FollowDistance = 5,
    FollowWalkSpeed = 18,
}

-- R15 default animations
local A_WALK  = "rbxassetid://507767714"
local A_IDLE  = "rbxassetid://507766666"

-- Emote animation IDs
local EMOTES = {
    Wave   = "rbxassetid://507770239",
    Point  = "rbxassetid://507770453",
    Dance  = "rbxassetid://507771019",
    Laugh  = "rbxassetid://507770818",
    Cheer  = "rbxassetid://507770677",
    Hug    = "rbxassetid://3344526316",  -- custom, may fall back
    Sit    = "rbxassetid://2506281703",  -- legacy sit
}

-- ============================================================
-- STATE (forward declared)
-- ============================================================
local currentDummy   = nil
local walkTrack      = nil
local idleTrack      = nil
local currentEmote   = nil
local followEnabled  = false
local wanderActive   = false
local currentMessage = nil

-- GUI element refs (assigned later)
local statusLabel, followButton

-- ============================================================
-- HELPERS
-- ============================================================
local function setStatus(text, color)
    if statusLabel then
        statusLabel.Text = text
        statusLabel.TextColor3 = color or Color3.fromRGB(160, 160, 175)
    end
end

local function getDummyParts()
    if not currentDummy or not currentDummy.Parent then return nil end
    local humanoid = currentDummy:FindFirstChildOfClass("Humanoid")
    local hrp = currentDummy:FindFirstChild("HumanoidRootPart")
    return humanoid, hrp
end

local function stopLocomotion()
    if walkTrack and walkTrack.IsPlaying then walkTrack:Stop(0.15) end
    if idleTrack and idleTrack.IsPlaying then idleTrack:Stop(0.15) end
end

local function stopEmote()
    if currentEmote then
        pcall(function() currentEmote:Stop(0.15) end)
        currentEmote = nil
    end
end

local function playEmote(animId, loop)
    local humanoid = getDummyParts()
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    stopEmote()
    stopLocomotion()

    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
    if not ok or not track then
        setStatus("Emote failed to load.", Color3.fromRGB(220, 120, 80))
        return
    end
    track.Looped = (loop ~= false)
    track.Priority = Enum.AnimationPriority.Action
    track:Play(0.15)
    currentEmote = track
end

local function stopFollow()
    followEnabled = false
    if followButton then
        followButton.Text = "Follow: OFF"
        followButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
    stopLocomotion()
end

local function stopWander()
    wanderActive = false
end

local function removeDummy()
    stopFollow()
    stopWander()
    stopEmote()
    walkTrack = nil
    idleTrack = nil
    if currentDummy and currentDummy.Parent then
        currentDummy:Destroy()
    end
    currentDummy = nil
end

local function setupAnimations(model)
    walkTrack, idleTrack = nil, nil
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    local wa = Instance.new("Animation"); wa.AnimationId = A_WALK
    walkTrack = animator:LoadAnimation(wa)
    walkTrack.Looped = true
    walkTrack.Priority = Enum.AnimationPriority.Movement

    local ia = Instance.new("Animation"); ia.AnimationId = A_IDLE
    idleTrack = animator:LoadAnimation(ia)
    idleTrack.Looped = true
    idleTrack.Priority = Enum.AnimationPriority.Idle
end

local function showMessage(text, duration)
    if not currentDummy or not currentDummy.Parent then return end
    local head = currentDummy:FindFirstChild("Head") or currentDummy:FindFirstChild("HumanoidRootPart")
    if not head then return end

    if currentMessage then currentMessage:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "DummyMessage"
    bb.Size = UDim2.new(0, 200, 0, 60)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 200
    bb.Parent = head

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -8, 1, -8)
    lbl.Position = UDim2.new(0, 4, 0, 4)
    lbl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    lbl.BackgroundTransparency = 0.1
    lbl.TextColor3 = Color3.fromRGB(25, 25, 25)
    lbl.Text = text
    lbl.TextSize = 14
    lbl.Font = Enum.Font.GothamBold
    lbl.TextWrapped = true
    lbl.Parent = bb
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", lbl)
    stroke.Color = Color3.fromRGB(80, 80, 100)

    currentMessage = bb
    task.delay(duration or 5, function()
        if bb and bb.Parent then
            bb:Destroy()
        end
        if currentMessage == bb then currentMessage = nil end
    end)
end

local function moveDummy(direction)
    local _, hrp = getDummyParts()
    if not hrp then
        setStatus("No dummy spawned.", Color3.fromRGB(220, 120, 80))
        return
    end
    local cam = workspace.CurrentCamera
    local look = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
    local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
    if look.Magnitude > 0 then look = look.Unit end
    if right.Magnitude > 0 then right = right.Unit end

    local step = CONFIG.MoveStep
    local offset
    if direction == "forward" then offset = look * step
    elseif direction == "back" then offset = look * -step
    elseif direction == "left" then offset = right * -step
    elseif direction == "right" then offset = right * step end
    if offset then hrp.CFrame = hrp.CFrame + offset end
end

local function spawnAvatar(username)
    username = (username or ""):match("^%s*(.-)%s*$")
    if username == "" then
        setStatus("Please enter a username.", Color3.fromRGB(220, 80, 80))
        return
    end
    setStatus("Looking up user...", Color3.fromRGB(220, 200, 100))
    local ok, userId = pcall(function() return Players:GetUserIdFromNameAsync(username) end)
    if not ok or not userId then
        setStatus("User not found: " .. username, Color3.fromRGB(220, 80, 80))
        return
    end
    setStatus("Creating avatar...", Color3.fromRGB(220, 200, 100))
    local ok2, model = pcall(function() return Players:CreateHumanoidModelFromUserId(userId) end)
    if not ok2 or not model then
        setStatus("Failed to create avatar.", Color3.fromRGB(220, 80, 80))
        return
    end

    model.Name = CONFIG.DummyName
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
        humanoid.WalkSpeed = CONFIG.FollowWalkSpeed
    end
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.Anchored = true end

    local spawnPos = CONFIG.DefaultSpawnPosition
    local character = LocalPlayer.Character
    if character then
        local myHrp = character:FindFirstChild("HumanoidRootPart")
        if myHrp then
            spawnPos = myHrp.Position + myHrp.CFrame.LookVector * 8 + Vector3.new(0, 3, 0)
        end
    end
    model:PivotTo(CFrame.new(spawnPos))

    removeDummy()
    model.Parent = workspace
    currentDummy = model
    setupAnimations(model)
    setStatus("Spawned: " .. username, Color3.fromRGB(80, 200, 120))
end

local function hugMe()
    local humanoid, dummyHrp = getDummyParts()
    local character = LocalPlayer.Character
    if not humanoid or not dummyHrp or not character then
        setStatus("No dummy or player.", Color3.fromRGB(220, 120, 80))
        return
    end
    local myHrp = character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end

    stopFollow()
    stopWander()
    stopEmote()
    stopLocomotion()
    if dummyHrp.Anchored then dummyHrp.Anchored = false end
    if humanoid.PlatformStand then humanoid.PlatformStand = false end

    setStatus("Walking to you...", Color3.fromRGB(240, 180, 220))
    task.spawn(function()
        local t0 = tick()
        while tick() - t0 < 8 do
            if not currentDummy or not currentDummy.Parent then return end
            local dist = (myHrp.Position - dummyHrp.Position).Magnitude
            if dist < 4 then break end
            humanoid:MoveTo(myHrp.Position)
            task.wait(0.15)
        end
        if not currentDummy or not currentDummy.Parent then return end
        humanoid:MoveTo(dummyHrp.Position)
        task.wait(0.15)
        local look = myHrp.Position - dummyHrp.Position
        look = Vector3.new(look.X, 0, look.Z)
        if look.Magnitude > 0.1 then
            dummyHrp.CFrame = CFrame.new(dummyHrp.Position, dummyHrp.Position + look.Unit)
        end
        playEmote(EMOTES.Hug, true)
        setStatus("Hugging you!", Color3.fromRGB(240, 120, 180))
    end)
end

local function walkToMe()
    local humanoid, dummyHrp = getDummyParts()
    local character = LocalPlayer.Character
    if not humanoid or not dummyHrp or not character then return end
    local myHrp = character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    stopFollow(); stopWander(); stopEmote()
    if dummyHrp.Anchored then dummyHrp.Anchored = false end
    if humanoid.PlatformStand then humanoid.PlatformStand = false end
    humanoid:MoveTo(myHrp.Position)
    setStatus("Walking to you...", Color3.fromRGB(120, 220, 160))
end

local function jumpDummy()
    local humanoid = getDummyParts()
    if humanoid then
        humanoid.Jump = true
        setStatus("Jump!", Color3.fromRGB(120, 220, 160))
    end
end

local function freezeDummy()
    local humanoid, hrp = getDummyParts()
    if humanoid and hrp then
        humanoid:MoveTo(hrp.Position)
        stopFollow(); stopWander(); stopEmote(); stopLocomotion()
        setStatus("Frozen.", Color3.fromRGB(160, 200, 240))
    end
end

local function startWander()
    local humanoid, hrp = getDummyParts()
    if not humanoid or not hrp then return end
    stopFollow(); stopEmote()
    if hrp.Anchored then hrp.Anchored = false end
    if humanoid.PlatformStand then humanoid.PlatformStand = false end
    wanderActive = true
    setStatus("Wandering...", Color3.fromRGB(180, 200, 120))
    task.spawn(function()
        while wanderActive and currentDummy and currentDummy.Parent do
            local pos = hrp.Position
            local target = pos + Vector3.new(math.random(-15, 15), 0, math.random(-15, 15))
            humanoid:MoveTo(target)
            task.wait(2 + math.random() * 2)
        end
    end)
end

-- ============================================================
-- GUI
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AvatarSpawnerGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 500)
mainFrame.Position = UDim2.new(0.5, -150, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- Minimized restore button
local restoreBtn = Instance.new("TextButton")
restoreBtn.Size = UDim2.new(0, 54, 0, 54)
restoreBtn.Position = UDim2.new(0, 20, 0.5, -27)
restoreBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
restoreBtn.Text = "👤"
restoreBtn.TextSize = 26
restoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
restoreBtn.Font = Enum.Font.GothamBold
restoreBtn.Visible = false
restoreBtn.Active = true
restoreBtn.Draggable = true
restoreBtn.Parent = screenGui
Instance.new("UICorner", restoreBtn).CornerRadius = UDim.new(1, 0)
local rstroke = Instance.new("UIStroke", restoreBtn)
rstroke.Color = Color3.fromRGB(255, 255, 255)
rstroke.Thickness = 2

-- TITLE BAR
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 34)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Avatar Spawner — Ultra"
titleLabel.TextColor3 = Color3.fromRGB(225, 225, 235)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 28, 0, 28)
minButton.Position = UDim2.new(1, -64, 0, 3)
minButton.BackgroundColor3 = Color3.fromRGB(60, 60, 78)
minButton.Text = "—"
minButton.TextColor3 = Color3.fromRGB(230, 230, 240)
minButton.TextSize = 16
minButton.Font = Enum.Font.GothamBold
minButton.Parent = titleBar
Instance.new("UICorner", minButton).CornerRadius = UDim.new(0, 6)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -32, 0, 3)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 55, 55)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 230, 230)
closeButton.TextSize = 15
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

-- SCROLL CONTENT
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -8, 1, -42)
scroll.Position = UDim2.new(0, 4, 0, 38)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 120)
scroll.CanvasSize = UDim2.new(0, 0, 0, 620)
scroll.Parent = mainFrame

local function mkLabel(parent, y, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -8, 0, 14)
    l.Position = UDim2.new(0, 4, 0, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(180, 180, 195)
    l.TextSize = 11
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function mkButton(parent, x, y, w, h, text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, w, 0, h)
    b.Position = UDim2.new(0, x, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(55, 55, 72)
    b.TextColor3 = Color3.fromRGB(230, 230, 245)
    b.Text = text
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local function mkTextBox(parent, x, y, w, h, placeholder)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(0, w, 0, h)
    t.Position = UDim2.new(0, x, 0, y)
    t.BackgroundColor3 = Color3.fromRGB(50, 50, 62)
    t.TextColor3 = Color3.fromRGB(240, 240, 250)
    t.PlaceholderText = placeholder or ""
    t.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    t.Text = ""
    t.TextSize = 12
    t.Font = Enum.Font.Gotham
    t.ClearTextOnFocus = false
    t.Parent = parent
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
    local p = Instance.new("UIPadding", t)
    p.PaddingLeft = UDim.new(0, 8); p.PaddingRight = UDim.new(0, 8)
    return t
end

-- Username
mkLabel(scroll, 4, "Roblox Username:")
local usernameBox = mkTextBox(scroll, 4, 20, 280, 30, "e.g. Builderman")

-- Spawn / Delete
local spawnButton = mkButton(scroll, 4, 54, 190, 30, "Spawn Avatar", Color3.fromRGB(60, 120, 220))
local deleteButton = mkButton(scroll, 200, 54, 84, 30, "Delete", Color3.fromRGB(150, 50, 50))

-- Follow / Teleport
followButton = mkButton(scroll, 4, 88, 138, 28, "Follow: OFF", Color3.fromRGB(60, 60, 80))
local teleportButton = mkButton(scroll, 148, 88, 136, 28, "Teleport to Me", Color3.fromRGB(80, 80, 130))

-- Adjust label
mkLabel(scroll, 122, "Adjust Position (3 studs/click):")

-- D-PAD
local dpadFrame = Instance.new("Frame")
dpadFrame.Size = UDim2.new(0, 100, 0, 100)
dpadFrame.Position = UDim2.new(0, 90, 0, 140)
dpadFrame.BackgroundTransparency = 1
dpadFrame.Parent = scroll

local function dpadBtn(x, y, txt, cb)
    local b = mkButton(dpadFrame, x, y, 32, 32, txt, Color3.fromRGB(55, 55, 72))
    b.TextSize = 16
    b.MouseButton1Click:Connect(cb)
    return b
end

dpadBtn(34, 0,  "↑", function() moveDummy("forward") end)
dpadBtn(34, 68, "↓", function() moveDummy("back")    end)
dpadBtn(0,  34, "←", function() moveDummy("left")    end)
dpadBtn(68, 34, "→", function() moveDummy("right")   end)

local cDot = Instance.new("Frame")
cDot.Size = UDim2.new(0, 12, 0, 12)
cDot.Position = UDim2.new(0, 44, 0, 44)
cDot.BackgroundColor3 = Color3.fromRGB(90, 90, 130)
cDot.BorderSizePixel = 0
cDot.Parent = dpadFrame
Instance.new("UICorner", cDot).CornerRadius = UDim.new(1, 0)

-- Height row
local yUpButton = mkButton(scroll, 4, 244, 138, 26, "▲ Height +", Color3.fromRGB(55, 90, 70))
local yDownButton = mkButton(scroll, 148, 244, 136, 26, "▼ Height −", Color3.fromRGB(90, 55, 55))

-- Animations label
mkLabel(scroll, 276, "Animations / Emotes:")

-- Emote buttons (2 rows of 4)
local eY1, eY2 = 292, 326
local eW, eGap = 68, 4
local eXs = {4, 76, 148, 220}

local btnWave  = mkButton(scroll, eXs[1], eY1, eW, 30, "Wave",  Color3.fromRGB(70, 90, 130))
local btnPoint = mkButton(scroll, eXs[2], eY1, eW, 30, "Point", Color3.fromRGB(70, 90, 130))
local btnDance = mkButton(scroll, eXs[3], eY1, eW, 30, "Dance", Color3.fromRGB(70, 90, 130))
local btnLaugh = mkButton(scroll, eXs[4], eY1, eW, 30, "Laugh", Color3.fromRGB(70, 90, 130))

local btnCheer = mkButton(scroll, eXs[1], eY2, eW, 30, "Cheer", Color3.fromRGB(100, 80, 130))
local btnHug   = mkButton(scroll, eXs[2], eY2, eW, 30, "Hug Me", Color3.fromRGB(180, 80, 150))
local btnSit   = mkButton(scroll, eXs[3], eY2, eW, 30, "Sit", Color3.fromRGB(80, 110, 80))
local btnStopEmote = mkButton(scroll, eXs[4], eY2, eW, 30, "Stop", Color3.fromRGB(120, 60, 60))

-- Tasks label
mkLabel(scroll, 362, "Tasks:")

local btnWalkToMe = mkButton(scroll, eXs[1], 378, eW, 30, "Walk to Me", Color3.fromRGB(60, 110, 160))
local btnJump     = mkButton(scroll, eXs[2], 378, eW, 30, "Jump",       Color3.fromRGB(60, 110, 160))
local btnWander   = mkButton(scroll, eXs[3], 378, eW, 30, "Wander",     Color3.fromRGB(60, 110, 160))
local btnFreeze   = mkButton(scroll, eXs[4], 378, eW, 30, "Freeze",     Color3.fromRGB(120, 90, 60))

-- Message label
mkLabel(scroll, 414, "Fake Message (dummy says it):")
local messageBox = mkTextBox(scroll, 4, 430, 280, 30, "Type message dummy will say...")

-- Delay + Send/Schedule
local delayBox = mkTextBox(scroll, 4, 466, 90, 30, "Delay (s)")
local sendNowBtn  = mkButton(scroll, 98, 466, 90, 30, "Send Now", Color3.fromRGB(80, 130, 80))
local scheduleBtn = mkButton(scroll, 192, 466, 92, 30, "Schedule", Color3.fromRGB(130, 100, 60))

-- Status
statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 280, 0, 40)
statusLabel.Position = UDim2.new(0, 4, 0, 504)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextWrapped = true
statusLabel.Parent = scroll

scroll.CanvasSize = UDim2.new(0, 0, 0, 552)

-- ============================================================
-- MINIMIZE / RESTORE
-- ============================================================
minButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    restoreBtn.Visible = true
end)

restoreBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    restoreBtn.Visible = false
end)

-- ============================================================
-- EVENT BINDINGS
-- ============================================================
spawnButton.MouseButton1Click:Connect(function()
    spawnAvatar(usernameBox.Text)
end)
usernameBox.FocusLost:Connect(function(enter) if enter then spawnAvatar(usernameBox.Text) end end)

deleteButton.MouseButton1Click:Connect(function()
    removeDummy()
    setStatus("Dummy deleted.", Color3.fromRGB(160, 160, 175))
end)

followButton.MouseButton1Click:Connect(function()
    if not currentDummy or not currentDummy.Parent then
        setStatus("Spawn a dummy first.", Color3.fromRGB(220, 120, 80)); return
    end
    followEnabled = not followEnabled
    if followEnabled then
        stopWander(); stopEmote()
        followButton.Text = "Follow: ON"
        followButton.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
        local humanoid, hrp = getDummyParts()
        if hrp then hrp.Anchored = false end
        if humanoid then humanoid.PlatformStand = false end
        setStatus("Following you...", Color3.fromRGB(120, 220, 160))
    else
        stopFollow()
        setStatus("Follow disabled.", Color3.fromRGB(160, 160, 175))
    end
end)

teleportButton.MouseButton1Click:Connect(function()
    local _, hrp = getDummyParts()
    local character = LocalPlayer.Character
    if not hrp or not character then
        setStatus("No dummy spawned.", Color3.fromRGB(220, 120, 80)); return
    end
    local myHrp = character:FindFirstChild("HumanoidRootPart")
    if myHrp then
        hrp.CFrame = CFrame.new(myHrp.Position + myHrp.CFrame.LookVector * 6 + Vector3.new(0, 3, 0))
        setStatus("Teleported to you.", Color3.fromRGB(80, 200, 120))
    end
end)

yUpButton.MouseButton1Click:Connect(function()
    local _, hrp = getDummyParts()
    if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, CONFIG.MoveStep, 0) end
end)
yDownButton.MouseButton1Click:Connect(function()
    local _, hrp = getDummyParts()
    if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, -CONFIG.MoveStep, 0) end
end)

-- Emote buttons
btnWave.MouseButton1Click:Connect(function() stopFollow(); stopWander(); playEmote(EMOTES.Wave, true); setStatus("Waving", Color3.fromRGB(180,220,255)) end)
btnPoint.MouseButton1Click:Connect(function() stopFollow(); stopWander(); playEmote(EMOTES.Point, true); setStatus("Pointing", Color3.fromRGB(180,220,255)) end)
btnDance.MouseButton1Click:Connect(function() stopFollow(); stopWander(); playEmote(EMOTES.Dance, true); setStatus("Dancing", Color3.fromRGB(180,220,255)) end)
btnLaugh.MouseButton1Click:Connect(function() stopFollow(); stopWander(); playEmote(EMOTES.Laugh, true); setStatus("Laughing", Color3.fromRGB(180,220,255)) end)
btnCheer.MouseButton1Click:Connect(function() stopFollow(); stopWander(); playEmote(EMOTES.Cheer, true); setStatus("Cheering", Color3.fromRGB(180,220,255)) end)
btnHug.MouseButton1Click:Connect(hugMe)
btnSit.MouseButton1Click:Connect(function()
    local humanoid = getDummyParts()
    if not humanoid then return end
    stopFollow(); stopWander()
    humanoid.Sit = true
    playEmote(EMOTES.Sit, true)
    setStatus("Sitting", Color3.fromRGB(180,240,200))
end)
btnStopEmote.MouseButton1Click:Connect(function()
    local humanoid = getDummyParts()
    stopEmote(); stopLocomotion(); stopWander()
    if humanoid then humanoid.Sit = false end
    setStatus("Emote stopped.", Color3.fromRGB(160, 160, 175))
end)

-- Task buttons
btnWalkToMe.MouseButton1Click:Connect(walkToMe)
btnJump.MouseButton1Click:Connect(jumpDummy)
btnWander.MouseButton1Click:Connect(startWander)
btnFreeze.MouseButton1Click:Connect(freezeDummy)

-- Message
sendNowBtn.MouseButton1Click:Connect(function()
    local msg = (messageBox.Text or ""):match("^%s*(.-)%s*$")
    if msg == "" then setStatus("Type a message first.", Color3.fromRGB(220, 120, 80)); return end
    if not currentDummy or not currentDummy.Parent then setStatus("Spawn a dummy first.", Color3.fromRGB(220, 120, 80)); return end
    showMessage(msg, 5)
    setStatus("Message sent.", Color3.fromRGB(120, 220, 160))
end)

scheduleBtn.MouseButton1Click:Connect(function()
    local msg = (messageBox.Text or ""):match("^%s*(.-)%s*$")
    local delay = tonumber(delayBox.Text)
    if msg == "" then setStatus("Type a message first.", Color3.fromRGB(220, 120, 80)); return end
    if not delay or delay < 0 then setStatus("Invalid delay (seconds).", Color3.fromRGB(220, 120, 80)); return end
    if not currentDummy or not currentDummy.Parent then setStatus("Spawn a dummy first.", Color3.fromRGB(220, 120, 80)); return end
    setStatus(("Message scheduled in %.1fs"):format(delay), Color3.fromRGB(220, 200, 120))
    task.delay(delay, function()
        if currentDummy and currentDummy.Parent then
            showMessage(msg, 5)
            setStatus("Dummy sent scheduled message.", Color3.fromRGB(120, 220, 160))
        end
    end)
end)

closeButton.MouseButton1Click:Connect(function()
    removeDummy()
    screenGui:Destroy()
end)

-- ============================================================
-- FOLLOW LOOP
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not followEnabled then return end
    if not currentDummy or not currentDummy.Parent then stopFollow(); return end

    local character = LocalPlayer.Character
    if not character then return end
    local myHrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid, dummyHrp = getDummyParts()
    if not myHrp or not humanoid or not dummyHrp then return end

    if dummyHrp.Anchored then dummyHrp.Anchored = false end
    if humanoid.PlatformStand then humanoid.PlatformStand = false end
    if humanoid.Sit then humanoid.Sit = false end

    local myPos = myHrp.Position
    local dummyPos = dummyHrp.Position
    local flatVec = Vector3.new(myPos.X - dummyPos.X, 0, myPos.Z - dummyPos.Z)
    local flatDist = flatVec.Magnitude

    if flatDist > CONFIG.FollowDistance then
        local dir = flatVec.Unit
        humanoid:MoveTo(myPos - dir * CONFIG.FollowDistance)
        if walkTrack and not walkTrack.IsPlaying then walkTrack:Play(0.15) end
        if idleTrack and idleTrack.IsPlaying then idleTrack:Stop(0.15) end
    else
        humanoid:MoveTo(dummyHrp.Position)
        if walkTrack and walkTrack.IsPlaying then walkTrack:Stop(0.2) end
        if idleTrack and not idleTrack.IsPlaying then idleTrack:Play(0.2) end
        local face = Vector3.new(myPos.X - dummyPos.X, 0, myPos.Z - dummyPos.Z)
        if face.Magnitude > 0.1 then
            dummyHrp.CFrame = CFrame.new(dummyPos, dummyPos + face.Unit)
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer then removeDummy() end
end)

setStatus("Ready. Enter a username to begin.", Color3.fromRGB(160, 160, 175))
