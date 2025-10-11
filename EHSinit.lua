--executor hub

local EHS_VERSION = 1.45

return function(themeName,shouldDownload)
    local function missing(t, f, fallback)
        if type(f) == t then return f end
        return fallback
    end

    local getgenv = missing('function',getgenv,function()
        if _G.genv==nil then
            _G.genv = {}
        end

        return _G.genv
    end)

    if getgenv().EHS_LOADED then
        return false, 'Already loaded.'
    end

    getgenv().EHS_LOADED = true

    local service

    local cloneref = missing("function", cloneref, function(...) return ... end)
    local queueteleport = missing("function", queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport))
    local httprequest = missing("function", request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request))
    local setclipboard = missing("function", setclipboard or toclipboard or set_clipboard or (
        Clipboard and Clipboard.set
    ))

    local gethui = missing("function", get_hidden_gui or gethui,function()
        return service.CoreGui
    end)

    local httpget = httprequest and function(url)
        local suc,res = pcall(httprequest,{
            ['Method'] = 'GET',
            ['Url'] = url,
        })

        local err = tostring(res.StatusCode):sub(1,1) ~= '2'

        if err then
            return ''
        end

        return suc and res and res.Body or ''
    end

    local waxwritefile, waxreadfile = writefile, readfile

    local writefile = missing("function", waxwritefile) and function(file, data, safe)
        if safe == true then return pcall(waxwritefile, file, data) end
        waxwritefile(file, data)
    end

    local readfile = missing("function", waxreadfile) and function(file, safe)
        if safe == true then return pcall(waxreadfile, file) end
        return waxreadfile(file)
    end

    local isfile = missing("function", isfile, readfile and function(file)
        local success, result = pcall(function()
            return readfile(file)
        end)
        return success and result ~= nil and result ~= ""
    end)

    local makefolder = missing("function", makefolder)
    local isfolder = missing("function", isfolder)

    local httpSupport = httpget ~= nil
    local fileSupport = (makefolder and isfolder and isfile and writefile and readfile) ~= nil
    
    local waxgetcustomasset = missing("function", getcustomasset or getsynasset)
    local function getcustomasset(asset,fallback)
        if waxgetcustomasset then
            local success, result = pcall(function()
                return waxgetcustomasset(asset)
            end)
            if success and result ~= nil and result ~= "" then
                return result
            end
        end
        return fallback
    end

    service = setmetatable({},{
        __index = function(_,name)
            local suc,res = pcall(function()
                return cloneref(game:GetService(name))
            end)

            return res
        end
    })

    local function create(class,props,parent)
        local suc,inst = pcall(function()
            return cloneref(Instance.new(class))
        end)

        if not (suc and inst) then
            return
        end

        for prop,val in pairs(props) do
            if prop == 'Parent' then continue end
            pcall(function()
                inst[prop] = val
            end)
        end

        inst.Parent = parent or props.Parent

        return inst
    end

    local themes = {
        ['blood'] = {
            ['foreground'] = Color3.fromRGB(25, 15, 15), 
            ['background'] = Color3.fromRGB(10, 5, 5),
            ['midground'] = Color3.fromRGB(18, 10, 10),
            ['accent'] = Color3.fromRGB(140, 20, 20),
            ['textColor'] = Color3.fromRGB(255, 244, 238),
            ['textColorWarn'] = Color3.fromRGB(255, 168, 0),
            ['textColorError'] = Color3.fromRGB(255, 64, 64),
            ['textColorSuccess'] = Color3.fromRGB(136, 255, 0),
            ['textColorInfo'] = Color3.fromRGB(64, 64, 235),
            ['specialColor'] = Color3.fromRGB(180, 25, 25),
            ['darkSpecialColor'] = Color3.fromRGB(100, 15, 15),
            ['specialTextColor'] = Color3.fromRGB(255, 100, 100),
            ['textFont'] = Enum.Font.Arial,
            ['textTitleFont'] = Enum.Font.JosefinSans,
        },
        ['primeRed'] = {
            ['foreground'] = Color3.fromRGB(60, 45, 40),
            ['background'] = Color3.fromRGB(35, 25, 22),
            ['midground'] = Color3.fromRGB(45, 30, 28),
            ['accent'] = Color3.fromRGB(155, 70, 55),
            ['textColor'] = Color3.fromRGB(245, 230, 220),
            ['textColorWarn'] = Color3.fromRGB(210, 120, 40), 
            ['textColorError'] = Color3.fromRGB(190, 60, 50),
            ['textColorSuccess'] = Color3.fromRGB(110, 170, 90), 
            ['textColorInfo'] = Color3.fromRGB(85, 105, 175),
            ['specialColor'] = Color3.fromRGB(160, 65, 55),
            ['darkSpecialColor'] = Color3.fromRGB(100, 45, 38),
            ['specialTextColor'] = Color3.fromRGB(200, 95, 80),
            ['textFont'] = Enum.Font.Arial,
            ['textTitleFont'] = Enum.Font.JosefinSans,
        },
        ['agua'] = {
            ['foreground'] = Color3.fromRGB(15, 25, 25), 
            ['background'] = Color3.fromRGB(5, 10, 10),
            ['midground'] = Color3.fromRGB(10, 18, 18),
            ['accent'] = Color3.fromRGB(20, 140, 140),
            ['textColor'] = Color3.fromRGB(238, 250, 255),
            ['textColorWarn'] = Color3.fromRGB(255, 168, 0),
            ['textColorError'] = Color3.fromRGB(255, 64, 64),
            ['textColorSuccess'] = Color3.fromRGB(0, 255, 200),
            ['textColorInfo'] = Color3.fromRGB(64, 200, 235),
            ['specialColor'] = Color3.fromRGB(25, 180, 180),
            ['darkSpecialColor'] = Color3.fromRGB(15, 100, 100),
            ['specialTextColor'] = Color3.fromRGB(100, 255, 255),
            ['textFont'] = Enum.Font.Arial,
            ['textTitleFont'] = Enum.Font.JosefinSans,
        },
        ['desert'] = {
            ['foreground'] = Color3.fromRGB(28, 22, 15), 
            ['background'] = Color3.fromRGB(12, 9, 5),
            ['midground'] = Color3.fromRGB(20, 16, 10),
            ['accent'] = Color3.fromRGB(180, 120, 40),
            ['textColor'] = Color3.fromRGB(255, 248, 238),
            ['textColorWarn'] = Color3.fromRGB(255, 168, 0),
            ['textColorError'] = Color3.fromRGB(255, 64, 64),
            ['textColorSuccess'] = Color3.fromRGB(160, 200, 80),
            ['textColorInfo'] = Color3.fromRGB(200, 160, 100),
            ['specialColor'] = Color3.fromRGB(210, 140, 60),
            ['darkSpecialColor'] = Color3.fromRGB(120, 80, 30),
            ['specialTextColor'] = Color3.fromRGB(255, 200, 120),
            ['textFont'] = Enum.Font.Arial,
            ['textTitleFont'] = Enum.Font.JosefinSans,
        },
    }

    local Players = service.Players
    local TweenService = service.TweenService
    local RunService = service.RunService
    local CoreGui = service.CoreGui

    local LocalPlayer = cloneref(Players.LocalPlayer)

    local function round(item,rad)
        return create("UICorner", {
            Parent = item,
            CornerRadius = rad or UDim.new(1, 0),
        })
    end

    local function downloadIcon(size)
        local frame = create("Frame", {
            Size = UDim2.fromOffset(size, size),
            BackgroundTransparency = 1,
        })

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

    local baseUrl = 'https://raw.githubusercontent.com/benjikad/EHS/refs/heads/main/'
    local urls = {
        'Universal.lua',
        'UiLibrary.lua',
        'Main.lua',
        'Icons.lua'
    }

    local usedConf = false

    if themeName == nil and fileSupport then
        pcall(function()
            if isfolder('EHS') and isfile('EHS/conf.ini') then
                local suc,res = readfile('EHS/conf.ini',true)

                if typeof(res) == 'string' then
                    local confTheme = res:split('\n')[1]

                    themeName = confTheme
                    usedConf = true
                end
            end
        end)
    end

    local themeName = typeof(themeName) == "string" and themeName or 'blood'
    if shouldDownload == nil then
        shouldDownload = true
    end

    local theme = themes[themeName or '']
    local themeExists = theme~=nil
    theme = theme or themes["blood"]

    if not themeExists and usedConf then
        writefile('EHS/conf.ini','blood')
    end

    local _parent = gethui() or CoreGui

    if _parent:FindFirstChild('EHS') then
        _parent:FindFirstChild('EHS'):Destroy()
    end

    local mainUi = create('ScreenGui',{
        Name = 'EHS',
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    },_parent)

    local mainFrame = create('CanvasGroup',{
        Size = UDim2.fromOffset(200,50),
        Position = UDim2.fromScale(.5,.5),
        AnchorPoint = Vector2.new(.5,.5),
        BackgroundTransparency = 0,
        BackgroundColor3 = theme.background,
        GroupTransparency = .5,
        Name = 'initMain'
    },mainUi)

    round(mainFrame,UDim.new(0,8))

    local drag = create('UIDragDetector',{},mainFrame)

    local downloadCanvas = create('CanvasGroup',{
        Size = UDim2.fromOffset(35,35),
        BackgroundTransparency = 1,
        Name = 'download'
    },mainFrame)

    local downloadGradient = create('UIGradient',{
        Transparency = NumberSequence.new(0),
        Rotation = 90,
    },downloadCanvas)

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
    },mainFrame)

    local icon = downloadIcon(35)

    icon.Parent = downloadCanvas

    local consoleScr = create('ScrollingFrame',{
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        AnchorPoint = Vector2.new(.5,.5),
        Size = UDim2.new(.875,0,.75,0),
        Position = UDim2.new(.5,0,.5,15),
        BackgroundColor3 = theme.midground,
        ScrollBarThickness = 6,
        BorderSizePixel = 0,
    },mainFrame)

    round(consoleScr,UDim.new(0,8))

    local consoleList = create('UIListLayout',{
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0,5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    },consoleScr)

    local consoleSpacer = create('Frame',{
        Size = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1
    },consoleScr)

    local consoleLabel = create('TextLabel',{
        BackgroundTransparency = 1,
        TextTransparency = 0,
        Text = '.',
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1,-10,0,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    })

    local size = 25
    local dark = theme.darkSpecialColor
    local light = theme.specialColor

    local startupComplete

    local function log(name,color,...)
        local color = color or theme.textColorInfo

        local data = table.pack(...)
        local str = table.concat(data,' ')

        local label = consoleLabel:Clone()
        label.Text = `[{name}]: {str}`
        label.TextColor3 = color
        label.Parent = consoleScr
    end

    local urlsToDownload = {}
    local downloaded = {}
    local modules = {}

    local function download(target)
        -- local split = url:split('/')
        -- local place = split[#split]
        log('Download',theme.textColorInfo,`Downloading {target}`)

        local res = httpget(baseUrl..target)
        
        if res=='' then
            return false
        end

        return true,res
    end

    local function getVersion(str)
        local line1 = str:split('\n')[1]

        local ver = line1:split('--v')[2]
        
        ver = tonumber(ver)

        return ver
    end

    local function startDownload()
        for target,version in urlsToDownload do
            local suc,res = download(target)

            if not suc then
                log('Download',theme.textColorError,'Failed to download.')
                startupComplete = true
                return
            end

            local ver = getVersion(res)
            if ver == 0 then
                continue
            end

            downloaded[target] = res

            if not fileSupport then
                continue
            end

            if ver > version then
                log('Files',theme.textColorWarn,`{target} is out of date, replacing..`)
            else
                continue
            end

            log('Files',theme.textColor,`Writing to {target}`)

            local s,e = writefile('EHS/'..target,res,true)

            if not s then
                log('Files',theme.textColorError,'Failed to write file.')
                startupComplete = true
                return
            end

            task.wait(.5)
        end

        -- task.wait(1)
        -- startupComplete = true
    end

    local function checkAndApplyFiles()
        if not fileSupport then
            return
        end

        local s,e = pcall(function()
            if not isfolder('EHS') then
                makefolder('EHS')
            end

            if not isfile('EHS/conf.ini') then
                writefile('EHS/conf.ini','blood')
            end

            for _,url in urls do
                if isfile('EHS/'..url) then
                    local res = readfile('EHS/'..url)

                    if not (res and res~='' and typeof(res)=='string') then
                        urlsToDownload[url] = 0
                        continue
                    end

                    local ver = getVersion(res)

                    if ver then
                        urlsToDownload[url] = ver
                    else
                        urlsToDownload[url] = 0
                    end
                else
                    urlsToDownload[url] = 0
                end
            end
        end)

        if not s then
            log('Files',theme.textColorError,'Failed to prepare file environment.')
        end
    end

    local function readFiles()
        for _,file in urls do
            log('Files',theme.textColor,`Reading file EHS/{file}`)
            local suc,res = readfile('EHS/'..file,true)

            if not suc or res=='' then
                log('Files',theme.textColorError,`Failed to read file EHS/{file}`)
                return false
            end
            
            downloaded[file] = res
        end

        return true
    end

    local function launchModules()
        
        for file,code in downloaded do
            log('System',theme.textColor,`Caching {file}`)

            local suc,out = pcall(loadstring,code)

            if not suc then
                return false,`Failed to compile {file}`
            end

            local suc,sys = pcall(out)

            if not suc then
                return false,`Failed to load {file}`
            end

            modules[file] = sys
        end

        return true
    end

    local timeout

    local function failure(why)
        startupComplete = true

        pcall(log,'System',theme.textColorError,`Failed to fully initialize. ({why})`)

        getgenv().EHS_LOADED = false

        pcall(task.cancel,timeout)
    end

    timeout = task.delay(10,failure,'Timeout.')

    local function initialize()
        local tween = TweenService:Create(mainFrame,TweenInfo.new(.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Size = UDim2.fromOffset(400,250),
            GroupTransparency = 0,
        })
        tween:Play()

        tween.Completed:Wait()

        log('System',theme.textColorInfo,`Running on version {EHS_VERSION}!`)

        if not themeExists then
            log('Settings',theme.textColorWarn,`Theme "{themeName}" was not found, using "blood" as a default.`)
        end

        if not fileSupport then
            log('Compatability',theme.textColorWarn,'File functions appear to be missing, and cannot be recreated with current functionality.')
            
            for _,url in urls do
                urlsToDownload[url] = 0
            end
        end

        if not httpSupport then
            return failure('Executor cannot update files.')
        end

        checkAndApplyFiles()

        if shouldDownload or not fileSupport then
            if not shouldDownload then
                log('Settings',theme.textColorWarn,'Cannot turn off downloading without file support.')
            end
            log('Download',theme.textColor,'Download Started..')
            startDownload()
        else
            log('Settings',theme.textColorWarn,'Downloads are disabled, your files might be out of date.')

            local success = readFiles()

            if not success then
                return failure('File read error.')
            end
        end

        local suc,err = launchModules()

        if not suc then
            failure(err)
        end

        local shared = {}
        shared.modules = modules
        shared.create = create
        shared.round = round
        shared.env = {
            getgenv = getgenv,

            cloneref = cloneref,
            queueteleport = queueteleport,
            httprequest = httprequest,
            setclipboard = setclipboard,

            gethui = gethui,

            httpget = httpget,

            waxwritefile = waxwritefile,
            waxreadfile = waxreadfile,

            writefile = writefile,
            readfile = readfile,

            isfile = isfile,

            makefolder = makefolder,
            isfolder = isfolder,

            waxgetcustomasset = waxgetcustomasset,
            getcustomasset = getcustomasset,
        }
        shared.theme = theme
        shared.themes = themes
        shared.service = service
        shared.httpSupport = httpSupport
        shared.fileSupport = fileSupport
        shared.mainUi = mainUi

        log('System',theme.textColorSuccess,'Loaded backend, launching EHS...')

        local done = false

        task.spawn(function()
            repeat
                task.wait()
            until done

            startupComplete = true

            pcall(task.cancel,timeout)
        end)

        local s,e

        task.spawn(function()
            local start = tick()
            repeat
                task.wait()
            until s~=nil or tick()-start>1

            if s == false then
                log('System',theme.textColorError,'Failed to load main module.')

                -- task.cancel(timeout)

                task.wait(2)

                done = true
            else
                done = true
                shared.ready = true
            end

        end)

        s,e = pcall(modules['Main.lua'],shared)

        if not s then
            warn(e)
        end
    end

    task.spawn(initialize)

    repeat
        for i=-size,100,4 do
            task.wait()
            local goal = ColorSequence.new({
                ColorSequenceKeypoint.new(0,dark),
                ColorSequenceKeypoint.new(math.clamp((i-.1)/100,0,1),dark),

                ColorSequenceKeypoint.new(math.clamp((i)/100,0,1),light),
                ColorSequenceKeypoint.new(math.clamp((i+size)/100,0,1),light),

                ColorSequenceKeypoint.new(math.clamp((i+size+.1)/100,0,1),dark),
                ColorSequenceKeypoint.new(1,dark),
            })

            downloadGradient.Color = goal
        end

        task.wait(.5)
    until startupComplete

    for i=-size,100,12 do
        task.wait()
        local goal = ColorSequence.new({
            ColorSequenceKeypoint.new(0,light),

            ColorSequenceKeypoint.new(math.clamp((i)/100,0,1),light),
            ColorSequenceKeypoint.new(math.clamp((i+size)/100,0,1),light),

            ColorSequenceKeypoint.new(math.clamp((i+size+.1)/100,0,1),dark),
            ColorSequenceKeypoint.new(1,dark),
        })

        downloadGradient.Color = goal
    end

    task.wait(.5)

    local tween = TweenService:Create(mainFrame,TweenInfo.new(.225,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
        Size = UDim2.fromOffset(200,50),
        GroupTransparency = .75,
    })
    tween:Play()
    tween.Completed:Wait()
    mainFrame:Destroy()

    getgenv().EHS_LOADED = false
end
