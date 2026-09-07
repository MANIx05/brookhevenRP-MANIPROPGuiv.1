-- MANI PROP GUI V.1 by @MANISH_K05
-- All auras automatically use 15 props if available, or 25 props if player has 25+ total props
-- Fixed: GUI loading, error handling, and stability

-- Load Fluent with error handling
local Fluent, FluentError = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not Fluent then
    warn("Failed to load Fluent library: " .. tostring(FluentError))
    return
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- AUTO MESSAGE IN ROBLOX CHAT
pcall(function()
    local chatService = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chatService then
        local sayMsg = chatService:FindFirstChild("SayMessageRequest")
        if sayMsg then
            sayMsg:FireServer("MANI HUB LOADED", "All")
        end
    end
end)

-- Create main window with error handling
local Window
local success, err = pcall(function()
    Window = Fluent:CreateWindow({
        Title = "MANI PROP GUI V.1",
        SubTitle = "by @MANISH_K05",
        TabWidth = 160,
        Size = UDim2.fromOffset(700, 660),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })
end)

if not success or not Window then
    warn("Failed to create GUI window: " .. tostring(err))
    return
end

-- Define tabs
local Tabs = {
    Common = Window:AddTab({ Title = "🟢 Common", Icon = "sparkles" }),
    Uncommon = Window:AddTab({ Title = "🔵 Uncommon", Icon = "gem" }),
    Rare = Window:AddTab({ Title = "🟣 Rare", Icon = "crown" }),
    Epic = Window:AddTab({ Title = "🟠 Epic", Icon = "flame" }),
    Legendary = Window:AddTab({ Title = "🔴 Legendary", Icon = "star" }),
    Mythic = Window:AddTab({ Title = "🟡 Mythic", Icon = "infinity" }),
    Secret = Window:AddTab({ Title = "💠 Secret", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "⚙️ Settings", Icon = "settings" })
}

-- All aura configurations (same auras but props are dynamic based on player's props)
local AllAuraConfigs = {
    -- Common Auras
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
    
    -- Uncommon Auras
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
    
    -- Rare Auras
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
    
    -- Epic Auras
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
    
    -- Legendary Auras
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
    
    -- Mythic Auras
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
    
    -- Secret Auras
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

local currentAura = nil
local auraRunning = false
local auraCoroutine = nil
local propList = {}
local centerPosition = nil
local propFolder = nil
local totalProps = 0

-- Function to find props
local function findProps()
    propList = {}
    local player = game.Players.LocalPlayer
    
    local possiblePaths = {
        "WorkspaceCom/001_TrafficCones",
        "Workspace/WorkspaceCom/001_TrafficCones",
        "Workspace/Props",
        "Workspace/TrafficCones"
    }
    
    for _, path in ipairs(possiblePaths) do
        local parts = {}
        for part in string.gmatch(path, "[^/]+") do
            table.insert(parts, part)
        end
        
        local current = workspace
        local found = true
        for _, part in ipairs(parts) do
            current = current:FindFirstChild(part)
            if not current then
                found = false
                break
            end
        end
        
        if found then
            propFolder = current
            break
        end
    end
    
    if not propFolder then
        for _, child in ipairs(workspace:GetDescendants()) do
            if child:IsA("Folder") and (child.Name:lower():find("prop") or child.Name:lower():find("cone") or child.Name:lower():find("traffic")) then
                propFolder = child
                break
            end
        end
    end
    
    if not propFolder then
        return false
    end
    
    local playerName = game.Players.LocalPlayer.Name
    for _, v in pairs(propFolder:GetChildren()) do
        if v:IsA("BasePart") or v:IsA("Model") then
            if string.find(v.Name, playerName) or string.find(v.Name, player.Name) then
                table.insert(propList, v)
            end
        end
    end
    
    if #propList < 15 then
        propList = {}
        for _, v in pairs(propFolder:GetChildren()) do
            if v:IsA("BasePart") or v:IsA("Model") then
                table.insert(propList, v)
            end
        end
    end
    
    if #propList < 15 then
        return false
    end
    
    -- Determine how many props to use (15 or 25)
    if #propList >= 25 then
        totalProps = 25
    else
        totalProps = 15
    end
    
    return true
end

-- Function to run aura animation
local function runAuraAnimation(config)
    if auraRunning then return end
    auraRunning = true
    
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local useProps = totalProps
    
    while auraRunning do
        if not char or not char.Parent then
            char = player.Character or player.CharacterAdded:Wait()
        end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            centerPosition = hrp.Position
            
            local total = math.min(useProps, #propList)
            local usedProps = {}
            
            for i = 1, total do
                table.insert(usedProps, propList[i])
            end
            
            for i, prop in ipairs(usedProps) do
                if prop and prop.Parent then
                    local angle = (2 * math.pi / total) * i + tick() * config.speed
                    
                    local radius = config.radius
                    local offsetY = config.offsetY
                    
                    if config.type == "wave" then
                        radius = config.radius + math.sin(angle * 3 + tick() * 2) * 2
                    elseif config.type == "spiral" then
                        radius = config.radius + (i / total) * 3 + math.sin(tick() * config.speed) * 1
                    elseif config.type == "star" then
                        if i % 2 == 0 then
                            radius = config.radius * 0.6 + math.sin(tick() * config.speed) * 0.5
                        else
                            radius = config.radius + math.sin(tick() * config.speed) * 0.5
                        end
                    elseif config.type == "double" then
                        if i % 2 == 0 then
                            radius = config.radius * 1.2 + math.sin(tick() * config.speed) * 0.3
                            offsetY = config.offsetY + 1 + math.sin(tick() * config.speed * 0.5)
                        else
                            radius = config.radius * 0.8 + math.sin(tick() * config.speed) * 0.3
                            offsetY = config.offsetY - 1 + math.sin(tick() * config.speed * 0.5)
                        end
                    end
                    
                    local x = math.cos(angle + math.rad(config.rotation)) * radius
                    local z = math.sin(angle + math.rad(config.rotation)) * radius
                    local y = offsetY + math.sin(tick() * config.speed + i) * 0.5
                    
                    local newPos = centerPosition + Vector3.new(x, y, z)
                    local lookAt = CFrame.new(newPos, centerPosition)
                    
                    pcall(function()
                        if prop:FindFirstChild("SetCurrentCFrame") then
                            prop:WaitForChild("SetCurrentCFrame"):InvokeServer(lookAt)
                        else
                            prop.CFrame = lookAt
                        end
                    end)
                end
            end
        end
        
        task.wait(0.05)
    end
end

-- Function to stop aura
local function stopAura()
    auraRunning = false
    if auraCoroutine then
        coroutine.close(auraCoroutine)
        auraCoroutine = nil
    end
    currentAura = nil
end

-- Function to start aura
local function startAura(auraKey)
    stopAura()
    
    if not findProps() then
        Fluent:Notify({
            Title = "Error",
            Content = "No props found! Please place props first.",
            Duration = 5
        })
        return
    end
    
    local config = AllAuraConfigs[auraKey]
    if not config then
        return
    end
    
    local useProps = totalProps
    if useProps < 15 then
        Fluent:Notify({
            Title = "Error",
            Content = "Not enough props! Need at least 15.",
            Duration = 5
        })
        return
    end
    
    currentAura = auraKey
    auraRunning = true
    auraCoroutine = coroutine.create(function()
        runAuraAnimation(config)
    end)
    coroutine.resume(auraCoroutine)
    
    Fluent:Notify({
        Title = config.color .. " Aura Activated",
        Content = config.name .. " with " .. useProps .. " props",
        Duration = 3
    })
end

-- Build aura buttons for a tab
local function buildAuraButtons(tab, auraKeys, title, subtitle)
    pcall(function()
        tab:AddParagraph({
            Title = title,
            Content = subtitle
        })
        
        for _, key in ipairs(auraKeys) do
            local config = AllAuraConfigs[key]
            if config then
                tab:AddButton({
                    Title = config.name .. " (Auto)",
                    Description = "Auto-detects 15 or 25 props",
                    Callback = function()
                        startAura(key)
                    end
                })
            end
        end
    end)
end

-- Build Common Aura UI
local function buildCommonUI()
    local auraList = {
        "SoftGlow", "FreshBreeze", "CalmRing", "TinyOrbit", "SimpleHalo",
        "FloatingMist", "GentleWave", "LightBloom", "MiniSpiral", "CloudRing",
        "SoftOrbit", "BrightCircle", "PeaceAura", "BreezeHalo", "MorningGlow",
        "FloatingStars", "LittleGalaxy", "DreamRing", "PureHalo", "SkyBloom"
    }
    buildAuraButtons(Tabs.Common, auraList, "⭐ Common Auras", "Auto-detects 15 or 25 props")
end

-- Build Uncommon Aura UI
local function buildUncommonUI()
    local auraList = {
        "AquaOrbit", "FrostRing", "CrystalWave", "WindSpiral", "Rainfall",
        "BlueComet", "IceHalo", "MistSpiral", "OceanRing", "CloudSpiral",
        "SnowOrbit", "SilverBloom", "MoonRing", "StarOrbit", "SkySpiral",
        "FrozenHalo", "CrystalOrbit", "TidalWave", "WinterBloom", "ArcticRing"
    }
    buildAuraButtons(Tabs.Uncommon, auraList, "💎 Uncommon Auras", "Auto-detects 15 or 25 props")
end

-- Build Rare Aura UI
local function buildRareUI()
    local auraList = {
        "MysticSpiral", "PhantomRing", "ArcaneOrbit", "SoulHalo", "AstralBloom",
        "RuneCircle", "DreamSpiral", "SpiritOrbit", "Moonveil", "Starveil",
        "EtherRing", "MirageOrbit", "TwilightHalo", "SpectralBloom", "MysticCrown",
        "AstralRing", "PhantomOrbit", "SoulSpiral", "ArcaneBloom", "Dreamveil"
    }
    buildAuraButtons(Tabs.Rare, auraList, "👑 Rare Auras", "Auto-detects 15 or 25 props")
end

-- Build Epic Aura UI
local function buildEpicUI()
    local auraList = {
        "SolarCrown", "LunarCrown", "ThunderRing", "FlameOrbit", "FrostCrown",
        "StormSpiral", "CometHalo", "MeteorRing", "GalaxyOrbit", "NebulaBloom",
        "GravityRing", "EnergySpiral", "VortexHalo", "PlasmaOrbit", "SolarSpiral",
        "ThunderCrown", "CosmicRing", "Starstorm", "SupernovaHalo", "CelestialOrbit"
    }
    buildAuraButtons(Tabs.Epic, auraList, "🔥 Epic Auras", "Auto-detects 15 or 25 props")
end

-- Build Legendary Aura UI
local function buildLegendaryUI()
    local auraList = {
        "EclipseCrown", "VoidSpiral", "InfinityRing", "EternalOrbit", "DivineHalo",
        "AncientCrown", "ImmortalSpiral", "RealityRing", "DimensionOrbit", "TimeflowHalo",
        "CosmicCrown", "UniverseSpiral", "InfinityBloom", "CelestialCrown", "EternityRing",
        "AstralDominion", "DivineOrbit", "RealityHalo", "InfiniteSpiral", "EternalBloom"
    }
    buildAuraButtons(Tabs.Legendary, auraList, "⭐ Legendary Auras", "Auto-detects 15 or 25 props")
end

-- Build Mythic Aura UI
local function buildMythicUI()
    local auraList = {
        "ChaosCrown", "AbyssOrbit", "OblivionRing", "VoidCrown", "DarkstarSpiral",
        "BlackholeHalo", "EndworldOrbit", "PhantomDominion", "AbyssalCrown", "InfiniteVoid",
        "RealityBreaker", "CosmicDestroyer", "EternalVoid", "DimensionBreak", "ChaosSpiral",
        "Voidstorm", "BlackstarCrown", "OblivionHalo", "ZeroPoint", "FinalEclipse"
    }
    buildAuraButtons(Tabs.Mythic, auraList, "🌟 Mythic Auras", "Auto-detects 15 or 25 props")
end

-- Build Secret Aura UI
local function buildSecretUI()
    local auraList = {
        "NOVA15", "Fifteenfold", "Prophecy", "TheCollector", "LostFormation",
        "ForbiddenOrbit", "UnknownEntity", "ZeroGravity", "BeyondReality", "TheLastAura",
        "HiddenDimension", "InfiniteMachinery", "AbsoluteZero", "Worldbreaker", "EternalMachinery",
        "UnknownSignal", "The15thRealm", "Singularity", "Realityexe"
    }
    buildAuraButtons(Tabs.Secret, auraList, "💠 Secret / Ultra Rare Auras", "Auto-detects 15 or 25 props")
end

-- Build Control UI (shared)
local function buildControlsUI()
    local function addControls(tab)
        tab:AddParagraph({
            Title = "🎮 Controls",
            Content = "Manage your aura"
        })
        
        tab:AddButton({
            Title = "⏹️ Stop Aura",
            Description = "Stop the current aura",
            Callback = function()
                stopAura()
                Fluent:Notify({
                    Title = "Aura Stopped",
                    Content = "All props stopped",
                    Duration = 3
                })
            end
        })
        
        tab:AddButton({
            Title = "🔄 Reset Props",
            Description = "Reset props to center position",
            Callback = function()
                stopAura()
                if findProps() then
                    local player = game.Players.LocalPlayer
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")
                    
                    for _, prop in ipairs(propList) do
                        pcall(function()
                            if prop:FindFirstChild("SetCurrentCFrame") then
                                prop:WaitForChild("SetCurrentCFrame"):InvokeServer(CFrame.new(hrp.Position))
                            else
                                prop.CFrame = CFrame.new(hrp.Position)
                            end
                        end)
                    end
                    Fluent:Notify({
                        Title = "Props Reset",
                        Content = "All props moved to center",
                        Duration = 3
                    })
                end
            end
        })
    end
    
    addControls(Tabs.Common)
    addControls(Tabs.Uncommon)
    addControls(Tabs.Rare)
    addControls(Tabs.Epic)
    addControls(Tabs.Legendary)
    addControls(Tabs.Mythic)
    addControls(Tabs.Secret)
end

-- Settings Tab
local function buildSettingsUI()
    Tabs.Settings:AddParagraph({
        Title = "⚙️ Settings",
        Content = "Aura settings and information"
    })
    
    -- Prop counter
    local propCountLabel = Tabs.Settings:AddParagraph({
        Title = "📊 Props Status",
        Content = "Checking props..."
    })
    
    -- Update prop count
    task.spawn(function()
        while true do
            pcall(function()
                if findProps() then
                    propCountLabel:SetContent("Found " .. #propList .. " props available\nUsing " .. totalProps .. " props for auras")
                else
                    propCountLabel:SetContent("No props found\nMake sure you have props placed")
                end
            end)
            task.wait(2)
        end
    end)
    
    Tabs.Settings:AddButton({
        Title = "🔄 Refresh Props",
        Description = "Refresh the prop list",
        Callback = function()
            pcall(function()
                findProps()
                Fluent:Notify({
                    Title = "Refreshed",
                    Content = "Found " .. #propList .. " props (using " .. totalProps .. ")",
                    Duration = 3
                })
            end)
        end
    })
    
    -- Aura Info
    Tabs.Settings:AddParagraph({
        Title = "📖 Aura Info",
        Content = "139 Different Auras Available:\n" ..
                   "• All auras automatically detect props\n" ..
                   "• Uses 15 props if you have 15-24 props\n" ..
                   "• Uses 25 props if you have 25+ props\n\n" ..
                   "Aura Types:\n" ..
                   "• Circle - Standard ring\n" ..
                   "• Wave - Wavy motion\n" ..
                   "• Spiral - Spiral pattern\n" ..
                   "• Star - Star pattern\n" ..
                   "• Double - Two-layer ring"
    })
end

-- Initialize
task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    
    pcall(function()
        findProps()
        
        buildCommonUI()
        buildUncommonUI()
        buildRareUI()
        buildEpicUI()
        buildLegendaryUI()
        buildMythicUI()
        buildSecretUI()
        buildControlsUI()
        buildSettingsUI()
        
        Window:SelectTab(1)
    end)
    
    Fluent:Notify({
        Title = "MANI PROP GUI V.1",
        Content = "139 Auras Loaded Successfully!",
        Duration = 5
    })
    
    if #propList > 0 then
        Fluent:Notify({
            Title = "Props Found",
            Content = #propList .. " props found (using " .. totalProps .. ")",
            Duration = 5
        })
    else
        Fluent:Notify({
            Title = "No Props Found",
            Content = "Place props to use auras",
            Duration = 5
        })
    end
end)

-- Addons setup
pcall(function()
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("MANIPropGUI")
    SaveManager:SetFolder("MANIPropGUI/props")
    
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
    
    SaveManager:LoadAutoloadConfig()
end)

-- Auto-stop aura when player respawns
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    stopAura()
end)
