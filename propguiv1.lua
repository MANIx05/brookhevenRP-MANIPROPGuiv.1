-- MANI PROP GUI V.1 by @MANISH_K05
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
local stopSnake

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
-- AURA ENGINE V3
-- Smooth, deterministic and visually different formations.
-- Styles are cached once per aura to avoid rebuilding tables
-- every frame.
-- =========================================================

local auraStyleCache = {}

local function auraHash(text)
    local h = 0
    for i = 1, #text do
        h = (h * 31 + string.byte(text, i)) % 100000
    end
    return h
end

local function getAuraStyle(auraKey, config)
    local cached = auraStyleCache[auraKey]
    if cached then
        return cached
    end

    local h = auraHash(tostring(auraKey) .. "|" .. tostring(config.name))
    cached = {
        style = (h % 14) + 1,
        phase = (h % 628) / 100,
        wave = 0.7 + ((math.floor(h / 17) % 100) / 100) * 1.8,
        height = 0.7 + ((math.floor(h / 29) % 100) / 100) * 2.0,
        twist = ((math.floor(h / 37) % 360) - 180) * math.pi / 180,
        tilt = ((math.floor(h / 43) % 28) - 14) * math.pi / 180,
        direction = (h % 2 == 0) and 1 or -1,
        petals = 3 + (h % 8),
        inner = 0.55 + ((math.floor(h / 53) % 25) / 100),
        outer = 0.95 + ((math.floor(h / 61) % 30) / 100),
        speedMul = 0.78 + ((math.floor(h / 71) % 45) / 100),
    }
    auraStyleCache[auraKey] = cached
    return cached
end

local function getAuraCFrame(auraKey, config, index, total, elapsed, center)
    local speed = tonumber(config.speed) or 0.5
    local baseRadius = tonumber(config.radius) or 12
    local baseY = tonumber(config.offsetY) or 0
    local rotation = math.rad(tonumber(config.rotation) or 0)
    local style = getAuraStyle(auraKey, config)

    local t = (index - 1) / math.max(total, 1)
    local baseAngle = math.pi * 2 * t
    local time = elapsed * speed * style.speedMul * style.direction
    local angle = baseAngle + time + rotation + style.phase

    local radius = baseRadius
    local y = baseY

    if style.style == 1 then
        -- Smooth breathing halo
        local breath = 0.5 + 0.5 * math.sin(time * 1.65 + index * 0.22)
        radius = baseRadius * (0.90 + breath * 0.16)
        y = baseY + math.sin(time * 1.9 + index * 0.35) * 0.55

    elseif style.style == 2 then
        -- Flower / petals
        local petal = math.sin(angle * style.petals + time * 0.55)
        radius = baseRadius * (0.72 + math.abs(petal) * 0.34)
        y = baseY + math.cos(angle * 2 + time) * 0.65

    elseif style.style == 3 then
        -- Helix
        radius = baseRadius * (0.76 + 0.20 * math.sin(t * math.pi * 2 + time))
        y = baseY + math.sin(t * math.pi * 2 + time * 1.35) * style.height * 1.55

    elseif style.style == 4 then
        -- Star
        local star = math.abs(math.cos(angle * 5 + time * 0.65))
        radius = baseRadius * (0.56 + 0.55 * star)
        y = baseY + math.sin(time * 1.7 + index * 0.52) * 0.85

    elseif style.style == 5 then
        -- Infinity / double orbit
        local side = (index % 2 == 0) and 1 or -1
        radius = baseRadius * ((side == 1) and style.outer or style.inner)
        angle = angle + side * (math.pi / 8)
        y = baseY + side * 1.45 + math.sin(time * 1.2 + index) * 0.4

    elseif style.style == 6 then
        -- Flowing wave
        radius = baseRadius + math.sin(angle * 3 + time * 1.9) * (1.1 + style.wave)
        y = baseY + math.sin(angle * 2 + time * 1.4) * style.height

    elseif style.style == 7 then
        -- Vortex
        local depth = (t - 0.5) * 2
        radius = baseRadius * (0.54 + 0.76 * (1 - math.abs(depth) * 0.28))
        angle = angle + depth * 2.35 + time * 0.38
        y = baseY + depth * style.height * 2.2

    elseif style.style == 8 then
        -- Crown
        local crown = math.sin(angle * 4 + time * 0.8)
        radius = baseRadius * (0.70 + 0.32 * math.max(crown, 0))
        y = baseY + 1.5 + math.max(crown, 0) * 2.7

    elseif style.style == 9 then
        -- Comet
        local trail = t
        radius = baseRadius * (0.58 + trail * 0.50)
        angle = angle - trail * 1.45
        y = baseY + math.sin(time * 1.45 + trail * math.pi * 2) * 1.25

    elseif style.style == 10 then
        -- Galaxy arms
        local arm = math.sin(t * math.pi * 4 + time)
        radius = baseRadius * (0.52 + 0.58 * math.abs(arm))
        angle = angle + arm * 1.05
        y = baseY + math.sin(t * math.pi * 4 + time * 0.75) * 2.15

    elseif style.style == 11 then
        -- Diamond pulse
        local diamond = 1 - math.abs(math.sin(angle * 4 + time))
        radius = baseRadius * (0.62 + diamond * 0.58)
        y = baseY + math.cos(angle * 4 + time) * 1.0

    elseif style.style == 12 then
        -- Three orbital lanes
        local lane = (index % 3) - 1
        radius = baseRadius * (1 + lane * 0.17)
        angle = angle + lane * 0.82
        y = baseY + lane * 1.65 + math.sin(time * 1.6 + index) * 0.5

    elseif style.style == 13 then
        -- Ripple sphere
        local wave = math.sin(t * math.pi * 2 + time * 1.2)
        radius = baseRadius * (0.72 + math.abs(wave) * 0.42)
        y = baseY + math.cos(t * math.pi * 4 + time) * 2.0

    else
        -- Slow orbital ribbon
        local ribbon = math.sin(t * math.pi * 2 + time)
        radius = baseRadius * (0.82 + ribbon * 0.20)
        angle = angle + math.sin(time * 0.55) * 0.65
        y = baseY + ribbon * 2.4
    end

    -- Original aura type is still respected as a secondary motion layer.
    if config.type == "wave" then
        radius += math.sin(angle * 3 + time * 1.65) * 1.25
        y += math.sin(time * 2 + index * 0.6) * 0.55
    elseif config.type == "spiral" then
        radius += t * 2.8
        y += (t - 0.5) * 2.0
        angle += t * 1.8
    elseif config.type == "star" then
        radius *= (index % 2 == 0) and 0.68 or 1.08
    elseif config.type == "double" then
        local side = (index % 2 == 0) and 1 or -1
        radius *= (side == 1) and 1.12 or 0.82
        y += side * 0.72
    end

    -- Universal micro-motion prevents dead/static frames.
    radius += math.sin(elapsed * speed * 2.0 + index * 0.31 + style.phase) * 0.28
    y += math.cos(elapsed * speed * 1.65 + index * 0.43) * 0.20

    local position = center + Vector3.new(
        math.cos(angle) * radius,
        y,
        math.sin(angle) * radius
    )

    local look = CFrame.lookAt(position, center)
    return look * CFrame.Angles(
        math.sin(angle + style.twist) * style.tilt,
        angle * 0.12,
        math.cos(angle + style.phase) * style.tilt
    )
end

local function runAuraAnimation(auraKey, config, token)
    local updateInterval = 0.10

    while auraRunning
        and currentAura == auraKey
        and auraToken == token do

        local character = getCharacter()

        if not character then
            task.wait(0.25)
            continue
        end

        local hrp = character:FindFirstChild("HumanoidRootPart")

        if not hrp then
            task.wait(0.1)
            continue
        end

        -- Refresh props if they were recreated by the game.
        if not propFolder
            or not propFolder.Parent
            or #propList == 0 then
            findProps()
        end

        local total = math.min(totalProps, #propList)

        if total > 0 then
            centerPosition = hrp.Position
            local elapsed = os.clock()

            for index = 1, total do
                if not auraRunning
                    or currentAura ~= auraKey
                    or auraToken ~= token then
                    break
                end

                local prop = propList[index]

                if prop and prop.Parent then
                    local target = getAuraCFrame(
                        auraKey,
                        config,
                        index,
                        total,
                        elapsed,
                        centerPosition
                    )

                    moveProp(prop, target)
                end
            end
        end

        task.wait(updateInterval)
    end
end

local function stopAura()
    auraRunning = false
    currentAura = nil

    -- Invalidates any previous animation loop.
    auraToken += 1

    -- Do not coroutine.close() a running thread. Let the token/state
    -- condition end it safely.
    auraThread = nil
end

local function startAura(auraKey)
    stopSnake()
    local config = AllAuraConfigs[auraKey]

    if not config then
        warn("[MANI AURA] Unknown aura:", auraKey)
        return
    end

    stopAura()

    if not findProps() then
        print("[MANI AURA] No owned props found in WorkspaceCom/001_TrafficCones")
        return
    end

    if totalProps <= 0 then
        print("[MANI AURA] No usable props found")
        return
    end

    currentAura = auraKey
    auraRunning = true

    auraToken += 1
    local myToken = auraToken

    auraThread = task.spawn(function()
        runAuraAnimation(auraKey, config, myToken)
    end)

    print(
        config.color
        .. " "
        .. config.name
        .. " activated with "
        .. totalProps
        .. " props"
    )
end

local function resetProps()
    stopAura()

    if not findProps() then
        return false
    end

    local character = getCharacter()
    if not character then
        return false
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return false
    end

    local resetCFrame = CFrame.new(hrp.Position)

    for _, prop in ipairs(propList) do
        moveProp(prop, resetCFrame)
        task.wait(0.03)
    end

    return true
end


-- =========================================================
-- SNAKE ENGINE V3
-- Up to 25 owned props become one smooth snake.
-- 20 controls/features are exposed in the Snake tab.
-- =========================================================

local snakeRunning = false
local snakeAutoTravel = false
local snakeFollowPlayer = true
local snakeReverse = false
local snakeWave = true
local snakePatrol = false
local snakeSmoothTurns = true
local snakeHeadLead = true
local snakeBreathing = true
local snakeTailWhip = true
local snakeSpiralTravel = false
local snakeRandomStops = true
local snakeHover = false
local snakeLength = 15
local snakeSpeed = 8
local snakeSpacing = 2.15
local snakeWaveHeight = 0.65
local snakeTurnSmooth = 0.12
local snakeTarget = nil
local snakeHeadPosition = nil
local snakeNextTargetAt = 0
local snakeHeading = nil
local snakeTravelSeed = 0

local function getSnakeProps()
    if not propFolder or not propFolder.Parent or #propList == 0 then
        findProps()
    end
    local out = {}
    local count = math.clamp(tonumber(snakeLength) or 15, 1, math.min(25, #propList))
    for i = 1, count do
        if propList[i] and propList[i].Parent then
            table.insert(out, propList[i])
        end
    end
    return out
end

local function chooseSnakeTarget(origin)
    snakeTravelSeed += 1
    local seed = snakeTravelSeed * 17 + math.floor(os.clock() * 10)
    local angle = math.rad((seed * 47) % 360)
    local distance = 22 + ((seed * 13) % 34)
    local y = snakeHover and (2 + ((seed * 7) % 5)) or 0
    return origin + Vector3.new(math.cos(angle) * distance, y, math.sin(angle) * distance)
end

local function moveSnake()
    local character = getCharacter()
    if not character then
        return
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end

    local snakeProps = getSnakeProps()
    local count = #snakeProps
    if count == 0 then
        return
    end

    local now = os.clock()
    local playerPos = hrp.Position
    local forward = hrp.CFrame.LookVector
    local desiredHead

    if snakeAutoTravel then
        if not snakeTarget
            or now >= snakeNextTargetAt
            or (snakeTarget - playerPos).Magnitude < 7 then
            snakeTarget = chooseSnakeTarget(playerPos)
            snakeNextTargetAt = now + (snakeRandomStops and 4.5 or 8.0)
        end
        desiredHead = snakeTarget
    else
        desiredHead = playerPos + forward * (snakeHeadLead and 2.5 or 0)
        if snakeHover then
            desiredHead += Vector3.new(0, 2.2, 0)
        end
    end

    if not snakeHeadPosition then
        snakeHeadPosition = desiredHead
    end

    local followAlpha = 1 - math.exp(-math.max(snakeSpeed, 1) * 0.075)
    snakeHeadPosition = snakeHeadPosition:Lerp(desiredHead, math.clamp(followAlpha, 0.04, 0.95))

    local headPos = snakeHeadPosition
    local previousPos = headPos
    local previousForward = snakeHeading or forward

    if snakeSmoothTurns then
        local wanted = desiredHead - playerPos
        if wanted.Magnitude > 0.01 then
            wanted = wanted.Unit
            previousForward = previousForward:Lerp(wanted, math.clamp(snakeTurnSmooth, 0.02, 0.5)).Unit
        end
    else
        previousForward = (desiredHead - playerPos).Magnitude > 0.01
            and (desiredHead - playerPos).Unit
            or forward
    end
    snakeHeading = previousForward

    local path = {}
    path[1] = headPos

    for i = 2, count do
        local back = (i - 1) * snakeSpacing
        local pos = headPos - previousForward * back

        if snakeFollowPlayer and not snakeAutoTravel then
            -- Gentle player-follow bend, like a real snake turning behind the head.
            local bend = math.sin(now * 1.35 - i * 0.42) * math.min(back * 0.035, 1.8)
            pos += Vector3.new(
                -previousForward.Z * bend,
                0,
                previousForward.X * bend
            )
        end

        if snakeWave then
            local wave = math.sin(now * 2.6 - i * 0.58) * snakeWaveHeight
            pos += Vector3.new(-previousForward.Z * wave, 0, previousForward.X * wave)
        end

        if snakeSpiralTravel then
            local spiral = (i / math.max(count, 1)) * math.pi * 1.5
            pos += Vector3.new(
                math.cos(spiral + now) * 0.45,
                math.sin(spiral + now * 0.8) * 0.25,
                math.sin(spiral + now) * 0.45
            )
        end

        if snakeBreathing then
            pos += Vector3.new(0, math.sin(now * 2.0 - i * 0.35) * 0.12, 0)
        end

        if snakeTailWhip and i > math.max(3, count - 5) then
            local tailFactor = (i - (count - 5)) / 5
            local whip = math.sin(now * 4.0 + i) * tailFactor * 1.2
            pos += Vector3.new(-previousForward.Z * whip, 0, previousForward.X * whip)
        end

        path[i] = pos
    end

    if snakeReverse then
        local reversed = {}
        for i = 1, count do
            reversed[i] = path[count - i + 1]
        end
        path = reversed
    end

    for i = 1, count do
        local prop = snakeProps[i]
        local pos = path[i]
        local nextPos = path[math.min(i + 1, count)]
        if i == count and i > 1 then
            nextPos = path[i - 1]
        end

        if prop and prop.Parent then
            local target
            if (nextPos - pos).Magnitude > 0.01 then
                target = CFrame.lookAt(pos, nextPos)
            else
                target = CFrame.new(pos)
            end
            moveProp(prop, target)
        end
    end
end

local function startSnake()
    if snakeRunning then
        return
    end

    if not findProps() then
        warn("[MANI SNAKE] No owned props found")
        return
    end

    snakeRunning = true
    snakeTarget = nil
    snakeHeadPosition = nil
    snakeNextTargetAt = 0
    snakeHeading = nil

    task.spawn(function()
        while snakeRunning do
            pcall(moveSnake)
            task.wait(0.075)
        end
    end)
end

stopSnake = function()
    snakeRunning = false
    snakeTarget = nil
    snakeHeadPosition = nil
    snakeHeading = nil
end


-- Mobile-first sizing hint. Roblox exposes display size categories for UI adaptation.
pcall(function()
    local GuiService = game:GetService("GuiService")
    if GuiService.ViewportDisplaySize == Enum.DisplaySize.Small then
        isFull = false
    end
end)

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

    local compactSize = UDim2.fromOffset(292, 382)
    local fullSize = UDim2.fromOffset(430, 500)

    local Window = Fluent:CreateWindow({
        Title = "MANI PROP GUI",
        SubTitle = "v3 • Mobile + Snake",
        TabWidth = 100,
        Size = compactSize,
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl,
        Resize = false
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
        Sn = Window:AddTab({ Title = "🐍", Icon = "move-3d" }),
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
    -- 20 advanced snake features.
    -- =====================================================
    Tabs.Sn:AddParagraph({
        Title = "🐍 MANI SNAKE",
        Content = "Turn 1-25 owned props into a smooth living snake."
    })

    Tabs.Sn:AddToggle("SnakeEnabled", {
        Title = "1. Snake Enabled",
        Default = false,
        Callback = function(v)
            if v then startSnake() else stopSnake() end
        end
    })

    Tabs.Sn:AddToggle("SnakeAutoTravel", {
        Title = "2. Auto Travel",
        Default = false,
        Callback = function(v)
            snakeAutoTravel = v
            snakeTarget = nil
        end
    })

    Tabs.Sn:AddToggle("SnakeFollow", {
        Title = "3. Follow Player",
        Default = true,
        Callback = function(v) snakeFollowPlayer = v end
    })

    Tabs.Sn:AddSlider("SnakeLength", {
        Title = "4. Snake Length",
        Default = 15,
        Min = 1,
        Max = 25,
        Rounding = 0,
        Callback = function(v) snakeLength = math.clamp(math.floor(v + 0.5), 1, 25) end
    })

    Tabs.Sn:AddSlider("SnakeSpeed", {
        Title = "5. Travel Speed",
        Default = 8,
        Min = 2,
        Max = 20,
        Rounding = 1,
        Callback = function(v) snakeSpeed = v end
    })

    Tabs.Sn:AddSlider("SnakeSpacing", {
        Title = "6. Body Spacing",
        Default = 2.15,
        Min = 1.0,
        Max = 4.0,
        Rounding = 2,
        Callback = function(v) snakeSpacing = v end
    })

    Tabs.Sn:AddToggle("SnakeWave", {
        Title = "7. Realistic Body Wave",
        Default = true,
        Callback = function(v) snakeWave = v end
    })

    Tabs.Sn:AddSlider("SnakeWaveHeight", {
        Title = "8. Wave Strength",
        Default = 0.65,
        Min = 0,
        Max = 2,
        Rounding = 2,
        Callback = function(v) snakeWaveHeight = v end
    })

    Tabs.Sn:AddToggle("SnakeSmoothTurns", {
        Title = "9. Smooth Turning",
        Default = true,
        Callback = function(v) snakeSmoothTurns = v end
    })

    Tabs.Sn:AddSlider("SnakeTurnSmooth", {
        Title = "10. Turn Smoothness",
        Default = 0.12,
        Min = 0.02,
        Max = 0.5,
        Rounding = 2,
        Callback = function(v) snakeTurnSmooth = v end
    })

    Tabs.Sn:AddToggle("SnakeHeadLead", {
        Title = "11. Head Lead",
        Default = true,
        Callback = function(v) snakeHeadLead = v end
    })

    Tabs.Sn:AddToggle("SnakeHover", {
        Title = "12. Hover Mode",
        Default = false,
        Callback = function(v) snakeHover = v end
    })

    Tabs.Sn:AddToggle("SnakeBreathing", {
        Title = "13. Body Breathing",
        Default = true,
        Callback = function(v) snakeBreathing = v end
    })

    Tabs.Sn:AddToggle("SnakeTailWhip", {
        Title = "14. Tail Whip",
        Default = true,
        Callback = function(v) snakeTailWhip = v end
    })

    Tabs.Sn:AddToggle("SnakeSpiral", {
        Title = "15. Spiral Travel",
        Default = false,
        Callback = function(v) snakeSpiralTravel = v end
    })

    Tabs.Sn:AddToggle("SnakeRandomStops", {
        Title = "16. Random Destinations",
        Default = true,
        Callback = function(v) snakeRandomStops = v; snakeTarget = nil end
    })

    Tabs.Sn:AddToggle("SnakeReverse", {
        Title = "17. Reverse Body",
        Default = false,
        Callback = function(v) snakeReverse = v end
    })

    Tabs.Sn:AddToggle("SnakePatrol", {
        Title = "18. Patrol Mode",
        Default = false,
        Callback = function(v)
            snakePatrol = v
            if v then snakeAutoTravel = true end
        end
    })

    Tabs.Sn:AddButton({
        Title = "19. New Random Destination",
        Description = "Immediately sends the snake to a new nearby point.",
        Callback = function()
            local character = getCharacter()
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                snakeTarget = chooseSnakeTarget(hrp.Position)
                snakeNextTargetAt = 0
            end
        end
    })

    Tabs.Sn:AddButton({
        Title = "20. Stop Snake",
        Description = "Stop the snake and release the props.",
        Callback = function()
            stopSnake()
        end
    })

    Tabs.Sn:AddParagraph({
        Title = "⚡ Performance",
        Content = "Uses only your owned props. 25 props max. Smooth movement is rate-limited to reduce remote spam."
    })

    -- Settings / profile / size controls
    local propLabel = Tabs.St:AddParagraph({
        Title = "📊 Props",
        Content = "Checking..."
    })

    local profileLabel = Tabs.St:AddParagraph({
        Title = "👤 PROFILE CARD",
        Content =
            "Display: " .. LocalPlayer.DisplayName
            .. "\nUsername: @" .. LocalPlayer.Name
            .. "\nUserId: " .. tostring(LocalPlayer.UserId)
            .. "\nStatus: MANI PROP Ready"
            .. "\nAura: None"
    })

    local function updateProfileLabel()
        pcall(function()
            local auraName = currentAura and AllAuraConfigs[currentAura]
            local auraText = auraName and auraName.name or "None"
            local snakeText = snakeRunning and " • Snake ON" or ""
            profileLabel:SetContent(
                "Display: " .. LocalPlayer.DisplayName
                .. "\nUsername: @" .. LocalPlayer.Name
                .. "\nUserId: " .. tostring(LocalPlayer.UserId)
                .. "\nStatus: " .. (snakeRunning and "Snake Active" or "MANI PROP Ready")
                .. "\nAura: " .. auraText .. snakeText
            )
        end)
    end

    task.spawn(function()
        while true do
            pcall(function()
                if findProps() then
                    propLabel:SetContent(#propList .. " found • using " .. totalProps)
                else
                    propLabel:SetContent("No props")
                end
                updateProfileLabel()
            end)
            task.wait(1)
        end
    end)

    Tabs.St:AddButton({
        Title = "🔄 Refresh Props",
        Description = "Re-scan your owned props.",
        Callback = function()
            findProps()
            if Fluent then
                Fluent:Notify({
                    Title = "Refreshed",
                    Content = #propList .. " props • using " .. totalProps,
                    Duration = 2
                })
            end
        end
    })

    local resizing = false
    local function smoothWindowResize(target)
        if resizing then return end
        resizing = true

        local from = isFull and compactSize or fullSize
        local to = target
        local steps = 14

        for i = 1, steps do
            local alpha = i / steps
            -- SmoothStep easing.
            alpha = alpha * alpha * (3 - 2 * alpha)

            local w = math.floor(from.X.Offset + (to.X.Offset - from.X.Offset) * alpha)
            local h = math.floor(from.Y.Offset + (to.Y.Offset - from.Y.Offset) * alpha)

            pcall(function()
                Window:SetSize(UDim2.fromOffset(w, h))
            end)
            task.wait(0.018)
        end

        -- Final authoritative size; prevents Fluent/mobile scaling from
        -- immediately snapping back after the button is pressed.
        for _ = 1, 3 do
            pcall(function() Window:SetSize(to) end)
            task.wait(0.05)
        end

        resizing = false
    end

    Tabs.St:AddButton({
        Title = "📐 Big Screen / Compact",
        Description = "Smoothly switch GUI size. It will stay at the selected size.",
        Callback = function()
            isFull = not isFull
            task.spawn(function()
                smoothWindowResize(isFull and fullSize or compactSize)
            end)

            if Fluent then
                Fluent:Notify({
                    Title = isFull and "Big Screen" or "Compact",
                    Content = isFull and "Large GUI enabled" or "Mobile compact GUI enabled",
                    Duration = 2
                })
            end
        end
    })

    Tabs.St:AddParagraph({
        Title = "📖 MANI PROP V3",
        Content = "139 Auras • 14+ smooth visual families • Snake: 20 features • 1-25 props • Mobile optimized"
    })

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
        stopSnake()

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
    frame.Size = UDim2.new(0, 278, 0, 360)
    frame.Position = UDim2.new(0.5, -139, 0.5, -180)
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

    local commonList = {"SoftGlow","FreshBreeze","CalmRing","TinyOrbit","SimpleHalo","FloatingMist","GentleWave","LightBloom","MiniSpiral","CloudRing","SoftOrbit","BrightCircle","PeaceAura","BreezeHalo","MorningGlow","FloatingStars","LittleGalaxy","DreamRing","PureHalo","SkyBloom"}
    local uncommonList = {"AquaOrbit","FrostRing","CrystalWave","WindSpiral","Rainfall","BlueComet","IceHalo","MistSpiral","OceanRing","CloudSpiral","SnowOrbit","SilverBloom","MoonRing","StarOrbit","SkySpiral","FrozenHalo","CrystalOrbit","TidalWave","WinterBloom","ArcticRing"}
    local rareList = {"MysticSpiral","PhantomRing","ArcaneOrbit","SoulHalo","AstralBloom","RuneCircle","DreamSpiral","SpiritOrbit","Moonveil","Starveil","EtherRing","MirageOrbit","TwilightHalo","SpectralBloom","MysticCrown","AstralRing","PhantomOrbit","SoulSpiral","ArcaneBloom","Dreamveil"}
    local epicList = {"SolarCrown","LunarCrown","ThunderRing","FlameOrbit","FrostCrown","StormSpiral","CometHalo","MeteorRing","GalaxyOrbit","NebulaBloom","GravityRing","EnergySpiral","VortexHalo","PlasmaOrbit","SolarSpiral","ThunderCrown","CosmicRing","Starstorm","SupernovaHalo","CelestialOrbit"}
    local legendaryList = {"EclipseCrown","VoidSpiral","InfinityRing","EternalOrbit","DivineHalo","AncientCrown","ImmortalSpiral","RealityRing","DimensionOrbit","TimeflowHalo","CosmicCrown","UniverseSpiral","InfinityBloom","CelestialCrown","EternityRing","AstralDominion","DivineOrbit","RealityHalo","InfiniteSpiral","EternalBloom"}
    local mythicList = {"ChaosCrown","AbyssOrbit","OblivionRing","VoidCrown","DarkstarSpiral","BlackholeHalo","EndworldOrbit","PhantomDominion","AbyssalCrown","InfiniteVoid","RealityBreaker","CosmicDestroyer","EternalVoid","DimensionBreak","ChaosSpiral","Voidstorm","BlackstarCrown","OblivionHalo","ZeroPoint","FinalEclipse"}
    local secretList = {"NOVA15","Fifteenfold","Prophecy","TheCollector","LostFormation","ForbiddenOrbit","UnknownEntity","ZeroGravity","BeyondReality","TheLastAura","HiddenDimension","InfiniteMachinery","AbsoluteZero","Worldbreaker","EternalMachinery","UnknownSignal","The15thRealm","Singularity","Realityexe"}

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

    local snakeBtn = Instance.new("TextButton")
    snakeBtn.Size = UDim2.new(0,72,0,20)
    snakeBtn.Position = UDim2.new(0.5,90,1,-28)
    snakeBtn.BackgroundColor3 = Color3.fromRGB(70,140,70)
    snakeBtn.Text = "Snake"
    snakeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    snakeBtn.TextScaled = true
    snakeBtn.Font = Enum.Font.Bold
    snakeBtn.Parent = frame
    snakeBtn.MouseButton1Click:Connect(function()
        if snakeRunning then
            stopSnake()
            snakeBtn.Text = "Snake"
        else
            startSnake()
            snakeBtn.Text = "Stop Snake"
        end
    end)


    -- Full-screen toggle button
    local sizeBtn = Instance.new("TextButton")
    sizeBtn.Size = UDim2.new(0,60,0,20)
    sizeBtn.Position = UDim2.new(0.5, -10, 1, -28)
    sizeBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
    sizeBtn.Text = "Big"
    sizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    sizeBtn.TextScaled = true
    sizeBtn.Font = Enum.Font.Bold
    sizeBtn.Parent = frame
    sizeBtn.MouseButton1Click:Connect(function()
        isFull = not isFull

        local fromW, fromH = frame.AbsoluteSize.X, frame.AbsoluteSize.Y
        local toW, toH = isFull and 430 or 278, isFull and 500 or 360

        for i = 1, 14 do
            local a = i / 14
            a = a * a * (3 - 2 * a)
            local w = math.floor(fromW + (toW - fromW) * a)
            local h = math.floor(fromH + (toH - fromH) * a)
            frame.Size = UDim2.fromOffset(w, h)
            frame.Position = UDim2.new(0.5, -w / 2, 0.5, -h / 2)
            task.wait(0.018)
        end

        frame.Size = UDim2.fromOffset(toW, toH)
        frame.Position = UDim2.new(0.5, -toW / 2, 0.5, -toH / 2)
        sizeBtn.Text = isFull and "Compact" or "Big"
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        local savedAura = currentAura
        stopSnake()

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
    print("MANI PROP GUI V3 fallback loaded. Owned props: " .. #propList .. " (using " .. totalProps .. ")")
end
