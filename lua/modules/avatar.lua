
local avatar = {}

-- MODULES
api = require("api")
hierarchyactions = require("hierarchyactions")

local index = {}
local avatarMetatable = {
    __index = index
}

local SKIN_1_PALETTE_INDEX = 1
local SKIN_2_PALETTE_INDEX = 2
local EYES_PALETTE_INDEX = 6
local EYES_DARK_PALETTE_INDEX = 8
local NOSE_PALETTE_INDEX = 7
local MOUTH_PALETTE_INDEX = 4

local bodyPartsNames = { "Head", "Body", "RightArm", "RightHand", "LeftArm", "LeftHand", "RightLeg", "LeftLeg", "RightFoot", "LeftFoot" }

local cachedHead = System.ShapeFromBundle("aduermael.head_skin2_v2")

index.eyesColors = { Color(166, 142, 163), Color(68, 172,229), Color(61, 204,141), Color(127, 80,51), Color(51, 38,29), Color(229, 114,189) }

index.skinColors = {
    {skin1=Color(246, 227, 208), skin2=Color(246, 216, 186), nose=Color(246, 210, 175), mouth=Color(220, 188, 157)},
    {skin1=Color(252, 202, 156), skin2=Color(252, 186, 129), nose=Color(249, 167, 117), mouth=Color(216, 162, 116)},
    {skin1=Color(255, 194, 173), skin2=Color(255, 178, 152), nose=Color(255, 162, 133), mouth=Color(217, 159, 140)},
    {skin1=Color(182, 129, 108), skin2=Color(183, 117, 94), nose=Color(189, 114, 80), mouth=Color(153, 102, 79)},
    {skin1=Color(156, 92, 88), skin2=Color(136, 76, 76), nose=Color(135, 64, 68), mouth=Color(109, 63, 61)},
    {skin1=Color(140, 96, 64), skin2=Color(124, 82, 52), nose=Color(119, 76, 45), mouth=Color(104, 68, 43)},
    {skin1=Color(59, 46, 37), skin2=Color(53, 41, 33), nose=Color(47, 33, 25), mouth=Color(47, 36, 29)}
}

local _initAnimations = function(avatar)
    local animWalk = Animation("Walk", { speed = 1.8, mode = AnimationMode.Loop })
    local walk_llegK = {
        { time = 0.0, rotation = { -1.1781, 0, 0} },
        { time = 1/6, rotation = { -0.785398, 0, 0} },
        { time = 1/3, rotation = { 0.785398, 0, 0} },
        { time = 1/2, rotation = { 1.1781, 0, 0} },
        { time = 2/3, rotation = { 0.392699, 0, 0} },
        { time = 5/6, rotation = { -1.1781, 0, 0} },
        { time = 1.0, rotation = { -1.1781, 0, 0} },
    }
    local walk_lfootK = {
        { time = 0.0, rotation = { 0, 0, 0} },
        { time = 1/6, rotation = { 0.687223, 0, 0} },
        { time = 1/3, rotation = { -0.392699, 0, 0} },
        { time = 1/2, rotation = { 0.785398, 0, 0} },
        { time = 2/3, rotation = { 1.1781, 0, 0} },
        { time = 5/6, rotation = { 1.9635, 0, 0} },
        { time = 1.0, rotation = { 0, 0, 0} },
    }
    local walk_rlegK = {
        { time = 0.0, rotation = { 1.1781, 0, 0} },
        { time = 1/6, rotation = { 0.392699, 0, 0} },
        { time = 1/3, rotation = { -1.1781, 0, 0} },
        { time = 1/2, rotation = { -1.1781, 0, 0} },
        { time = 2/3, rotation = { -0.785398, 0, 0} },
        { time = 5/6, rotation = { 0.785398, 0, 0} },
        { time = 1.0, rotation = { 1.1781, 0, 0} },
    }
    local walk_rfootK = {
        { time = 0.0, rotation = { 0.785398, 0, 0} },
        { time = 1/6, rotation = { 1.1781, 0, 0} },
        { time = 1/3, rotation = { 1.9635, 0, 0} },
        { time = 1/2, rotation = { 0, 0, 0} },
        { time = 2/3, rotation = { 0.687223, 0, 0} },
        { time = 5/6, rotation = { -0.392699, 0, 0} },
        { time = 1.0, rotation = { 0.785398, 0, 0} },
    }
    local walk_larmK = {
        { time = 0.0, rotation = { 1.1781, 0, 1.0472 } },
        { time = 1/6, rotation = { 0.589049, 0.19635, 1.0472 } },
        { time = 1/3, rotation = { 0.19635, 0, 1.0472 } },
        { time = 1/2, rotation = { -1.37445, 0.19635, 1.0472 } },
        { time = 2/3, rotation = { -0.589049, 0, 1.0472 } },
        { time = 5/6, rotation = { 0.19635, 0, 1.0472 } },
        { time = 1.0, rotation = { 1.1781, 0, 1.0472 } },
    }
    local walk_lhandK = {
        { time = 0.0, rotation = { 0, 0.245437, 0.294524 } },
        { time = 1/6, rotation = { 0, 0.785398, 0} },
        { time = 1/3, rotation = { 0, 1.1781, 0} },
        { time = 1/2, rotation = { 0, 0.19635, 0} },
        { time = 2/3, rotation = { 0, 0.589049, 0} },
        { time = 5/6, rotation = { 0, 0.392699, 0.0981748 } },
        { time = 1.0, rotation = { 0, 0.245437, 0.294524 } },
    }
    local walk_rarmK = {
        { time = 0.0, rotation = { -1.37445, -0.19635, -1.0472 } },
        { time = 1/6, rotation = { -0.589049, 0, -1.0472 } },
        { time = 1/3, rotation = { 0.19635, 0, -1.0472 } },
        { time = 1/2, rotation = { 1.1781, 0, -1.0472 } },
        { time = 2/3, rotation = { 0.589049, 0.19635, -1.0472 } },
        { time = 5/6, rotation = { 0.19635, 0, -1.0472 } },
        { time = 1.0, rotation = { -1.37445, -0.19635, -1.0472 } },
    }
    local walk_rhandK = {
        { time = 0.0, rotation = { 0, -0.19635, 0} },
        { time = 1/6, rotation = { 0, -0.589049, 0} },
        { time = 1/3, rotation = { 0, -0.392699, -0.0981748 } },
        { time = 1/2, rotation = { 0, -0.245437, -0.294524 } },
        { time = 2/3, rotation = { 0, -0.785398, 0} },
        { time = 5/6, rotation = { 0, -1.1781, 0} },
        { time = 1.0, rotation = { 0, -0.19635, 0} },
    }
    local walk_headK = {
        { time = 0.0, rotation = { 0.0490874, -0.0490874, 0 } },
        { time = 1/6, rotation = { 0.0490874, -0.0490874, 0 } },
        { time = 1/3, rotation = { 0, -0.0490874, 0 } },
        { time = 1/2, rotation = { 0.0490874, -0.0490874, 0 } },
        { time = 2/3, rotation = { 0.0490874, -0.0490874, 0 } },
        { time = 5/6, rotation = { 0, -0.0490874, 0 } },
        { time = 1.0, rotation = { 0.0490874, -0.0490874, 0 } },
    }
    local walk_bodyK = {
        { time = 0.0, position = { 0.0, 15.0, 0.0 }, rotation = { 0, 0, 0 } },
        { time = 1/6, position = { 0.0, 12.0, 0.0 }, rotation = { 0, 0, 0 } },
        { time = 1/3, position = { 0.0, 14.0, 0.0 }, rotation = { 0, 0, 0 } },
        { time = 1/2, position = { 0.0, 15.0, 0.0 }, rotation = { 0, 0, 0 } },
        { time = 2/3, position = { 0.0, 12.0, 0.0 }, rotation = { 0, 0, 0 } },
        { time = 5/6, position = { 0.0, 14.0, 0.0 }, rotation = { 0, 0, 0 } },
        { time = 1.0, position = { 0.0, 15.0, 0.0 }, rotation = { 0, 0, 0 } },
    }
    local walkConfig = {
        RightArm = walk_rarmK,
        RightHand = walk_rhandK,
        LeftArm = walk_larmK,
        LeftHand = walk_lhandK,
        RightLeg = walk_rlegK,
        RightFoot = walk_rfootK,
        LeftLeg = walk_llegK,
        LeftFoot = walk_lfootK,
        -- can't move head first person if head is set in animations
        -- Head = walk_headK,
        Body = walk_bodyK
    }
    for name,v in pairs(walkConfig) do
        for _,frame in ipairs(v) do
            animWalk:AddFrameInGroup(name, frame.time, { position = frame.position, rotation = frame.rotation })
            animWalk:Bind(name, (name == "Body" and not avatar[name]) and avatar or avatar[name])
        end
    end

    local animIdle = Animation("Idle", { speed = 0.5, mode = AnimationMode.Loop })
    local idle_keyframes_data = {
        { name = "LeftLeg", time = 0.0, rotation = { -0.0, 0, -0.0 } },
        { name = "LeftLeg", time = 0.5, rotation = { -0.0, 0, -0.0 } },
        { name = "LeftLeg", time = 1.0, rotation = { -0.0, 0, -0.0 } },
        { name = "LeftFoot", time = 0.0, rotation = { -0.0, 0, -0.0 } },
        { name = "LeftFoot", time = 0.5, rotation = { -0.0, 0, -0.0 } },
        { name = "LeftFoot", time = 1.0, rotation = { -0.0, 0, -0.0 } },
        { name = "RightLeg", time = 0.0, rotation = { -0.0, 0, -0.0 } },
        { name = "RightLeg", time = 0.5, rotation = { -0.0, 0, -0.0 } },
        { name = "RightLeg", time = 1.0, rotation = { -0.0, 0, -0.0 } },
        { name = "RightFoot", time = 0.0, rotation = { -0.0, 0, -0.0 } },
        { name = "RightFoot", time = 0.5, rotation = { -0.0, 0, -0.0 } },
        { name = "RightFoot", time = 1.0, rotation = { -0.0, 0, -0.0 } },
        { name = "LeftArm", time = 0.0, rotation = { -0.0, 0, 1.14537 } },
        { name = "LeftArm", time = 0.5, rotation = { -0.0, 0, 1.14537 } },
        { name = "LeftArm", time = 1.0, rotation = { -0.0, 0, 1.14537 } },
        { name = "LeftHand", time = 0.0, rotation = { -0.0, 0.294524, -0.0981748 } },
        { name = "LeftHand", time = 0.5, rotation = { -0.0, 0.19635, -0.0981748 } },
        { name = "LeftHand", time = 1.0, rotation = { -0.0, 0.294524, -0.0981748 } },
        { name = "RightArm", time = 0.0, rotation = { -0.0, 0, -1.14537 } },
        { name = "RightArm", time = 0.5, rotation = { -0.0, 0, -1.14537 } },
        { name = "RightArm", time = 1.0, rotation = { -0.0, 0, -1.14537 } },
        { name = "RightHand", time = 0.0, rotation = { -0.0, -0.294524, -0.0 } },
        { name = "RightHand", time = 0.5, rotation = { -0.0, -0.19635, -0.0 } },
        { name = "RightHand", time = 1.0, rotation = { -0.0, -0.294524, -0.0 } },
        -- can't move head first person if head is set in animations
        -- { name = "Head", time = 0.0, rotation = { 0, 0, 0 } },
        -- { name = "Head", time = 0.5, rotation = { 0, 0, 0 } },
        -- { name = "Head", time = 1.0, rotation = { 0, 0, 0 } },
        { name = "Body", time = 0.0, position = { 0.0, 12.0, 0.0 }, rotation = { 0, 0, 0 } },
        { name = "Body", time = 0.5, position = { 0.0, 12.0, 0.0 }, rotation = { 0, 0, 0 } },
        { name = "Body", time = 1.0, position = { 0.0, 12.0, 0.0 }, rotation = { 0, 0, 0 } },
    }

    for _,frame in ipairs(idle_keyframes_data) do
        animIdle:AddFrameInGroup(frame.name, frame.time, { position = frame.position, rotation = frame.rotation })
        animIdle:Bind(frame.name, (frame.name == "Body" and not avatar[frame.name]) and avatar or avatar[frame.name])
    end

    local animSwingRight = Animation("SwingRight", { speed = 3 })
    local swingRight_rightArm = { { time = 0.0, rotation = { -0.0, 0, -1.0472 } }, { time = 1/3, rotation = { -0.785398, 0.392699, 0.1309 } }, { time = 2/3, rotation = { 0.392699, -1.9635, -0.261799 } }, { time = 1.0, rotation = { -0.0, 0, -1.0472 } } }
    local swingRight_rightHand = { { time = 0.0, rotation = { -0.0, -0.392699, -0.0 } }, { time = 1/3, rotation = { -1.5708, -0.392699, -0.0 } }, { time = 2/3, rotation = { -2.74889, -1.5708, -0.0 } }, { time = 1.0, rotation = { -0.0, -0.392699, -0.0 } } }
    local swingRightConfig = {
        RightArm = swingRight_rightArm,
        RightHand = swingRight_rightHand
    }
    for name,v in pairs(swingRightConfig) do
        for _,frame in ipairs(v) do
            animSwingRight:AddFrameInGroup(name, frame.time, { position = frame.position, rotation = frame.rotation })
            animSwingRight:Bind(name, (name == "Body" and not avatar[name]) and avatar or avatar[name])
        end
    end

    local animSwingLeft = Animation("SwingLeft", { speed = 3 })
    local swingLeft_leftArm = { { time = 0.0, rotation = { -0.0, 0, -1.0472 } }, { time = 1/3, rotation = { -0.785398, 0.392699, 0.1309 } }, { time = 2/3, rotation = { 0.392699, -1.9635, -0.261799 } }, { time = 1.0, rotation = { -0.0, 0, -1.0472 } } }
    local swingLeft_leftHand = { { time = 0.0, rotation = { -0.0, -0.392699, -0.0 } }, { time = 1/3, rotation = { -1.5708, -0.392699, -0.0 } }, { time = 2/3, rotation = { -2.74889, -1.5708, -0.0 } }, { time = 1.0, rotation = { -0.0, -0.392699, -0.0 } } }
    local swingLeftConfig = {
        LeftHand = swingLeft_leftHand,
        LeftArm = swingLeft_leftArm
    }
    for name,v in pairs(swingLeftConfig) do
        for _,frame in ipairs(v) do
            animSwingLeft:AddFrameInGroup(name, frame.time, { position = frame.position, rotation = frame.rotation })
            animSwingLeft:Bind(name, (name == "Body" and not avatar[name]) and avatar or avatar[name])
        end
    end

    local anims = require("animations"):create()
    anims.Walk = animWalk
    anims.Idle = animIdle
    anims.SwingRight = animSwingRight
    anims.SwingLeft = animSwingLeft

    avatar.Animations = anims

    LocalEvent:Listen(LocalEvent.Name.Tick, function(dt)
        if anims.stanceDirty and not anims.SwingRight.IsPlaying and not anims.SwingLeft.IsPlaying then
            anims.Walk:Toggle("RightHand", true)
            anims.Walk:Toggle("RightArm", true)
            anims.Walk:Toggle("LeftHand", true)
            anims.Walk:Toggle("LeftArm", true)
            anims.Idle:Toggle("RightHand", true)
            anims.Idle:Toggle("RightArm", true)
            anims.Idle:Toggle("LeftHand", true)
            anims.Idle:Toggle("LeftArm", true)
            anims.stanceDirty = false
        end
    end)
    anims.Idle:Play()
end

index.setEyesColor = function(self, playerOrHead, c)
    local head = playerOrHead
    if playerOrHead.Head then
        head = playerOrHead.Head
    end
    head.Palette[6].Color = c
    head.Palette[8].Color = c
    head.Palette[8].Color:ApplyBrightnessDiff(-0.15)
end

index.getEyesColor = function(self, playerOrHead)
    local head = playerOrHead
    if playerOrHead.Head then
        head = playerOrHead.Head
    end
    return head.Palette[6].Color
end

index.setBodyPartColor = function(self, name, shape, skin1, skin2)
    local skin1key = SKIN_1_PALETTE_INDEX
    if name == "LeftHand" or name == "Body" or name == "RightArm" then skin1key = SKIN_2_PALETTE_INDEX end

    if shape.Palette[skin1key] then
    	if skin1 ~= nil then
        	shape.Palette[skin1key].Color = skin1
    	end
    end

    if name ~= "Body" then
        local skin2key = SKIN_2_PALETTE_INDEX
        if name == "LeftHand" or name == "RightArm" then skin2key = SKIN_1_PALETTE_INDEX end
        if shape.Palette[skin2key] then
        	if skin2 ~= nil then
            	shape.Palette[skin2key].Color = skin2
        	end
        end
    end
end

index.setHeadColors = function(self, head, skin1, skin2, nose, mouth)
    head.Palette[SKIN_1_PALETTE_INDEX].Color = skin1
    head.Palette[SKIN_2_PALETTE_INDEX].Color = skin2
    self:setNoseColor(head, nose)
    self:setMouthColor(head, mouth)
end

-- Warning: `player` argument can be of different forms
index.setSkinColor = function(self, player, skin1, skin2, nose, mouth)
    if skin1 and skin2 then
        for _,name in ipairs(bodyPartsNames) do
            self:setBodyPartColor(name, player[name], skin1, skin2)
        end
        if player.Name == "Body" then
            -- player is a Body shape
            -- first color is shirt color
            -- second color is neck skin color
            self:setBodyPartColor(name, player, nil, skin1)
        end
    end

    if nose then
        self:setNoseColor(player, nose)
    end

    if mouth then
        self:setMouthColor(player, mouth)
    end
end

index.getNoseColor = function(self, playerOrHead)
    local head = playerOrHead
    if playerOrHead.Head then
        head = playerOrHead.Head
    end
    return head.Palette[7].Color
end

index.setNoseColor = function(self, playerOrHead, color)
    if not color or type(color) ~= "Color" then
        print("Error: setNoseColor second argument must be of type Color.")
        return
    end

    local head = playerOrHead
    if playerOrHead.Head then
        head = playerOrHead.Head
    end
    
    head.Palette[7].Color = color
end

index.getMouthColor = function(self, playerOrHead)
    local head = playerOrHead
    if playerOrHead.Head then
        head = playerOrHead.Head
    end
    return head.Palette[4].Color
end

index.setMouthColor = function(self, playerOrHead, color)
    if not color or type(color) ~= "Color" then
        print("Error: setMouthColor second argument must be of type Color.")
        return
    end

    local head = playerOrHead
    if playerOrHead.Head then
        head = playerOrHead.Head
    end
    head.Palette[4].Color = color
end

local function tableToColor(t)
    return Color(math.floor(t.r),math.floor(t.g),math.floor(t.b))
end

-- Returns sent requests
-- /!\ return table of requests does not contain all requests right away
-- reference should be kept, not copying entries right after function call.
index.prepareHead = function(self, head, usernameOrId, callback)
    local requests = {}
    local req = api.getAvatar(usernameOrId, function(err, data)
        if err then callback(err) return end
        if data.skinColor then
            local skinColor = tableToColor(data.skinColor)
            local skinColor2 = tableToColor(data.skinColor2)
            self:setBodyPartColor("Head", head, skinColor, skinColor2)
        end
        if data.eyesColor then
            self:setEyesColor(head, tableToColor(data.eyesColor))
        end
        if data.noseColor then
            self:setNoseColor(head, tableToColor(data.noseColor))
        end
        if data.mouthColor then
            self:setMouthColor(head, tableToColor(data.mouthColor))
        end

        local req = Object:Load(data.hair, function(shape)
            if shape == nil then return callback("Error: can't find hair '"..data.hair.."'.") end
            require("equipments"):attachEquipmentToBodyPart(shape, head)
            callback(nil, head)
        end)
        table.insert(requests, req)
    end)
    table.insert(requests, req)
    return requests
end

-- Returns sent requests
-- /!\ return table of requests does not contain all requests right away
-- reference should be kept, not copying entries right after function call.
index.getPlayerHead = function(self, usernameOrId, callback)
    local head = Shape(cachedHead)
    local requests = self:prepareHead(head, usernameOrId, callback)
    return requests
end

-- returns MutaleShape + sent requests (table)
-- /!\ return table of requests does not contain all requests right away
-- reference should be kept, not copying entries right after function call.
index.get = function(self, usernameOrId)
	local requests = {}
    local root = System.MutableShapeFromBundle("caillef.multiavatar")
    root._Head = root.Head -- retain Head shape

    root.Name = "Body"
    hierarchyactions:applyToDescendants(root, {includeRoot = true}, function(o)
        o.Physics = PhysicsMode.Disabled
    end)
    _initAnimations(root)

    local equipments = require("equipments")
    local loadEquipments = function(avatar, data)
        local equipmentsList = { "hair", "jacket", "pants", "boots" }
        local nbEquipments = #equipmentsList
        local nbEquipmentsLoaded = 0
        local nextEquipmentLoaded = function()
            nbEquipmentsLoaded = nbEquipmentsLoaded + 1
            if nbEquipmentsLoaded >= nbEquipments then
                if root.didLoad then root.didLoad(nil, root) return end
            end
        end
        for _,v in ipairs(equipmentsList) do
        	-- equipments.load creates the `root.equipments` field
            local req = equipments.load(v, data[v], root, false, false, function(obj)
                if not obj then
                    print("Error: can't equip default wearables")
                end
                nextEquipmentLoaded()
            end)
            table.insert(requests, req)
        end
    end

    local req = api.getAvatar(usernameOrId, function(err, data)
        if err then
            if root.didLoad then root.didLoad(err) end
            return
        end

        local skinColor = nil
        local skinColor2 = nil
        local noseColor = nil
        local mouthColor = nil
        local eyesColor = nil

        if data.skinColor then
            skinColor = Color(math.floor(data.skinColor.r),math.floor(data.skinColor.g),math.floor(data.skinColor.b))
        end
        if data.skinColor2 then
            skinColor2 = Color(math.floor(data.skinColor2.r),math.floor(data.skinColor2.g),math.floor(data.skinColor2.b))
        end
        if data.noseColor then
            noseColor = Color(math.floor(data.noseColor.r),math.floor(data.noseColor.g),math.floor(data.noseColor.b))
        end
        if data.mouthColor then
            mouthColor = Color(math.floor(data.mouthColor.r),math.floor(data.mouthColor.g),math.floor(data.mouthColor.b))
        end
        if data.eyesColor then
            eyesColor = Color(math.floor(data.eyesColor.r),math.floor(data.eyesColor.g),math.floor(data.eyesColor.b))
        end

        if skinColor or skinColor2 or noseColor or mouthColor then
            index:setSkinColor(root, skinColor, skinColor2, noseColor, mouthColor)
        end

        if eyesColor then
            index:setEyesColor(root, eyesColor)
        end

        loadEquipments(root, data)
    end)

    table.insert(requests, req)

    return root, requests
end

setmetatable(avatar, avatarMetatable)

return avatar
