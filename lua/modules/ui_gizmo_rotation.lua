-- Example
--	local node = ui_rotation:create({ shape = shape })
--	node.Size = 220
--	node.pos = { 50, 300 }
--  node:setShape(shape2)

local create = function(_, config)
	local ui = require("uikit")
	local padding = require("uitheme").current.padding
	local node = ui:createFrame(Color(0,0,0,0.2))

	local shape = config.shape

	local shapeWorldAxis = MutableShape()
	shapeWorldAxis:AddBlock(Color.White,0,0,0)
	shapeWorldAxis.Pivot = { 0.5, 0.5, 0.5 }

	local ratio = 7
	local axisConfig = {
		{ color = Color.Red, axis = "X", vector = "Right" },
		{ color = Color.Green, axis = "Y", vector = "Up" },
		{ color = Color.Blue, axis = "Z", vector = "Forward" },
	}
	local axisList = {}

	local diff = nil
	for _,config in ipairs(axisConfig) do
		local handle = MutableShape()
		handle:AddBlock(config.color,0,0,0)

		local uiAxis = ui:createShape(handle)
		uiAxis:setParent(node)

		uiAxis.parentDidResize = function()
			uiAxis.pos = { (node.Width - ratio) * 0.5, (node.Height - ratio) * 0.5 }
			local handleSize = node.Width / ratio
			handle.Scale[config.axis] = handleSize
			if handle.sphereUp then
				handle.sphereUp.Scale[config.axis] = 1 / handleSize
                handle.sphereUp.Scale = handle.sphereUp.Scale * (node.Width / 200)
				handle.sphereDown.Scale[config.axis] = 1 / handleSize
                handle.sphereDown.Scale = handle.sphereDown.Scale * (node.Width / 200)
			end
		end
		handle.Pivot = { 0.5, 0.5, 0.5 }

		uiAxis.onPress = function()
			diff = 0
			shapeWorldAxis:SetParent(World)
			shapeWorldAxis.Position = shape.Position
			shapeWorldAxis.Rotation = shape.Rotation
			if config.axis == "X" then
				shapeWorldAxis.Scale = shape.Scale * Number3(shape.Width + 5, 0.1, 0.1)
			elseif config.axis == "Y" then
				shapeWorldAxis.Scale = shape.Scale * Number3(0.1, shape.Height + 5, 0.1)
			elseif config.axis == "Z" then
				shapeWorldAxis.Scale = shape.Scale * Number3(0.1, 0.1, shape.Depth + 5)
			end
            shapeWorldAxis.Palette[1].Color = config.color
		end
		uiAxis.onDrag = function(_, x, _)
			shape:RotateWorld(shape[config.vector], (diff - x) * 0.01)
			shape.Rotation = shape.Rotation -- trigger onsetcallback

			shapeWorldAxis.Position = shape.Position
			shapeWorldAxis.Rotation = shape.Rotation
			diff = x
			return true
		end
		uiAxis.onRelease = function()
			shapeWorldAxis:RemoveFromParent()
		end
		table.insert(axisList, { handle = handle, uiAxis = uiAxis })

		-- sphere handles
		Object:Load("caillef.sphere7x7", function(obj)
			obj:SetParent(handle)
			obj.Pivot = { obj.Width * 0.5, obj.Height * 0.5, obj.Depth * 0.5 }
			obj.Palette[1].Color = config.color
			obj.LocalPosition[config.axis] = 0.5
			obj.Layers = handle.Layers
			obj.CollisionGroups = handle.CollisionGroups
			obj.Physics = PhysicsMode.TriggerPerBlock
            obj.IsUnlit = true
			handle.sphereUp = obj

			obj = Shape(obj)
			obj:SetParent(handle)
			obj.Pivot = { obj.Width * 0.5, obj.Height * 0.5, obj.Depth * 0.5 }
			obj.Palette[1].Color = config.color
			obj.LocalPosition[config.axis] = -0.5
			obj.Layers = handle.Layers
			obj.CollisionGroups = handle.CollisionGroups
			obj.Physics = PhysicsMode.TriggerPerBlock
            obj.IsUnlit = true
			handle.sphereDown = obj

			uiAxis:parentDidResize()
		end)
	end

    -- TODO: cancel this on remove
	LocalEvent:Listen(LocalEvent.Name.Tick, function()
		for _,axis in ipairs(axisList) do
			local newRotation = -Camera.Rotation * shape.Rotation
			axis.handle.Rotation = newRotation
		end
	end)

	local rotateUpdateUI

	-- local xInput = ui:createTextInput(math.deg(shape.Rotation.X), "X")
	-- xInput.onSubmit = function()
	-- 	shape.LocalRotation.X = math.rad(math.ceil(tonumber(xInput.Text)))
	-- 	rotateUpdateUI()
	-- end
	-- local xText = ui:createButton("X")
	-- xText.Height = xInput.Height
	-- xText.onRelease = function()
	-- 	xInput:focus()
	-- end
	-- xText:setColor(Color.Red)
	-- local yInput = ui:createTextInput(math.deg(shape.Rotation.Y), "Y")
	-- yInput.onSubmit = function()
	-- 	shape.LocalRotation.Y = math.rad(math.ceil(tonumber(yInput.Text)))
	-- 	rotateUpdateUI()
	-- end
	-- local yText = ui:createButton("Y")
	-- yText.onRelease = function()
	-- 	yInput:focus()
	-- end
	-- yText:setColor(Color.Green)
	-- local zInput = ui:createTextInput(math.deg(shape.Rotation.Z), "Z")
	-- zInput.onSubmit = function()
	-- 	shape.LocalRotation.Z = math.rad(math.ceil(tonumber(zInput.Text)))
	-- 	rotateUpdateUI()
	-- end
	-- local zText = ui:createButton("Z")
	-- zText.onRelease = function()
	-- 	zInput:focus()
	-- end
	-- zText:setColor(Color.Blue)

	rotateUpdateUI = function()
		if not shape or not xInput then return end
		xInput.Text = math.floor(math.deg(math.abs(shape.Rotation.X)))
		yInput.Text = math.floor(math.deg(math.abs(shape.Rotation.Y)))
		zInput.Text = math.floor(math.deg(math.abs(shape.Rotation.Z)))
	end
	node.setShape = function(self, newShape)
		if shape then
			shape.Rotation:RemoveOnSetCallback(rotateUpdateUI)
		end
		shape = newShape
		shape.Rotation:AddOnSetCallback(rotateUpdateUI)
		rotateUpdateUI()
	end
	node:setShape(shape)

	-- local inputsContainer = require("ui_container"):createHorizontalContainer()
	-- inputsContainer:pushElement(xText)
	-- inputsContainer:pushElement(xInput)
	-- inputsContainer:pushElement(yText)
	-- inputsContainer:pushElement(yInput)
	-- inputsContainer:pushElement(zText)
	-- inputsContainer:pushElement(zInput)

	-- inputsContainer.parentDidResize = function()
	-- 	xInput.Width = (node.Width - xText.Width * 3 - padding * 2) / 3
	-- 	yInput.Width = xInput.Width
	-- 	zInput.Width = xInput.Width

	-- 	xText.Height = xInput.Height
	-- 	yText.Height = yInput.Height
	-- 	zText.Height = zInput.Height
    --     inputsContainer.pos = { 0, -inputsContainer.Height, 0 }
	-- 	inputsContainer:refresh()
	-- end

    -- node.showInputs = function()
    --     inputsContainer:show()
    -- end

    -- node.hideInputs = function()
    --     inputsContainer:hide()
    -- end

    -- node.inputs = inputsContainer
	-- inputsContainer:setParent(node)

	return node
end

return {
    create = create
}