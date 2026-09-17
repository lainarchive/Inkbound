local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local Stroke = require(ReplicatedStorage:WaitForChild("Inkbound"):WaitForChild("Stroke"))

local INK_COLOR = Color3.fromRGB(35, 43, 60)
local PAPER_COLOR = Color3.fromRGB(242, 232, 207)
local ACCENT_COLOR = Color3.fromRGB(222, 170, 91)

local playerGui = player:WaitForChild("PlayerGui")
local oldGui = playerGui:FindFirstChild("InkboundDrawingGui")
if oldGui then
	oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "InkboundDrawingGui"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 20
gui.Parent = playerGui

local strokeLayer = Instance.new("Frame")
strokeLayer.Name = "StrokeLayer"
strokeLayer.BackgroundTransparency = 1
strokeLayer.BorderSizePixel = 0
strokeLayer.Size = UDim2.fromScale(1, 1)
strokeLayer.ZIndex = 1
strokeLayer.Parent = gui

local statusPanel = Instance.new("Frame")
statusPanel.Name = "StatusPanel"
statusPanel.AnchorPoint = Vector2.new(0, 0)
statusPanel.BackgroundColor3 = PAPER_COLOR
statusPanel.BackgroundTransparency = 0.08
statusPanel.BorderSizePixel = 0
statusPanel.Position = UDim2.fromOffset(22, 22)
statusPanel.Size = UDim2.fromOffset(300, 108)
statusPanel.ZIndex = 10
statusPanel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = statusPanel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = INK_COLOR
panelStroke.Thickness = 2
panelStroke.Transparency = 0.2
panelStroke.Parent = statusPanel

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(16, 10)
title.Size = UDim2.fromOffset(268, 26)
title.Font = Enum.Font.GothamBold
title.Text = "INKBOUND  /  DRAWING PROTOTYPE"
title.TextColor3 = INK_COLOR
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11
title.Parent = statusPanel

local status = Instance.new("TextLabel")
status.Name = "Status"
status.BackgroundTransparency = 1
status.Position = UDim2.fromOffset(16, 39)
status.Size = UDim2.fromOffset(268, 24)
status.Font = Enum.Font.GothamSemibold
status.TextColor3 = ACCENT_COLOR
status.TextSize = 16
status.TextXAlignment = Enum.TextXAlignment.Left
status.ZIndex = 11
status.Parent = statusPanel

local stats = Instance.new("TextLabel")
stats.Name = "Stats"
stats.BackgroundTransparency = 1
stats.Position = UDim2.fromOffset(16, 65)
stats.Size = UDim2.fromOffset(268, 20)
stats.Font = Enum.Font.Gotham
stats.TextColor3 = INK_COLOR
stats.TextSize = 12
stats.TextXAlignment = Enum.TextXAlignment.Left
stats.ZIndex = 11
stats.Parent = statusPanel

local hint = Instance.new("TextLabel")
hint.Name = "Hint"
hint.AnchorPoint = Vector2.new(0.5, 1)
hint.BackgroundColor3 = PAPER_COLOR
hint.BackgroundTransparency = 0.08
hint.BorderSizePixel = 0
hint.Position = UDim2.fromScale(0.5, 0.96)
hint.Size = UDim2.fromOffset(460, 34)
hint.Font = Enum.Font.GothamMedium
hint.Text = "Press E to enter drawing mode  •  Hold left mouse / touch to draw  •  R clears"
hint.TextColor3 = INK_COLOR
hint.TextSize = 13
hint.ZIndex = 10
hint.Parent = gui

local hintCorner = Instance.new("UICorner")
hintCorner.CornerRadius = UDim.new(0, 10)
hintCorner.Parent = hint

local drawingEnabled = false
local currentStroke = nil
local currentContainer = nil
local pointerKind = nil
local activeTouch = nil
local strokeCount = 0
local pointCount = 0

local function refreshStats()
	stats.Text = string.format("Strokes: %d   Points captured: %d", strokeCount, pointCount)
end

local function getPointerPosition(inputObject)
	if inputObject and inputObject.UserInputType == Enum.UserInputType.Touch then
		return Vector2.new(inputObject.Position.X, inputObject.Position.Y)
	end

	local mousePosition = UserInputService:GetMouseLocation()
	return Vector2.new(mousePosition.X, mousePosition.Y)
end

local function drawSegment(container, fromPosition, toPosition)
	local delta = toPosition - fromPosition
	local length = delta.Magnitude
	if length < 1 then
		return
	end

	local segment = Instance.new("Frame")
	segment.Name = "InkSegment"
	segment.AnchorPoint = Vector2.new(0.5, 0.5)
	segment.BackgroundColor3 = INK_COLOR
	segment.BorderSizePixel = 0
	segment.Position = UDim2.fromOffset(
		(fromPosition.X + toPosition.X) / 2,
		(fromPosition.Y + toPosition.Y) / 2
	)
	segment.Rotation = math.deg(math.atan2(delta.Y, delta.X))
	segment.Size = UDim2.fromOffset(length, 7)
	segment.ZIndex = 2
	segment.Parent = container

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = segment
end

local function appendPoint(position)
	if not currentStroke then
		return
	end

	local previousPoint = currentStroke.points[#currentStroke.points]
	if Stroke.addPoint(currentStroke, position) then
		pointCount += 1
		if previousPoint then
			drawSegment(currentContainer, previousPoint.position, position)
		end
		refreshStats()
	end
end

local function finishStroke()
	if not currentStroke then
		return
	end

	Stroke.finish(currentStroke)
	if #currentStroke.points >= 2 then
		strokeCount += 1
		Debris:AddItem(currentContainer, 4)
	else
		currentContainer:Destroy()
		pointCount -= #currentStroke.points
	end

	currentStroke = nil
	currentContainer = nil
	pointerKind = nil
	activeTouch = nil
	refreshStats()
end

local function beginStroke(inputObject)
	if currentStroke then
		finishStroke()
	end

	currentStroke = Stroke.new()
	currentContainer = Instance.new("Frame")
	currentContainer.Name = "Stroke"
	currentContainer.BackgroundTransparency = 1
	currentContainer.BorderSizePixel = 0
	currentContainer.Size = UDim2.fromScale(1, 1)
	currentContainer.ZIndex = 2
	currentContainer.Parent = strokeLayer

	if inputObject.UserInputType == Enum.UserInputType.Touch then
		pointerKind = "touch"
		activeTouch = inputObject
	else
		pointerKind = "mouse"
	end

	appendPoint(getPointerPosition(inputObject))
end

local function clearStrokes()
	for _, child in ipairs(strokeLayer:GetChildren()) do
		child:Destroy()
	end
	currentStroke = nil
	currentContainer = nil
	pointerKind = nil
	activeTouch = nil
	strokeCount = 0
	pointCount = 0
	refreshStats()
end

local function setDrawingEnabled(enabled)
	drawingEnabled = enabled
	if not drawingEnabled then
		finishStroke()
	end

	if drawingEnabled then
		status.Text = "DRAWING MODE  /  INK READY"
		status.TextColor3 = ACCENT_COLOR
	else
		status.Text = "EXPLORE MODE  /  PRESS E TO DRAW"
		status.TextColor3 = INK_COLOR
	end
end

UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
	if inputObject.KeyCode == Enum.KeyCode.E then
		setDrawingEnabled(not drawingEnabled)
		return
	end

	if inputObject.KeyCode == Enum.KeyCode.R then
		clearStrokes()
		return
	end

	if inputObject.KeyCode == Enum.KeyCode.Escape then
		setDrawingEnabled(false)
		return
	end

	if gameProcessed or not drawingEnabled then
		return
	end

	local isMouse = inputObject.UserInputType == Enum.UserInputType.MouseButton1
	local isTouch = inputObject.UserInputType == Enum.UserInputType.Touch
	if isMouse or isTouch then
		beginStroke(inputObject)
	end
end)

UserInputService.InputChanged:Connect(function(inputObject)
	if not currentStroke then
		return
	end

	if pointerKind == "mouse" and inputObject.UserInputType == Enum.UserInputType.MouseMovement then
		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
			appendPoint(getPointerPosition(inputObject))
		end
	elseif pointerKind == "touch" and inputObject == activeTouch then
		appendPoint(getPointerPosition(inputObject))
	end
end)

UserInputService.InputEnded:Connect(function(inputObject)
	if pointerKind == "mouse" and inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
		finishStroke()
	elseif pointerKind == "touch" and inputObject == activeTouch then
		finishStroke()
	end
end)

UserInputService.WindowFocusReleased:Connect(finishStroke)

refreshStats()
setDrawingEnabled(false)
