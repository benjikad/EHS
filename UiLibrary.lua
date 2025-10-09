--v1.3
return function(shared)
    local create = shared.create
    local round = shared.round

    local theme = shared.theme
    local themes = shared.themes

    local modules = shared.modules
    local icon = modules['Icons.lua'](shared)

    local service = shared.service

    local TweenService = service.TweenService

    local function constructUi(screenGui)
        local uiSize = UDim2.fromOffset(500,350)

        local mainCanvas = create('CanvasGroup',{
            Size = uiSize-UDim2.fromOffset(200,200),
            Position = UDim2.fromScale(.5,.5),
            AnchorPoint = Vector2.new(.5,.5),
            BackgroundTransparency = 0,
            BackgroundColor3 = theme.background,
            GroupTransparency = .5,
            Name = 'main'
        },screenGui)

        round(mainCanvas,UDim.new(0,8))

        local drag = create('UIDragDetector',{},mainCanvas)

        local title = create('TextLabel',{
            BackgroundTransparency = 1,
            TextTransparency = 0,
            TextColor3 = theme.textColor,
            TextSize = 19,
            Position = UDim2.fromOffset(35,2),
            Size = UDim2.new(1,-45,0,35),
            Text = 'EHS',
            Font = theme.textFont,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 2,
        },mainCanvas)

        local sidebar = create('Frame',{
            BackgroundTransparency = 0,
            BackgroundColor3 = theme.midground,
            Position = UDim2.fromOffset(0,0),
            Size = UDim2.new(0,100,1,0),
            BorderColor3 = theme.foreground,
            BorderSizePixel = 2,
            Visible = false
        },mainCanvas)

        local hamburgerIcon = icon.hamburgerIcon(30,true)
        hamburgerIcon.Position = UDim2.fromOffset(3,3)
        hamburgerIcon.Parent = mainCanvas

        local tween = TweenService:Create(mainCanvas,TweenInfo.new(.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Size = uiSize,
            GroupTransparency = 0,
        })
        tween:Play()

        return mainCanvas,sidebar,hamburgerIcon
    end

    local lib = {}
    lib.__index = lib

    function lib:newSection(name)
        table.insert(self.sections,name)

        local section = {}
        section.__index = section

        

        return section
    end

    function lib.new(screenGui)
        local self = setmetatable({},lib)
        
        self.screenGui = screenGui
        self.sections = {}
        self.currentSection = ''
        self.mainCanvas = constructUi(screenGui)

        return self
    end

    return lib
end
