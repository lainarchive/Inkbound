local Stroke = {}

export type Point = {
	position: Vector2,
	timestamp: number,
}

export type Data = {
	points: { Point },
	startedAt: number,
	endedAt: number?,
}

function Stroke.new(): Data
	return {
		points = {},
		startedAt = os.clock(),
	}
end

function Stroke.addPoint(stroke: Data, position: Vector2, timestamp: number?): boolean
	local lastPoint = stroke.points[#stroke.points]
	if lastPoint and (position - lastPoint.position).Magnitude < 3 then
		return false
	end

	table.insert(stroke.points, {
		position = position,
		timestamp = timestamp or os.clock(),
	})

	return true
end

function Stroke.finish(stroke: Data, timestamp: number?)
	stroke.endedAt = timestamp or os.clock()
end

return Stroke
