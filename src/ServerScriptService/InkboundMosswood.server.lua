local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local oldScene = Workspace:FindFirstChild("InkboundMosswood")
if oldScene then
	oldScene:Destroy()
end

local scene = Instance.new("Folder")
scene.Name = "InkboundMosswood"
scene.Parent = Workspace

local environment = Instance.new("Folder")
environment.Name = "Environment"
environment.Parent = scene

local landmarks = Instance.new("Folder")
landmarks.Name = "Landmarks"
landmarks.Parent = scene

local props = Instance.new("Folder")
props.Name = "Props"
props.Parent = scene

local INK = Color3.fromRGB(35, 43, 60)
local PAPER = Color3.fromRGB(224, 214, 188)
local MOSS = Color3.fromRGB(93, 129, 90)
local MOSS_DARK = Color3.fromRGB(53, 77, 67)
local BARK = Color3.fromRGB(91, 67, 57)
local GLOW = Color3.fromRGB(222, 170, 91)
local FLOWER = Color3.fromRGB(173, 124, 169)

local function makePart(parent, name, size, cframe, color, material, shape, canCollide)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = canCollide ~= false
	part.CastShadow = true
	part.Color = color
	part.Material = material
	part.Size = size
	part.CFrame = cframe
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	if shape then
		part.Shape = shape
	end
	part.Parent = parent
	return part
end

local function makeTree(x, z, scale)
	local trunkHeight = 8 * scale
	makePart(
		environment,
		"TreeTrunk",
		Vector3.new(1.8 * scale, trunkHeight, 1.8 * scale),
		CFrame.new(x, trunkHeight / 2, z),
		BARK,
		Enum.Material.Wood,
		Enum.PartType.Cylinder
	)

	makePart(
		environment,
		"TreeCanopy",
		Vector3.new(9 * scale, 7 * scale, 9 * scale),
		CFrame.new(x, trunkHeight + 1.5 * scale, z),
		MOSS,
		Enum.Material.Grass,
		Enum.PartType.Ball,
		false
	)
	makePart(
		environment,
		"TreeCanopyInk",
		Vector3.new(5 * scale, 4 * scale, 5 * scale),
		CFrame.new(x + 1.4 * scale, trunkHeight + 3 * scale, z - 0.6 * scale),
		MOSS_DARK,
		Enum.Material.Grass,
		Enum.PartType.Ball,
		false
	)
end

local function makeFlower(x, z, color)
	makePart(
		props,
		"FlowerStem",
		Vector3.new(0.18, 1.4, 0.18),
		CFrame.new(x, 0.7, z),
		MOSS_DARK,
		Enum.Material.Grass,
		Enum.PartType.Cylinder,
		false
	)
	makePart(
		props,
		"FlowerBud",
		Vector3.new(0.75, 0.75, 0.75),
		CFrame.new(x, 1.45, z),
		color,
		Enum.Material.Neon,
		Enum.PartType.Ball,
		false
	)
end

-- A simple illustrated floor gives the drawing prototype a place to live.
makePart(
	environment,
	"MosswoodGround",
	Vector3.new(180, 2, 180),
	CFrame.new(0, -1, 0),
	Color3.fromRGB(137, 153, 112),
	Enum.Material.Grass
)

-- Paper-like stepping stones lead from the spawn to the drawing clearing.
for index = 1, 6 do
	local z = 58 - (index - 1) * 10
	makePart(
		landmarks,
		"PathStone",
		Vector3.new(15, 0.35, 7),
		CFrame.new(0, 0.18, z) * CFrame.Angles(0, math.rad((index % 2 == 0 and 4 or -4)), 0),
		PAPER,
		Enum.Material.Sandstone
	)
end

-- The first playable space: a quiet clearing intended for drawing tests.
local clearing = makePart(
	landmarks,
	"DrawingClearing",
	Vector3.new(34, 0.7, 34),
	CFrame.new(0, 0.35, -8),
	PAPER,
	Enum.Material.Sandstone,
	Enum.PartType.Cylinder
)
clearing.CastShadow = false

local inkstone = makePart(
	landmarks,
	"Inkstone",
	Vector3.new(3.5, 3.5, 3.5),
	CFrame.new(0, 3, -8),
	INK,
	Enum.Material.Neon,
	Enum.PartType.Ball,
	false
)
local inkLight = Instance.new("PointLight")
inkLight.Color = GLOW
inkLight.Brightness = 1.8
inkLight.Range = 18
inkLight.Parent = inkstone

for index = 1, 8 do
	local angle = (math.pi * 2 / 8) * index
	local x = math.cos(angle) * 13
	local z = -8 + math.sin(angle) * 13
	makePart(
		landmarks,
		"ClearingStone",
		Vector3.new(2.5, 1.1, 2.5),
		CFrame.new(x, 0.8, z),
		MOSS_DARK,
		Enum.Material.Slate,
		Enum.PartType.Ball
	)
end

-- A readable sign makes the test scene self-explanatory in Studio.
makePart(
	props,
	"SignPost",
	Vector3.new(0.7, 5, 0.7),
	CFrame.new(-14, 2.5, 50),
	BARK,
	Enum.Material.Wood,
	Enum.PartType.Cylinder
)
local sign = makePart(
	props,
	"MosswoodSign",
	Vector3.new(12, 4.5, 0.6),
	CFrame.new(-8, 4.6, 50) * CFrame.Angles(0, math.rad(8), 0),
	PAPER,
	Enum.Material.Wood
)

local signGui = Instance.new("SurfaceGui")
signGui.Name = "SignText"
signGui.AlwaysOnTop = true
signGui.Face = Enum.NormalId.Front
signGui.LightInfluence = 0
signGui.PixelsPerStud = 45
signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
signGui.Parent = sign

local signText = Instance.new("TextLabel")
signText.BackgroundTransparency = 1
signText.Size = UDim2.fromScale(1, 1)
signText.Font = Enum.Font.GothamBold
signText.Text = "MOSSWOOD\nquiet ink lives here"
signText.TextColor3 = INK
signText.TextScaled = true
signText.TextWrapped = true
signText.Parent = signGui

for _, tree in ipairs({
	{ -70, 55, 1.4 },
	{ -52, 22, 1.0 },
	{ 60, 42, 1.3 },
	{ 68, -18, 1.1 },
	{ -63, -28, 1.15 },
	{ 48, -57, 1.45 },
	{ -35, -65, 0.95 },
}) do
	makeTree(tree[1], tree[2], tree[3])
end

for _, flower in ipairs({
	{ -28, 34, FLOWER },
	{ 26, 28, GLOW },
	{ -31, -35, GLOW },
	{ 30, -30, FLOWER },
	{ -45, 4, FLOWER },
	{ 43, 5, GLOW },
}) do
	makeFlower(flower[1], flower[2], flower[3])
end

local spawn = Instance.new("SpawnLocation")
spawn.Name = "MosswoodSpawn"
spawn.Anchored = true
spawn.CanCollide = true
spawn.Neutral = true
spawn.AllowTeamChangeOnTouch = false
spawn.Duration = 0
spawn.Material = Enum.Material.Grass
spawn.Color = MOSS
spawn.Size = Vector3.new(8, 1, 8)
spawn.CFrame = CFrame.new(0, 0.5, 68)
spawn.Parent = scene

local atmosphere = Lighting:FindFirstChild("InkboundMosswoodAtmosphere")
if atmosphere then
	atmosphere:Destroy()
end

atmosphere.Name = "InkboundMosswoodAtmosphere"
atmosphere.Color = Color3.fromRGB(198, 210, 181)
atmosphere.Decay = Color3.fromRGB(95, 113, 109)
atmosphere.Density = 0.25
atmosphere.Glare = 0.1
atmosphere.Haze = 1.1
atmosphere.Parent = Lighting

Lighting.Ambient = Color3.fromRGB(105, 116, 106)
Lighting.Brightness = 2
Lighting.ClockTime = 17.5
Lighting.OutdoorAmbient = Color3.fromRGB(126, 139, 112)
