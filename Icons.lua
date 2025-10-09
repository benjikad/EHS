--v1.1
return function(shared)
    local create = shared.create
    local round = shared.round

    local items = {}

    function items.downloadIcon(size,isButton)
        size = size or 30

        local frame = create(isButton and 'TextButton' or 'Frame', {
            Size = UDim2.fromOffset(size, size),
            BackgroundTransparency = 1,
        })

        if isButton then
            frame.AutoButtonColor = false
            frame.Text = ''
        end

        local shaftHeightScale = 0.5
        local shaftWidthScale = 0.08
        local headWidthScale = 0.3
        local headHeightScale = 0.08
        local boxWidthScale = 0.65
        local boxHeightScale = 0.1
        local boxSideHeightScale = 0.3
        local boxThicknessScale = 0.08

        local arrowShaft = create("Frame", {
            Parent = frame,
            Size = UDim2.fromScale(shaftWidthScale, shaftHeightScale),
            Position = UDim2.fromScale(0.5, 0.1),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
        })
        
        round(arrowShaft)

        local headY = -0.01 + shaftHeightScale

        local arrowLeft = create("Frame", {
            Parent = frame,
            Size = UDim2.fromScale(headWidthScale, headHeightScale),
            Position = UDim2.fromScale(0.57, headY),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Rotation = 45,
        })
        
        round(arrowLeft)

        local arrowRight = create("Frame", {
            Parent = frame,
            Size = UDim2.fromScale(headWidthScale, headHeightScale),
            Position = UDim2.fromScale(0.43, headY),
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Rotation = -45,
        })
        
        round(arrowRight)

        local boxBottom = create("Frame", {
            Parent = frame,
            Size = UDim2.fromScale(boxWidthScale, boxHeightScale),
            Position = UDim2.fromScale(0.5, 0.95),
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
        })

        local boxLeft = create("Frame", {
            Parent = frame,
            Size = UDim2.fromScale(boxThicknessScale, boxSideHeightScale),
            Position = UDim2.fromScale(0.5 - boxWidthScale / 2, 0.95),
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
        })
        
        round(boxLeft)

        local boxRight = create("Frame", {
            Parent = frame,
            Size = UDim2.fromScale(boxThicknessScale, boxSideHeightScale),
            Position = UDim2.fromScale(0.5 + boxWidthScale / 2, 0.95),
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
        })
        
        round(boxRight)

        return frame
    end

    function items.hamburgerIcon(size,isButton)
        size = size or 30

        local frame = create(isButton and 'TextButton' or 'Frame', {
            Size = UDim2.fromOffset(size, size),
            BackgroundTransparency = 1,
        })

        if isButton then
            frame.AutoButtonColor = false
            frame.Text = ''
        end
        
        local topLine = create('Frame',{
            BackgroundColor3 = Color3.new(1, 1, 1),
            Size = UDim2.new(0.8, 0, 0.1, 0),
            Position = UDim2.new(0.1, 0, 0.15, 0),
            BorderSizePixel = 0
        }, frame)
        round(topLine)
        
        local middleLine = create('Frame',{
            BackgroundColor3 = Color3.new(1, 1, 1),
            Size = UDim2.new(0.8, 0, 0.1, 0),
            Position = UDim2.new(0.1, 0, 0.45, 0),
            BorderSizePixel = 0
        }, frame)
        round(middleLine)
        
        local bottomLine = create('Frame',{
            BackgroundColor3 = Color3.new(1, 1, 1),
            Size = UDim2.new(0.8, 0, 0.1, 0),
            Position = UDim2.new(0.1, 0, 0.75, 0),
            BorderSizePixel = 0
        }, frame)
        round(bottomLine)
        
        return frame
    end

    return items
end
