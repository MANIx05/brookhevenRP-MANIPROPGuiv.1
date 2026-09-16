-- ============================================================
--  ███  MANI AVATAR SPAWNER  ███
--  Client-side dummy avatar spawner with advanced features.
--  PC + Mobile executors.
-- ============================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

-- ============================================================
-- CONFIG
-- ============================================================
local CONFIG = {
    DefaultSpawnPosition = Vector3.new(0, 5, 0),
    DummyName            = "MANI_AvatarDummy",
    MoveStep             = 3,
    FollowDistance       = 5,
    FollowWalkSpeed      = 18,
    ScaleStep            = 0.1,
    ScaleMin             = 0.3,
    ScaleMax             = 3.0,
    TransparencyStep     = 0.1,
}

local A_WALK = "rbxassetid://507767714"
local A_IDLE = "rbxassetid://507766666"

local EMOTES = {
    Wave  = "rbxassetid://507770239",
    Point = "rbxassetid://507770453",
    Dance = "rbxassetid://507771019",
    Laugh = "rbxassetid://507770818",
    Cheer = "rbxassetid://507770677",
    Hug   = "rbxassetid://3344526316",
    Sit   = "rbxassetid://2506281703",
    Lay   = "rbxassetid://3576694744",
}

-- ============================================================
-- STATE
-- ============================================================
local currentDummy    = nil
local walkTrack       = nil
local idleTrack       = nil
local currentEmote    = nil
local followEnabled   = false
local wanderActive    = false
local guardActive     = false
local spinActive      = false
local currentMessage  = nil
local currentScale    = 1
local currentTrans    = 0
local forceField      = nil
local trail           = nil
local highlight       = nil
local trailEnabled    = false
local highlightEnabled= false
local nametagEnabled  = false
local rainbowActive   = false
local lastPos         = nil
local espBillboard    = nil

-- GUI refs (assigned later)
local statusLabel, followButton, guardButton, spinButton
local trailButton, highlightButton, nametagButton, rainbowButton
local scaleLabel, transLabel
local dummyListFrame

-- ============================================================
-- HELPERS
-- ============================================================
local function setStatus(text, color)
    if statusLabel then
        statusLabel.Text = text
        statusLabel.TextColor3 = color or Color3.fromRGB(160, 160, 175)
    end
end

local function getParts()
    if not currentDummy or not currentDummy.Parent then return nil end
    local humanoid = currentDummy:FindFirstChildOfClass("Humanoid")
    local hrp      = currentDummy:FindFirstChild("HumanoidRootPart")
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

local function stopFollow()
    followEnabled = false
    if followButton then
        followButton.Text = "Follow: OFF"
        followButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
    stopLocomotion()
end

local function stopWander()   wanderActive = false end
local function stopGuard()    guardActive  = false end
local function stopSpin()     spinActive   = false end
local function stopRainbow()  rainbowActive= false end

local function fullReset()
    stopFollow(); stopWander(); stopGuard(); stopSpin(); stopRainbow()
    stopEmote(); stopLocomotion()
end

local function playEmote(animId, loop)
    local humanoid = getParts()
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator"); animator.Parent = humanoid
    end
    stopEmote(); stopLocomotion()
    local anim = Instance.new("Animation"); anim.AnimationId = animId
    local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
    if not ok or not track then
        setStatus("Emote failed to load.", Color3.fromRGB(220, 120, 80)); return
    end
    track.Looped = (loop ~= false)
    track.Priority = Enum.AnimationPriority.Action
    track:Play(0.15)
    currentEmote = track
end

local function setupAnimations(model)
    walkTrack, idleTrack = nil, nil
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator"); animator.Parent = humanoid
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
    bb.Name = "MANI_Message"
    bb.Size = UDim2.new(0, 220, 0, 60)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 250
    bb.Parent = head

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -8, 1, -8)
    lbl.Position = UDim2.new(0, 4, 0, 4)
    lbl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    lbl.BackgroundTransparency = 0.05
    lbl.TextColor3 = Color3.fromRGB(25, 25, 25)
    lbl.Text = text
    lbl.TextSize = 15
    lbl.Font = Enum.Font.GothamBold
    lbl.TextWrapped = true
    lbl.Parent = bb
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", lbl)
    stroke.Color = Color3.fromRGB(80, 80, 100)

    currentMessage = bb
    task.delay(duration or 5, function()
        if bb and bb.Parent then bb:Destroy() end
        if currentMessage == bb then currentMessage = nil end
    end)
end

local function moveDummy(dir)
    local _, hrp = getParts()
    if not hrp then setStatus("No dummy spawned.", Color3.fromRGB(220, 120, 80)); return end
    local cam = workspace.CurrentCamera
    local look  = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
    local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
    if look.Magnitude > 0 then look = look.Unit end
    if right.Magnitude > 0 then right = right.Unit end
    local s = CONFIG.MoveStep
    local off
    if dir == "forward" then off = look * s
    elseif dir == "back" then off = look * -s
    elseif dir == "left" then off = right * -s
    elseif dir == "right" then off = right * s end
    if off then hrp.CFrame = hrp.CFrame + off end
end

-- ============================================================
-- ADVANCED FEATURE BUILDERS
-- ============================================================
local function applyScale(scale)
    if not currentDummy or not currentDummy.Parent then return end
    local humanoid = currentDummy:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local desc = humanoid:FindFirstChildOfClass("HumanoidDescription")
    local h = humanoid:FindFirstChildOfClass("BodyHeightScale")
    -- Prefer model scale API
    pcall(function() currentDummy:ScaleTo(scale) end)
    currentScale = scale
    if scaleLabel then
        scaleLabel.Text = string.format("Scale: %.2f", scale)
    end
end

local function applyTransparency(t)
    if not currentDummy or not currentDummy.Parent then return end
    for _, part in ipairs(currentDummy:GetDescendants()) do
        if part:IsA("BasePart") and not part:FindFirstChild("MANI_NoTrans") then
            part.LocalTransparencyModifier = t
        end
        if part:IsA("Decal") then
            part.Transparency = t
        end
    end
    currentTrans = t
    if transLabel then
        transLabel.Text = string.format("Alpha: %.1f", 1 - t)
    end
end

local function enableTrail(on)
    trailEnabled = on
    if not currentDummy or not currentDummy.Parent then return end
    local hrp = currentDummy:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if on then
        if trail and trail.Parent then trail:Destroy() end
        local a0 = Instance.new("Attachment", hrp)
        a0.Name = "MANI_TrailA0"
        a0.Position = Vector3.new(0, 1, 0)
        local a1 = Instance.new("Attachment", hrp)
        a1.Name = "MANI_TrailA1"
        a1.Position = Vector3.new(0, -1, 0)
        local tr = Instance.new("Trail")
        tr.Attachment0 = a0
        tr.Attachment1 = a1
        tr.Lifetime = 1.2
        tr.MinLength = 0.1
        tr.Color = ColorSequence.new(Color3.fromRGB(120, 200, 255), Color3.fromRGB(200, 120, 255))
        tr.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1),
        })
        tr.Parent = hrp
        trail = tr
        setStatus("Trail ON", Color3.fromRGB(160, 220, 255))
    else
        if trail and trail.Parent then trail:Destroy() end
        for _, name in ipairs({"MANI_TrailA0","MANI_TrailA1"}) do
            local a = hrp:FindFirstChild(name)
            if a then a:Destroy() end
        end
        trail = nil
        setStatus("Trail OFF", Color3.fromRGB(160, 160, 175))
    end
end

local function enableHighlight(on)
    highlightEnabled = on
    if not currentDummy or not currentDummy.Parent then return end
    if on then
        if highlight and highlight.Parent then highlight:Destroy() end
        local hl = Instance.new("Highlight")
        hl.Name = "MANI_Highlight"
        hl.FillColor = Color3.fromRGB(80, 160, 255)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.55
        hl.OutlineTransparency = 0.1
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = currentDummy
        hl.Parent = currentDummy
        highlight = hl
        setStatus("Highlight ON", Color3.fromRGB(120, 200, 255))
    else
        if highlight and highlight.Parent then highlight:Destroy() end
        highlight = nil
        setStatus("Highlight OFF", Color3.fromRGB(160, 160, 175))
    end
end

local function enableNametag(on)
    nametagEnabled = on
    if not currentDummy or not currentDummy.Parent then return end
    local head = currentDummy:FindFirstChild("Head") or currentDummy:FindFirstChild("HumanoidRootPart")
    if not head then return end
    local existing = head:FindFirstChild("MANI_Nametag")
    if on then
        if existing then existing:Destroy() end
        local bb = Instance.new("BillboardGui")
        bb.Name = "MANI_Nametag"
        bb.Size = UDim2.new(0, 200, 0, 32)
        bb.StudsOffset = Vector3.new(0, 4, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 250
        bb.Parent = head
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "★ MANI AVATAR ★"
        lbl.TextColor3 = Color3.fromRGB(255, 220, 80)
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.fromRGB(40, 20, 0)
        lbl.TextSize = 18
        lbl.Font = Enum.Font.GothamBlack
        lbl.Parent = bb
        setStatus("Nametag ON", Color3.fromRGB(255, 220, 120))
    else
        if existing then existing:Destroy() end
        setStatus("Nametag OFF", Color3.fromRGB(160, 160, 175))
    end
end

local function enableForceField(on)
    if not currentDummy or not currentDummy.Parent then return end
    if on then
        if forceField and forceField.Parent then forceField:Destroy() end
        local ff = Instance.new("ForceField")
        ff.Name = "MANI_FF"
        ff.Visible = true
        ff.Parent = currentDummy
        forceField = ff
        setStatus("Shield ON", Color3.fromRGB(120, 220, 255))
    else
        if forceField and forceField.Parent then forceField:Destroy() end
        forceField = nil
        setStatus("Shield OFF", Color3.fromRGB(160, 160, 175))
    end
end

local function enableRainbow(on)
    rainbowActive = on
    if on then
        setStatus("Rainbow mode ON", Color3.fromRGB(255, 180, 120))
    else
        if currentDummy and currentDummy.Parent then
            for _, part in ipairs(currentDummy:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = Color3.fromRGB(163, 162, 165)
                end
            end
        end
        setStatus("Rainbow mode OFF", Color3.fromRGB(160, 160, 175))
    end
end

local function makeESP()
    if espBillboard and espBillboard.Parent then espBillboard:Destroy() end
    if not currentDummy or not currentDummy.Parent then return end
    local hrp = currentDummy:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bb = Instance.new("BillboardGui")
    bb.Name = "MANI_ESP"
    bb.Size = UDim2.new(0, 60, 0, 12)
    bb.StudsOffset = Vector3.new(0, -3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = hrp
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "[ DUMMY ]"
    lbl.TextColor3 = Color3.fromRGB(120, 255, 180)
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 40, 20)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Code
    lbl.Parent = bb
    espBillboard = bb
end

-- ============================================================
-- SPAWN
-- ============================================================
local function spawnAvatar(username)
    username = (username or ""):match("^%s*(.-)%s*$")
    if username == "" then
        setStatus("Please enter a username.", Color3.fromRGB(220, 80, 80)); return
    end
    setStatus("Looking up user...", Color3.fromRGB(220, 200, 100))
    local ok, userId = pcall(function() return Players:GetUserIdFromNameAsync(username) end)
    if not ok or not userId then
        setStatus("User not found: " .. username, Color3.fromRGB(220, 80, 80)); return
    end
    setStatus("Creating avatar...", Color3.fromRGB(220, 200, 100))
    local ok2, model = pcall(function() return Players:CreateHumanoidModelFromUserId(userId) end)
    if not ok2 or not model then
        setStatus("Failed to create avatar.", Color3.fromRGB(220, 80, 80)); return
    end

    model.Name = CONFIG.DummyName
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
        humanoid.WalkSpeed = CONFIG.FollowWalkSpeed
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
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

    -- cleanup previous
    fullReset()
    if currentDummy and currentDummy.Parent then currentDummy:Destroy() end
    if espBillboard and espBillboard.Parent then espBillboard:Destroy() end
    currentDummy = nil

    model.Parent = workspace
    currentDummy = model
    currentScale = 1
    currentTrans = 0
    trailEnabled = false
    highlightEnabled = false
    nametagEnabled = false
    rainbowActive = false
    if trailButton then trailButton.BackgroundColor3 = Color3.fromRGB(60, 90, 130) end
    if highlightButton then highlightButton.BackgroundColor3 = Color3.fromRGB(60, 90, 130) end
    if nametagButton then nametagButton.BackgroundColor3 = Color3.fromRGB(60, 90, 130) end
    if rainbowButton then rainbowButton.BackgroundColor3 = Color3.fromRGB(90, 60, 130) end

    setupAnimations(model)
    makeESP()
    if scaleLabel then scaleLabel.Text = "Scale: 1.00" end
    if transLabel then transLabel.Text = "Alpha: 1.0" end
    setStatus("Spawned: " .. username, Color3.fromRGB(80, 200, 120))
end

-- ============================================================
-- GUI
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MANI_AVATAR_SPAWNER"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 560)
mainFrame.Position = UDim2.new(0.5, -160, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(90, 130, 220)
mainStroke.Thickness = 1.5

-- Gradient background
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 42)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 24)),
})
grad.Rotation = 90
grad.Parent = mainFrame

-- TITLE BAR
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "★ MANI AVATAR SPAWNER ★"
titleLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 28, 0, 28)
minButton.Position = UDim2.new(1, -66, 0, 5)
minButton.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
minButton.Text = "—"
minButton.TextColor3 = Color3.fromRGB(230, 230, 240)
minButton.TextSize = 16
minButton.Font = Enum.Font.GothamBold
minButton.Parent = titleBar
Instance.new("UICorner", minButton).CornerRadius = UDim.new(0, 6)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -34, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(170, 55, 55)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 230, 230)
closeButton.TextSize = 15
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

-- MINIMIZED BUTTON
local restoreBtn = Instance.new("TextButton")
restoreBtn.Size = UDim2.new(0, 60, 0, 60)
restoreBtn.Position = UDim2.new(0, 20, 0.5, -30)
restoreBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
restoreBtn.Text = "★"
restoreBtn.TextSize = 30
restoreBtn.TextColor3 = Color3.fromRGB(255, 230, 120)
restoreBtn.Font = Enum.Font.GothamBlack
restoreBtn.Visible = false
restoreBtn.Active = true
restoreBtn.Draggable = true
restoreBtn.Parent = screenGui
Instance.new("UICorner", restoreBtn).CornerRadius = UDim.new(1, 0)
local rstroke = Instance.new("UIStroke", restoreBtn)
rstroke.Color = Color3.fromRGB(255, 220, 100)
rstroke.Thickness = 2

-- TAB BAR (Categories)
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -8, 0, 30)
tabBar.Position = UDim2.new(0, 4, 0, 42)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)

local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Size = UDim2.new(1, 0, 1, 0)
tabScroll.BackgroundTransparency = 1
tabScroll.BorderSizePixel = 0
tabScroll.ScrollBarThickness = 0
tabScroll.CanvasSize = UDim2.new(0, 700, 0, 0)
tabScroll.ScrollDirection = Enum.ScrollDirection.Horizontal
tabScroll.Parent = tabBar

local pages = {}
local tabButtons = {}

local function createTab(name, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 88, 1, -4)
    b.Position = UDim2.new(0, 4 + (order-1)*92, 0, 2)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    b.TextColor3 = Color3.fromRGB(220, 220, 240)
    b.Text = name
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = tabScroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    tabButtons[name] = b

    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -8, 1, -78)
    page.Position = UDim2.new(0, 4, 0, 76)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 130)
    page.CanvasSize = UDim2.new(0, 0, 0, 700)
    page.Visible = false
    page.Parent = mainFrame
    pages[name] = page
    return page
end

local function showTab(name)
    for n, p in pairs(pages) do p.Visible = (n == name) end
    for n, b in pairs(tabButtons) do
        if n == name then
            b.BackgroundColor3 = Color3.fromRGB(80, 130, 220)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            b.TextColor3 = Color3.fromRGB(220, 220, 240)
        end
    end
end

local pageMain  = createTab("Spawn",   1)
local pageMove  = createTab("Move",    2)
local pageAnims = createTab("Emotes",  3)
local pageTasks = createTab("Tasks",   4)
local pageVis   = createTab("Visuals", 5)
local pageMsg   = createTab("Message", 6)

-- GUI helper funcs
local function mkLabel(parent, x, y, w, text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, w, 0, 14)
    l.Position = UDim2.new(0, x, 0, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.fromRGB(170, 170, 190)
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
    b.BackgroundColor3 = color or Color3.fromRGB(55, 55, 78)
    b.TextColor3 = Color3.fromRGB(230, 230, 245)
    b.Text = text
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local function mkTextBox(parent, x, y, w, h, ph)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(0, w, 0, h)
    t.Position = UDim2.new(0, x, 0, y)
    t.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    t.TextColor3 = Color3.fromRGB(240, 240, 250)
    t.PlaceholderText = ph or ""
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

-- ============================================================
-- PAGE: SPAWN
-- ============================================================
mkLabel(pageMain, 4, 6, 300, "Roblox Username:")
local usernameBox = mkTextBox(pageMain, 4, 22, 300, 34, "e.g. Builderman")

local spawnButton = mkButton(pageMain, 4, 62, 200, 36, "★ SPAWN AVATAR ★", Color3.fromRGB(60, 130, 220))
local deleteButton = mkButton(pageMain, 210, 62, 94, 36, "Delete", Color3.fromRGB(160, 55, 55))

mkLabel(pageMain, 4, 106, 300, "Quick Spawn (Recent):")
local quickBoxes = {}
for i = 1, 5 do
    local b = mkButton(pageMain, 4, 124 + (i-1)*30, 300, 26, "(empty)", Color3.fromRGB(45, 45, 65))
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Text = "  (empty slot " .. i .. ")"
    quickBoxes[i] = b
end

-- Refresh recent with real usernames
local function refreshQuick()
    local ok, pages2 = pcall(function() return Players:GetFriendsAsync(LocalPlayer.UserId) end)
    -- Simpler: fill with random online friends if available
    local friends = {}
    local success, pagesEnum = pcall(function() return Players:GetFriendsAsync(LocalPlayer.UserId) end)
    if success then
        for _ = 1, 5 do
            local page = pagesEnum:GetCurrentPage()
            for _, item in ipairs(page) do
                if #friends < 5 then
                    table.insert(friends, item.Username)
                end
            end
            if pagesEnum.IsFinished then break end
            pcall(function() pagesEnum:AdvanceToNextPageAsync() end)
        end
    end
    for i = 1, 5 do
        if friends[i] then
            quickBoxes[i].Text = "  ▶ " .. friends[i]
            quickBoxes[i]:SetAttribute("Username", friends[i])
        else
            quickBoxes[i].Text = "  (empty slot " .. i .. ")"
            quickBoxes[i]:SetAttribute("Username", nil)
        end
    end
end

for _, b in ipairs(quickBoxes) do
    b.MouseButton1Click:Connect(function()
        local u = b:GetAttribute("Username")
        if u then
            usernameBox.Text = u
            spawnAvatar(u)
        end
    end)
end

-- ============================================================
-- PAGE: MOVE
-- ============================================================
mkLabel(pageMove, 4, 6, 300, "D-Pad  (relative to camera):")

local dpadFrame = Instance.new("Frame")
dpadFrame.Size = UDim2.new(0, 120, 0, 120)
dpadFrame.Position = UDim2.new(0, 90, 0, 26)
dpadFrame.BackgroundTransparency = 1
dpadFrame.Parent = pageMove

local function dpadBtn(x, y, txt, cb)
    local b = mkButton(dpadFrame, x, y, 38, 38, txt, Color3.fromRGB(60, 60, 85))
    b.TextSize = 18
    b.MouseButton1Click:Connect(cb)
end

dpadBtn(41, 0,  "↑", function() moveDummy("forward") end)
dpadBtn(41, 82, "↓", function() moveDummy("back")    end)
dpadBtn(0,  41, "←", function() moveDummy("left")    end)
dpadBtn(82, 41, "→", function() moveDummy("right")   end)

local cDot = Instance.new("Frame")
cDot.Size = UDim2.new(0, 14, 0, 14)
cDot.Position = UDim2.new(0, 53, 0, 53)
cDot.BackgroundColor3 = Color3.fromRGB(90, 130, 220)
cDot.BorderSizePixel = 0
cDot.Parent = dpadFrame
Instance.new("UICorner", cDot).CornerRadius = UDim.new(1, 0)

local yUpBtn   = mkButton(pageMove, 4,   152, 145, 30, "▲ Height +", Color3.fromRGB(55, 100, 75))
local yDnBtn   = mkButton(pageMove, 155, 152, 149, 30, "▼ Height −", Color3.fromRGB(100, 55, 55))

local teleportButton = mkButton(pageMove, 4, 188, 300, 32, "⚡ Teleport to Me", Color3.fromRGB(100, 100, 200))

mkLabel(pageMove, 4, 226, 300, "Position Shortcuts:")
mkButton(pageMove, 4,   242, 96, 28, "Above Me",  Color3.fromRGB(70, 110, 90)).MouseButton1Click:Connect(function()
    local _, hrp = getParts()
    local ch = LocalPlayer.Character
    if hrp and ch and ch:FindFirstChild("HumanoidRootPart") then
        hrp.CFrame = CFrame.new(ch.HumanoidRootPart.Position + Vector3.new(0, 8, 0))
    end
end)
mkButton(pageMove, 104, 242, 96, 28, "Behind Me", Color3.fromRGB(70, 90, 130)).MouseButton1Click:Connect(function()
    local _, hrp = getParts()
    local ch = LocalPlayer.Character
    if hrp and ch and ch:FindFirstChild("HumanoidRootPart") then
        local myHrp = ch.HumanoidRootPart
        hrp.CFrame = CFrame.new(myHrp.Position - myHrp.CFrame.LookVector * 6)
    end
end)
mkButton(pageMove, 204, 242, 100, 28, "On My Spot", Color3.fromRGB(110, 70, 130)).MouseButton1Click:Connect(function()
    local _, hrp = getParts()
    local ch = LocalPlayer.Character
    if hrp and ch and ch:FindFirstChild("HumanoidRootPart") then
        hrp.CFrame = CFrame.new(ch.HumanoidRootPart.Position)
    end
end)

-- ============================================================
-- PAGE: EMOTES
-- ============================================================
mkLabel(pageAnims, 4, 6, 300, "Loop Emotes:")

local btnWave  = mkButton(pageAnims, 4,   22, 96, 32, "👋 Wave",  Color3.fromRGB(70, 90, 140))
local btnPoint = mkButton(pageAnims, 104, 22, 96, 32, "👉 Point", Color3.fromRGB(70, 90, 140))
local btnDance = mkButton(pageAnims, 204, 22, 100,32, "💃 Dance", Color3.fromRGB(70, 90, 140))

local btnLaugh = mkButton(pageAnims, 4,   58, 96, 32, "😂 Laugh", Color3.fromRGB(80, 100, 150))
local btnCheer = mkButton(pageAnims, 104, 58, 96, 32, "🎉 Cheer", Color3.fromRGB(80, 100, 150))
local btnSit   = mkButton(pageAnims, 204, 58, 100,32, "🪑 Sit",   Color3.fromRGB(80, 120, 90))

local btnHug   = mkButton(pageAnims, 4,   94, 200,32, "🤗 HUG ME (walks to you)", Color3.fromRGB(190, 80, 160))
local btnLay   = mkButton(pageAnims, 208, 94, 96, 32, "🛌 Lay", Color3.fromRGB(90, 90, 150))

local btnStopEmote = mkButton(pageAnims, 4, 130, 300, 32, "⏹ Stop All Animations", Color3.fromRGB(150, 60, 60))

mkLabel(pageAnims, 4, 172, 300, "Character Customization:")
local scaleLabel = mkLabel(pageAnims, 4, 190, 300, "Scale: 1.00", Color3.fromRGB(180, 220, 255))
local scaleUpBtn   = mkButton(pageAnims, 4,   208, 74, 28, "Scale +", Color3.fromRGB(60, 90, 140))
local scaleDnBtn   = mkButton(pageAnims, 82,  208, 74, 28, "Scale −", Color3.fromRGB(60, 90, 140))
local scaleRstBtn  = mkButton(pageAnims, 160, 208, 144,28, "Reset Scale", Color3.fromRGB(90, 90, 130))

local transLabel   = mkLabel(pageAnims, 4, 244, 300, "Alpha: 1.0", Color3.fromRGB(200, 200, 240))
local transUpBtn   = mkButton(pageAnims, 4,   262, 74, 28, "Alpha +", Color3.fromRGB(90, 90, 140))
local transDnBtn   = mkButton(pageAnims, 82,  262, 74, 28, "Alpha −", Color3.fromRGB(90, 90, 140))
local transRstBtn  = mkButton(pageAnims, 160, 262, 144,28, "Reset Alpha", Color3.fromRGB(90, 90, 130))

-- ============================================================
-- PAGE: TASKS
-- ============================================================
mkLabel(pageTasks, 4, 6, 300, "Behavior Tasks:")

guardButton = mkButton(pageTasks, 4, 22, 148, 34, "🛡 Guard Me", Color3.fromRGB(70, 130, 100))
spinButton  = mkButton(pageTasks, 156, 22, 148, 34, "🌀 Spin",     Color3.fromRGB(120, 90, 160))

local walkBtn = mkButton(pageTasks, 4, 62, 148, 32, "🚶 Walk to Me", Color3.fromRGB(60, 110, 170))
local jumpBtn = mkButton(pageTasks, 156, 62, 148, 32, "⬆ Jump",     Color3.fromRGB(60, 110, 170))

local wanderBtn = mkButton(pageTasks, 4, 100, 148, 32, "🌍 Wander",   Color3.fromRGB(60, 130, 130))
local freezeBtn = mkButton(pageTasks, 156, 100, 148, 32, "❄ Freeze", Color3.fromRGB(90, 130, 170))

local followInline = mkButton(pageTasks, 4, 138, 148, 34, "Follow: OFF", Color3.fromRGB(60, 60, 80))
followButton = followInline

local forceFieldBtn = mkButton(pageTasks, 156, 138, 148, 34, "🛡 Shield: OFF", Color3.fromRGB(70, 70, 100))

mkLabel(pageTasks, 4, 182, 300, "Advanced:")

local jumpLoopBtn = mkButton(pageTasks, 4, 198, 148, 32, "Jump Loop", Color3.fromRGB(110, 90, 130))
local faceMeBtn   = mkButton(pageTasks, 156, 198, 148, 32, "Face Me", Color3.fromRGB(110, 90, 130))

local followFastBtn = mkButton(pageTasks, 4, 234, 148, 32, "Follow Speed: 18", Color3.fromRGB(70, 100, 140))
local tpOnJumpBtn   = mkButton(pageTasks, 156, 234, 148, 32, "Closest to Me", Color3.fromRGB(70, 100, 140))

-- ============================================================
-- PAGE: VISUALS
-- ============================================================
mkLabel(pageVis, 4, 6, 300, "Dummy Aesthetics:")

trailButton     = mkButton(pageVis, 4,   24, 148, 34, "✨ Trail: OFF",     Color3.fromRGB(60, 90, 130))
highlightButton = mkButton(pageVis, 156, 24, 148, 34, "🔦 Highlight: OFF", Color3.fromRGB(60, 90, 130))
nametagButton   = mkButton(pageVis, 4,   62, 148, 34, "🏷 Nametag: OFF",   Color3.fromRGB(60, 90, 130))
rainbowButton   = mkButton(pageVis, 156, 62, 148, 34, "🌈 Rainbow: OFF",   Color3.fromRGB(90, 60, 130))

mkLabel(pageVis, 4, 104, 300, "Extra Visuals:")
mkButton(pageVis, 4, 120, 148, 32, "Toggle ESP",     Color3.fromRGB(60, 130, 90)).MouseButton1Click:Connect(function()
    if espBillboard and espBillboard.Parent then
        espBillboard:Destroy(); espBillboard = nil
        setStatus("ESP removed.", Color3.fromRGB(160, 160, 175))
    else
        makeESP(); setStatus("ESP enabled.", Color3.fromRGB(120, 220, 160))
    end
end)
mkButton(pageVis, 156, 120, 148, 32, "Camera on Dummy", Color3.fromRGB(130, 90, 60)).MouseButton1Click:Connect(function()
    local _, hrp = getParts()
    if hrp then
        workspace.CurrentCamera.CameraSubject = hrp
        setStatus("Camera → Dummy", Color3.fromRGB(255, 200, 120))
    end
end)
mkButton(pageVis, 4, 156, 148, 32, "Camera → Me", Color3.fromRGB(130, 90, 60)).MouseButton1Click:Connect(function()
    local ch = LocalPlayer.Character
    if ch and ch:FindFirstChildOfClass("Humanoid") then
        workspace.CurrentCamera.CameraSubject = ch:FindFirstChildOfClass("Humanoid")
        setStatus("Camera → You", Color3.fromRGB(255, 200, 120))
    end
end)
mkButton(pageVis, 156, 156, 148, 32, "Hide All GUIs", Color3.fromRGB(90, 60, 60)).MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    restoreBtn.Visible = true
end)

-- ============================================================
-- PAGE: MESSAGE
-- ============================================================
mkLabel(pageMsg, 4, 6, 300, "Fake Message Dummy Will 'Say':")
local messageBox = mkTextBox(pageMsg, 4, 22, 300, 34, "Type a message...")

mkLabel(pageMsg, 4, 62, 300, "Quick Phrases:")
local phrases = {
    "Hello there!",
    "I'm watching you 👀",
    "Nice to meet you!",
    "Follow me!",
    "I'm your friend now.",
    "Hello, human!",
}
for i, p in ipairs(phrases) do
    local row = math.floor((i-1)/2)
    local col = (i-1) % 2
    local b = mkButton(pageMsg, 4 + col*152, 78 + row*30, 148, 26, p, Color3.fromRGB(60, 60, 90))
    b.MouseButton1Click:Connect(function()
        messageBox.Text = p
    end)
end

mkLabel(pageMsg, 4, 174, 300, "Delay (seconds):")
local delayBox = mkTextBox(pageMsg, 4, 192, 140, 32, "e.g. 5")

local sendNowBtn  = mkButton(pageMsg, 4,   232, 148, 34, "💬 Send Now",   Color3.fromRGB(60, 130, 80))
local scheduleBtn = mkButton(pageMsg, 156, 232, 148, 34, "⏰ Schedule",  Color3.fromRGB(130, 100, 60))

mkLabel(pageMsg, 4, 274, 300, "Auto Message Loop:")
local autoMsgBox = mkTextBox(pageMsg, 4, 292, 200, 30, "Auto msg text")
local autoMsgBtn = mkButton(pageMsg, 208, 292, 96, 30, "Auto: OFF", Color3.fromRGB(70, 70, 100))

local autoMsgActive = false
local autoMsgTask   = nil
autoMsgBtn.MouseButton1Click:Connect(function()
    if autoMsgActive then
        autoMsgActive = false
        autoMsgBtn.Text = "Auto: OFF"
        autoMsgBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
        setStatus("Auto message OFF.", Color3.fromRGB(160, 160, 175))
        return
    end
    if not currentDummy or not currentDummy.Parent then
        setStatus("Spawn a dummy first.", Color3.fromRGB(220, 120, 80)); return
    end
    autoMsgActive = true
    autoMsgBtn.Text = "Auto: ON"
    autoMsgBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
    setStatus("Auto message ON.", Color3.fromRGB(120, 220, 160))
    task.spawn(function()
        while autoMsgActive do
            local txt = autoMsgBox.Text
            if txt ~= "" and currentDummy and currentDummy.Parent then
                showMessage(txt, 4)
            end
            task.wait(8)
        end
    end)
end)

-- ============================================================
-- STATUS LABEL (bottom of main frame)
-- ============================================================
statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -12, 0, 22)
statusLabel.Position = UDim2.new(0, 6, 1, -26)
statusLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
statusLabel.BackgroundTransparency = 0.3
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(160, 220, 180)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame
Instance.new("UICorner", statusLabel).CornerRadius = UDim.new(0, 6)

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
    pcall(refreshQuick)
end)
usernameBox.FocusLost:Connect(function(enter)
    if enter then
        spawnAvatar(usernameBox.Text)
        pcall(refreshQuick)
    end
end)
deleteButton.MouseButton1Click:Connect(function()
    fullReset()
    if currentDummy and currentDummy.Parent then currentDummy:Destroy() end
    if espBillboard and espBillboard.Parent then espBillboard:Destroy() end
    currentDummy = nil
    setStatus("Dummy deleted.", Color3.fromRGB(160, 160, 175))
end)

-- Follow
followInline.MouseButton1Click:Connect(function()
    if not currentDummy or not currentDummy.Parent then
        setStatus("Spawn a dummy first.", Color3.fromRGB(220, 120, 80)); return
    end
    followEnabled = not followEnabled
    if followEnabled then
        stopWander(); stopGuard(); stopSpin(); stopEmote(); stopRainbow()
        followInline.Text = "Follow: ON"
        followInline.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
        local humanoid, hrp = getParts()
        if hrp then hrp.Anchored = false end
        if humanoid then humanoid.PlatformStand = false end
        setStatus("Following you...", Color3.fromRGB(120, 220, 160))
    else
        stopFollow()
        setStatus("Follow disabled.", Color3.fromRGB(160, 160, 175))
    end
end)

-- Guard
guardButton.MouseButton1Click:Connect(function()
    if not currentDummy or not currentDummy.Parent then
        setStatus("Spawn a dummy first.", Color3.fromRGB(220, 120, 80)); return
    end
    guardActive = not guardActive
    if guardActive then
        stopFollow(); stopWander(); stopEmote()
        guardButton.Text = "🛡 Guarding"
        guardButton.BackgroundColor3 = Color3.fromRGB(70, 200, 130)
        setStatus("Guarding around you.", Color3.fromRGB(120, 240, 160))
        task.spawn(function()
            local character = LocalPlayer.Character
            local idx = 0
            while guardActive and currentDummy and currentDummy.Parent do
                local humanoid, hrp = getParts()
                local myHrp = character and character:FindFirstChild("HumanoidRootPart")
                if humanoid and hrp and myHrp then
                    idx = idx + 1
                    local angle = (idx * 30) * math.pi / 180
                    local r = 6
                    local tx = myHrp.Position + Vector3.new(math.cos(angle)*r, 0, math.sin(angle)*r)
                    humanoid:MoveTo(tx)
                end
                task.wait(0.35)
            end
        end)
    else
        guardButton.Text = "🛡 Guard Me"
        guardButton.BackgroundColor3 = Color3.fromRGB(70, 130, 100)
        stopGuard()
        setStatus("Guard OFF.", Color3.fromRGB(160, 160, 175))
    end
end)

-- Spin
spinButton.MouseButton1Click:Connect(function()
    if not currentDummy or not currentDummy.Parent then
        setStatus("Spawn a dummy first.", Color3.fromRGB(220, 120, 80)); return
    end
    spinActive = not spinActive
    if spinActive then
        stopFollow(); stopWander()
        spinButton.Text = "🌀 Spinning"
        spinButton.BackgroundColor3 = Color3.fromRGB(180, 130, 220)
        setStatus("Spinning...", Color3.fromRGB(200, 160, 255))
        task.spawn(function()
            while spinActive and currentDummy and currentDummy.Parent do
                local _, hrp = getParts()
                if hrp then
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
                end
                task.wait(0.03)
            end
        end)
    else
        spinButton.Text = "🌀 Spin"
        spinButton.BackgroundColor3 = Color3.fromRGB(120, 90, 160)
        stopSpin()
        setStatus("Spin OFF.", Color3.fromRGB(160, 160, 175))
    end
end)

-- Task buttons
walkBtn.MouseButton1Click:Connect(function()
    local humanoid, hrp = getParts()
    local ch = LocalPlayer.Character
    if not humanoid or not hrp or not ch then return end
    local myHrp = ch:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    stopFollow(); stopWander(); stopGuard(); stopSpin(); stopEmote()
    if hrp.Anchored then hrp.Anchored = false end
    humanoid.PlatformStand = false
    humanoid:MoveTo(myHrp.Position)
    setStatus("Walking to you...", Color3.fromRGB(120, 220, 160))
end)

jumpBtn.MouseButton1Click:Connect(function()
    local humanoid = getParts()
    if humanoid then
        humanoid.Jump = true
        setStatus("Jump!", Color3.fromRGB(120, 220, 160))
    end
end)

wanderBtn.MouseButton1Click:Connect(function()
    local humanoid, hrp = getParts()
    if not humanoid or not hrp then return end
    stopFollow(); stopGuard(); stopSpin(); stopEmote()
    hrp.Anchored = false
    humanoid.PlatformStand = false
    wanderActive = true
    setStatus("Wandering...", Color3.fromRGB(180, 200, 120))
    task.spawn(function()
        while wanderActive and currentDummy and currentDummy.Parent do
            local pos = hrp.Position
            humanoid:MoveTo(pos + Vector3.new(math.random(-15, 15), 0, math.random(-15, 15)))
            task.wait(2 + math.random() * 2)
        end
    end)
end)

freezeBtn.MouseButton1Click:Connect(function()
    local humanoid, hrp = getParts()
    if humanoid and hrp then
        stopFollow(); stopWander(); stopGuard(); stopSpin(); stopEmote(); stopLocomotion()
        humanoid:MoveTo(hrp.Position)
        setStatus("Frozen.", Color3.fromRGB(160, 200, 240))
    end
end)

-- Force field
local ffActive = false
forceFieldBtn.MouseButton1Click:Connect(function()
    ffActive = not ffActive
    enableForceField(ffActive)
    forceFieldBtn.Text = ffActive and "🛡 Shield: ON" or "🛡 Shield: OFF"
    forceFieldBtn.BackgroundColor3 = ffActive and Color3.fromRGB(80, 180, 220) or Color3.fromRGB(70, 70, 100)
end)

-- Jump loop
local jumpLoopActive = false
jumpLoopBtn.MouseButton1Click:Connect(function()
    jumpLoopActive = not jumpLoopActive
    jumpLoopBtn.Text = jumpLoopActive and "Stop Jump Loop" or "Jump Loop"
    jumpLoopBtn.BackgroundColor3 = jumpLoopActive and Color3.fromRGB(180, 90, 180) or Color3.fromRGB(110, 90, 130)
    if jumpLoopActive then
        task.spawn(function()
            while jumpLoopActive and currentDummy and currentDummy.Parent do
                local h = getParts()
                if h then h.Jump = true end
                task.wait(0.6)
            end
        end)
    end
end)

faceMeBtn.MouseButton1Click:Connect(function()
    local _, hrp = getParts()
    local ch = LocalPlayer.Character
    if not hrp or not ch then return end
    local myHrp = ch:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    local look = Vector3.new(myHrp.Position.X - hrp.Position.X, 0, myHrp.Position.Z - hrp.Position.Z)
    if look.Magnitude > 0.1 then
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + look.Unit)
        setStatus("Facing you.", Color3.fromRGB(160, 220, 200))
    end
end)

followFastBtn.MouseButton1Click:Connect(function()
    local humanoid = getParts()
    if not humanoid then return end
    CONFIG.FollowWalkSpeed = CONFIG.FollowWalkSpeed + 6
    if CONFIG.FollowWalkSpeed > 40 then CONFIG.FollowWalkSpeed = 12 end
    humanoid.WalkSpeed = CONFIG.FollowWalkSpeed
    followFastBtn.Text = "Follow Speed: " .. tostring(math.floor(CONFIG.FollowWalkSpeed))
    setStatus("Follow speed = " .. CONFIG.FollowWalkSpeed, Color3.fromRGB(160, 200, 240))
end)

tpOnJumpBtn.MouseButton1Click:Connect(function()
    local _, hrp = getParts()
    local ch = LocalPlayer.Character
    if not hrp or not ch then return end
    local myHrp = ch:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    hrp.CFrame = CFrame.new(myHrp.Position + Vector3.new(0, 0.5, 0))
    setStatus("Snapped to you.", Color3.fromRGB(160, 220, 200))
end)

-- Emotes
btnWave.MouseButton1Click:Connect(function() stopFollow(); stopWander(); stopGuard(); stopSpin(); playEmote(EMOTES.Wave, true); setStatus("Waving", Color3.fromRGB(180,220,255)) end)
btnPoint.MouseButton1Click:Connect(function() stopFollow(); stopWander(); stopGuard(); stopSpin(); playEmote(EMOTES.Point, true); setStatus("Pointing", Color3.fromRGB(180,220,255)) end)
btnDance.MouseButton1Click:Connect(function() stopFollow(); stopWander(); stopGuard(); stopSpin(); playEmote(EMOTES.Dance, true); setStatus("Dancing", Color3.fromRGB(180,220,255)) end)
btnLaugh.MouseButton1Click:Connect(function() stopFollow(); stopWander(); stopGuard(); stopSpin(); playEmote(EMOTES.Laugh, true); setStatus("Laughing", Color3.fromRGB(180,220,255)) end)
btnCheer.MouseButton1Click:Connect(function() stopFollow(); stopWander(); stopGuard(); stopSpin(); playEmote(EMOTES.Cheer, true); setStatus("Cheering", Color3.fromRGB(180,220,255)) end)
btnSit.MouseButton1Click:Connect(function()
    local humanoid = getParts()
    if not humanoid then return end
    stopFollow(); stopWander(); stopGuard(); stopSpin()
    humanoid.Sit = true
    playEmote(EMOTES.Sit, true)
    setStatus("Sitting", Color3.fromRGB(180,240,200))
end)
btnLay.MouseButton1Click:Connect(function()
    stopFollow(); stopWander(); stopGuard(); stopSpin()
    playEmote(EMOTES.Lay, true)
    setStatus("Laying down", Color3.fromRGB(180,220,255))
end)
btnHug.MouseButton1Click:Connect(function()
    local humanoid, hrp = getParts()
    local ch = LocalPlayer.Character
    if not humanoid or not hrp or not ch then return end
    local myHrp = ch:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    stopFollow(); stopWander(); stopGuard(); stopSpin(); stopEmote(); stopLocomotion()
    if hrp.Anchored then hrp.Anchored = false end
    humanoid.PlatformStand = false
    setStatus("Walking to hug you...", Color3.fromRGB(240, 180, 220))
    task.spawn(function()
        local t0 = tick()
        while tick() - t0 < 8 do
            if not currentDummy or not currentDummy.Parent then return end
            if (myHrp.Position - hrp.Position).Magnitude < 4 then break end
            humanoid:MoveTo(myHrp.Position)
            task.wait(0.15)
        end
        if not currentDummy or not currentDummy.Parent then return end
        humanoid:MoveTo(hrp.Position)
        task.wait(0.15)
        local look = myHrp.Position - hrp.Position
        look = Vector3.new(look.X, 0, look.Z)
        if look.Magnitude > 0.1 then
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + look.Unit)
        end
        playEmote(EMOTES.Hug, true)
        setStatus("Hugging you!", Color3.fromRGB(240, 120, 180))
    end)
end)
btnStopEmote.MouseButton1Click:Connect(function()
    local humanoid = getParts()
    stopEmote(); stopLocomotion(); stopWander(); stopGuard(); stopSpin()
    if humanoid then humanoid.Sit = false end
    setStatus("Animations stopped.", Color3.fromRGB(160, 160, 175))
end)

-- Scale buttons
scaleUpBtn.MouseButton1Click:Connect(function()
    local s = math.min(CONFIG.ScaleMax, currentScale + CONFIG.ScaleStep)
    applyScale(s)
    setStatus(("Scale: %.2f"):format(s), Color3.fromRGB(180, 220, 255))
end)
scaleDnBtn.MouseButton1Click:Connect(function()
    local s = math.max(CONFIG.ScaleMin, currentScale - CONFIG.ScaleStep)
    applyScale(s)
    setStatus(("Scale: %.2f"):format(s), Color3.fromRGB(180, 220, 255))
end)
scaleRstBtn.MouseButton1Click:Connect(function()
    applyScale(1)
    setStatus("Scale reset.", Color3.fromRGB(160, 160, 175))
end)

-- Transparency buttons
transUpBtn.MouseButton1Click:Connect(function()
    local t = math.max(0, currentTrans - CONFIG.TransparencyStep)
    applyTransparency(t)
    setStatus(("Alpha: %.1f"):format(1 - t), Color3.fromRGB(200, 200, 240))
end)
transDnBtn.MouseButton1Click:Connect(function()
    local t = math.min(1, currentTrans + CONFIG.TransparencyStep)
    applyTransparency(t)
    setStatus(("Alpha: %.1f"):format(1 - t), Color3.fromRGB(200, 200, 240))
end)
transRstBtn.MouseButton1Click:Connect(function()
    applyTransparency(0)
    setStatus("Alpha reset.", Color3.fromRGB(160, 160, 175))
end)

-- Visual toggles
trailButton.MouseButton1Click:Connect(function()
    trailEnabled = not trailEnabled
    enableTrail(trailEnabled)
    trailButton.Text = trailEnabled and "✨ Trail: ON" or "✨ Trail: OFF"
    trailButton.BackgroundColor3 = trailEnabled and Color3.fromRGB(120, 180, 250) or Color3.fromRGB(60, 90, 130)
end)
highlightButton.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    enableHighlight(highlightEnabled)
    highlightButton.Text = highlightEnabled and "🔦 Highlight: ON" or "🔦 Highlight: OFF"
    highlightButton.BackgroundColor3 = highlightEnabled and Color3.fromRGB(120, 180, 250) or Color3.fromRGB(60, 90, 130)
end)
nametagButton.MouseButton1Click:Connect(function()
    nametagEnabled = not nametagEnabled
    enableNametag(nametagEnabled)
    nametagButton.Text = nametagEnabled and "🏷 Nametag: ON" or "🏷 Nametag: OFF"
    nametagButton.BackgroundColor3 = nametagEnabled and Color3.fromRGB(230, 200, 120) or Color3.fromRGB(60, 90, 130)
end)
rainbowButton.MouseButton1Click:Connect(function()
    rainbowActive = not rainbowActive
    enableRainbow(rainbowActive)
    rainbowButton.Text = rainbowActive and "🌈 Rainbow: ON" or "🌈 Rainbow: OFF"
    rainbowButton.BackgroundColor3 = rainbowActive and Color3.fromRGB(200, 100, 220) or Color3.fromRGB(90, 60, 130)
end)

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
    if not delay or delay < 0 then setStatus("Invalid delay.", Color3.fromRGB(220, 120, 80)); return end
    if not currentDummy or not currentDummy.Parent then setStatus("Spawn a dummy first.", Color3.fromRGB(220, 120, 80)); return end
    setStatus(("Scheduled in %.1fs"):format(delay), Color3.fromRGB(220, 200, 120))
    task.delay(delay, function()
        if currentDummy and currentDummy.Parent then
            showMessage(msg, 5)
            setStatus("Scheduled message sent.", Color3.fromRGB(120, 220, 160))
        end
    end)
end)

closeButton.MouseButton1Click:Connect(function()
    fullReset()
    if currentDummy and currentDummy.Parent then currentDummy:Destroy() end
    screenGui:Destroy()
end)

-- ============================================================
-- MAIN LOOPS
-- ============================================================
RunService.Heartbeat:Connect(function()
    -- FOLLOW
    if followEnabled and currentDummy and currentDummy.Parent then
        local ch = LocalPlayer.Character
        local myHrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local humanoid, hrp = getParts()
        if myHrp and humanoid and hrp then
            if hrp.Anchored then hrp.Anchored = false end
            if humanoid.PlatformStand then humanoid.PlatformStand = false end
            if humanoid.Sit then humanoid.Sit = false end
            local myPos = myHrp.Position
            local dummyPos = hrp.Position
            local flat = Vector3.new(myPos.X - dummyPos.X, 0, myPos.Z - dummyPos.Z)
            local dist = flat.Magnitude
            if dist > CONFIG.FollowDistance then
                humanoid:MoveTo(myPos - flat.Unit * CONFIG.FollowDistance)
                if walkTrack and not walkTrack.IsPlaying then walkTrack:Play(0.15) end
                if idleTrack and idleTrack.IsPlaying then idleTrack:Stop(0.15) end
            else
                humanoid:MoveTo(hrp.Position)
                if walkTrack and walkTrack.IsPlaying then walkTrack:Stop(0.2) end
                if idleTrack and not idleTrack.IsPlaying then idleTrack:Play(0.2) end
                local face = Vector3.new(myPos.X - dummyPos.X, 0, myPos.Z - dummyPos.Z)
                if face.Magnitude > 0.1 then
                    hrp.CFrame = CFrame.new(dummyPos, dummyPos + face.Unit)
                end
            end
        end
    end

    -- RAINBOW
    if rainbowActive and currentDummy and currentDummy.Parent then
        local hue = (tick() * 0.5) % 1
        for _, part in ipairs(currentDummy:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.fromHSV(hue, 0.85, 1)
            end
        end    end
end)

-- Periodically refresh quick list once
task.spawn(function()
    task.wait(1)
    pcall(refreshQuick)
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer then
        fullReset()
        if currentDummy and currentDummy.Parent then currentDummy:Destroy() end
    end
end)

-- ============================================================
-- INIT
-- ============================================================
showTab("Spawn")
setStatus("MANI AVATAR SPAWNER ready. Enter a username.", Color3.fromRGB(160, 220, 180))
