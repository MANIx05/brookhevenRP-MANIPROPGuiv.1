-- ============================================================
--  ★ MANI AVATAR SPAWNER ★ — COMPACT + REALTIME AVATAR
--  Smaller GUI • Full real-time avatar (clothes/accessories/face/body)
-- ============================================================

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP         = Players.LocalPlayer
local PG         = LP:WaitForChild("PlayerGui")

-- ============================================================
-- CONFIG
-- ============================================================
local CFG = {
    MoveStep = 3, FollowDist = 5, FollowSpeed = 18,
    ScaleStep = 0.1, ScaleMin = 0.3, ScaleMax = 3.0,
    TransStep = 0.1, DummyName = "MANI_Dummy",
}

local A_WALK = "rbxassetid://507767714"
local A_IDLE = "rbxassetid://507766666"
local EM = {
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
local D, walkT, idleT, curEmote = nil, nil, nil, nil
local followOn, wanderOn, guardOn, spinOn = false, false, false, false
local jumpLoopOn, autoMsgOn = false, false
local msgGui, trail, hl, esp, ff = nil, nil, nil, nil, nil
local scale, alpha = 1, 0
local trailOn, hlOn, nameOn, rainOn, ffOn = false, false, false, false, false

-- ============================================================
-- HELPERS
-- ============================================================
local function status(txt, col)
    if _G.MANI_STATUS then
        _G.MANI_STATUS.Text = "  " .. tostring(txt)
        _G.MANI_STATUS.TextColor3 = col or Color3.fromRGB(160, 220, 180)
    end
end

local function parts()
    if not D or not D.Parent then return nil end
    return D:FindFirstChildOfClass("Humanoid"), D:FindFirstChild("HumanoidRootPart")
end

local function stopLoco()
    if walkT and walkT.IsPlaying then walkT:Stop(0.15) end
    if idleT and idleT.IsPlaying then idleT:Stop(0.15) end
end
local function stopEmote()
    if curEmote then pcall(function() curEmote:Stop(0.15) end); curEmote = nil end
end
local function stopFollow()
    followOn = false
    if _G.MANI_FOLLOW_BTN then
        _G.MANI_FOLLOW_BTN.Text = "Follow: OFF"
        _G.MANI_FOLLOW_BTN.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
    stopLoco()
end
local function stopWander() wanderOn = false end
local function stopGuard()  guardOn = false end
local function stopSpin()   spinOn = false end
local function stopJump()   jumpLoopOn = false end
local function stopRain()   rainOn = false end

local function fullReset()
    stopFollow(); stopWander(); stopGuard(); stopSpin(); stopJump(); stopRain()
    stopEmote(); stopLoco()
end

local function playEmote(id, loop)
    local h = parts()
    if not h then return end
    local an = h:FindFirstChildOfClass("Animator")
    if not an then an = Instance.new("Animator"); an.Parent = h end
    stopEmote(); stopLoco()
    local a = Instance.new("Animation"); a.AnimationId = id
    local ok, t = pcall(function() return an:LoadAnimation(a) end)
    if not ok or not t then status("Emote failed", Color3.fromRGB(220, 120, 80)); return end
    t.Looped = (loop ~= false)
    t.Priority = Enum.AnimationPriority.Action
    t:Play(0.15)
    curEmote = t
end

local function setupAnims(m)
    walkT, idleT = nil, nil
    local h = m:FindFirstChildOfClass("Humanoid")
    if not h then return end
    local an = h:FindFirstChildOfClass("Animator")
    if not an then an = Instance.new("Animator"); an.Parent = h end
    local wa = Instance.new("Animation"); wa.AnimationId = A_WALK
    walkT = an:LoadAnimation(wa); walkT.Looped = true
    walkT.Priority = Enum.AnimationPriority.Movement
    local ia = Instance.new("Animation"); ia.AnimationId = A_IDLE
    idleT = an:LoadAnimation(ia); idleT.Looped = true
    idleT.Priority = Enum.AnimationPriority.Idle
end

local function say(txt, dur)
    if not D or not D.Parent then return end
    local head = D:FindFirstChild("Head") or D:FindFirstChild("HumanoidRootPart")
    if not head then return end
    if msgGui then msgGui:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 200, 0, 54)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.Parent = head
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -8, 1, -8); l.Position = UDim2.new(0, 4, 0, 4)
    l.BackgroundColor3 = Color3.fromRGB(255,255,255); l.BackgroundTransparency = 0.05
    l.TextColor3 = Color3.fromRGB(25,25,25); l.Text = txt
    l.TextSize = 13; l.Font = Enum.Font.GothamBold; l.TextWrapped = true
    l.Parent = bb
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 12)
    msgGui = bb
    task.delay(dur or 5, function()
        if bb and bb.Parent then bb:Destroy() end
        if msgGui == bb then msgGui = nil end
    end)
end

local function move(d)
    local _, h = parts()
    if not h then status("No dummy", Color3.fromRGB(220, 120, 80)); return end
    local cam = workspace.CurrentCamera; if not cam then return end
    local lk = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
    local rt = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
    if lk.Magnitude > 0 then lk = lk.Unit end
    if rt.Magnitude > 0 then rt = rt.Unit end
    local s = CFG.MoveStep
    local o
    if d == "f" then o = lk * s
    elseif d == "b" then o = lk * -s
    elseif d == "l" then o = rt * -s
    elseif d == "r" then o = rt * s end
    if o then h.CFrame = h.CFrame + o end
end

local function setScale(s)
    if not D or not D.Parent then return end
    pcall(function() D:ScaleTo(s) end)
    scale = s
    if _G.MANI_SCALE_LBL then _G.MANI_SCALE_LBL.Text = string.format("Scale: %.2f", s) end
end

local function setAlpha(t)
    if not D or not D.Parent then return end
    for _, p in ipairs(D:GetDescendants()) do
        if p:IsA("BasePart") then p.LocalTransparencyModifier = t
        elseif p:IsA("Decal") then p.Transparency = t end
    end
    alpha = t
    if _G.MANI_ALPHA_LBL then _G.MANI_ALPHA_LBL.Text = string.format("Alpha: %.1f", 1 - t) end
end

local function toggleTrail(on)
    trailOn = on
    if not D or not D.Parent then return end
    local h = D:FindFirstChild("HumanoidRootPart"); if not h then return end
    if trail and trail.Parent then trail:Destroy() end
    for _, n in ipairs({"MANI_T0","MANI_T1"}) do
        local x = h:FindFirstChild(n); if x then x:Destroy() end
    end
    if on then
        local a0 = Instance.new("Attachment", h); a0.Name = "MANI_T0"; a0.Position = Vector3.new(0,1,0)
        local a1 = Instance.new("Attachment", h); a1.Name = "MANI_T1"; a1.Position = Vector3.new(0,-1,0)
        local t = Instance.new("Trail")
        t.Attachment0 = a0; t.Attachment1 = a1; t.Lifetime = 1.2
        t.Color = ColorSequence.new(Color3.fromRGB(120,200,255), Color3.fromRGB(200,120,255))
        t.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,1)})
        t.Parent = h
        trail = t
    else trail = nil end
end

local function toggleHL(on)
    hlOn = on
    if not D or not D.Parent then return end
    if hl and hl.Parent then hl:Destroy() end
    if on then
        local x = Instance.new("Highlight")
        x.FillColor = Color3.fromRGB(80,160,255)
        x.OutlineColor = Color3.fromRGB(255,255,255)
        x.FillTransparency = 0.55; x.OutlineTransparency = 0.1
        x.Adornee = D; x.Parent = D
        hl = x
    else hl = nil end
end

local function toggleName(on)
    nameOn = on
    if not D or not D.Parent then return end
    local head = D:FindFirstChild("Head") or D:FindFirstChild("HumanoidRootPart")
    if not head then return end
    local ex = head:FindFirstChild("MANI_NT")
    if ex then ex:Destroy() end
    if on then
        local bb = Instance.new("BillboardGui")
        bb.Name = "MANI_NT"; bb.Size = UDim2.new(0,200,0,32)
        bb.StudsOffset = Vector3.new(0,4,0); bb.AlwaysOnTop = true
        bb.Parent = head
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
        l.Text = "★ MANI AVATAR ★"; l.TextColor3 = Color3.fromRGB(255,220,80)
        l.TextStrokeTransparency = 0; l.TextStrokeColor3 = Color3.fromRGB(40,20,0)
        l.TextSize = 18; l.Font = Enum.Font.GothamBlack; l.Parent = bb
    end
end

local function toggleFF(on)
    ffOn = on
    if not D or not D.Parent then return end
    if ff and ff.Parent then ff:Destroy() end
    if on then
        local x = Instance.new("ForceField"); x.Visible = true; x.Parent = D; ff = x
    else ff = nil end
end

local function makeESP()
    if esp and esp.Parent then esp:Destroy() end
    if not D or not D.Parent then return end
    local h = D:FindFirstChild("HumanoidRootPart"); if not h then return end
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0,60,0,12); bb.StudsOffset = Vector3.new(0,-3,0)
    bb.AlwaysOnTop = true; bb.Parent = h
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
    l.Text = "[ DUMMY ]"; l.TextColor3 = Color3.fromRGB(120,255,180)
    l.TextStrokeTransparency = 0; l.TextStrokeColor3 = Color3.fromRGB(0,40,20)
    l.TextSize = 11; l.Font = Enum.Font.Code; l.Parent = bb
    esp = bb
end

-- ============================================================
-- ★ REALTIME AVATAR SPAWNER (uses HumanoidDescription)
-- ============================================================
local function createRealAvatar(userId)
    -- Method 1: GetHumanoidDescriptionFromUserId + CreateHumanoidModelFromDescription
    -- This returns the FULL current outfit (clothes, accessories, face, body colors, animations)
    local ok1, desc = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(userId)
    end)
    if ok1 and desc then
        -- Detect rig type (R15 is default for modern avatars)
        local rigType = Enum.HumanoidRigType.R15
        local ok2, model = pcall(function()
            return Players:CreateHumanoidModelFromDescription(desc, rigType)
        end)
        if ok2 and model then
            return model
        end
        -- Fallback to R6 if R15 failed
        local ok3, model6 = pcall(function()
            return Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R6)
        end)
        if ok3 and model6 then return model6 end
    end
    -- Method 2 fallback: legacy UserId method
    local ok4, model = pcall(function()
        return Players:CreateHumanoidModelFromUserId(userId)
    end)
    if ok4 and model then return model end
    return nil
end

local function spawnAvatar(uname, isBH)
    uname = (uname or ""):match("^%s*(.-)%s*$")
    if uname == "" then status("Enter a username", Color3.fromRGB(220,80,80)); return end
    status("Looking up " .. uname .. "...", Color3.fromRGB(220,200,100))

    -- Try GetUserIdFromNameAsync first (works for any player)
    local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(uname) end)
    if not ok or not uid then
        -- If the player is IN the server, use their UserId directly
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Name:lower() == uname:lower() or pl.DisplayName:lower() == uname:lower() then
                uid = pl.UserId
                break
            end
        end
    end
    if not uid then status("User not found: " .. uname, Color3.fromRGB(220,80,80)); return end

    status("Loading full avatar...", Color3.fromRGB(220,200,100))
    local m = createRealAvatar(uid)
    if not m then status("Failed to create avatar", Color3.fromRGB(220,80,80)); return end

    m.Name = (isBH and "BH_" or "") .. CFG.DummyName
    local h = m:FindFirstChildOfClass("Humanoid")
    if h then
        h.PlatformStand = true
        h.WalkSpeed = CFG.FollowSpeed
        h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
    local hrp = m:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.Anchored = true end

    local sp = Vector3.new(0,5,0)
    local ch = LP.Character
    if ch then
        local mh = ch:FindFirstChild("HumanoidRootPart")
        if mh then sp = mh.Position + mh.CFrame.LookVector * 8 + Vector3.new(0,3,0) end
    end
    m:PivotTo(CFrame.new(sp))

    fullReset()
    if D and D.Parent then D:Destroy() end
    if esp and esp.Parent then esp:Destroy() end
    D = nil

    m.Parent = workspace
    D = m

    -- Preload assets so clothes/accessories render fully
    task.spawn(function()
        local assets = {}
        for _, item in ipairs(m:GetDescendants()) do
            if item:IsA("Decal") or item:IsA("Texture") then
                local id = item.Texture
                if id and id ~= "" then table.insert(assets, id) end
            elseif item:IsA("Shirt") or item:IsA("Pants") then
                local id = item.ShirtTemplate or item.PantsTemplate
                if id and id ~= "" then table.insert(assets, id) end
            elseif item:IsA("Accessory") then
                local handle = item:FindFirstChild("Handle")
                if handle then
                    for _, d in ipairs(handle:GetChildren()) do
                        if d:IsA("Decal") or d:IsA("Texture") then
                            if d.Texture and d.Texture ~= "" then
                                table.insert(assets, d.Texture)
                            end
                        end
                    end
                end
            elseif item:IsA("MeshPart") and item.TextureID and item.TextureID ~= "" then
                table.insert(assets, item.TextureID)
            end
        end
        if #assets > 0 then
            pcall(function() game:GetService("ContentProvider"):PreloadAsync(assets) end)
        end
    end)

    scale = 1; alpha = 0
    trailOn = false; hlOn = false; nameOn = false; rainOn = false; ffOn = false
    if _G.MANI_TRAIL_BTN then _G.MANI_TRAIL_BTN.Text = "Trail: OFF"; _G.MANI_TRAIL_BTN.BackgroundColor3 = Color3.fromRGB(60,90,130) end
    if _G.MANI_HL_BTN then _G.MANI_HL_BTN.Text = "Highlight: OFF"; _G.MANI_HL_BTN.BackgroundColor3 = Color3.fromRGB(60,90,130) end
    if _G.MANI_NAME_BTN then _G.MANI_NAME_BTN.Text = "Nametag: OFF"; _G.MANI_NAME_BTN.BackgroundColor3 = Color3.fromRGB(60,90,130) end
    if _G.MANI_RAIN_BTN then _G.MANI_RAIN_BTN.Text = "Rainbow: OFF"; _G.MANI_RAIN_BTN.BackgroundColor3 = Color3.fromRGB(90,60,130) end
    if _G.MANI_FF_BTN then _G.MANI_FF_BTN.Text = "Shield: OFF"; _G.MANI_FF_BTN.BackgroundColor3 = Color3.fromRGB(70,70,100) end
    if _G.MANI_SCALE_LBL then _G.MANI_SCALE_LBL.Text = "Scale: 1.00" end
    if _G.MANI_ALPHA_LBL then _G.MANI_ALPHA_LBL.Text = "Alpha: 1.0" end

    setupAnims(m); makeESP()
    status("Loaded: " .. uname, Color3.fromRGB(80,200,120))
end

-- ============================================================
-- BUILD GUI (COMPACT)
-- ============================================================
if _G.MANI_SCREEN then pcall(function() _G.MANI_SCREEN:Destroy() end) end

local SG = Instance.new("ScreenGui")
SG.Name = "MANI_AVATAR_SPAWNER"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = PG
_G.MANI_SCREEN = SG

-- MAIN FRAME (smaller: 280 x 440)
local MF = Instance.new("Frame")
MF.Name = "MainFrame"
MF.Size = UDim2.new(0, 280, 0, 440)
MF.Position = UDim2.new(0, 20, 0, 40)
MF.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
MF.BorderSizePixel = 0
MF.Active = true
MF.Draggable = true
MF.Parent = SG
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 10)
local mstr = Instance.new("UIStroke", MF)
mstr.Color = Color3.fromRGB(90,130,220); mstr.Thickness = 1.5

-- TITLE BAR
local TB = Instance.new("Frame")
TB.Size = UDim2.new(1, 0, 0, 30)
TB.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TB.BorderSizePixel = 0
TB.Parent = MF
Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 10)

local TL = Instance.new("TextLabel")
TL.Size = UDim2.new(1, -80, 1, 0); TL.Position = UDim2.new(0, 10, 0, 0)
TL.BackgroundTransparency = 1
TL.Text = "★ MANI AVATAR SPAWNER"
TL.TextColor3 = Color3.fromRGB(255,220,100); TL.TextSize = 11
TL.Font = Enum.Font.GothamBlack; TL.TextXAlignment = Enum.TextXAlignment.Left
TL.Parent = TB

local MinB = Instance.new("TextButton")
MinB.Size = UDim2.new(0, 22, 0, 22); MinB.Position = UDim2.new(1, -50, 0, 4)
MinB.BackgroundColor3 = Color3.fromRGB(70,70,100)
MinB.Text = "—"; MinB.TextColor3 = Color3.fromRGB(230,230,240)
MinB.TextSize = 14; MinB.Font = Enum.Font.GothamBold
MinB.Parent = TB
Instance.new("UICorner", MinB).CornerRadius = UDim.new(0, 5)

local CloseB = Instance.new("TextButton")
CloseB.Size = UDim2.new(0, 22, 0, 22); CloseB.Position = UDim2.new(1, -26, 0, 4)
CloseB.BackgroundColor3 = Color3.fromRGB(170,55,55)
CloseB.Text = "X"; CloseB.TextColor3 = Color3.fromRGB(255,230,230)
CloseB.TextSize = 11; CloseB.Font = Enum.Font.GothamBold
CloseB.Parent = TB
Instance.new("UICorner", CloseB).CornerRadius = UDim.new(0, 5)

-- RESTORE BUTTON
local RB = Instance.new("TextButton")
RB.Size = UDim2.new(0, 46, 0, 46); RB.Position = UDim2.new(0, 20, 0.5, -23)
RB.BackgroundColor3 = Color3.fromRGB(60,120,220)
RB.Text = "★"; RB.TextSize = 22; RB.TextColor3 = Color3.fromRGB(255,230,120)
RB.Font = Enum.Font.GothamBlack; RB.Visible = false; RB.Active = true; RB.Draggable = true
RB.Parent = SG
Instance.new("UICorner", RB).CornerRadius = UDim.new(1, 0)
local rs = Instance.new("UIStroke", RB); rs.Color = Color3.fromRGB(255,220,100); rs.Thickness = 2

-- SCROLLING CONTENT
local SF = Instance.new("ScrollingFrame")
SF.Size = UDim2.new(1, -6, 1, -62)
SF.Position = UDim2.new(0, 3, 0, 34)
SF.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
SF.BorderSizePixel = 0
SF.ScrollBarThickness = 5
SF.ScrollBarImageColor3 = Color3.fromRGB(100, 130, 200)
SF.CanvasSize = UDim2.new(0, 0, 0, 1400)
SF.Parent = MF
Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 8)

-- STATUS BAR
local SB = Instance.new("TextLabel")
SB.Size = UDim2.new(1, -6, 0, 22)
SB.Position = UDim2.new(0, 3, 1, -24)
SB.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
SB.BackgroundTransparency = 0.15
SB.Text = "  Ready"
SB.TextColor3 = Color3.fromRGB(160,220,180); SB.TextSize = 10
SB.Font = Enum.Font.GothamBold; SB.TextXAlignment = Enum.TextXAlignment.Left
SB.TextWrapped = true; SB.Parent = MF
Instance.new("UICorner", SB).CornerRadius = UDim.new(0, 5)
_G.MANI_STATUS = SB

-- ============================================================
-- LAYOUT HELPERS (compact widths for 268px content area)
-- ============================================================
local W = 262  -- usable content width
local Y = 0
local function section(txt, col)
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, -6, 0, 20)
    h.Position = UDim2.new(0, 3, 0, Y)
    h.BackgroundColor3 = col or Color3.fromRGB(60, 80, 130)
    h.Text = "  " .. txt
    h.TextColor3 = Color3.fromRGB(255,255,255)
    h.TextSize = 11; h.Font = Enum.Font.GothamBold
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.Parent = SF
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 5)
    Y = Y + 24
end
local function label(txt, col)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -6, 0, 14)
    l.Position = UDim2.new(0, 3, 0, Y)
    l.BackgroundTransparency = 1
    l.Text = txt; l.TextColor3 = col or Color3.fromRGB(180,180,200)
    l.TextSize = 10; l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = SF
    Y = Y + 16
end
local function button(x, w, h, txt, col, sz)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, w, 0, h or 26)
    b.Position = UDim2.new(0, x or 3, 0, Y)
    b.BackgroundColor3 = col or Color3.fromRGB(55,55,80)
    b.TextColor3 = Color3.fromRGB(230,230,245)
    b.Text = txt; b.TextSize = sz or 11
    b.Font = Enum.Font.GothamBold; b.Parent = SF
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end
local function textbox(ph)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(1, -6, 0, 28)
    t.Position = UDim2.new(0, 3, 0, Y)
    t.BackgroundColor3 = Color3.fromRGB(45,45,60)
    t.TextColor3 = Color3.fromRGB(240,240,250)
    t.PlaceholderText = ph or ""
    t.PlaceholderColor3 = Color3.fromRGB(120,120,140)
    t.Text = ""; t.TextSize = 11; t.Font = Enum.Font.Gotham
    t.ClearTextOnFocus = false; t.Parent = SF
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 5)
    local p = Instance.new("UIPadding", t)
    p.PaddingLeft = UDim.new(0, 7); p.PaddingRight = UDim.new(0, 7)
    Y = Y + 32
    return t
end

-- Layout math: content width 262, gap 4, 2 columns of 129
local COL1_X, COL1_W = 3, 129
local COL2_X, COL2_W = 136, 129

-- ============================================================
-- SECTION: SPAWN
-- ============================================================
section("★ SPAWN AVATAR", Color3.fromRGB(70, 120, 200))
label("Roblox Username:")
local usernameBox = textbox("e.g. Builderman")
local spawnBtn = button(COL1_X, COL1_W, 30, "★ SPAWN ★", Color3.fromRGB(60,130,220), 12)
local delBtn   = button(COL2_X, COL2_W, 30, "🗑 Delete", Color3.fromRGB(160,55,55), 12)
Y = Y + 34

label("Quick Spawn (your friends):")
local quickBoxes = {}
for i = 1, 3 do
    local b = button(3, W, 22, "  (loading...)", Color3.fromRGB(45,45,65), 10)
    b.TextXAlignment = Enum.TextXAlignment.Left
    quickBoxes[i] = b
    Y = Y + 25
end

-- ============================================================
-- SECTION: POSITION
-- ============================================================
section("✥ POSITION", Color3.fromRGB(70, 130, 130))
label("D-Pad (moves dummy 3 studs):")

-- D-pad: 3 buttons in a row (up), then left/down/right in a row
local upBtn    = button(90, 82, 24, "↑ Forward", Color3.fromRGB(60,60,90), 10)
Y = Y + 27
local leftBtn  = button(3,   82, 24, "← Left",    Color3.fromRGB(60,60,90), 10)
local downBtn  = button(90,  82, 24, "↓ Back",    Color3.fromRGB(60,60,90), 10)
local rightBtn = button(177, 82, 24, "→ Right",   Color3.fromRGB(60,60,90), 10)
Y = Y + 28

local hUpBtn = button(COL1_X, COL1_W, 26, "▲ Height +", Color3.fromRGB(55,100,75), 11)
local hDnBtn = button(COL2_X, COL2_W, 26, "▼ Height −", Color3.fromRGB(100,55,55), 11)
Y = Y + 30

local tpBtn = button(3, W, 28, "⚡ Teleport to Me", Color3.fromRGB(100,100,200), 12)
Y = Y + 32

local aboveBtn  = button(3,   84, 24, "Above Me",  Color3.fromRGB(70,110,90), 10)
local behindBtn = button(90,  84, 24, "Behind Me", Color3.fromRGB(70,90,130), 10)
local onBtn     = button(177, 85, 24, "On Spot",   Color3.fromRGB(110,70,130), 10)
Y = Y + 28

-- ============================================================
-- SECTION: EMOTES
-- ============================================================
section("💃 EMOTES", Color3.fromRGB(150, 70, 140))
local waveB  = button(3,   84, 26, "👋 Wave",  Color3.fromRGB(70,90,140), 10)
local pointB = button(90,  84, 26, "👉 Point", Color3.fromRGB(70,90,140), 10)
local danceB = button(177, 85, 26, "💃 Dance", Color3.fromRGB(70,90,140), 10)
Y = Y + 30
local laughB = button(3,   84, 26, "😂 Laugh", Color3.fromRGB(80,100,150), 10)
local cheerB = button(90,  84, 26, "🎉 Cheer", Color3.fromRGB(80,100,150), 10)
local sitB   = button(177, 85, 26, "🪑 Sit",   Color3.fromRGB(80,120,90), 10)
Y = Y + 30
local hugB = button(COL1_X, COL1_W, 28, "🤗 HUG ME", Color3.fromRGB(190,80,160), 11)
local layB = button(COL2_X, COL2_W, 28, "🛌 Lay",    Color3.fromRGB(90,90,150), 11)
Y = Y + 32
local stopAllB = button(3, W, 26, "⏹ STOP ALL ANIMATIONS", Color3.fromRGB(150,60,60), 11)
Y = Y + 30

label("Customization:")
_G.MANI_SCALE_LBL = label("Scale: 1.00", Color3.fromRGB(180,220,255))
local sclUpB = button(3,   84, 24, "Scale +",     Color3.fromRGB(60,90,140), 10)
local sclDnB = button(90,  84, 24, "Scale −",     Color3.fromRGB(60,90,140), 10)
local sclRsB = button(177, 85, 24, "Reset",       Color3.fromRGB(90,90,130), 10)
Y = Y + 28
_G.MANI_ALPHA_LBL = label("Alpha: 1.0", Color3.fromRGB(200,200,240))
local alpUpB = button(3,   84, 24, "Alpha +",     Color3.fromRGB(90,90,140), 10)
local alpDnB = button(90,  84, 24, "Alpha −",     Color3.fromRGB(90,90,140), 10)
local alpRsB = button(177, 85, 24, "Reset",       Color3.fromRGB(90,90,130), 10)
Y = Y + 28

-- ============================================================
-- SECTION: TASKS
-- ============================================================
section("⚙ TASKS", Color3.fromRGB(90, 130, 70))
_G.MANI_GUARD_BTN = button(COL1_X, COL1_W, 28, "🛡 Guard Me", Color3.fromRGB(70,130,100), 11)
_G.MANI_SPIN_BTN  = button(COL2_X, COL2_W, 28, "🌀 Spin",     Color3.fromRGB(120,90,160), 11)
Y = Y + 32
local walkMeB = button(COL1_X, COL1_W, 26, "🚶 Walk to Me", Color3.fromRGB(60,110,170), 10)
local jumpB   = button(COL2_X, COL2_W, 26, "⬆ Jump",       Color3.fromRGB(60,110,170), 10)
Y = Y + 30
local wandB   = button(COL1_X, COL1_W, 26, "🌍 Wander",  Color3.fromRGB(60,130,130), 10)
local freezB  = button(COL2_X, COL2_W, 26, "❄ Freeze",   Color3.fromRGB(90,130,170), 10)
Y = Y + 30
_G.MANI_FOLLOW_BTN = button(COL1_X, COL1_W, 28, "Follow: OFF", Color3.fromRGB(60,60,80), 11)
_G.MANI_FF_BTN     = button(COL2_X, COL2_W, 28, "🛡 Shield", Color3.fromRGB(70,70,100), 11)
Y = Y + 32
_G.MANI_JUMP_BTN = button(COL1_X, COL1_W, 26, "Jump Loop", Color3.fromRGB(110,90,130), 10)
local faceMeB    = button(COL2_X, COL2_W, 26, "Face Me",   Color3.fromRGB(110,90,130), 10)
Y = Y + 30
local spdUpB = button(COL1_X, COL1_W, 26, "Speed: 18", Color3.fromRGB(70,100,140), 10)
local snapB  = button(COL2_X, COL2_W, 26, "Snap to Me", Color3.fromRGB(70,100,140), 10)
Y = Y + 30

-- ============================================================
-- SECTION: VISUALS
-- ============================================================
section("👁 VISUALS", Color3.fromRGB(130, 100, 60))
_G.MANI_TRAIL_BTN = button(COL1_X, COL1_W, 28, "✨ Trail: OFF", Color3.fromRGB(60,90,130), 11)
_G.MANI_HL_BTN    = button(COL2_X, COL2_W, 28, "🔦 Highlight", Color3.fromRGB(60,90,130), 11)
Y = Y + 32
_G.MANI_NAME_BTN  = button(COL1_X, COL1_W, 28, "🏷 Nametag", Color3.fromRGB(60,90,130), 11)
_G.MANI_RAIN_BTN  = button(COL2_X, COL2_W, 28, "🌈 Rainbow", Color3.fromRGB(90,60,130), 11)
Y = Y + 32
local espB    = button(COL1_X, COL1_W, 26, "Toggle ESP", Color3.fromRGB(60,130,90), 10)
local camDumB = button(COL2_X, COL2_W, 26, "Cam → Dummy", Color3.fromRGB(130,90,60), 10)
Y = Y + 30
local camMeB  = button(COL1_X, COL1_W, 26, "Cam → Me",   Color3.fromRGB(130,90,60), 10)
local hideB   = button(COL2_X, COL2_W, 26, "Hide Panel", Color3.fromRGB(90,60,60), 10)
Y = Y + 30

-- ============================================================
-- SECTION: MESSAGE
-- ============================================================
section("💬 FAKE MESSAGE", Color3.fromRGB(90, 100, 140))
label("Message dummy will 'say':")
local msgBox = textbox("Type a message...")
local p1 = button(3,   84, 22, "Hello!", Color3.fromRGB(60,60,90), 9)
local p2 = button(90,  84, 22, "I see you 👀", Color3.fromRGB(60,60,90), 9)
local p3 = button(177, 85, 22, "Follow me!", Color3.fromRGB(60,60,90), 9)
Y = Y + 26
label("Delay (s) for Schedule:")
local delayBox = textbox("e.g. 5")
local sendB  = button(COL1_X, COL1_W, 28, "💬 Send Now",  Color3.fromRGB(60,130,80), 11)
local schedB = button(COL2_X, COL2_W, 28, "⏰ Schedule",  Color3.fromRGB(130,100,60), 11)
Y = Y + 32
local autoBox = button(3, W, 28, "Auto Message: OFF", Color3.fromRGB(70,70,100), 11)
Y = Y + 32

-- ============================================================
-- SECTION: BROOKHAVEN
-- ============================================================
section("🌉 BROOKHAVEN", Color3.fromRGB(60, 90, 160))
local bhInfo = Instance.new("TextLabel")
bhInfo.Size = UDim2.new(1, -6, 0, 42)
bhInfo.Position = UDim2.new(0, 3, 0, Y)
bhInfo.BackgroundTransparency = 1
bhInfo.Text = "Loads player's REAL current outfit (clothes, accessories, face, body, animations). Works whether the player is online or offline."
bhInfo.TextColor3 = Color3.fromRGB(170,170,190); bhInfo.TextSize = 10
bhInfo.Font = Enum.Font.Gotham; bhInfo.TextWrapped = true
bhInfo.TextXAlignment = Enum.TextXAlignment.Left
bhInfo.Parent = SF
Y = Y + 46
label("Username:")
local bhBox = textbox("e.g. Builderman")
local bhSpawnB = button(3, W, 30, "🌉 SPAWN REAL AVATAR", Color3.fromRGB(70,130,200), 12)
Y = Y + 34
local bhMyB   = button(COL1_X, COL1_W, 28, "🌉 My Avatar", Color3.fromRGB(80,110,160), 11)
local bhNearB = button(COL2_X, COL2_W, 28, "📋 Nearest",  Color3.fromRGB(130,90,130), 11)
Y = Y + 34

SF.CanvasSize = UDim2.new(0, 0, 0, Y + 16)

-- ============================================================
-- EVENT BINDINGS
-- ============================================================
MinB.MouseButton1Click:Connect(function() MF.Visible = false; RB.Visible = true end)
RB.MouseButton1Click:Connect(function() MF.Visible = true; RB.Visible = false end)
CloseB.MouseButton1Click:Connect(function()
    fullReset()
    if D and D.Parent then D:Destroy() end
    if esp and esp.Parent then esp:Destroy() end
    SG:Destroy()
end)

spawnBtn.MouseButton1Click:Connect(function() spawnAvatar(usernameBox.Text, false) end)
usernameBox.FocusLost:Connect(function(e) if e then spawnAvatar(usernameBox.Text, false) end end)
delBtn.MouseButton1Click:Connect(function()
    fullReset()
    if D and D.Parent then D:Destroy() end
    if esp and esp.Parent then esp:Destroy() end
    D = nil
    status("Dummy deleted.", Color3.fromRGB(160,160,175))
end)

local function loadFriends()
    task.spawn(function()
        local friends = {}
        pcall(function()
            local pages = Players:GetFriendsAsync(LP.UserId)
            while true do
                for _, item in ipairs(pages:GetCurrentPage()) do
                    if #friends >= 3 then break end
                    table.insert(friends, item.Username)
                end
                if pages.IsFinished or #friends >= 3 then break end
                local ok = pcall(function() pages:AdvanceToNextPageAsync() end)
                if not ok then break end
            end
        end)
        for i = 1, 3 do
            if friends[i] then
                quickBoxes[i].Text = "  ▶ " .. friends[i]
                quickBoxes[i]:SetAttribute("U", friends[i])
            else
                quickBoxes[i].Text = "  (no friend " .. i .. ")"
                quickBoxes[i]:SetAttribute("U", nil)
            end
        end
    end)
end
for _, b in ipairs(quickBoxes) do
    b.MouseButton1Click:Connect(function()
        local u = b:GetAttribute("U")
        if u then usernameBox.Text = u; spawnAvatar(u, false) end
    end)
end

upBtn.MouseButton1Click:Connect(function() move("f") end)
downBtn.MouseButton1Click:Connect(function() move("b") end)
leftBtn.MouseButton1Click:Connect(function() move("l") end)
rightBtn.MouseButton1Click:Connect(function() move("r") end)
hUpBtn.MouseButton1Click:Connect(function()
    local _, h = parts(); if h then h.CFrame = h.CFrame + Vector3.new(0, CFG.MoveStep, 0) end
end)
hDnBtn.MouseButton1Click:Connect(function()
    local _, h = parts(); if h then h.CFrame = h.CFrame + Vector3.new(0, -CFG.MoveStep, 0) end
end)
tpBtn.MouseButton1Click:Connect(function()
    local _, h = parts(); local ch = LP.Character
    if not h or not ch then status("No dummy", Color3.fromRGB(220,120,80)); return end
    local mh = ch:FindFirstChild("HumanoidRootPart")
    if mh then
        h.CFrame = CFrame.new(mh.Position + mh.CFrame.LookVector * 6 + Vector3.new(0,3,0))
        status("Teleported.", Color3.fromRGB(80,200,120))
    end
end)
aboveBtn.MouseButton1Click:Connect(function()
    local _, h = parts(); local ch = LP.Character
    if h and ch then
        local mh = ch:FindFirstChild("HumanoidRootPart")
        if mh then h.CFrame = CFrame.new(mh.Position + Vector3.new(0,8,0)) end
    end
end)
behindBtn.MouseButton1Click:Connect(function()
    local _, h = parts(); local ch = LP.Character
    if h and ch then
        local mh = ch:FindFirstChild("HumanoidRootPart")
        if mh then h.CFrame = CFrame.new(mh.Position - mh.CFrame.LookVector * 6) end
    end
end)
onBtn.MouseButton1Click:Connect(function()
    local _, h = parts(); local ch = LP.Character
    if h and ch then
        local mh = ch:FindFirstChild("HumanoidRootPart")
        if mh then h.CFrame = CFrame.new(mh.Position) end
    end
end)

waveB.MouseButton1Click:Connect(function()  stopFollow(); stopWander(); stopGuard(); stopSpin(); playEmote(EM.Wave, true);  status("Waving", Color3.fromRGB(180,220,255)) end)
pointB.MouseButton1Click:Connect(function() stopFollow(); stopWander(); stopGuard(); stopSpin(); playEmote(EM.Point, true); status("Pointing", Color3.fromRGB(180,220,255)) end)
danceB.MouseButton1Click:Connect(function() stopFollow(); stopWander(); stopGuard(); stopSpin(); playEmote(EM.Dance, true); status("Dancing", Color3.fromRGB(180,220,255)) end)
laughB.MouseButton1Click:Connect(function() stopFollow(); stopWander(); stopGuard(); stopSpin(); playEmote(EM.Laugh, true); status("Laughing", Color3.fromRGB(180,220,255)) end)
cheerB.MouseButton1Click:Connect(function() stopFollow(); stopWander(); stopGuard(); stopSpin(); playEmote(EM.Cheer, true); status("Cheering", Color3.fromRGB(180,220,255)) end)
sitB.MouseButton1Click:Connect(function()
    local h = parts(); if not h then return end
    stopFollow(); stopWander(); stopGuard(); stopSpin()
    h.Sit = true; playEmote(EM.Sit, true); status("Sitting", Color3.fromRGB(180,240,200))
end)
layB.MouseButton1Click:Connect(function()
    stopFollow(); stopWander(); stopGuard(); stopSpin()
    playEmote(EM.Lay, true); status("Laying down", Color3.fromRGB(180,220,255))
end)
hugB.MouseButton1Click:Connect(function()
    local h, hrp = parts()
    local ch = LP.Character
    if not h or not hrp or not ch then return end
    local mh = ch:FindFirstChild("HumanoidRootPart"); if not mh then return end
    stopFollow(); stopWander(); stopGuard(); stopSpin(); stopEmote(); stopLoco()
    hrp.Anchored = false; h.PlatformStand = false
    status("Walking to hug you...", Color3.fromRGB(240,180,220))
    task.spawn(function()
        local t0 = tick()
        while tick() - t0 < 8 do
            if not D or not D.Parent then return end
            if (mh.Position - hrp.Position).Magnitude < 4 then break end
            h:MoveTo(mh.Position); task.wait(0.15)
        end
        if not D or not D.Parent then return end
        h:MoveTo(hrp.Position); task.wait(0.15)
        local lk = mh.Position - hrp.Position; lk = Vector3.new(lk.X, 0, lk.Z)
        if lk.Magnitude > 0.1 then hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lk.Unit) end
        playEmote(EM.Hug, true)
        status("Hugging you!", Color3.fromRGB(240,120,180))
    end)
end)
stopAllB.MouseButton1Click:Connect(function()
    local h = parts()
    stopEmote(); stopLoco(); stopWander(); stopGuard(); stopSpin()
    if h then h.Sit = false end
    status("All stopped.", Color3.fromRGB(160,160,175))
end)

sclUpB.MouseButton1Click:Connect(function() setScale(math.min(CFG.ScaleMax, scale + CFG.ScaleStep)) end)
sclDnB.MouseButton1Click:Connect(function() setScale(math.max(CFG.ScaleMin, scale - CFG.ScaleStep)) end)
sclRsB.MouseButton1Click:Connect(function() setScale(1) end)
alpUpB.MouseButton1Click:Connect(function() setAlpha(math.max(0, alpha - CFG.TransStep)) end)
alpDnB.MouseButton1Click:Connect(function() setAlpha(math.min(1, alpha + CFG.TransStep)) end)
alpRsB.MouseButton1Click:Connect(function() setAlpha(0) end)

_G.MANI_GUARD_BTN.MouseButton1Click:Connect(function()
    if not D or not D.Parent then status("Spawn a dummy first", Color3.fromRGB(220,120,80)); return end
    guardOn = not guardOn
    if guardOn then
        stopFollow(); stopWander(); stopEmote()
        _G.MANI_GUARD_BTN.Text = "🛡 Guarding"
        _G.MANI_GUARD_BTN.BackgroundColor3 = Color3.fromRGB(70,200,130)
        status("Guarding around you.", Color3.fromRGB(120,240,160))
        task.spawn(function()
            local ch = LP.Character; local i = 0
            while guardOn and D and D.Parent do
                local h, hrp = parts()
                local mh = ch and ch:FindFirstChild("HumanoidRootPart")
                if h and hrp and mh then
                    i = i + 1
                    local ang = (i * 30) * math.pi / 180
                    h:MoveTo(mh.Position + Vector3.new(math.cos(ang)*6, 0, math.sin(ang)*6))
                end
                task.wait(0.35)
            end
        end)
    else
        _G.MANI_GUARD_BTN.Text = "🛡 Guard Me"
        _G.MANI_GUARD_BTN.BackgroundColor3 = Color3.fromRGB(70,130,100)
        stopGuard()
        status("Guard OFF.", Color3.fromRGB(160,160,175))
    end
end)

_G.MANI_SPIN_BTN.MouseButton1Click:Connect(function()
    if not D or not D.Parent then status("Spawn a dummy first", Color3.fromRGB(220,120,80)); return end
    spinOn = not spinOn
    if spinOn then
        stopFollow(); stopWander()
        _G.MANI_SPIN_BTN.Text = "🌀 Spinning"
        _G.MANI_SPIN_BTN.BackgroundColor3 = Color3.fromRGB(180,130,220)
        status("Spinning...", Color3.fromRGB(200,160,255))
        task.spawn(function()
            while spinOn and D and D.Parent do
                local _, hrp = parts()
                if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0) end
                task.wait(0.03)
            end
        end)
    else
        _G.MANI_SPIN_BTN.Text = "🌀 Spin"
        _G.MANI_SPIN_BTN.BackgroundColor3 = Color3.fromRGB(120,90,160)
        stopSpin()
        status("Spin OFF.", Color3.fromRGB(160,160,175))
    end
end)

walkMeB.MouseButton1Click:Connect(function()
    local h, hrp = parts()
    local ch = LP.Character
    if not h or not hrp or not ch then return end
    local mh = ch:FindFirstChild("HumanoidRootPart"); if not mh then return end
    stopFollow(); stopWander(); stopGuard(); stopSpin(); stopEmote()
    hrp.Anchored = false; h.PlatformStand = false
    h:MoveTo(mh.Position)
    status("Walking to you...", Color3.fromRGB(120,220,160))
end)
jumpB.MouseButton1Click:Connect(function()
    local h = parts(); if h then h.Jump = true; status("Jump!", Color3.fromRGB(120,220,160)) end
end)
wandB.MouseButton1Click:Connect(function()
    local h, hrp = parts()
    if not h or not hrp then return end
    stopFollow(); stopGuard(); stopSpin(); stopEmote()
    hrp.Anchored = false; h.PlatformStand = false
    wanderOn = true
    status("Wandering...", Color3.fromRGB(180,200,120))
    task.spawn(function()
        while wanderOn and D and D.Parent do
            local p = hrp.Position
            h:MoveTo(p + Vector3.new(math.random(-15,15), 0, math.random(-15,15)))
            task.wait(2 + math.random() * 2)
        end
    end)
end)
freezB.MouseButton1Click:Connect(function()
    local h, hrp = parts()
    if h and hrp then
        stopFollow(); stopWander(); stopGuard(); stopSpin(); stopEmote(); stopLoco()
        h:MoveTo(hrp.Position)
        status("Frozen.", Color3.fromRGB(160,200,240))
    end
end)
_G.MANI_FOLLOW_BTN.MouseButton1Click:Connect(function()
    if not D or not D.Parent then status("Spawn a dummy first", Color3.fromRGB(220,120,80)); return end
    followOn = not followOn
    if followOn then
        stopWander(); stopGuard(); stopSpin(); stopEmote(); stopRain()
        _G.MANI_FOLLOW_BTN.Text = "Follow: ON"
        _G.MANI_FOLLOW_BTN.BackgroundColor3 = Color3.fromRGB(60,180,100)
        local h, hrp = parts()
        if hrp then hrp.Anchored = false end
        if h then h.PlatformStand = false end
        status("Following you...", Color3.fromRGB(120,220,160))
    else
        stopFollow()
        status("Follow disabled.", Color3.fromRGB(160,160,175))
    end
end)
_G.MANI_FF_BTN.MouseButton1Click:Connect(function()
    toggleFF(not ffOn)
    _G.MANI_FF_BTN.Text = ffOn and "🛡 Shield: ON" or "🛡 Shield"
    _G.MANI_FF_BTN.BackgroundColor3 = ffOn and Color3.fromRGB(80,180,220) or Color3.fromRGB(70,70,100)
    status(ffOn and "Shield ON" or "Shield OFF", Color3.fromRGB(140,200,240))
end)
_G.MANI_JUMP_BTN.MouseButton1Click:Connect(function()
    jumpLoopOn = not jumpLoopOn
    _G.MANI_JUMP_BTN.Text = jumpLoopOn and "Stop Jump" or "Jump Loop"
    _G.MANI_JUMP_BTN.BackgroundColor3 = jumpLoopOn and Color3.fromRGB(180,90,180) or Color3.fromRGB(110,90,130)
    if jumpLoopOn then
        task.spawn(function()
            while jumpLoopOn and D and D.Parent do
                local h = parts(); if h then h.Jump = true end
                task.wait(0.6)
            end
        end)
    end
end)
faceMeB.MouseButton1Click:Connect(function()
    local _, hrp = parts()
    local ch = LP.Character
    if not hrp or not ch then return end
    local mh = ch:FindFirstChild("HumanoidRootPart"); if not mh then return end
    local lk = Vector3.new(mh.Position.X - hrp.Position.X, 0, mh.Position.Z - hrp.Position.Z)
    if lk.Magnitude > 0.1 then
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lk.Unit)
        status("Facing you.", Color3.fromRGB(160,220,200))
    end
end)
spdUpB.MouseButton1Click:Connect(function()
    local h = parts(); if not h then return end
    CFG.FollowSpeed = CFG.FollowSpeed + 6
    if CFG.FollowSpeed > 40 then CFG.FollowSpeed = 12 end
    h.WalkSpeed = CFG.FollowSpeed
    spdUpB.Text = "Speed: " .. tostring(math.floor(CFG.FollowSpeed))
    status("Follow speed = " .. CFG.FollowSpeed, Color3.fromRGB(160,200,240))
end)
snapB.MouseButton1Click:Connect(function()
    local _, hrp = parts()
    local ch = LP.Character
    if not hrp or not ch then return end
    local mh = ch:FindFirstChild("HumanoidRootPart")
    if mh then
        hrp.CFrame = CFrame.new(mh.Position + Vector3.new(0, 0.5, 0))
        status("Snapped.", Color3.fromRGB(160,220,200))
    end
end)

_G.MANI_TRAIL_BTN.MouseButton1Click:Connect(function()
    toggleTrail(not trailOn)
    _G.MANI_TRAIL_BTN.Text = trailOn and "✨ Trail: ON" or "✨ Trail: OFF"
    _G.MANI_TRAIL_BTN.BackgroundColor3 = trailOn and Color3.fromRGB(120,180,250) or Color3.fromRGB(60,90,130)
end)
_G.MANI_HL_BTN.MouseButton1Click:Connect(function()
    toggleHL(not hlOn)
    _G.MANI_HL_BTN.Text = hlOn and "🔦 High: ON" or "🔦 Highlight"
    _G.MANI_HL_BTN.BackgroundColor3 = hlOn and Color3.fromRGB(120,180,250) or Color3.fromRGB(60,90,130)
end)
_G.MANI_NAME_BTN.MouseButton1Click:Connect(function()
    toggleName(not nameOn)
    _G.MANI_NAME_BTN.Text = nameOn and "🏷 Name: ON" or "🏷 Nametag"
    _G.MANI_NAME_BTN.BackgroundColor3 = nameOn and Color3.fromRGB(230,200,120) or Color3.fromRGB(60,90,130)
end)
_G.MANI_RAIN_BTN.MouseButton1Click:Connect(function()
    rainOn = not rainOn
    if not rainOn and D and D.Parent then
        for _, p in ipairs(D:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.Color = Color3.fromRGB(163,162,165)
            end
        end
    end
    _G.MANI_RAIN_BTN.Text = rainOn and "🌈 Rain: ON" or "🌈 Rainbow"
    _G.MANI_RAIN_BTN.BackgroundColor3 = rainOn and Color3.fromRGB(200,100,220) or Color3.fromRGB(90,60,130)
end)
espB.MouseButton1Click:Connect(function()
    if esp and esp.Parent then esp:Destroy(); esp = nil; status("ESP off.", Color3.fromRGB(160,160,175))
    else makeESP(); status("ESP on.", Color3.fromRGB(120,220,160)) end
end)
camDumB.MouseButton1Click:Connect(function()
    local _, hrp = parts()
    if hrp then workspace.CurrentCamera.CameraSubject = hrp; status("Cam → Dummy", Color3.fromRGB(255,200,120)) end
end)
camMeB.MouseButton1Click:Connect(function()
    local ch = LP.Character
    if ch then
        local h = ch:FindFirstChildOfClass("Humanoid")
        if h then workspace.CurrentCamera.CameraSubject = h; status("Cam → You", Color3.fromRGB(255,200,120)) end
    end
end)
hideB.MouseButton1Click:Connect(function() MF.Visible = false; RB.Visible = true end)

p1.MouseButton1Click:Connect(function() msgBox.Text = "Hello!" end)
p2.MouseButton1Click:Connect(function() msgBox.Text = "I'm watching you 👀" end)
p3.MouseButton1Click:Connect(function() msgBox.Text = "Follow me!" end)

sendB.MouseButton1Click:Connect(function()
    local m = (msgBox.Text or ""):match("^%s*(.-)%s*$")
    if m == "" then status("Type a message", Color3.fromRGB(220,120,80)); return end
    if not D or not D.Parent then status("Spawn a dummy first", Color3.fromRGB(220,120,80)); return end
    say(m, 5); status("Message sent.", Color3.fromRGB(120,220,160))
end)
schedB.MouseButton1Click:Connect(function()
    local m = (msgBox.Text or ""):match("^%s*(.-)%s*$")
    local d = tonumber(delayBox.Text)
    if m == "" then status("Type a message", Color3.fromRGB(220,120,80)); return end
    if not d or d < 0 then status("Invalid delay", Color3.fromRGB(220,120,80)); return end
    if not D or not D.Parent then status("Spawn a dummy first", Color3.fromRGB(220,120,80)); return end
    status(("Scheduled in %.1fs"):format(d), Color3.fromRGB(220,200,120))
    task.delay(d, function()
        if D and D.Parent then say(m, 5); status("Msg sent.", Color3.fromRGB(120,220,160)) end
    end)
end)
autoBox.MouseButton1Click:Connect(function()
    if autoMsgOn then
        autoMsgOn = false
        autoBox.Text = "Auto Message: OFF"
        autoBox.BackgroundColor3 = Color3.fromRGB(70,70,100)
        status("Auto OFF.", Color3.fromRGB(160,160,175))
        return
    end
    if not D or not D.Parent then status("Spawn a dummy first", Color3.fromRGB(220,120,80)); return end
    autoMsgOn = true
    autoBox.Text = "Auto Message: ON"
    autoBox.BackgroundColor3 = Color3.fromRGB(100,180,100)
    status("Auto ON.", Color3.fromRGB(120,220,160))
    task.spawn(function()
        while autoMsgOn do
            local txt = msgBox.Text
            if txt ~= "" and D and D.Parent then say(txt, 4) end
            task.wait(8)
        end
    end)
end)

-- Brookhaven
bhSpawnB.MouseButton1Click:Connect(function() spawnAvatar(bhBox.Text, true) end)
bhBox.FocusLost:Connect(function(e) if e then spawnAvatar(bhBox.Text, true) end end)
bhMyB.MouseButton1Click:Connect(function()
    bhBox.Text = LP.Name
    spawnAvatar(LP.Name, true)
end)
bhNearB.MouseButton1Click:Connect(function()
    local near, dist = nil, math.huge
    local ch = LP.Character
    local mh = ch and ch:FindFirstChild("HumanoidRootPart")
    if not mh then status("You need a character.", Color3.fromRGB(220,120,80)); return end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character then
            local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - mh.Position).Magnitude
                if d < dist then dist = d; near = pl end
            end
        end
    end
    if near then bhBox.Text = near.Name; spawnAvatar(near.Name, true)
    else status("No nearby players.", Color3.fromRGB(220,120,80)) end
end)

-- ============================================================
-- MAIN LOOPS
-- ============================================================
RunService.Heartbeat:Connect(function()
    if followOn and D and D.Parent then
        local ch = LP.Character
        local mh = ch and ch:FindFirstChild("HumanoidRootPart")
        local h, hrp = parts()
        if mh and h and hrp then
            if hrp.Anchored then hrp.Anchored = false end
            if h.PlatformStand then h.PlatformStand = false end
            if h.Sit then h.Sit = false end
            local mp, dp = mh.Position, hrp.Position
            local flat = Vector3.new(mp.X - dp.X, 0, mp.Z - dp.Z)
            if flat.Magnitude > CFG.FollowDist then
                h:MoveTo(mp - flat.Unit * CFG.FollowDist)
                if walkT and not walkT.IsPlaying then walkT:Play(0.15) end
                if idleT and idleT.IsPlaying then idleT:Stop(0.15) end
            else
                h:MoveTo(hrp.Position)
                if walkT and walkT.IsPlaying then walkT:Stop(0.2) end
                if idleT and not idleT.IsPlaying then idleT:Play(0.2) end
                local f = Vector3.new(mp.X - dp.X, 0, mp.Z - dp.Z)
                if f.Magnitude > 0.1 then hrp.CFrame = CFrame.new(dp, dp + f.Unit) end
            end
        end
    end
    if rainOn and D and D.Parent then
        local hue = (tick() * 0.5) % 1
        for _, p in ipairs(D:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.Color = Color3.fromHSV(hue, 0.85, 1)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(pl)
    if pl == LP then
        fullReset()
        if D and D.Parent then D:Destroy() end
    end
end)

-- ============================================================
-- INIT
-- ============================================================
status("Ready! Enter a username.", Color3.fromRGB(160,220,180))
task.spawn(function() task.wait(0.5); pcall(loadFriends) end)

print("[MANI AVATAR SPAWNER] Loaded. Size: 280x440. Canvas:", Y)
