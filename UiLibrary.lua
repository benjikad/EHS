--v1.5
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
            Font = theme.textTitleFont,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 5,
            Name = 'Title'
        },mainCanvas)
        
        local sidebar = create('Frame',{
            BackgroundTransparency = 0,
            BackgroundColor3 = theme.midground,
            Position = UDim2.fromOffset(-160,0),
            Size = UDim2.new(0,150,1,0),
            BorderColor3 = theme.foreground,
            BorderSizePixel = 2,
            ZIndex = 4,
            Name = 'Sidebar'
        },mainCanvas)
        
        local sideScr = create('ScrollingFrame',{
            BackgroundTransparency = 1,
            Size = UDim2.new(1,-8,1,-45),
            Position = UDim2.fromOffset(4,40),
            VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left,
            ScrollBarThickness = 3,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(),
        },sidebar)
        
        local sideList = create('UIListLayout',{
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0,5),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        },sideScr)
        
        local hamburgerIcon = icon.hamburgerIcon(30,true)
        hamburgerIcon.Position = UDim2.fromOffset(3,3)
        hamburgerIcon.ZIndex = 5
        hamburgerIcon.Name = 'HamburgerIcon'
        hamburgerIcon.Parent = mainCanvas
        
        for _,v in pairs(hamburgerIcon:GetDescendants()) do
            if v:IsA('Frame') then
                v.BackgroundColor3 = theme.specialColor
            end
        end
        
        local tween = TweenService:Create(mainCanvas,TweenInfo.new(.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Size = uiSize,
            GroupTransparency = 0,
        })
        tween:Play()
        
        local dark = create('TextButton',{
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.new(0,0,0),
            Size = UDim2.fromScale(1,1),
            BorderSizePixel = 0,
            ZIndex = 3,
            Name = 'DarkOverlay',
            AutoButtonColor = false,
            Text = '',
            Interactable = false,
        },mainCanvas)
        
        return mainCanvas,sidebar,sideScr,hamburgerIcon,dark
    end
    
    local function constructSectionUi(parent,name)
        local section = create('CanvasGroup',{
            Size = UDim2.new(1,-10,1,-40),
            Position = UDim2.new(.5,0,0,35),
            AnchorPoint = Vector2.new(.5,0),
            GroupTransparency = 1,
            BackgroundTransparency = .75,
            Visible = false,
            Name = 'Section_'..name
        },parent.mainCanvas)
        round(section,UDim.new(0,8))
        
        local sectionScr = create('ScrollingFrame',{
            Size = UDim2.new(1,-10,1,-20),
            Position = UDim2.new(.5,0,.5,0),
            AnchorPoint = Vector2.new(.5,.5),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(),
        },section)

        local canvasList = create('UIListLayout',{
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0,5),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        },sectionScr)
        
        local sectionOpen = create('TextButton',{
            Text = '',
            Size = UDim2.new(1,-10,0,0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = theme.darkSpecialColor,
            AutoButtonColor = false,
            Name = 'SectionButton_'..name
        })
        round(sectionOpen,UDim.new(0,4))
        
        local list = create('UIListLayout',{
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0,5),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        },sectionOpen)
        
        local bumperTop = create('Frame',{
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0,0),
            BorderSizePixel = 0,
            LayoutOrder = 1,
        },sectionOpen)
        
        local bumperBottom = create('Frame',{
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0,0),
            BorderSizePixel = 0,
            LayoutOrder = 3,
        },sectionOpen)
        
        local text = create('TextLabel',{
            BackgroundTransparency = 1,
            Size = UDim2.new(1,-10,0,0),
            AutomaticSize = Enum.AutomaticSize.Y,
            TextWrapped = true,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            Text = name,
            TextTransparency = 0,
            TextColor3 = theme.textColor,
            Font = theme.textFont,
            TextSize = 16,
            Name = 'SectionText'
        },sectionOpen)
        
        return section,sectionOpen,sectionScr
    end
    
    local function createItem()
        local item = create('TextButton',{
            BackgroundTransparency = 0,
            BackgroundColor3 = theme.midground,
            Size = UDim2.new(1,-10,0,0),
            BorderSizePixel = 0,
            LayoutOrder = 1,
            AutoButtonColor = false,
            Text = '',
            AutomaticSize = Enum.AutomaticSize.Y
        })

        local list = create('UIListLayout',{
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0,5),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        },item)
        
        local bumperTop = create('Frame',{
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0,0),
            BorderSizePixel = 0,
            LayoutOrder = 1,
        },item)
        
        local bumperBottom = create('Frame',{
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0,0),
            BorderSizePixel = 0,
            LayoutOrder = 3,
        },item)

        local holder = create('Frame',{
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            Name = 'Holder'
        },item)
        
        local text = create('TextLabel',{
            BackgroundTransparency = 1,
            Size = UDim2.new(1,-10,0,0),
            Position = UDim2.fromOffset(5,0),
            AutomaticSize = Enum.AutomaticSize.Y,
            TextWrapped = true,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            Text = 'New Label',
            TextTransparency = 0,
            TextColor3 = theme.textColor,
            Font = theme.textFont,
            TextSize = 16,
            Name = 'SectionText',
            TextXAlignment = Enum.TextXAlignment.Left,
        },holder)

        return item, text
    end

    local lib = {}
    lib.__index = lib
    
    function lib:applyTheme(themeName, tweenDuration)
        tweenDuration = tweenDuration or 0.3
        local newTheme = themes[themeName]
        if not newTheme then
            return
        end
        
        theme = newTheme
        shared.theme = newTheme
        
        local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        TweenService:Create(self.mainCanvas, tweenInfo, {
            BackgroundColor3 = newTheme.background
        }):Play()
        
        local title = self.mainCanvas:FindFirstChild('Title')
        if title then
            TweenService:Create(title, tweenInfo, {
                TextColor3 = newTheme.textColor
            }):Play()
        end
        
        TweenService:Create(self.sidebar, tweenInfo, {
            BackgroundColor3 = newTheme.midground,
            BorderColor3 = newTheme.foreground
        }):Play()
        
        for _,v in pairs(self.sidebarButton:GetDescendants()) do
            if v:IsA('Frame') then
                TweenService:Create(v, tweenInfo, {
                    BackgroundColor3 = newTheme.specialColor
                }):Play()
            end
        end
        
        for _, section in pairs(self.sections) do
            local sectionButton = section.open
            local isActive = self.currentSection == section
            
            TweenService:Create(sectionButton, tweenInfo, {
                BackgroundColor3 = isActive and newTheme.specialColor or newTheme.darkSpecialColor
            }):Play()
            
            local sectionText = sectionButton:FindFirstChild('SectionText')
            if sectionText then
                TweenService:Create(sectionText, tweenInfo, {
                    TextColor3 = newTheme.textColor
                }):Play()
                if newTheme.textFont then
                    sectionText.Font = newTheme.textFont
                end
            end
        end
        
        for _, section in pairs(self.sections) do
            self:updateSectionTheme(section.canvas, newTheme, tweenInfo)
        end
    end
    
    function lib:updateSectionTheme(container, newTheme, tweenInfo)
        for _, element in pairs(container:GetDescendants()) do
            if element:IsA('TextLabel') or element:IsA('TextButton') or element:IsA('TextBox') then
                TweenService:Create(element, tweenInfo, {
                    TextColor3 = newTheme.textColor
                }):Play()
                if newTheme.textFont then
                    element.Font = newTheme.textFont
                end
            end
            
            if element:IsA('Frame') then
                if element:GetAttribute('ThemeRole') == 'background' then
                    TweenService:Create(element, tweenInfo, {
                        BackgroundColor3 = newTheme.background
                    }):Play()
                elseif element:GetAttribute('ThemeRole') == 'foreground' then
                    TweenService:Create(element, tweenInfo, {
                        BackgroundColor3 = newTheme.foreground
                    }):Play()
                elseif element:GetAttribute('ThemeRole') == 'midground' then
                    TweenService:Create(element, tweenInfo, {
                        BackgroundColor3 = newTheme.midground
                    }):Play()
                elseif element:GetAttribute('ThemeRole') == 'special' then
                    TweenService:Create(element, tweenInfo, {
                        BackgroundColor3 = newTheme.specialColor
                    }):Play()
                end
            end
        end
    end
    
    function lib:newSection(name)
        local ui = self
        local section = {}
        section.__type = 'EHS_SECTION'
        
        local sectionCanvas,sectionOpen,sectionScr = constructSectionUi(ui,name)
        section.canvas = sectionCanvas
        section.open = sectionOpen
        section.scrl = sectionScr
        
        sectionOpen.Parent = ui.sidebarScr
        
        sectionOpen.LayoutOrder = #ui.sections
        sectionOpen.MouseButton1Click:Connect(function()
            ui:open(section)
        end)
        
        table.insert(ui.sections, section)

        function section:newLabel(txt,props)
            local hold,text = createItem()
            text.Text = txt

            if typeof(props) == 'table' then
                for prop,val in props do
                    pcall(function()
                        text[prop] = val
                    end)
                end
            end

            hold.Parent = self.scrl
        end
        
        return section
    end
    
    local openDebounce = false
    function lib:open(section)
        if openDebounce then return end
        local current = self.currentSection
        if not (typeof(section) == 'table' and section.__type == 'EHS_SECTION') then
            return
        end
        if current == section then
            return
        end
        
        if current ~= nil then
            openDebounce = true
            
            TweenService:Create(current.open,TweenInfo.new(.25),{BackgroundColor3 = theme.darkSpecialColor}):Play()
            local tween = TweenService:Create(current.canvas,TweenInfo.new(.15),{GroupTransparency = 1})
            tween:Play()
            tween.Completed:Wait()
            current.canvas.Visible = false
            openDebounce = false
        end
        
        section.canvas.Visible = true
        TweenService:Create(section.open,TweenInfo.new(.25),{BackgroundColor3 = theme.specialColor}):Play()
        local tween = TweenService:Create(section.canvas,TweenInfo.new(.15),{GroupTransparency = 0})
        tween:Play()
        self.currentSection = section
    end
    
    function lib.new(screenGui)
        local self = setmetatable({},lib)
        
        self.screenGui = screenGui
        self.sections = {}
        self.currentSection = nil
        
        local canvas,sidebar,sidebarScr,sidebarButton,dark = constructUi(screenGui)
        self.mainCanvas = canvas
        self.sidebar = sidebar
        self.sidebarScr = sidebarScr
        self.sidebarButton = sidebarButton
        self.sidebarOpen = false

        dark.MouseButton1Click:Connect(function()
            if dark.Transparency ~= 1 then
                self.sidebarOpen = false
                TweenService:Create(sidebar,TweenInfo.new(.15),{Position = UDim2.fromOffset(-160,0)}):Play()
                TweenService:Create(dark,TweenInfo.new(.15),{BackgroundTransparency = 1}):Play()
                dark.Interactable = false
            end
        end)
        
        sidebarButton.MouseButton1Click:Connect(function()
            self.sidebarOpen = not self.sidebarOpen
            if self.sidebarOpen then
                TweenService:Create(sidebar,TweenInfo.new(.15),{Position = UDim2.fromOffset(0,0)}):Play()
                TweenService:Create(dark,TweenInfo.new(.15),{BackgroundTransparency = .75}):Play()
                dark.Interactable = true
            else
                TweenService:Create(sidebar,TweenInfo.new(.15),{Position = UDim2.fromOffset(-160,0)}):Play()
                TweenService:Create(dark,TweenInfo.new(.15),{BackgroundTransparency = 1}):Play()
                dark.Interactable = false
            end
        end)
        
        return self
    end
    
    return lib
end
