-- MANI PROP GUI V.1 by @MANISH_K05
-- Ultra-compact for mobile: 320x420 / 280x380
-- Fixed prop detection to match your original script

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

-- Fixed prop detection (exactly matching your original script)
local function findProps()
    propList = {}
    local player = game.Players.LocalPlayer

    -- Try exact path first
    local folder = workspace:FindFirstChild("WorkspaceCom")
    if folder then
        folder = folder:FindFirstChild("001_TrafficCones")
    end

    if folder then
        propFolder = folder
    else
        -- fallback search
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

    -- Collect props: first try to match player name
    local playerName = player.Name
    local foundAny = false
    for _, v in pairs(propFolder:GetChildren()) do
        if v:IsA("BasePart") or v:IsA("Model") then
            if string.find(v.Name, playerName) then
                table.insert(propList, v)
                foundAny = true
            end
        end
    end

    -- If none match, take all props
    if not foundAny then
        for _, v in pairs(propFolder:GetChildren()) do
            if v:IsA("BasePart") or v:IsA("Model") then
                table.insert(propList, v)
            end
        end
    end

    if #propList < 15 then
        return false
    end

    totalProps = (#propList >= 25) and 25 or 15
    return true
end

-- Animation function with proper SetCurrentCFrame handling
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

                    -- Use InvokeServer if available, otherwise set CFrame directly
                    pcall(function()
                        local setCF = prop:FindFirstChild("SetCurrentCFrame")
                        if setCF then
                            setCF:InvokeServer(lookAt)
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

local function stopAura()
    auraRunning = false
    if auraCoroutine then
        coroutine.close(auraCoroutine)
        auraCoroutine = nil
    end
    currentAura = nil
end

local function startAura(auraKey)
    stopAura()
    if not findProps() then
        print("No props found!")
        return
    end
    local config = AllAuraConfigs[auraKey]
    if not config then
        return
    end
    if totalProps < 15 then
        print("Not enough props!")
        return
    end
    currentAura = auraKey
    auraRunning = true
    auraCoroutine = coroutine.create(function()
        runAuraAnimation(config)
    end)
    coroutine.resume(auraCoroutine)
    print(config.color .. " " .. config.name .. " activated with " .. totalProps .. " props")
end

-- Try to load Fluent
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

if UseFluent and Fluent then
    local SaveManager, InterfaceManager
    pcall(function()
        SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
        InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
    end)

    local Window = Fluent:CreateWindow({
        Title = "MANI PROP GUI",
        SubTitle = "v1",
        TabWidth = 100,
        Size = UDim2.fromOffset(320, 420),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local Tabs = {
        C = Window:AddTab({ Title = "🟢", Icon = "sparkles" }),
        U = Window:AddTab({ Title = "🔵", Icon = "gem" }),
        R = Window:AddTab({ Title = "🟣", Icon = "crown" }),
        E = Window:AddTab({ Title = "🟠", Icon = "flame" }),
        L = Window:AddTab({ Title = "🔴", Icon = "star" }),
        M = Window:AddTab({ Title = "🟡", Icon = "infinity" }),
        S = Window:AddTab({ Title = "💠", Icon = "eye" }),
        St = Window:AddTab({ Title = "⚙️", Icon = "settings" })
    }

    local function buildAuraButtons(tab, auraKeys, title)
        pcall(function()
            tab:AddParagraph({ Title = title, Content = "15/25 props" })
            for _, key in ipairs(auraKeys) do
                local config = AllAuraConfigs[key]
                if config then
                    tab:AddButton({
                        Title = config.name,
                        Description = "",
                        Callback = function()
                            startAura(key)
                        end
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

    -- Controls in each tab
    local function addControls(tab)
        tab:AddParagraph({ Title = "🎮", Content = "" })
        tab:AddButton({ Title = "⏹️Stop", Description = "", Callback = function() stopAura() Fluent:Notify({Title="Stopped", Content="Aura stopped", Duration=2}) end })
        tab:AddButton({ Title = "🔄Reset", Description = "", Callback = function()
            stopAura()
            if findProps() then
                local player = game.Players.LocalPlayer
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                for _, prop in ipairs(propList) do
                    pcall(function()
                        local setCF = prop:FindFirstChild("SetCurrentCFrame")
                        if setCF then setCF:InvokeServer(CFrame.new(hrp.Position))
                        else prop.CFrame = CFrame.new(hrp.Position) end
                    end)
                end
                Fluent:Notify({Title="Reset", Content="Props reset", Duration=2})
            end
        end })
    end
    addControls(Tabs.C); addControls(Tabs.U); addControls(Tabs.R); addControls(Tabs.E); addControls(Tabs.L); addControls(Tabs.M); addControls(Tabs.S)

    -- Settings tab
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
    Tabs.St:AddButton({ Title = "🔄Refresh", Description = "", Callback = function() findProps() Fluent:Notify({Title="Refreshed", Content=#propList.." props", Duration=2}) end })
    Tabs.St:AddParagraph({ Title = "📖 Info", Content = "139 auras • Auto 15/25" })

    task.spawn(function()
        repeat task.wait() until game:IsLoaded()
        pcall(function()
            findProps()
            Window:SelectTab(1)
        end)
        Fluent:Notify({ Title = "MANI PROP GUI", Content = "139 Auras Loaded!", Duration = 3 })
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

    game.Players.LocalPlayer.CharacterAdded:Connect(function() stopAura() end)

else
    -- Fallback GUI (even smaller)
    local player = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "MANIPropGUI"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 380)
    frame.Position = UDim2.new(0.5, -140, 0.5, -190)
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

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,22,0,22)
    closeBtn.Position = UDim2.new(1,-26,0,3)
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
    stopBtn.Size = UDim2.new(0,70,0,20)
    stopBtn.Position = UDim2.new(0.5,-80,1,-28)
    stopBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    stopBtn.Text = "Stop"
    stopBtn.TextColor3 = Color3.fromRGB(255,255,255)
    stopBtn.TextScaled = true
    stopBtn.Font = Enum.Font.Bold
    stopBtn.Parent = frame
    stopBtn.MouseButton1Click:Connect(function() stopAura() end)

    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0,70,0,20)
    resetBtn.Position = UDim2.new(0.5,10,1,-28)
    resetBtn.BackgroundColor3 = Color3.fromRGB(50,50,200)
    resetBtn.Text = "Reset"
    resetBtn.TextColor3 = Color3.fromRGB(255,255,255)
    resetBtn.TextScaled = true
    resetBtn.Font = Enum.Font.Bold
    resetBtn.Parent = frame
    resetBtn.MouseButton1Click:Connect(function()
        stopAura()
        if findProps() then
            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            for _, prop in ipairs(propList) do
                pcall(function()
                    local setCF = prop:FindFirstChild("SetCurrentCFrame")
                    if setCF then setCF:InvokeServer(CFrame.new(hrp.Position))
                    else prop.CFrame = CFrame.new(hrp.Position) end
                end)
            end
        end
    end)

    game.Players.LocalPlayer.CharacterAdded:Connect(function() stopAura() end)
    findProps()
    print("Fallback GUI loaded. Props: " .. #propList .. " (using " .. totalProps .. ")")
end
