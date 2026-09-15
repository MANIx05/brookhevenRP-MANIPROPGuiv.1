-- MANI PROP GUI V4 by @MANISH_K05
-- Smooth Auras + Profile + Snake + Realistic Rope
-- Fixed: minimize toggles, full-screen toggle, aura follows player, props work

local AllAuraConfigs = {
    SoftGlow = { name = "Soft Glow", speed = 0.5, radius = 12, offsetY = 0, rotation = 0, type = "circle", color = "🟢" },
    FreshBreeze = { name = "Fresh Breeze", speed = 0.7, radius = 14, offsetY = 2, rotation = 15, type = "circle", color = "🟢" },
    CalmRing = { name = "Calm Ring", speed = 0.3, radius = 10, offsetY = 1, rotation = 0, type = "circle", color = "🟢" },
    TinyOrbit = { name = "Tiny Orbit", speed = 1.2, radius = 8, offsetY = 0, rotation = 0, type = "circle", color = "🟢" },
    SimpleHalo = { name = "Simple Halo", speed = 0.4, radius = 13, offsetY = 3, rotation = 0, type = "circle", color = "🟢" },
    FloatingMist = { name = "Floating Mist", speed = 0.2, radius = 16, offsetY = 5, rotation = 10, type = "circle", color = "🟢" },
    GentleWave = { name = "Gentle Wave", speed = 0.8, radius = 11, offsetY = 1, rotation = 0, type = "wave", color = "🟢" },
    LightBloom = { name = "Light Bloom", speed = 0.6, radius = 9, offsetY = 0, rotation = 5, type = "circle", color = "🟢" },
    MiniSpiral = { name = "Mini Spiral", speed = 0.9, radius = 10, offsetY = 2, rotation = 0, type = "spiral", color = "🟢" },
    CloudRing = { name = "Cloud Ring", speed = 0.2, radius = 18, offsetY = 4, rotation = 0, type = "circle", color = "🟢" },
    SoftOrbit = { name = "Soft Orbit", speed = 0.5, radius = 12, offsetY = 0, rotation = 0, type = "circle", color = "🟢" },
    BrightCircle = { name = "Bright Circle", speed = 0.6, radius = 14, offsetY = 1, rotation = 0, type = "circle", color = "🟢" },
    PeaceAura = { name = "Peace Aura", speed = 0.3, radius = 16, offsetY = 2, rotation = 5, type = "circle", color = "🟢" },
    BreezeHalo = { name = "Breeze Halo", speed = 0.7, radius = 13, offsetY = 3, rotation = 0, type = "circle", color = "🟢" },
    MorningGlow = { name = "Morning Glow", speed = 0.4, radius = 15, offsetY = 1, rotation = 10, type = "circle", color = "🟢" },
    FloatingStars = { name = "Floating Stars", speed = 0.8, radius = 11, offsetY = 4, rotation = 0, type = "star", color = "🟢" },
    LittleGalaxy = { name = "Little Galaxy", speed = 0.5, radius = 17, offsetY = 2, rotation = 15, type = "spiral", color = "🟢" },
    DreamRing = { name = "Dream Ring", speed = 0.3, radius = 14, offsetY = 0, rotation = 0, type = "double", color = "🟢" },
    PureHalo = { name = "Pure Halo", speed = 0.4, radius = 12, offsetY = 3, rotation = 0, type = "circle", color = "🟢" },
    SkyBloom = { name = "Sky Bloom", speed = 0.6, radius = 18, offsetY = 5, rotation = 8, type = "circle", color = "🟢" },
    AquaOrbit = { name = "Aqua Orbit", speed = 0.7, radius = 13, offsetY = 1, rotation = 5, type = "circle", color = "🔵" },
    FrostRing = { name = "Frost Ring", speed = 0.4, radius = 11, offsetY = 0, rotation = 0, type = "circle", color = "🔵" },
    CrystalWave = { name = "Crystal Wave", speed = 0.9, radius = 14, offsetY = 2, rotation = 0, type = "wave", color = "🔵" },
    WindSpiral = { name = "Wind Spiral", speed = 1.0, radius = 12, offsetY = 1, rotation = 10, type = "spiral", color = "🔵" },
    Rainfall = { name = "Rainfall", speed = 0.5, radius = 15, offsetY = 4, rotation = 0, type = "circle", color = "🔵" },
    BlueComet = { name = "Blue Comet", speed = 1.2, radius = 10, offsetY = 0, rotation = 15, type = "circle", color = "🔵" },
    IceHalo = { name = "Ice Halo", speed = 0.3, radius = 13, offsetY = 3, rotation = 0, type = "circle", color = "🔵" },
    MistSpiral = { name = "Mist Spiral", speed = 0.6, radius = 16, offsetY = 2, rotation = 5, type = "spiral", color = "🔵" },
    OceanRing = { name = "Ocean Ring", speed = 0.4, radius = 14, offsetY = 1, rotation = 0, type = "circle", color = "🔵" },
    CloudSpiral = { name = "Cloud Spiral", speed = 0.3, radius = 17, offsetY = 5, rotation = 8, type = "spiral", color = "🔵" },
    SnowOrbit = { name = "Snow Orbit", speed = 0.5, radius = 14, offsetY = 1, rotation = 0, type = "circle", color = "🔵" },
    SilverBloom = { name = "Silver Bloom", speed = 0.6, radius = 16, offsetY = 2, rotation = 5, type = "circle", color = "🔵" },
    MoonRing = { name = "Moon Ring", speed = 0.3, radius = 12, offsetY = 0, rotation = 0, type = "circle", color = "🔵" },
    StarOrbit = { name = "Star Orbit", speed = 0.8, radius = 13, offsetY = 3, rotation = 10, type = "star", color = "🔵" },
    SkySpiral = { name = "Sky Spiral", speed = 0.7, radius = 15, offsetY = 2, rotation = 12, type = "spiral", color = "🔵" },
    FrozenHalo = { name = "Frozen Halo", speed = 0.4, radius = 11, offsetY = 4, rotation = 0, type = "circle", color = "🔵" },
    CrystalOrbit = { name = "Crystal Orbit", speed = 0.9, radius = 17, offsetY = 1, rotation = 15, type = "circle", color = "🔵" },
    TidalWave = { name = "Tidal Wave", speed = 0.5, radius = 18, offsetY = 3, rotation = 0, type = "wave", color = "🔵" },
    WinterBloom = { name = "Winter Bloom", speed = 0.4, radius = 14, offsetY = 2, rotation = 8, type = "circle", color = "🔵" },
    ArcticRing = { name = "Arctic Ring", speed = 0.3, radius = 16, offsetY = 5, rotation = 0, type = "double", color = "🔵" },
    MysticSpiral = { name = "Mystic Spiral", speed = 0.8, radius = 14, offsetY = 2, rotation = 10, type = "spiral", color = "🟣" },
    PhantomRing = { name = "Phantom Ring", speed = 0.5, radius = 12, offsetY = 0, rotation = 0, type = "double", color = "🟣" },
    ArcaneOrbit = { name = "Arcane Orbit", speed = 0.7, radius = 15, offsetY = 1, rotation = 8, type = "circle", color = "🟣" },
    SoulHalo = { name = "Soul Halo", speed = 0.4, radius = 13, offsetY = 3, rotation = 0, type = "circle", color = "🟣" },
    AstralBloom = { name = "Astral Bloom", speed = 0.6, radius = 16, offsetY = 2, rotation = 12, type = "star", color = "🟣" },
    RuneCircle = { name = "Rune Circle", speed = 0.3, radius = 11, offsetY = 0, rotation = 15, type = "circle", color = "🟣" },
    DreamSpiral = { name = "Dream Spiral", speed = 0.9, radius = 14, offsetY = 3, rotation = 0, type = "spiral", color = "🟣" },
    SpiritOrbit = { name = "Spirit Orbit", speed = 0.5, radius = 17, offsetY = 4, rotation = 6, type = "circle", color = "🟣" },
    Moonveil = { name = "Moonveil", speed = 0.4, radius = 12, offsetY = 1, rotation = 0, type = "wave", color = "🟣" },
    Starveil = { name = "Starveil", speed = 0.7, radius = 15, offsetY = 2, rotation = 10, type = "star", color = "🟣" },
    EtherRing = { name = "Ether Ring", speed = 0.5, radius = 16, offsetY = 1, rotation = 0, type = "double", color = "🟣" },
    MirageOrbit = { name = "Mirage Orbit", speed = 0.8, radius = 14, offsetY = 2, rotation = 8, type = "circle", color = "🟣" },
    TwilightHalo = { name = "Twilight Halo", speed = 0.4, radius = 17, offsetY = 3, rotation = 5, type = "circle", color = "🟣" },
    SpectralBloom = { name = "Spectral Bloom", speed = 0.6, radius = 18, offsetY = 4, rotation = 10, type = "spiral", color = "🟣" },
    MysticCrown = { name = "Mystic Crown", speed = 0.3, radius = 13, offsetY = 5, rotation = 0, type = "circle", color = "🟣" },
    AstralRing = { name = "Astral Ring", speed = 0.7, radius = 15, offsetY = 0, rotation = 12, type = "circle", color = "🟣" },
    PhantomOrbit = { name = "Phantom Orbit", speed = 0.9, radius = 12, offsetY = 2, rotation = 15, type = "wave", color = "🟣" },
    SoulSpiral = { name = "Soul Spiral", speed = 0.5, radius = 19, offsetY = 3, rotation = 6, type = "spiral", color = "🟣" },
    ArcaneBloom = { name = "Arcane Bloom", speed = 0.6, radius = 16, offsetY = 2, rotation = 9, type = "star", color = "🟣" },
    Dreamveil = { name = "Dreamveil", speed = 0.4, radius = 14, offsetY = 4, rotation = 0, type = "double", color = "🟣" },
    SolarCrown = { name = "Solar Crown", speed = 0.6, radius = 15, offsetY = 3, rotation = 0, type = "double", color = "🟠" },
    LunarCrown = { name = "Lunar Crown", speed = 0.4, radius = 14, offsetY = 2, rotation = 10, type = "double", color = "🟠" },
    ThunderRing = { name = "Thunder Ring", speed = 1.2, radius = 13, offsetY = 0, rotation = 5, type = "wave", color = "🟠" },
    FlameOrbit = { name = "Flame Orbit", speed = 0.9, radius = 16, offsetY = 1, rotation = 8, type = "spiral", color = "🟠" },
    FrostCrown = { name = "Frost Crown", speed = 0.3, radius = 12, offsetY = 4, rotation = 0, type = "circle", color = "🟠" },
    StormSpiral = { name = "Storm Spiral", speed = 1.0, radius = 17, offsetY = 2, rotation = 12, type = "spiral", color = "🟠" },
    CometHalo = { name = "Comet Halo", speed = 0.8, radius = 14, offsetY = 1, rotation = 15, type = "star", color = "🟠" },
    MeteorRing = { name = "Meteor Ring", speed = 1.1, radius = 11, offsetY = 0, rotation = 0, type = "circle", color = "🟠" },
    GalaxyOrbit = { name = "Galaxy Orbit", speed = 0.5, radius = 18, offsetY = 3, rotation = 6, type = "circle", color = "🟠" },
    NebulaBloom = { name = "Nebula Bloom", speed = 0.4, radius = 16, offsetY = 4, rotation = 10, type = "star", color = "🟠" },
    GravityRing = { name = "Gravity Ring", speed = 0.5, radius = 16, offsetY = 0, rotation = 0, type = "double", color = "🟠" },
    EnergySpiral = { name = "Energy Spiral", speed = 0.9, radius = 15, offsetY = 2, rotation = 8, type = "spiral", color = "🟠" },
    VortexHalo = { name = "Vortex Halo", speed = 0.7, radius = 18, offsetY = 3, rotation = 5, type = "wave", color = "🟠" },
    PlasmaOrbit = { name = "Plasma Orbit", speed = 1.0, radius = 14, offsetY = 1, rotation = 12, type = "circle", color = "🟠" },
    SolarSpiral = { name = "Solar Spiral", speed = 0.6, radius = 19, offsetY = 4, rotation = 15, type = "spiral", color = "🟠" },
    ThunderCrown = { name = "Thunder Crown", speed = 0.8, radius = 13, offsetY = 5, rotation = 0, type = "double", color = "🟠" },
    CosmicRing = { name = "Cosmic Ring", speed = 0.4, radius = 17, offsetY = 1, rotation = 10, type = "circle", color = "🟠" },
    Starstorm = { name = "Starstorm", speed = 1.1, radius = 12, offsetY = 2, rotation = 6, type = "star", color = "🟠" },
    SupernovaHalo = { name = "Supernova Halo", speed = 0.7, radius = 20, offsetY = 3, rotation = 8, type = "wave", color = "🟠" },
    CelestialOrbit = { name = "Celestial Orbit", speed = 0.5, radius = 16, offsetY = 2, rotation = 12, type = "circle", color = "🟠" },
    EclipseCrown = { name = "Eclipse Crown", speed = 0.5, radius = 16, offsetY = 4, rotation = 8, type = "double", color = "🔴" },
    VoidSpiral = { name = "Void Spiral", speed = 1.0, radius = 14, offsetY = 1, rotation = 12, type = "spiral", color = "🔴" },
    InfinityRing = { name = "Infinity Ring", speed = 0.4, radius = 13, offsetY = 0, rotation = 0, type = "double", color = "🔴" },
    EternalOrbit = { name = "Eternal Orbit", speed = 0.6, radius = 17, offsetY = 2, rotation = 6, type = "circle", color = "🔴" },
    DivineHalo = { name = "Divine Halo", speed = 0.3, radius = 15, offsetY = 5, rotation = 0, type = "circle", color = "🔴" },
    AncientCrown = { name = "Ancient Crown", speed = 0.4, radius = 12, offsetY = 3, rotation = 10, type = "star", color = "🔴" },
    ImmortalSpiral = { name = "Immortal Spiral", speed = 0.9, radius = 18, offsetY = 2, rotation = 15, type = "spiral", color = "🔴" },
    RealityRing = { name = "Reality Ring", speed = 0.5, radius = 14, offsetY = 0, rotation = 5, type = "wave", color = "🔴" },
    DimensionOrbit = { name = "Dimension Orbit", speed = 0.7, radius = 16, offsetY = 3, rotation = 8, type = "circle", color = "🔴" },
    TimeflowHalo = { name = "Timeflow Halo", speed = 0.3, radius = 13, offsetY = 4, rotation = 0, type = "wave", color = "🔴" },
    CosmicCrown = { name = "Cosmic Crown", speed = 0.4, radius = 18, offsetY = 4, rotation = 6, type = "double", color = "🔴" },
    UniverseSpiral = { name = "Universe Spiral", speed = 0.8, radius = 20, offsetY = 2, rotation = 12, type = "spiral", color = "🔴" },
    InfinityBloom = { name = "Infinity Bloom", speed = 0.5, radius = 16, offsetY = 3, rotation = 8, type = "star", color = "🔴" },
    CelestialCrown = { name = "Celestial Crown", speed = 0.3, radius = 17, offsetY = 5, rotation = 0, type = "circle", color = "🔴" },
    EternityRing = { name = "Eternity Ring", speed = 0.4, radius = 14, offsetY = 0, rotation = 10, type = "double", color = "🔴" },
    AstralDominion = { name = "Astral Dominion", speed = 0.6, radius = 19, offsetY = 3, rotation = 5, type = "circle", color = "🔴" },
    DivineOrbit = { name = "Divine Orbit", speed = 0.5, radius = 15, offsetY = 2, rotation = 12, type = "wave", color = "🔴" },
    RealityHalo = { name = "Reality Halo", speed = 0.4, radius = 16, offsetY = 4, rotation = 0, type = "circle", color = "🔴" },
    InfiniteSpiral = { name = "Infinite Spiral", speed = 0.9, radius = 18, offsetY = 1, rotation = 15, type = "spiral", color = "🔴" },
    EternalBloom = { name = "Eternal Bloom", speed = 0.5, radius = 17, offsetY = 3, rotation = 8, type = "star", color = "🔴" },
    ChaosCrown = { name = "Chaos Crown", speed = 0.8, radius = 18, offsetY = 4, rotation = 12, type = "double", color = "🟡" },
    AbyssOrbit = { name = "Abyss Orbit", speed = 0.6, radius = 16, offsetY = 2, rotation = 8, type = "circle", color = "🟡" },
    OblivionRing = { name = "Oblivion Ring", speed = 0.5, radius = 14, offsetY = 0, rotation = 0, type = "double", color = "🟡" },
    VoidCrown = { name = "Void Crown", speed = 0.4, radius = 17, offsetY = 5, rotation = 10, type = "circle", color = "🟡" },
    DarkstarSpiral = { name = "Darkstar Spiral", speed = 1.0, radius = 15, offsetY = 3, rotation = 15, type = "spiral", color = "🟡" },
    BlackholeHalo = { name = "Blackhole Halo", speed = 0.3, radius = 13, offsetY = 1, rotation = 0, type = "wave", color = "🟡" },
    EndworldOrbit = { name = "Endworld Orbit", speed = 0.7, radius = 19, offsetY = 2, rotation = 6, type = "circle", color = "🟡" },
    PhantomDominion = { name = "Phantom Dominion", speed = 0.9, radius = 14, offsetY = 4, rotation = 12, type = "star", color = "🟡" },
    AbyssalCrown = { name = "Abyssal Crown", speed = 0.5, radius = 16, offsetY = 3, rotation = 8, type = "double", color = "🟡" },
    InfiniteVoid = { name = "Infinite Void", speed = 0.6, radius = 12, offsetY = 0, rotation = 5, type = "spiral", color = "🟡" },
    RealityBreaker = { name = "Reality Breaker", speed = 0.9, radius = 20, offsetY = 3, rotation = 10, type = "spiral", color = "🟡" },
    CosmicDestroyer = { name = "Cosmic Destroyer", speed = 0.7, radius = 18, offsetY = 4, rotation = 8, type = "double", color = "🟡" },
    EternalVoid = { name = "Eternal Void", speed = 0.5, radius = 17, offsetY = 2, rotation = 12, type = "wave", color = "🟡" },
    DimensionBreak = { name = "Dimension Break", speed = 0.8, radius = 19, offsetY = 1, rotation = 15, type = "circle", color = "🟡" },
    ChaosSpiral = { name = "Chaos Spiral", speed = 1.0, radius = 16, offsetY = 3, rotation = 6, type = "spiral", color = "🟡" },
    Voidstorm = { name = "Voidstorm", speed = 0.6, radius = 21, offsetY = 5, rotation = 10, type = "star", color = "🟡" },
    BlackstarCrown = { name = "Blackstar Crown", speed = 0.4, radius = 15, offsetY = 4, rotation = 0, type = "double", color = "🟡" },
    OblivionHalo = { name = "Oblivion Halo", speed = 0.5, radius = 18, offsetY = 2, rotation = 8, type = "circle", color = "🟡" },
    ZeroPoint = { name = "Zero Point", speed = 0.3, radius = 14, offsetY = 0, rotation = 5, type = "wave", color = "🟡" },
    FinalEclipse = { name = "Final Eclipse", speed = 0.7, radius = 22, offsetY = 3, rotation = 12, type = "double", color = "🟡" },
    NOVA15 = { name = "NOVA-15", speed = 1.5, radius = 20, offsetY = 3, rotation = 15, type = "double", color = "💠" },
    Fifteenfold = { name = "Fifteenfold", speed = 0.8, radius = 18, offsetY = 2, rotation = 10, type = "spiral", color = "💠" },
    Prophecy = { name = "Prophecy", speed = 0.6, radius = 16, offsetY = 4, rotation = 8, type = "star", color = "💠" },
    TheCollector = { name = "The Collector", speed = 0.4, radius = 14, offsetY = 1, rotation = 0, type = "circle", color = "💠" },
    LostFormation = { name = "Lost Formation", speed = 0.7, radius = 17, offsetY = 3, rotation = 12, type = "wave", color = "💠" },
    ForbiddenOrbit = { name = "Forbidden Orbit", speed = 0.9, radius = 15, offsetY = 0, rotation = 6, type = "double", color = "💠" },
    UnknownEntity = { name = "Unknown Entity", speed = 0.5, radius = 19, offsetY = 5, rotation = 10, type = "spiral", color = "💠" },
    ZeroGravity = { name = "Zero Gravity", speed = 0.3, radius = 13, offsetY = 2, rotation = 0, type = "circle", color = "💠" },
    BeyondReality = { name = "Beyond Reality", speed = 1.0, radius = 16, offsetY = 4, rotation = 15, type = "star", color = "💠" },
    TheLastAura = { name = "The Last Aura", speed = 0.6, radius = 14, offsetY = 1, rotation = 8, type = "wave", color = "💠" },
    HiddenDimension = { name = "Hidden Dimension", speed = 0.8, radius = 22, offsetY = 3, rotation = 12, type = "double", color = "💠" },
    InfiniteMachinery = { name = "Infinite Machinery", speed = 0.6, radius = 18, offsetY = 2, rotation = 10, type = "spiral", color = "💠" },
    AbsoluteZero = { name = "Absolute Zero", speed = 0.4, radius = 16, offsetY = 1, rotation = 0, type = "circle", color = "💠" },
    Worldbreaker = { name = "Worldbreaker", speed = 0.9, radius = 24, offsetY = 4, rotation = 15, type = "star", color = "💠" },
    EternalMachinery = { name = "Eternal Machinery", speed = 0.7, radius = 20, offsetY = 3, rotation = 8, type = "double", color = "💠" },
    UnknownSignal = { name = "Unknown Signal", speed = 0.5, radius = 17, offsetY = 2, rotation = 6, type = "wave", color = "💠" },
    The15thRealm = { name = "The 15th Realm", speed = 0.3, radius = 15, offsetY = 0, rotation = 5, type = "circle", color = "💠" },
    Singularity = { name = "Singularity", speed = 1.0, radius = 21, offsetY = 5, rotation = 12, type = "spiral", color = "💠" },
    Realityexe = { name = "Reality.exe", speed = 0.8, radius = 19, offsetY = 3, rotation = 10, type = "double", color = "💠" }
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentAura = nil
local auraRunning = false
local auraThread = nil
local auraToken = 0

local propList = {}
local centerPosition = nil
local propFolder = nil
local totalProps = 0

-- =========================================================
-- PROP ENGINE
-- Uses the same server RemoteFunction as the working
-- SetCurrentCFrame prop-handle script.
-- =========================================================

local function getPropFolder()
    local workspaceCom = workspace:FindFirstChild("WorkspaceCom")
    if not workspaceCom then
        return nil
    end

    return workspaceCom:FindFirstChild("001_TrafficCones")
end

local function findSetCurrentCFrame(prop)
    if not prop then
        return nil
    end

    -- The known-working prop script uses this as a direct child.
    local remote = prop:FindFirstChild("SetCurrentCFrame")
    if remote and remote:IsA("RemoteFunction") then
        return remote
    end

    -- Extra robustness if the RemoteFunction is nested.
    for _, descendant in ipairs(prop:GetDescendants()) do
        if descendant.Name == "SetCurrentCFrame"
            and descendant:IsA("RemoteFunction") then
            return descendant
        end
    end

    return nil
end

local function findProps()
    table.clear(propList)
    propFolder = getPropFolder()
    totalProps = 0

    if not propFolder then
        return false
    end

    local playerName = LocalPlayer.Name

    -- IMPORTANT:
    -- Only use props whose name contains the local player's
    -- username, matching the user's working prop script.
    for _, prop in ipairs(propFolder:GetChildren()) do
        if (prop:IsA("BasePart") or prop:IsA("Model"))
            and string.find(prop.Name, playerName, 1, true) then
            table.insert(propList, prop)
        end
    end

    if #propList == 0 then
        return false
    end

    -- Prefer 25 props when available.
    -- If fewer exist, use every owned prop instead of failing.
    totalProps = math.min(#propList, 25)

    return true
end

local function moveProp(prop, targetCFrame)
    if not prop or not prop.Parent then
        return
    end

    local setCF = findSetCurrentCFrame(prop)

    if setCF then
        -- This is the actual working prop movement method.
        local ok, err = pcall(function()
            setCF:InvokeServer(targetCFrame)
        end)

        if not ok then
            warn("[MANI AURA] SetCurrentCFrame failed:", err)
        end

        return
    end

    -- Local fallback only when the prop has no remote.
    pcall(function()
        if prop:IsA("BasePart") then
            prop.CFrame = targetCFrame
        elseif prop:IsA("Model") then
            prop:PivotTo(targetCFrame)
        end
    end)
end

local function getCharacter()
    local character = LocalPlayer.Character

    if not character or not character.Parent then
        return nil
    end

    return character
end

-- =========================================================
-- SMOOTH AURA ENGINE
-- =========================================================
local auraStyleCache = {}
local function hashAura(key)
    local h=7
    for i=1,#tostring(key) do h=(h*31+string.byte(tostring(key),i))%100000 end
    return h
end
local function getAuraStyle(key)
    if auraStyleCache[key] then return auraStyleCache[key] end
    local h=hashAura(key)
    local st={
        family=(h%14)+1, phase=(h%628)/100,
        direction=(h%2==0) and 1 or -1,
        pulse=.35+(h%80)/100, twist=((h%360)*math.pi/180),
        height=.7+(h%170)/100, wave=.5+(h%130)/100,
        petals=3+(h%7), tilt=((h%30)-15)*math.pi/180
    }
    auraStyleCache[key]=st
    return st
end

local function getAuraCFrame(auraKey, config, index, total, elapsed, center)
    local speed=tonumber(config.speed) or .5
    local R=tonumber(config.radius) or 12
    local baseY=tonumber(config.offsetY) or 0
    local rot=math.rad(tonumber(config.rotation) or 0)
    local st=getAuraStyle(auraKey)
    local u=index/total
    local a=(math.pi*2*u)+elapsed*speed*st.direction+rot+st.phase
    local r,y=R,baseY
    local fam=st.family

    if fam==1 then -- breathing halo
        r=R*(1+.12*math.sin(elapsed*speed*2+st.phase))
        y=baseY+.35*math.sin(elapsed*speed*2+index*.4)
    elseif fam==2 then -- flower
        r=R*(.72+.28*(.5+.5*math.sin(a*st.petals)))
        y=baseY+.8*math.sin(a*st.petals+elapsed*speed)
    elseif fam==3 then -- helix
        r=R*(.72+.28*u); y=baseY+(u-.5)*5+1.1*math.sin(elapsed*speed*2+a)
        a=a+u*math.pi*2
    elseif fam==4 then -- star spikes
        local spike=(index%2==0) and 1.18 or .62
        r=R*spike*(.95+.06*math.sin(elapsed*speed*3+index))
        y=baseY+.45*math.sin(elapsed*speed*2+index)
    elseif fam==5 then -- double orbit
        r=R*((index%2==0) and 1.15 or .72)
        y=baseY+((index%2==0) and 1.15 or -1.15)+.45*math.sin(elapsed*speed+index)
        a=a+((index%2==0) and .2 or math.pi)
    elseif fam==6 then -- wave ring
        r=R+math.sin(a*3+elapsed*speed*2)*2.4
        y=baseY+math.sin(a*2+elapsed*speed*2)*1.2
    elseif fam==7 then -- vortex
        r=R*(.5+.5*u)+math.sin(elapsed*speed+a)*1.3
        y=baseY+(u-.5)*4
        a=a+u*math.pi*4
    elseif fam==8 then -- crown
        r=R*(.65+.35*math.abs(math.sin(a*2)))
        y=baseY+2.2+.8*math.cos(a*3+elapsed*speed)
    elseif fam==9 then -- comet
        r=R*(.72+.28*u)
        y=baseY+.6*math.sin(a*2)
        a=a+u*.9
    elseif fam==10 then -- galaxy
        r=R*(.55+.45*u)
        y=baseY+(u-.5)*2.5+math.sin(a*2+elapsed)*.5
        a=a+u*math.pi*3
    elseif fam==11 then -- diamond
        local d=math.abs(math.sin(a)); r=R*(.65+.5*d); y=baseY+math.cos(a*2)*1.1
    elseif fam==12 then -- orbital rings
        r=R*(index%3==0 and 1.15 or .82)
        y=baseY+math.sin(a*2+index)*1.6
        a=a+(index%3)*1.1
    elseif fam==13 then -- pulse spiral
        r=R*(.65+.35*u)+math.sin(elapsed*speed*3+index)*1.5
        y=baseY+math.sin(elapsed*speed*2+index*.8)*1.5
        a=a+u*math.pi*5
    else -- infinity
        local x=math.sin(a)*R
        local z=math.sin(a*2)*R*.62
        local pos=center+Vector3.new(x,baseY+math.cos(a*2)*1.2,z)
        return CFrame.lookAt(pos,center)
    end

    -- Preserve original config type as a subtle secondary motion layer.
    if config.type=='wave' then
        r=r+math.sin(a*3+elapsed*speed*2)*1.0
    elseif config.type=='spiral' then
        r=r+u*2.0; y=y+(u-.5)*1.4
    elseif config.type=='star' then
        r=r+((index%2==0) and 1.1 or -.7)
    elseif config.type=='double' then
        y=y+((index%2==0) and .45 or -.45)
    end
    local pos=center+Vector3.new(math.cos(a)*r,y,math.sin(a)*r)
    local look=CFrame.lookAt(pos,center)
    return look*CFrame.Angles(st.tilt,0,st.twist+math.sin(elapsed*speed+st.phase)*.08)
end

local function runAuraAnimation(auraKey, config, token)
    local updateInterval=.055
    while auraRunning and currentAura==auraKey and auraToken==token do
        local character=getCharacter()
        local hrp=character and character:FindFirstChild('HumanoidRootPart')
        if not hrp then task.wait(.1); continue end
        if not propFolder or not propFolder.Parent or #propList==0 then findProps() end
        local total=math.min(totalProps,#propList)
        if total>0 then
            centerPosition=centerPosition and centerPosition:Lerp(hrp.Position,.32) or hrp.Position
            local elapsed=os.clock()
            for index=1,total do
                if not auraRunning or currentAura~=auraKey or auraToken~=token then break end
                local prop=propList[index]
                if prop and prop.Parent then
                    local target=getAuraCFrame(auraKey,config,index,total,elapsed,centerPosition)
                    moveProp(prop,target)
                end
            end
        end
        task.wait(updateInterval)
    end
end

local function stopAura()
    auraRunning=false; currentAura=nil; auraToken+=1; auraThread=nil
end
local function startAura(auraKey)
    local config=AllAuraConfigs[auraKey]
    if not config then return end
    stopAura()
    if not findProps() or totalProps<=0 then return end
    currentAura=auraKey; auraRunning=true; auraToken+=1
    local token=auraToken
    auraThread=task.spawn(function() runAuraAnimation(auraKey,config,token) end)
    print(config.color..' '..config.name..' activated with '..totalProps..' props')
end
local function resetProps()
    stopAura()
    if not findProps() then return false end
    local character=getCharacter(); local hrp=character and character:FindFirstChild('HumanoidRootPart')
    if not hrp then return false end
    for _,prop in ipairs(propList) do moveProp(prop,CFrame.new(hrp.Position)); task.wait(.02) end
    return true
end

-- =========================================================
-- SNAKE SYSTEM: head follows player, each prop follows the
-- previous prop's smoothed path. No direct teleport snapping.
-- =========================================================
local snake={active=false,auto=false,speed=10,spacing=2.25,height=0.15,wave=1.15,turn=.24,phase=.0,reverse=false,loop=nil,targets={}}
local function snakeStop() snake.active=false; snake.auto=false; if snake.loop then snake.loop=nil end end
local function snakeGetProps() if not findProps() then return {} end return propList end
local function snakePoint(i,headPos,headLook,t)
    local dir=headLook.Magnitude>0 and headLook.Unit or Vector3.new(0,0,-1)
    local right=Vector3.new(-dir.Z,0,dir.X)
    local back=dir*(-i*snake.spacing)
    local wave=right*math.sin(t*snake.speed*.75-i*.72+snake.phase)*(snake.wave*(i/(math.max(1,#propList))))
    local y=snake.height+math.sin(t*snake.speed+i*.55)*.18
    return headPos+back+wave+Vector3.new(0,y,0)
end
local function runSnake()
    local lastHead=nil
    while snake.active do
        local props=snakeGetProps(); local char=getCharacter(); local hrp=char and char:FindFirstChild('HumanoidRootPart')
        if not hrp or #props==0 then task.wait(.12); continue end
        local t=os.clock()
        local head=hrp.Position
        local look=hrp.CFrame.LookVector
        if snake.auto then
            head=head+Vector3.new(math.cos(t*.33)*18,math.sin(t*.55)*2,math.sin(t*.33)*18)
            look=Vector3.new(-math.sin(t*.33),0,math.cos(t*.33))
        end
        lastHead=lastHead and lastHead:Lerp(head,.28) or head
        local prev=lastHead
        for i,prop in ipairs(props) do
            local target=snakePoint(i-1,lastHead,look,t)
            if snake.reverse then target=snakePoint(#props-i,lastHead,look,t) end
            snake.targets[i]=snake.targets[i] and snake.targets[i]:Lerp(target,snake.turn) or target
            local pos=snake.targets[i]
            local facing=(pos-prev); if facing.Magnitude<.01 then facing=look end
            moveProp(prop,CFrame.lookAt(pos,pos+facing.Unit))
            prev=pos
        end
        task.wait(.055)
    end
end
local function snakeStart(auto)
    snakeStop(); snake.active=true; snake.auto=auto==true; snake.targets={}; snake.loop=task.spawn(runSnake)
end

-- =========================================================
-- ROPE SYSTEM (ported from supplied Rayfield version)
-- =========================================================
local rope={p1='',p2='',includeMe=false,active=false,loop=nil,wave=.6,sag=.18,segments=15,speed=3}
local function getPlayerByName(name)
    name=string.lower(tostring(name or ''))
    if name=='' then return nil end
    for _,plr in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(plr.Name),name,1,true) then return plr end
    end
end
local function getHRP(plr)
    if not plr then return nil end
    local char=plr.Character
    return char and char:FindFirstChild('HumanoidRootPart')
end
local function ropeCurve(t,a,b)
    local mid=(a+b)/2
    local sag=math.clamp((a-b).Magnitude*rope.sag,2,14)
    mid=mid-Vector3.new(0,sag,0)
    return a:Lerp(mid,t):Lerp(mid:Lerp(b,t),t)
end
local function stopRope() rope.active=false; if rope.loop then rope.loop=nil end end
local function runRope()
    while rope.active do
        local p1=rope.includeMe and LocalPlayer or getPlayerByName(rope.p1)
        local p2=getPlayerByName(rope.p2)
        local h1=getHRP(p1); local h2=getHRP(p2)
        local props=snakeGetProps()
        if h1 and h2 and #props>0 then
            local a,b=h1.Position,h2.Position
            local count=math.min(#props,math.clamp(math.floor((a-b).Magnitude/2),4,rope.segments))
            for i=1,count do
                local t=i/(count+1)
                local pos=ropeCurve(t,a,b)
                pos+=Vector3.new(0,math.sin(t*math.pi*4+os.clock()*rope.speed)*rope.wave,0)
                moveProp(props[i],CFrame.lookAt(pos,b))
            end
        end
        task.wait(.055)
    end
end
local function startRope()
    stopRope(); rope.active=true; rope.loop=task.spawn(runRope)
end

-- =========================================================
-- PROFILE DATA
-- =========================================================
local profileName=LocalPlayer.DisplayName
local profileUser='@'..LocalPlayer.Name

-- GUI handling
local UseFluent = false
local Fluent = nil
for attempt = 1, 3 do
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)
    if success and result then
        Fluent = result
        UseFluent = true
        break
    end
    task.wait(1)
end

local guiVisible = true
local isFull = false

if UseFluent and Fluent then
    local SaveManager, InterfaceManager
    pcall(function()
        SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
        InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
    end)

    local compactSize = UDim2.fromOffset(285, 370)
    local fullSize = UDim2.fromOffset(430, 510)

    local Window = Fluent:CreateWindow({
        Title = "MANI PROP GUI",
        SubTitle = "v4 • Smooth Snake + Rope",
        TabWidth = 100,
        Size = compactSize,
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- Override minimize: toggle visibility instead of destroy
    local oldMinimize = Window.Minimize
    Window.Minimize = function()
        guiVisible = not guiVisible
        Window.Visible = guiVisible
    end

    -- Add full-screen toggle button in settings
    local Tabs = {
        C = Window:AddTab({ Title = "🟢", Icon = "sparkles" }),
        U = Window:AddTab({ Title = "🔵", Icon = "gem" }),
        R = Window:AddTab({ Title = "🟣", Icon = "crown" }),
        E = Window:AddTab({ Title = "🟠", Icon = "flame" }),
        L = Window:AddTab({ Title = "🔴", Icon = "star" }),
        M = Window:AddTab({ Title = "🟡", Icon = "infinity" }),
        S = Window:AddTab({ Title = "💠", Icon = "eye" }),
        Sn = Window:AddTab({ Title = "🐍", Icon = "move" }),
        Rp = Window:AddTab({ Title = "🪢", Icon = "link" }),
        St = Window:AddTab({ Title = "⚙️", Icon = "settings" })
    }

    local function buildAuraButtons(tab, auraKeys, title)
        pcall(function()
            tab:AddParagraph({ Title = title, Content = "Owned props • auto 1-25" })
            for _, key in ipairs(auraKeys) do
                local config = AllAuraConfigs[key]
                if config then
                    tab:AddButton({
                        Title = config.name,
                        Description = "",
                        Callback = function() startAura(key) end
                    })
                end
            end
        end)
    end

    local commonList = {"SoftGlow","FreshBreeze","CalmRing","TinyOrbit","SimpleHalo","FloatingMist","GentleWave","LightBloom","MiniSpiral","CloudRing","SoftOrbit","BrightCircle","PeaceAura","BreezeHalo","MorningGlow","FloatingStars","LittleGalaxy","DreamRing","PureHalo","SkyBloom"}
    local uncommonList = {"AquaOrbit","FrostRing","CrystalWave","WindSpiral","Rainfall","BlueComet","IceHalo","MistSpiral","OceanRing","CloudSpiral","SnowOrbit","SilverBloom","MoonRing","StarOrbit","SkySpiral","FrozenHalo","CrystalOrbit","TidalWave","WinterBloom","ArcticRing"}
    local rareList = {"MysticSpiral","PhantomRing","ArcaneOrbit","SoulHalo","AstralBloom","RuneCircle","DreamSpiral","SpiritOrbit","Moonveil","Starveil","EtherRing","MirageOrbit","TwilightHalo","SpectralBloom","MysticCrown","AstralRing","PhantomOrbit","SoulSpiral","ArcaneBloom","Dreamveil"}
    local epicList = {"SolarCrown","LunarCrown","ThunderRing","FlameOrbit","FrostCrown","StormSpiral","CometHalo","MeteorRing","GalaxyOrbit","NebulaBloom","GravityRing","EnergySpiral","VortexHalo","PlasmaOrbit","SolarSpiral","ThunderCrown","CosmicRing","Starstorm","SupernovaHalo","CelestialOrbit"}
    local legendaryList = {"EclipseCrown","VoidSpiral","InfinityRing","EternalOrbit","DivineHalo","AncientCrown","ImmortalSpiral","RealityRing","DimensionOrbit","TimeflowHalo","CosmicCrown","UniverseSpiral","InfinityBloom","CelestialCrown","EternityRing","AstralDominion","DivineOrbit","RealityHalo","InfiniteSpiral","EternalBloom"}
    local mythicList = {"ChaosCrown","AbyssOrbit","OblivionRing","VoidCrown","DarkstarSpiral","BlackholeHalo","EndworldOrbit","PhantomDominion","AbyssalCrown","InfiniteVoid","RealityBreaker","CosmicDestroyer","EternalVoid","DimensionBreak","ChaosSpiral","Voidstorm","BlackstarCrown","OblivionHalo","ZeroPoint","FinalEclipse"}
    local secretList = {"NOVA15","Fifteenfold","Prophecy","TheCollector","LostFormation","ForbiddenOrbit","UnknownEntity","ZeroGravity","BeyondReality","TheLastAura","HiddenDimension","InfiniteMachinery","AbsoluteZero","Worldbreaker","EternalMachinery","UnknownSignal","The15thRealm","Singularity","Realityexe"}

    buildAuraButtons(Tabs.C, commonList, "⭐ Common")
    buildAuraButtons(Tabs.U, uncommonList, "💎 Uncommon")
    buildAuraButtons(Tabs.R, rareList, "👑 Rare")
    buildAuraButtons(Tabs.E, epicList, "🔥 Epic")
    buildAuraButtons(Tabs.L, legendaryList, "⭐ Legendary")
    buildAuraButtons(Tabs.M, mythicList, "🌟 Mythic")
    buildAuraButtons(Tabs.S, secretList, "💠 Secret")

    local function addControls(tab)
        tab:AddParagraph({ Title = "🎮", Content = "" })
        tab:AddButton({ Title = "⏹️Stop", Description = "", Callback = function()
            stopAura()
            if Fluent then Fluent:Notify({Title="Stopped", Content="Aura stopped", Duration=2}) end
        end })
        tab:AddButton({ Title = "🔄Reset", Description = "", Callback = function()
            if resetProps() then
                if Fluent then
                    Fluent:Notify({Title="Reset", Content="Props reset", Duration=2})
                end
            end
        end })
    end
    addControls(Tabs.C); addControls(Tabs.U); addControls(Tabs.R); addControls(Tabs.E); addControls(Tabs.L); addControls(Tabs.M); addControls(Tabs.S)

    -- =====================================================
    -- SNAKE TAB
    -- =====================================================
    Sn:AddParagraph({Title="🐍 Smooth Prop Snake",Content="1-25 owned props • body follows the head smoothly"})
    Sn:AddButton({Title="🐍 Follow Me",Description="Snake head smoothly follows your character",Callback=function() snakeStart(false) end})
    Sn:AddButton({Title="🗺️ Auto Travel",Description="Snake travels automatically",Callback=function() snakeStart(true) end})
    Sn:AddButton({Title="⏹ Stop Snake",Description="Stop snake movement",Callback=function() snakeStop() end})
    Sn:AddButton({Title="🔀 Reverse Body",Description="Reverse head-to-tail order",Callback=function() snake.reverse=not snake.reverse end})
    Sn:AddButton({Title="🎲 New Travel Pattern",Description="Restart automatic travel with a new phase",Callback=function() snake.phase=math.random()*20; snakeStart(true) end})
    Sn:AddSlider({Title="Snake Speed",Min=2,Max=20,Default=10,Rounding=1,Callback=function(v) snake.speed=v end})
    Sn:AddSlider({Title="Body Spacing",Min=1,Max=5,Default=2.25,Rounding=2,Callback=function(v) snake.spacing=v end})
    Sn:AddSlider({Title="Wave",Min=0,Max=3,Default=1.15,Rounding=2,Callback=function(v) snake.wave=v end})
    Sn:AddSlider({Title="Follow Smoothness",Min=.08,Max=.55,Default=.24,Rounding=2,Callback=function(v) snake.turn=v end})
    Sn:AddSlider({Title="Body Height",Min=-2,Max=3,Default=.15,Rounding=2,Callback=function(v) snake.height=v end})
    Sn:AddParagraph({Title="✨ Snake Features",Content="Smooth head • segment follow • body wave • turning • spacing • speed • auto travel • reverse • phase randomizer"})

    -- =====================================================
    -- ROPE TAB
    -- =====================================================
    Rp:AddParagraph({Title="🪢 Realistic Prop Rope",Content="Curved Bezier rope with dynamic sag + wave"})
    Rp:AddInput({Title="Player 1",Default="",Placeholder="Enter player name",Callback=function(v) rope.p1=v end})
    Rp:AddInput({Title="Player 2",Default="",Placeholder="Enter player name",Callback=function(v) rope.p2=v end})
    Rp:AddToggle({Title="Include Me (Player 1)",Default=false,Callback=function(v) rope.includeMe=v end})
    Rp:AddButton({Title="🔥 Start Real Rope",Description="Smoothly connects Player 1 and Player 2",Callback=function() startRope(); Fluent:Notify({Title="Rope",Content="Realistic rope started",Duration=2}) end})
    Rp:AddButton({Title="❌ Stop Rope",Description="Stop rope movement",Callback=function() stopRope() end})
    Rp:AddSlider({Title="Rope Wave",Min=0,Max=2,Default=.6,Rounding=2,Callback=function(v) rope.wave=v end})
    Rp:AddSlider({Title="Rope Sag",Min=.05,Max=.4,Default=.18,Rounding=2,Callback=function(v) rope.sag=v end})
    Rp:AddSlider({Title="Max Segments",Min=4,Max=15,Default=15,Rounding=0,Callback=function(v) rope.segments=v end})
    Rp:AddSlider({Title="Wave Speed",Min=0,Max=8,Default=3,Rounding=1,Callback=function(v) rope.speed=v end})

    -- Settings tab with full-screen toggle
    local propLabel = Tabs.St:AddParagraph({ Title = "📊 Props", Content = "Checking..." })
    task.spawn(function()
        while true do
            pcall(function()
                if findProps() then
                    propLabel:SetContent(#propList .. " found • using " .. totalProps)
                else
                    propLabel:SetContent("No props")
                end
            end)
            task.wait(2)
        end
    end)
    Tabs.St:AddButton({ Title = "🔄Refresh", Description = "", Callback = function()
        findProps()
        if Fluent then Fluent:Notify({Title="Refreshed", Content=#propList.." props", Duration=2}) end
    end })
    Tabs.St:AddParagraph({Title="👤 Current User",Content=profileName.."\n"..profileUser.."\nUserId: "..tostring(LocalPlayer.UserId)})
    local function smoothResize(target)
        local current=isFull and fullSize or compactSize
        local sw,sh=current.X.Offset,current.Y.Offset
        local tw,th=target.X.Offset,target.Y.Offset
        for i=1,12 do
            local a=i/12
            a=a*a*(3-2*a)
            local w=math.floor(sw+(tw-sw)*a)
            local h=math.floor(sh+(th-sh)*a)
            pcall(function() Window:SetSize(UDim2.fromOffset(w,h)) end)
            task.wait(.012)
        end
        pcall(function() Window:SetSize(target) end)
    end
    Tabs.St:AddButton({ Title = "📐 Big Screen / Compact", Description = "Smooth resize • no automatic snap-back", Callback = function()
        isFull=not isFull
        local target=isFull and fullSize or compactSize
        task.spawn(function() smoothResize(target) end)
        if Fluent then Fluent:Notify({Title=isFull and "Big Screen" or "Compact",Content="Smooth resize complete",Duration=2}) end
    end })
    Tabs.St:AddParagraph({ Title = "📖 Info", Content = "139 auras • 1-25 props • Smooth Snake • Realistic Rope" })

    task.spawn(function()
        repeat task.wait() until game:IsLoaded()
        pcall(function()
            findProps()
            Window:SelectTab(1)
        end)
        if Fluent then Fluent:Notify({ Title = "MANI PROP GUI", Content = "139 Auras Loaded!", Duration = 3 }) end
    end)

    pcall(function()
        if SaveManager and InterfaceManager then
            SaveManager:SetLibrary(Fluent)
            InterfaceManager:SetLibrary(Fluent)
            SaveManager:IgnoreThemeSettings()
            SaveManager:SetIgnoreIndexes({})
            InterfaceManager:SetFolder("MANIPropGUI")
            SaveManager:SetFolder("MANIPropGUI/props")
            InterfaceManager:BuildInterfaceSection(Tabs.St)
            SaveManager:BuildConfigSection(Tabs.St)
            SaveManager:LoadAutoloadConfig()
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        local savedAura = currentAura
        stopRope()
        snakeStop()

        if savedAura then
            stopAura()

            task.wait(1)

            if LocalPlayer.Character then
                startAura(savedAura)
            end
        else
            stopAura()
        end
    end)

else
    -- Fallback GUI with minimize and full-screen toggle
    local player = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "MANIPropGUI"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 285, 0, 370)
    frame.Position = UDim2.new(0.5, -142, 0.5, -185)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,28)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundColor3 = Color3.fromRGB(50,50,50)
    title.Text = "MANI PROP GUI"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextScaled = true
    title.Font = Enum.Font.Bold
    title.Parent = frame

    -- Minimize button (toggle visibility)
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0,28,0,22)
    minBtn.Position = UDim2.new(1,-60,0,3)
    minBtn.BackgroundColor3 = Color3.fromRGB(50,50,150)
    minBtn.Text = "─"
    minBtn.TextColor3 = Color3.fromRGB(255,255,255)
    minBtn.TextScaled = true
    minBtn.Font = Enum.Font.Bold
    minBtn.Parent = frame
    minBtn.MouseButton1Click:Connect(function()
        gui.Enabled = not gui.Enabled
    end)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,28,0,22)
    closeBtn.Position = UDim2.new(1,-30,0,3)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.Bold
    closeBtn.Parent = frame
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,-10,1,-65)
    scroll.Position = UDim2.new(0,5,0,32)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ScrollBarThickness = 3
    scroll.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,2)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll

    local function createCategory(title, auraKeys)
        local catLabel = Instance.new("TextLabel")
        catLabel.Size = UDim2.new(1,0,0,16)
        catLabel.BackgroundColor3 = Color3.fromRGB(60,60,60)
        catLabel.Text = title
        catLabel.TextColor3 = Color3.fromRGB(255,255,255)
        catLabel.TextScaled = true
        catLabel.Font = Enum.Font.Bold
        catLabel.Parent = scroll

        for _, key in ipairs(auraKeys) do
            local config = AllAuraConfigs[key]
            if config then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1,0,0,20)
                btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
                btn.Text = config.name
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.TextScaled = true
                btn.Font = Enum.Font.Regular
                btn.Parent = scroll
                btn.MouseButton1Click:Connect(function() startAura(key) end)
            end
        end
    end

    createCategory("🟢 Common", commonList)
    createCategory("🔵 Uncommon", uncommonList)
    createCategory("🟣 Rare", rareList)
    createCategory("🟠 Epic", epicList)
    createCategory("🔴 Legendary", legendaryList)
    createCategory("🟡 Mythic", mythicList)
    createCategory("💠 Secret", secretList)

    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0,60,0,20)
    stopBtn.Position = UDim2.new(0.5,-70,1,-28)
    stopBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    stopBtn.Text = "Stop"
    stopBtn.TextColor3 = Color3.fromRGB(255,255,255)
    stopBtn.TextScaled = true
    stopBtn.Font = Enum.Font.Bold
    stopBtn.Parent = frame
    stopBtn.MouseButton1Click:Connect(function() stopAura() end)

    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0,60,0,20)
    resetBtn.Position = UDim2.new(0.5,10,1,-28)
    resetBtn.BackgroundColor3 = Color3.fromRGB(50,50,200)
    resetBtn.Text = "Reset"
    resetBtn.TextColor3 = Color3.fromRGB(255,255,255)
    resetBtn.TextScaled = true
    resetBtn.Font = Enum.Font.Bold
    resetBtn.Parent = frame
    resetBtn.MouseButton1Click:Connect(function()
        resetProps()
    end)

    -- Full-screen toggle button
    local sizeBtn = Instance.new("TextButton")
    sizeBtn.Size = UDim2.new(0,60,0,20)
    sizeBtn.Position = UDim2.new(0.5, -10, 1, -28)
    sizeBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
    sizeBtn.Text = "Full"
    sizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    sizeBtn.TextScaled = true
    sizeBtn.Font = Enum.Font.Bold
    sizeBtn.Parent = frame
    sizeBtn.MouseButton1Click:Connect(function()
        isFull = not isFull
        if isFull then
            frame.Size = UDim2.new(0, 430, 0, 510)
            frame.Position = UDim2.new(0.5, -215, 0.5, -255)
            sizeBtn.Text = "Compact"
        else
            frame.Size = UDim2.new(0, 285, 0, 370)
            frame.Position = UDim2.new(0.5, -142, 0.5, -185)
            sizeBtn.Text = "Full"
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        local savedAura = currentAura
        stopRope()
        snakeStop()

        if savedAura then
            stopAura()

            task.wait(1)

            if LocalPlayer.Character then
                startAura(savedAura)
            end
        else
            stopAura()
        end
    end)
    findProps()
    print("Fallback GUI loaded. Owned props: " .. #propList .. " (using " .. totalProps .. ")")
end
