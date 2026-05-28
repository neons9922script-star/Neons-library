--[[
╔══════════════════════════════════════════════════════════════╗
║              NeonHub UI Library  v2.1                        ║
║         Mobile Optimized | Dark Theme | 15 Elements          ║
║   Key System | Loading | Save/Load | 20 Themes | Draggable   ║
╚══════════════════════════════════════════════════════════════╝

USAGE EXAMPLE:

    local NeonHub = loadstring(game:HttpGet("URL_HERE"))()

    -- 1) Key System
    NeonHub:KeySystem({
        Text            = "Key System",
        KeySystem       = true,
        Key             = "123",
        AutoSaveKey     = true,
        KeyJson         = "Key_NeonHub.json",
        GetKeyBySite    = true,
        KeySite         = "https://pastebin.com/raw/YOURPASTE",
        -- IDs de imagem (opcional, deixe "" para padrão)
        Minimize_button_image_id = (""),   -- ID da imagem do botão minimizar/abrir
        UI_Library_Fund          = (""),   -- ID da imagem do fundo da UI
    })

    -- 2) Loading Screen
    NeonHub:LoadingScreen({
        LoadingText = "Welcome Back!",
        Duration    = 10,
    })

    -- 3) Create Window
    local Win = NeonHub:CreateWindow({
        Name     = "NeonHub",
        SubTitle = "by .ftgs",
    })

    -- 4) Add tabs + elements
    local Tab = Win:AddTab("Main", "🏠")

    -- 5) Add built-in Config tab
    Win:AddConfig()
--]]

-- ══════════════════════════════════════════════════════════════
--  SERVICES
-- ══════════════════════════════════════════════════════════════
local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local HttpService       = game:GetService("HttpService")
local RunService        = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════════════════════════
--  UTILITY
-- ══════════════════════════════════════════════════════════════
local function Tween(inst, props, t, style, dir)
    TweenService:Create(
        inst,
        TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function New(class, props)
    local o = Instance.new(class)
    for k, v in next, props do
        if k ~= "Parent" then o[k] = v end
    end
    if props.Parent then o.Parent = props.Parent end
    return o
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos = false, nil, nil

    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = inp.Position
            startPos  = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if dragging
        and (inp.UserInputType == Enum.UserInputType.MouseMovement
          or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
--  20 THEMES
-- ══════════════════════════════════════════════════════════════
local Themes = {
    Dark      = {BG=Color3.fromRGB(20,20,20),    Side=Color3.fromRGB(14,14,14),   El=Color3.fromRGB(32,32,32),   Tx=Color3.fromRGB(240,240,240), Sub=Color3.fromRGB(155,155,155), Acc=Color3.fromRGB(0,200,100),   Sl=Color3.fromRGB(30,120,255),  Btn=Color3.fromRGB(45,45,45),  Brd=Color3.fromRGB(55,55,55)},
    Midnight  = {BG=Color3.fromRGB(10,10,30),    Side=Color3.fromRGB(8,8,22),     El=Color3.fromRGB(22,22,50),   Tx=Color3.fromRGB(200,200,255), Sub=Color3.fromRGB(130,130,200), Acc=Color3.fromRGB(100,100,255), Sl=Color3.fromRGB(80,80,255),   Btn=Color3.fromRGB(30,30,70),  Brd=Color3.fromRGB(50,50,90)},
    Ocean     = {BG=Color3.fromRGB(10,25,40),    Side=Color3.fromRGB(8,18,30),    El=Color3.fromRGB(15,35,55),   Tx=Color3.fromRGB(200,230,255), Sub=Color3.fromRGB(120,170,210), Acc=Color3.fromRGB(0,180,220),   Sl=Color3.fromRGB(0,150,200),   Btn=Color3.fromRGB(20,50,80),  Brd=Color3.fromRGB(30,70,110)},
    Forest    = {BG=Color3.fromRGB(15,25,15),    Side=Color3.fromRGB(10,18,10),   El=Color3.fromRGB(22,38,22),   Tx=Color3.fromRGB(200,240,200), Sub=Color3.fromRGB(130,180,130), Acc=Color3.fromRGB(50,200,50),   Sl=Color3.fromRGB(30,160,30),   Btn=Color3.fromRGB(25,50,25),  Brd=Color3.fromRGB(40,70,40)},
    Rose      = {BG=Color3.fromRGB(35,15,20),    Side=Color3.fromRGB(25,10,15),   El=Color3.fromRGB(50,22,30),   Tx=Color3.fromRGB(255,210,220), Sub=Color3.fromRGB(200,140,155), Acc=Color3.fromRGB(255,80,120),  Sl=Color3.fromRGB(220,60,100),  Btn=Color3.fromRGB(70,25,40),  Brd=Color3.fromRGB(90,35,55)},
    Sunset    = {BG=Color3.fromRGB(30,15,5),     Side=Color3.fromRGB(22,10,3),    El=Color3.fromRGB(45,22,8),    Tx=Color3.fromRGB(255,220,180), Sub=Color3.fromRGB(200,160,110), Acc=Color3.fromRGB(255,140,30),  Sl=Color3.fromRGB(255,100,20),  Btn=Color3.fromRGB(65,25,8),   Brd=Color3.fromRGB(85,35,12)},
    Purple    = {BG=Color3.fromRGB(20,10,30),    Side=Color3.fromRGB(14,7,22),    El=Color3.fromRGB(32,16,48),   Tx=Color3.fromRGB(230,210,255), Sub=Color3.fromRGB(160,130,200), Acc=Color3.fromRGB(160,80,255),  Sl=Color3.fromRGB(130,60,220),  Btn=Color3.fromRGB(45,20,70),  Brd=Color3.fromRGB(60,30,90)},
    Neon      = {BG=Color3.fromRGB(8,8,8),       Side=Color3.fromRGB(5,5,5),      El=Color3.fromRGB(15,15,15),   Tx=Color3.fromRGB(0,255,200),   Sub=Color3.fromRGB(0,180,140),   Acc=Color3.fromRGB(0,255,200),   Sl=Color3.fromRGB(0,200,255),   Btn=Color3.fromRGB(20,20,20),  Brd=Color3.fromRGB(0,100,80)},
    Arctic    = {BG=Color3.fromRGB(220,235,245), Side=Color3.fromRGB(200,220,235),El=Color3.fromRGB(235,245,255),Tx=Color3.fromRGB(30,40,60),    Sub=Color3.fromRGB(80,100,130),  Acc=Color3.fromRGB(0,120,220),   Sl=Color3.fromRGB(0,100,200),   Btn=Color3.fromRGB(200,215,230),Brd=Color3.fromRGB(160,185,210)},
    Light     = {BG=Color3.fromRGB(240,240,240), Side=Color3.fromRGB(225,225,225),El=Color3.fromRGB(255,255,255),Tx=Color3.fromRGB(30,30,30),    Sub=Color3.fromRGB(100,100,100), Acc=Color3.fromRGB(0,120,220),   Sl=Color3.fromRGB(0,100,200),   Btn=Color3.fromRGB(210,210,210),Brd=Color3.fromRGB(190,190,190)},
    Cherry    = {BG=Color3.fromRGB(25,5,10),     Side=Color3.fromRGB(18,3,7),     El=Color3.fromRGB(38,8,15),    Tx=Color3.fromRGB(255,190,200), Sub=Color3.fromRGB(180,110,120), Acc=Color3.fromRGB(255,30,60),   Sl=Color3.fromRGB(200,20,50),   Btn=Color3.fromRGB(55,10,20),  Brd=Color3.fromRGB(75,15,28)},
    Cyan      = {BG=Color3.fromRGB(5,22,25),     Side=Color3.fromRGB(3,15,18),    El=Color3.fromRGB(8,35,40),    Tx=Color3.fromRGB(180,255,255), Sub=Color3.fromRGB(100,190,200), Acc=Color3.fromRGB(0,220,240),   Sl=Color3.fromRGB(0,190,210),   Btn=Color3.fromRGB(10,50,58),  Brd=Color3.fromRGB(15,70,80)},
    Gold      = {BG=Color3.fromRGB(20,16,5),     Side=Color3.fromRGB(15,11,3),    El=Color3.fromRGB(32,25,8),    Tx=Color3.fromRGB(255,235,150), Sub=Color3.fromRGB(190,165,80),  Acc=Color3.fromRGB(255,200,0),   Sl=Color3.fromRGB(220,170,0),   Btn=Color3.fromRGB(50,38,10),  Brd=Color3.fromRGB(70,52,15)},
    Slate     = {BG=Color3.fromRGB(30,35,45),    Side=Color3.fromRGB(22,26,34),   El=Color3.fromRGB(40,48,60),   Tx=Color3.fromRGB(210,220,235), Sub=Color3.fromRGB(130,145,170), Acc=Color3.fromRGB(80,140,220),  Sl=Color3.fromRGB(60,120,200),  Btn=Color3.fromRGB(50,60,80),  Brd=Color3.fromRGB(60,75,100)},
    Ruby      = {BG=Color3.fromRGB(22,5,5),      Side=Color3.fromRGB(15,3,3),     El=Color3.fromRGB(35,8,8),     Tx=Color3.fromRGB(255,200,200), Sub=Color3.fromRGB(180,110,110), Acc=Color3.fromRGB(220,30,30),   Sl=Color3.fromRGB(180,20,20),   Btn=Color3.fromRGB(50,10,10),  Brd=Color3.fromRGB(70,15,15)},
    Emerald   = {BG=Color3.fromRGB(5,22,12),     Side=Color3.fromRGB(3,15,8),     El=Color3.fromRGB(8,35,18),    Tx=Color3.fromRGB(180,255,200), Sub=Color3.fromRGB(100,190,130), Acc=Color3.fromRGB(0,200,80),    Sl=Color3.fromRGB(0,170,60),    Btn=Color3.fromRGB(10,50,22),  Brd=Color3.fromRGB(15,70,30)},
    Lavender  = {BG=Color3.fromRGB(25,20,35),    Side=Color3.fromRGB(18,14,25),   El=Color3.fromRGB(38,30,55),   Tx=Color3.fromRGB(220,210,255), Sub=Color3.fromRGB(155,140,200), Acc=Color3.fromRGB(180,140,255), Sl=Color3.fromRGB(150,110,230), Btn=Color3.fromRGB(55,42,80),  Brd=Color3.fromRGB(75,58,110)},
    Obsidian  = {BG=Color3.fromRGB(5,5,5),       Side=Color3.fromRGB(3,3,3),      El=Color3.fromRGB(12,12,12),   Tx=Color3.fromRGB(200,200,200), Sub=Color3.fromRGB(100,100,100), Acc=Color3.fromRGB(150,150,150), Sl=Color3.fromRGB(120,120,120), Btn=Color3.fromRGB(18,18,18),  Brd=Color3.fromRGB(30,30,30)},
    Vapor     = {BG=Color3.fromRGB(15,5,25),     Side=Color3.fromRGB(10,3,18),    El=Color3.fromRGB(25,10,40),   Tx=Color3.fromRGB(255,180,255), Sub=Color3.fromRGB(180,110,200), Acc=Color3.fromRGB(255,50,255),  Sl=Color3.fromRGB(200,30,220),  Btn=Color3.fromRGB(40,12,65),  Brd=Color3.fromRGB(60,18,90)},
    Matrix    = {BG=Color3.fromRGB(0,8,0),       Side=Color3.fromRGB(0,5,0),      El=Color3.fromRGB(0,15,0),     Tx=Color3.fromRGB(0,255,70),    Sub=Color3.fromRGB(0,180,50),    Acc=Color3.fromRGB(0,255,70),    Sl=Color3.fromRGB(0,200,50),    Btn=Color3.fromRGB(0,20,0),    Brd=Color3.fromRGB(0,50,0)},
}

local ThemeNames = {}
for k in next, Themes do table.insert(ThemeNames, k) end
table.sort(ThemeNames)

-- ══════════════════════════════════════════════════════════════
--  SAVE SYSTEM
-- ══════════════════════════════════════════════════════════════
local SaveFolder = "Neon_Savess"

local function EnsureFolder()
    if not isfolder(SaveFolder) then makefolder(SaveFolder) end
end

local function SaveData(name, data)
    EnsureFolder()
    local ok, err = pcall(function()
        writefile(SaveFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
    return ok, err
end

local function LoadData(name)
    local path = SaveFolder .. "/" .. name .. ".json"
    local ok, result = pcall(function()
        if isfile(path) then
            return HttpService:JSONDecode(readfile(path))
        end
        return nil
    end)
    return ok and result or nil
end

local function GetSaves()
    EnsureFolder()
    local saves = {}
    local ok, files = pcall(listfiles, SaveFolder)
    if ok then
        for _, f in ipairs(files) do
            local name = f:match("([^/\\]+)%.json$")
            if name then table.insert(saves, name) end
        end
    end
    return saves
end

-- ══════════════════════════════════════════════════════════════
--  LIBRARY STATE
-- ══════════════════════════════════════════════════════════════
local NeonHub = {}
NeonHub.__index = NeonHub

-- Configurações globais da biblioteca
local LibConfig = {
    Theme                  = "Dark",
    Transparency           = false,
    SaveName               = "MySave",
    AutoLoad               = false,
    AutoLoadSave           = "",
    Minimize_button_image_id = "",
    UI_Library_Fund          = "",
}

local CurrentTheme       = Themes["Dark"]
local RegisteredElements = {}

-- Referências globais para aplicação de tema em tempo real
local _MainFrame   = nil
local _TitleBar    = nil
local _Sidebar     = nil
local _ToggleBtn   = nil
local _BgImageLbl  = nil
local _ToggleImgLbl = nil
local _AllElements = {} -- lista de {instance, prop, themeKey}

-- ══════════════════════════════════════════════════════════════
--  APLICA TEMA EM TEMPO REAL
-- ══════════════════════════════════════════════════════════════
local function ApplyTheme(themeName)
    if not Themes[themeName] then return end
    LibConfig.Theme = themeName
    CurrentTheme    = Themes[themeName]
    local T         = CurrentTheme

    -- Redesenha os elementos registrados para o tema
    for _, entry in ipairs(_AllElements) do
        local ok = pcall(function()
            entry.inst[entry.prop] = T[entry.key]
        end)
    end
end

local function RegisterThemeProp(inst, prop, themeKey)
    table.insert(_AllElements, {inst=inst, prop=prop, key=themeKey})
end

-- ══════════════════════════════════════════════════════════════
--  KEY SYSTEM
-- ══════════════════════════════════════════════════════════════
function NeonHub:KeySystem(cfg)
    cfg = cfg or {}
    cfg.Text         = cfg.Text        or "Key System"
    cfg.KeySystem    = cfg.KeySystem   ~= nil and cfg.KeySystem or false
    cfg.Key          = cfg.Key         or "123"
    cfg.AutoSaveKey  = cfg.AutoSaveKey ~= nil and cfg.AutoSaveKey or true
    cfg.KeyJson      = cfg.KeyJson     or "Key_NeonHub.json"
    cfg.GetKeyBySite = cfg.GetKeyBySite ~= nil and cfg.GetKeyBySite or false
    cfg.KeySite      = cfg.KeySite     or ""

    -- ── Salva os IDs de imagem nas configurações globais ──────
    if cfg.Minimize_button_image_id and cfg.Minimize_button_image_id ~= "" then
        LibConfig.Minimize_button_image_id = tostring(cfg.Minimize_button_image_id)
    end
    if cfg.UI_Library_Fund and cfg.UI_Library_Fund ~= "" then
        LibConfig.UI_Library_Fund = tostring(cfg.UI_Library_Fund)
    end

    if not cfg.KeySystem then return true end

    -- Auto-load saved key
    if cfg.AutoSaveKey then
        local ok, saved = pcall(readfile, cfg.KeyJson)
        if ok and saved == cfg.Key then return true end
    end

    local T      = CurrentTheme
    local result = false

    local gui = New("ScreenGui", {
        Name           = "NeonHub_Key",
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent         = PlayerGui,
    })

    New("Frame", {
        Size                   = UDim2.fromScale(1, 1),
        BackgroundColor3       = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.45,
        Parent                 = gui,
    })

    local win = New("Frame", {
        Size             = UDim2.fromOffset(370, 210),
        Position         = UDim2.fromScale(0.5, 0.5),
        AnchorPoint      = Vector2.new(0.5, 0.5),
        BackgroundColor3 = T.BG,
        BorderSizePixel  = 0,
        Parent           = gui,
    })
    New("UICorner", {CornerRadius = UDim.new(0, 14), Parent = win})
    New("UIStroke",  {Color = T.Brd, Thickness = 1.5, Parent = win})
    MakeDraggable(win)

    local hdr = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = T.Side,
        BorderSizePixel  = 0,
        Parent           = win,
    })
    New("UICorner", {CornerRadius = UDim.new(0, 14), Parent = hdr})
    New("Frame", {Size=UDim2.new(1,0,0.5,0), Position=UDim2.fromScale(0,0.5), BackgroundColor3=T.Side, BorderSizePixel=0, Parent=hdr})
    New("TextLabel", {
        Text="🔐  "..cfg.Text, Font=Enum.Font.GothamBold, TextSize=16,
        TextColor3=T.Tx, BackgroundTransparency=1,
        Size=UDim2.fromScale(1,1), TextXAlignment=Enum.TextXAlignment.Center, Parent=hdr,
    })

    if cfg.GetKeyBySite and cfg.KeySite ~= "" then
        local linkBtn = New("TextButton", {
            Text="🔗 Get Key from Site", Font=Enum.Font.GothamSemibold, TextSize=12,
            TextColor3=T.Acc, BackgroundTransparency=1,
            Size=UDim2.new(1,0,0,22), Position=UDim2.fromOffset(0,50), Parent=win,
        })
        linkBtn.MouseButton1Click:Connect(function()
            pcall(function() game:GetService("GuiService"):OpenBrowserWindow(cfg.KeySite) end)
        end)
    end

    local box = New("TextBox", {
        PlaceholderText="Enter your key here...", Text="",
        Font=Enum.Font.Gotham, TextSize=14,
        TextColor3=T.Tx, PlaceholderColor3=T.Sub,
        BackgroundColor3=T.El, BorderSizePixel=0,
        Size=UDim2.new(1,-40,0,42), Position=UDim2.fromOffset(20,78),
        ClearTextOnFocus=false, Parent=win,
    })
    New("UICorner", {CornerRadius=UDim.new(0,8), Parent=box})
    New("UIStroke",  {Color=T.Brd, Thickness=1, Parent=box})
    New("UIPadding", {PaddingLeft=UDim.new(0,10), Parent=box})

    local errLbl = New("TextLabel", {
        Text="", Font=Enum.Font.Gotham, TextSize=12,
        TextColor3=Color3.fromRGB(255,80,80), BackgroundTransparency=1,
        Size=UDim2.new(1,-40,0,16), Position=UDim2.fromOffset(20,124), Parent=win,
    })

    local submitBtn = New("TextButton", {
        Text="Submit", Font=Enum.Font.GothamBold, TextSize=15,
        TextColor3=Color3.fromRGB(255,255,255), BackgroundColor3=T.Acc,
        BorderSizePixel=0, Size=UDim2.new(1,-40,0,40), Position=UDim2.fromOffset(20,144),
        Parent=win,
    })
    New("UICorner", {CornerRadius=UDim.new(0,8), Parent=submitBtn})

    submitBtn.MouseButton1Click:Connect(function()
        local entered = box.Text
        local valid   = false
        if cfg.GetKeyBySite and cfg.KeySite ~= "" then
            local ok, res = pcall(function() return game:HttpGet(cfg.KeySite) end)
            if ok and res then
                for line in res:gmatch("[^\n]+") do
                    if line:match("^%s*(.-)%s*$") == entered then valid = true break end
                end
            end
        end
        if entered == cfg.Key or valid then
            if cfg.AutoSaveKey then pcall(writefile, cfg.KeyJson, entered) end
            result = true
            Tween(win, {Size=UDim2.fromOffset(370,0)}, 0.2)
            task.delay(0.25, function() gui:Destroy() end)
        else
            errLbl.Text = "❌  Invalid key — please try again."
            Tween(win, {BackgroundColor3=Color3.fromRGB(55,12,12)}, 0.1)
            task.delay(0.25, function() Tween(win, {BackgroundColor3=T.BG}, 0.15) end)
        end
    end)

    repeat task.wait(0.05) until result or not gui.Parent
    return result
end

-- ══════════════════════════════════════════════════════════════
--  LOADING SCREEN
-- ══════════════════════════════════════════════════════════════
function NeonHub:LoadingScreen(cfg)
    cfg = cfg or {}
    cfg.LoadingText = cfg.LoadingText or "Loading..."
    cfg.Duration    = tonumber(cfg.Duration) or 5

    local T   = CurrentTheme
    local gui = New("ScreenGui", {
        Name="NeonHub_Loading", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=PlayerGui,
    })

    local bg = New("Frame", {
        Size=UDim2.fromScale(1,1), BackgroundColor3=T.BG,
        BackgroundTransparency = LibConfig.Transparency and 0.4 or 0,
        BorderSizePixel=0, Parent=gui,
    })

    local spinner = New("TextLabel", {
        Text="◉", Font=Enum.Font.GothamBold, TextSize=48,
        TextColor3=T.Acc, BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,60), Position=UDim2.fromScale(0,0.3),
        TextXAlignment=Enum.TextXAlignment.Center, Parent=bg,
    })

    New("TextLabel", {
        Text="NeonHub", Font=Enum.Font.GothamBold, TextSize=34,
        TextColor3=T.Tx, BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,44), Position=UDim2.fromScale(0,0.42),
        TextXAlignment=Enum.TextXAlignment.Center, Parent=bg,
    })

    New("TextLabel", {
        Text=cfg.LoadingText, Font=Enum.Font.Gotham, TextSize=15,
        TextColor3=T.Sub, BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,28), Position=UDim2.fromScale(0,0.52),
        TextXAlignment=Enum.TextXAlignment.Center, Parent=bg,
    })

    local barBg = New("Frame", {
        Size=UDim2.new(0.5,0,0,6), Position=UDim2.new(0.25,0,0.62,0),
        BackgroundColor3=T.El, BorderSizePixel=0, Parent=bg,
    })
    New("UICorner", {CornerRadius=UDim.new(1,0), Parent=barBg})
    local barFill = New("Frame", {
        Size=UDim2.new(0,0,1,0), BackgroundColor3=T.Acc, BorderSizePixel=0, Parent=barBg,
    })
    New("UICorner", {CornerRadius=UDim.new(1,0), Parent=barFill})

    local pctLbl = New("TextLabel", {
        Text="0%", Font=Enum.Font.GothamSemibold, TextSize=12,
        TextColor3=T.Sub, BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,18), Position=UDim2.new(0.25,0,0.64,0),
        TextXAlignment=Enum.TextXAlignment.Center, Parent=bg,
    })

    local spinConn
    local rot = 0
    spinConn = RunService.Heartbeat:Connect(function(dt)
        rot = rot + dt * 180
        spinner.Rotation = rot
    end)

    local startT = tick()
    local progConn
    progConn = RunService.Heartbeat:Connect(function()
        local p = math.min((tick()-startT) / cfg.Duration, 1)
        barFill.Size = UDim2.new(p, 0, 1, 0)
        pctLbl.Text  = math.floor(p*100).."%"
    end)

    task.delay(cfg.Duration, function()
        spinConn:Disconnect()
        progConn:Disconnect()
        Tween(bg, {BackgroundTransparency=1}, 0.6)
        task.delay(0.65, function() gui:Destroy() end)
    end)

    task.wait(cfg.Duration + 0.7)
end

-- ══════════════════════════════════════════════════════════════
--  CREATE WINDOW
-- ══════════════════════════════════════════════════════════════
function NeonHub:CreateWindow(cfg)
    cfg = cfg or {}
    cfg.Name    = cfg.Name    or "NeonHub"
    cfg.SubTitle = cfg.SubTitle or "UI Library"
    cfg.Width   = cfg.Width   or 600
    cfg.Height  = cfg.Height  or 420

    -- Aplica tema salvo
    if Themes[LibConfig.Theme] then
        CurrentTheme = Themes[LibConfig.Theme]
    end
    local T = CurrentTheme

    -- Limpa lista de elementos de tema para essa janela
    _AllElements = {}

    local Win = { Tabs={}, _tabFrames={}, _tabBtns={} }

    local Gui = New("ScreenGui", {
        Name="NeonHub_Main", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=PlayerGui,
    })

    -- ── Main frame ────────────────────────────────────────────
    local MainFrame = New("Frame", {
        Size=UDim2.fromOffset(cfg.Width, cfg.Height),
        Position=UDim2.fromScale(0.5,0.5),
        AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundColor3=T.BG,
        BackgroundTransparency = LibConfig.Transparency and 0.4 or 0,
        BorderSizePixel=0, ClipsDescendants=true, Parent=Gui,
    })
    New("UICorner", {CornerRadius=UDim.new(0,12), Parent=MainFrame})
    local mfStroke = New("UIStroke", {Color=T.Brd, Thickness=1.5, Parent=MainFrame})
    _MainFrame = MainFrame

    RegisterThemeProp(MainFrame, "BackgroundColor3", "BG")
    RegisterThemeProp(mfStroke,  "Color",            "Brd")

    -- ── Fundo da UI (UI_Library_Fund) ─────────────────────────
    local bgImageLbl = New("ImageLabel", {
        Image = LibConfig.UI_Library_Fund ~= "" and ("rbxassetid://"..LibConfig.UI_Library_Fund) or "",
        Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
        ScaleType=Enum.ScaleType.Crop, ZIndex=0,
        Visible = LibConfig.UI_Library_Fund ~= "",
        Parent=MainFrame,
    })
    _BgImageLbl = bgImageLbl

    -- ── Title bar ─────────────────────────────────────────────
    local TitleBar = New("Frame", {
        Size=UDim2.new(1,0,0,44),
        BackgroundColor3=T.Side,
        BorderSizePixel=0, ZIndex=3, Parent=MainFrame,
    })
    New("UICorner", {CornerRadius=UDim.new(0,12), Parent=TitleBar})
    New("Frame", {
        Size=UDim2.new(1,0,0.5,0), Position=UDim2.fromScale(0,0.5),
        BackgroundColor3=T.Side, BorderSizePixel=0, ZIndex=2, Parent=TitleBar,
    })
    RegisterThemeProp(TitleBar, "BackgroundColor3", "Side")
    _TitleBar = TitleBar

    New("TextLabel", {
        Text="◉", Font=Enum.Font.GothamBold, TextSize=18,
        TextColor3=T.Acc, BackgroundTransparency=1,
        Size=UDim2.fromOffset(30,44), Position=UDim2.fromOffset(10,0), ZIndex=4, Parent=TitleBar,
    })
    New("TextLabel", {
        Text=cfg.Name, Font=Enum.Font.GothamBold, TextSize=15,
        TextColor3=T.Tx, BackgroundTransparency=1,
        Size=UDim2.fromOffset(250,22), Position=UDim2.fromOffset(44,5),
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4, Parent=TitleBar,
    })
    New("TextLabel", {
        Text=cfg.SubTitle, Font=Enum.Font.Gotham, TextSize=11,
        TextColor3=T.Sub, BackgroundTransparency=1,
        Size=UDim2.fromOffset(250,16), Position=UDim2.fromOffset(44,22),
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4, Parent=TitleBar,
    })

    local CloseBtn = New("TextButton", {
        Text="✕", Font=Enum.Font.GothamBold, TextSize=16,
        TextColor3=T.Sub, BackgroundTransparency=1,
        Size=UDim2.fromOffset(36,36), Position=UDim2.new(1,-40,0,4), ZIndex=5, Parent=TitleBar,
    })
    MakeDraggable(MainFrame, TitleBar)

    -- ── Body ──────────────────────────────────────────────────
    local Body = New("Frame", {
        Size=UDim2.new(1,0,1,-44), Position=UDim2.fromOffset(0,44),
        BackgroundTransparency=1, Parent=MainFrame,
    })

    local Sidebar = New("Frame", {
        Size=UDim2.new(0,175,1,0),
        BackgroundColor3=T.Side,
        BackgroundTransparency = LibConfig.Transparency and 0.4 or 0,
        BorderSizePixel=0, Parent=Body,
    })
    RegisterThemeProp(Sidebar, "BackgroundColor3", "Side")
    _Sidebar = Sidebar

    local SideList = New("ScrollingFrame", {
        Size=UDim2.new(1,-8,1,-8), Position=UDim2.fromOffset(4,4),
        BackgroundTransparency=1, ScrollBarThickness=2,
        ScrollBarImageColor3=T.Acc,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        BorderSizePixel=0, Parent=Sidebar,
    })
    New("UIListLayout", {Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder, Parent=SideList})
    New("UIPadding", {PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4), Parent=SideList})

    local ContentArea = New("Frame", {
        Size=UDim2.new(1,-175,1,0), Position=UDim2.fromOffset(175,0),
        BackgroundTransparency=1, ClipsDescendants=true, Parent=Body,
    })

    -- ── Toggle Button (floating, draggable) ───────────────────
    local IsOpen    = true
    local ToggleBtn = New("ImageButton", {
        Size=UDim2.fromOffset(48,48),
        Position=UDim2.new(0,20,0.5,-24),
        BackgroundColor3=T.BG,
        BackgroundTransparency = LibConfig.Transparency and 0.4 or 0,
        BorderSizePixel=0, ZIndex=15, Parent=Gui,
    })
    New("UICorner", {CornerRadius=UDim.new(0,12), Parent=ToggleBtn})
    local tbStroke = New("UIStroke", {Color=T.Brd, Thickness=1.5, Parent=ToggleBtn})
    RegisterThemeProp(ToggleBtn, "BackgroundColor3", "BG")
    RegisterThemeProp(tbStroke,  "Color",            "Brd")
    MakeDraggable(ToggleBtn)
    _ToggleBtn = ToggleBtn

    -- Imagem do botão toggle (Minimize_button_image_id)
    local toggleImgLbl = nil
    local toggleTextLbl = nil
    if LibConfig.Minimize_button_image_id ~= "" then
        toggleImgLbl = New("ImageLabel", {
            Image="rbxassetid://"..LibConfig.Minimize_button_image_id,
            Size=UDim2.fromScale(0.75,0.75), Position=UDim2.fromScale(0.125,0.125),
            BackgroundTransparency=1, ZIndex=16, Parent=ToggleBtn,
        })
    else
        toggleTextLbl = New("TextLabel", {
            Text="☰", Font=Enum.Font.GothamBold, TextSize=22,
            TextColor3=T.Tx, BackgroundTransparency=1,
            Size=UDim2.fromScale(1,1), ZIndex=16, Parent=ToggleBtn,
        })
        RegisterThemeProp(toggleTextLbl, "TextColor3", "Tx")
    end
    _ToggleImgLbl = toggleImgLbl

    local function ToggleWindow()
        IsOpen = not IsOpen
        if IsOpen then
            MainFrame.Visible = true
            Tween(MainFrame, {Size=UDim2.fromOffset(cfg.Width, cfg.Height)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            Tween(MainFrame, {Size=UDim2.fromOffset(0,0)}, 0.2)
            task.delay(0.22, function() MainFrame.Visible = false end)
        end
    end
    ToggleBtn.MouseButton1Click:Connect(ToggleWindow)
    CloseBtn.MouseButton1Click:Connect(function()
        if IsOpen then ToggleWindow() end
    end)

    -- ══════════════════════════════════════════════════════════
    --  ADD TAB
    -- ══════════════════════════════════════════════════════════
    function Win:AddTab(name, icon)
        local T   = CurrentTheme
        local Tab = { Name=name, _order=0 }

        local iconTxt = icon and (icon.."  ") or "   "
        local TabBtn  = New("TextButton", {
            Text= iconTxt .. name,
            Font=Enum.Font.GothamSemibold, TextSize=13,
            TextColor3=T.Sub, BackgroundColor3=T.El,
            BackgroundTransparency=1,
            TextXAlignment=Enum.TextXAlignment.Left,
            Size=UDim2.new(1,0,0,38), BorderSizePixel=0,
            LayoutOrder=#Win.Tabs+1, Parent=SideList,
        })
        New("UICorner", {CornerRadius=UDim.new(0,8), Parent=TabBtn})
        New("UIPadding", {PaddingLeft=UDim.new(0,10), Parent=TabBtn})

        local TabFrame = New("ScrollingFrame", {
            Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
            ScrollBarThickness=3, ScrollBarImageColor3=T.Acc,
            CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
            BorderSizePixel=0, Visible=false, Parent=ContentArea,
        })
        New("UIListLayout", {Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder, Parent=TabFrame})
        New("UIPadding", {
            PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10),
            PaddingTop=UDim.new(0,12),  PaddingBottom=UDim.new(0,12),
            Parent=TabFrame,
        })

        New("TextLabel", {
            Text=name, Font=Enum.Font.GothamBold, TextSize=18,
            TextColor3=T.Tx, BackgroundTransparency=1,
            Size=UDim2.new(1,0,0,26), LayoutOrder=0,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=TabFrame,
        })
        New("TextLabel", {
            Text="Interactive Elements", Font=Enum.Font.Gotham, TextSize=12,
            TextColor3=T.Sub, BackgroundTransparency=1,
            Size=UDim2.new(1,0,0,16), LayoutOrder=1,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=TabFrame,
        })

        table.insert(Win.Tabs,       Tab)
        table.insert(Win._tabFrames, TabFrame)
        table.insert(Win._tabBtns,   TabBtn)

        TabBtn.MouseButton1Click:Connect(function()
            for i, f in ipairs(Win._tabFrames) do
                f.Visible = false
                Tween(Win._tabBtns[i], {BackgroundTransparency=1, TextColor3=CurrentTheme.Sub}, 0.12)
            end
            TabFrame.Visible = true
            Tween(TabBtn, {BackgroundTransparency=0.8, TextColor3=CurrentTheme.Tx}, 0.12)
        end)

        if #Win.Tabs == 1 then
            TabFrame.Visible = true
            TabBtn.BackgroundTransparency = 0.8
            TabBtn.TextColor3 = T.Tx
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT HELPERS
        -- ──────────────────────────────────────────────────────
        local EOrder = 2

        local function NextO()
            EOrder = EOrder + 1
            return EOrder
        end

        local function Card(h, noStroke)
            local T = CurrentTheme
            local c = New("Frame", {
                Size=UDim2.new(1,0,0,h or 50),
                BackgroundColor3=T.El,
                BorderSizePixel=0,
                LayoutOrder=NextO(),
                Parent=TabFrame,
            })
            New("UICorner", {CornerRadius=UDim.new(0,9), Parent=c})
            if not noStroke then
                local s = New("UIStroke", {Color=T.Brd, Thickness=1, Parent=c})
                RegisterThemeProp(s, "Color", "Brd")
            end
            RegisterThemeProp(c, "BackgroundColor3", "El")
            return c
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 1: TOGGLE
        -- ──────────────────────────────────────────────────────
        function Tab:AddToggle(cfg)
            cfg = cfg or {}
            cfg.Name     = cfg.Name     or "Toggle"
            cfg.Default  = cfg.Default  ~= nil and cfg.Default or false
            cfg.Callback = cfg.Callback or function() end

            local val  = cfg.Default
            local card = Card(50)

            New("TextLabel", {
                Text=cfg.Name, Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                Size=UDim2.new(1,-70,1,0), Position=UDim2.fromOffset(12,0),
                TextXAlignment=Enum.TextXAlignment.Left, Parent=card,
            })

            local swBg = New("Frame", {
                Size=UDim2.fromOffset(50,26),
                Position=UDim2.new(1,-62,0.5,-13),
                BackgroundColor3=val and CurrentTheme.Acc or CurrentTheme.Brd,
                BorderSizePixel=0, Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(1,0), Parent=swBg})
            local knob = New("Frame", {
                Size=UDim2.fromOffset(20,20),
                Position=val and UDim2.fromOffset(26,3) or UDim2.fromOffset(3,3),
                BackgroundColor3=Color3.fromRGB(255,255,255),
                BorderSizePixel=0, Parent=swBg,
            })
            New("UICorner", {CornerRadius=UDim.new(1,0), Parent=knob})

            local btn = New("TextButton", {
                Text="", BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=swBg,
            })
            btn.MouseButton1Click:Connect(function()
                val = not val
                Tween(swBg, {BackgroundColor3=val and CurrentTheme.Acc or CurrentTheme.Brd}, 0.15)
                Tween(knob, {Position=val and UDim2.fromOffset(26,3) or UDim2.fromOffset(3,3)}, 0.15)
                cfg.Callback(val)
            end)

            if cfg.Flag then
                RegisteredElements[cfg.Flag] = {
                    Type="Toggle",
                    Get=function() return val end,
                    Set=function(v)
                        val = v
                        Tween(swBg,  {BackgroundColor3=val and CurrentTheme.Acc or CurrentTheme.Brd}, 0.15)
                        Tween(knob,  {Position=val and UDim2.fromOffset(26,3) or UDim2.fromOffset(3,3)}, 0.15)
                        cfg.Callback(val)
                    end,
                }
            end
            return {Get=function() return val end}
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 2: SLIDER
        -- ──────────────────────────────────────────────────────
        function Tab:AddSlider(cfg)
            cfg = cfg or {}
            cfg.Name      = cfg.Name      or "Slider"
            cfg.Min       = cfg.Min       or 0
            cfg.Max       = cfg.Max       or 100
            cfg.Default   = cfg.Default   or cfg.Min
            cfg.Increment = cfg.Increment or 1
            cfg.Suffix    = cfg.Suffix    or ""
            cfg.Callback  = cfg.Callback  or function() end

            local val  = cfg.Default
            local card = Card(70)

            New("TextLabel", {
                Text=cfg.Name, Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                Size=UDim2.new(0.65,0,0,24), Position=UDim2.fromOffset(12,6),
                TextXAlignment=Enum.TextXAlignment.Left, Parent=card,
            })
            local valLbl = New("TextLabel", {
                Text=tostring(val)..cfg.Suffix, Font=Enum.Font.GothamBold, TextSize=13,
                TextColor3=CurrentTheme.Acc, BackgroundTransparency=1,
                Size=UDim2.new(0.35,-12,0,24), Position=UDim2.new(0.65,0,0,6),
                TextXAlignment=Enum.TextXAlignment.Right, Parent=card,
            })

            local trackBg = New("Frame", {
                Size=UDim2.new(1,-24,0,8), Position=UDim2.fromOffset(12,42),
                BackgroundColor3=CurrentTheme.Brd, BorderSizePixel=0, Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(1,0), Parent=trackBg})

            local p0   = (val-cfg.Min)/(cfg.Max-cfg.Min)
            local fill = New("Frame", {
                Size=UDim2.new(p0,0,1,0), BackgroundColor3=CurrentTheme.Sl, BorderSizePixel=0, Parent=trackBg,
            })
            New("UICorner", {CornerRadius=UDim.new(1,0), Parent=fill})

            local knob = New("Frame", {
                Size=UDim2.fromOffset(20,20), Position=UDim2.new(p0,0,0.5,-10),
                BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0, ZIndex=2, Parent=trackBg,
            })
            New("UICorner", {CornerRadius=UDim.new(1,0), Parent=knob})
            local kStroke = New("UIStroke", {Color=CurrentTheme.Sl, Thickness=2, Parent=knob})
            RegisterThemeProp(kStroke, "Color", "Sl")
            RegisterThemeProp(fill,    "BackgroundColor3", "Sl")
            RegisterThemeProp(trackBg, "BackgroundColor3", "Brd")

            local function UpdateSlider(inp)
                local relX = math.clamp(inp.Position.X - trackBg.AbsolutePosition.X, 0, trackBg.AbsoluteSize.X)
                local p    = relX / trackBg.AbsoluteSize.X
                val = math.clamp(math.round((cfg.Min+(cfg.Max-cfg.Min)*p)/cfg.Increment)*cfg.Increment, cfg.Min, cfg.Max)
                local np = (val-cfg.Min)/(cfg.Max-cfg.Min)
                fill.Size     = UDim2.new(np,0,1,0)
                knob.Position = UDim2.new(np,0,0.5,-10)
                valLbl.Text   = tostring(val)..cfg.Suffix
                cfg.Callback(val)
            end

            local dragging = false
            local sb = New("TextButton", {Text="",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=3,Parent=trackBg})
            sb.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                    dragging=true; UpdateSlider(inp)
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
                    UpdateSlider(inp)
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=false end
            end)

            if cfg.Flag then
                RegisteredElements[cfg.Flag] = {
                    Type="Slider",
                    Get=function() return val end,
                    Set=function(v)
                        val = math.clamp(v, cfg.Min, cfg.Max)
                        local np=(val-cfg.Min)/(cfg.Max-cfg.Min)
                        fill.Size=UDim2.new(np,0,1,0); knob.Position=UDim2.new(np,0,0.5,-10)
                        valLbl.Text=tostring(val)..cfg.Suffix; cfg.Callback(val)
                    end,
                }
            end
            return {Get=function() return val end}
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 3: BUTTON
        -- ──────────────────────────────────────────────────────
        function Tab:AddButton(cfg)
            cfg = cfg or {}
            cfg.Name     = cfg.Name     or "Button"
            cfg.Callback = cfg.Callback or function() end

            local card = Card(46)
            local btn  = New("TextButton", {
                Text=cfg.Name, Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=CurrentTheme.Tx, BackgroundColor3=CurrentTheme.Btn, BorderSizePixel=0,
                Size=UDim2.new(1,-24,0,32), Position=UDim2.fromOffset(12,7), Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(0,8), Parent=btn})
            RegisterThemeProp(btn, "BackgroundColor3", "Btn")
            RegisterThemeProp(btn, "TextColor3",       "Tx")
            btn.MouseButton1Click:Connect(function()
                cfg.Callback()
                Tween(btn,{BackgroundColor3=CurrentTheme.Acc},0.08)
                task.delay(0.22, function() Tween(btn,{BackgroundColor3=CurrentTheme.Btn},0.12) end)
            end)
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 4: DROPDOWN (com scroll automático)
        -- ──────────────────────────────────────────────────────
        function Tab:AddDropdown(cfg)
            cfg = cfg or {}
            cfg.Name     = cfg.Name     or "Dropdown"
            cfg.Options  = cfg.Options  or {}
            cfg.Default  = cfg.Default  or (cfg.Options[1] or "")
            cfg.Callback = cfg.Callback or function() end

            local val    = cfg.Default
            local isOpen = false
            local card   = Card(46)
            card.ClipsDescendants = false

            local header = New("Frame", {
                Size=UDim2.new(1,-24,0,34), Position=UDim2.fromOffset(12,6),
                BackgroundColor3=CurrentTheme.Btn, BorderSizePixel=0, Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(0,8), Parent=header})
            local hStroke = New("UIStroke", {Color=CurrentTheme.Brd, Thickness=1, Parent=header})
            RegisterThemeProp(header,  "BackgroundColor3", "Btn")
            RegisterThemeProp(hStroke, "Color",            "Brd")

            New("TextLabel", {
                Text=cfg.Name, Font=Enum.Font.GothamSemibold, TextSize=12,
                TextColor3=CurrentTheme.Sub, BackgroundTransparency=1,
                Size=UDim2.new(0.45,0,1,0), Position=UDim2.fromOffset(10,0),
                TextXAlignment=Enum.TextXAlignment.Left, Parent=header,
            })
            local valLbl = New("TextLabel", {
                Text=val, Font=Enum.Font.GothamSemibold, TextSize=12,
                TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                Size=UDim2.new(0.5,0,1,0), Position=UDim2.new(0.45,0,0,0),
                TextXAlignment=Enum.TextXAlignment.Right, Parent=header,
            })
            local arrow = New("TextLabel", {
                Text="▾", Font=Enum.Font.GothamBold, TextSize=14,
                TextColor3=CurrentTheme.Sub, BackgroundTransparency=1,
                Size=UDim2.fromOffset(24,34), Position=UDim2.new(1,-24,0,0), Parent=header,
            })

            local maxVisible = 5
            local itemH      = 30
            local dropH      = math.min(#cfg.Options, maxVisible) * itemH + 6

            local dropFrame = New("ScrollingFrame", {
                Size=UDim2.new(1,-24,0,dropH),
                Position=UDim2.new(0,12,0,46),
                BackgroundColor3=CurrentTheme.Btn, BorderSizePixel=0,
                ScrollBarThickness=3, ScrollBarImageColor3=CurrentTheme.Acc,
                CanvasSize=UDim2.new(0,0,0,#cfg.Options*itemH),
                Visible=false, ZIndex=20, Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(0,8), Parent=dropFrame})
            local dfStroke = New("UIStroke", {Color=CurrentTheme.Brd, Thickness=1, Parent=dropFrame})
            New("UIListLayout", {Padding=UDim.new(0,0), Parent=dropFrame})
            RegisterThemeProp(dropFrame, "BackgroundColor3", "Btn")
            RegisterThemeProp(dfStroke,  "Color",            "Brd")

            for _, opt in ipairs(cfg.Options) do
                local optBtn = New("TextButton", {
                    Text="  "..opt, Font=Enum.Font.Gotham, TextSize=12,
                    TextColor3=opt==val and CurrentTheme.Acc or CurrentTheme.Tx,
                    BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,itemH), ZIndex=21, Parent=dropFrame,
                    TextXAlignment=Enum.TextXAlignment.Left,
                })
                optBtn.MouseButton1Click:Connect(function()
                    val = opt
                    valLbl.Text  = val
                    isOpen       = false
                    dropFrame.Visible = false
                    card.Size    = UDim2.new(1,0,0,46)
                    Tween(arrow, {Rotation=0}, 0.12)
                    cfg.Callback(val)
                    for _, ch in ipairs(dropFrame:GetChildren()) do
                        if ch:IsA("TextButton") then
                            ch.TextColor3 = (ch.Text:sub(3)==opt) and CurrentTheme.Acc or CurrentTheme.Tx
                        end
                    end
                end)
            end

            local hBtn = New("TextButton", {
                Text="",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=5,Parent=header
            })
            hBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                dropFrame.Visible = isOpen
                if isOpen then
                    card.Size = UDim2.new(1,0,0, 46+dropH+4)
                    Tween(arrow,{Rotation=180},0.12)
                else
                    card.Size = UDim2.new(1,0,0,46)
                    Tween(arrow,{Rotation=0},0.12)
                end
            end)

            if cfg.Flag then
                RegisteredElements[cfg.Flag] = {
                    Type="Dropdown",
                    Get=function() return val end,
                    Set=function(v) val=v; valLbl.Text=v; cfg.Callback(v) end,
                }
            end
            return {Get=function() return val end}
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 5: MULTI-DROPDOWN
        -- ──────────────────────────────────────────────────────
        function Tab:AddMultiDropdown(cfg)
            cfg = cfg or {}
            cfg.Name     = cfg.Name     or "Multi-Select"
            cfg.Options  = cfg.Options  or {}
            cfg.Default  = cfg.Default  or {}
            cfg.Callback = cfg.Callback or function() end

            local selected = {}
            for _,v in ipairs(cfg.Default) do selected[v]=true end
            local isOpen = false
            local card   = Card(46)
            card.ClipsDescendants = false

            local header = New("Frame", {
                Size=UDim2.new(1,-24,0,34), Position=UDim2.fromOffset(12,6),
                BackgroundColor3=CurrentTheme.Btn, BorderSizePixel=0, Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(0,8), Parent=header})
            New("UIStroke", {Color=CurrentTheme.Brd, Thickness=1, Parent=header})
            New("TextLabel", {
                Text=cfg.Name, Font=Enum.Font.GothamSemibold, TextSize=12,
                TextColor3=CurrentTheme.Sub, BackgroundTransparency=1,
                Size=UDim2.new(0.45,0,1,0), Position=UDim2.fromOffset(10,0),
                TextXAlignment=Enum.TextXAlignment.Left, Parent=header,
            })
            local cntLbl = New("TextLabel", {
                Text="0 selected", Font=Enum.Font.GothamSemibold, TextSize=12,
                TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                Size=UDim2.new(0.5,0,1,0), Position=UDim2.new(0.45,0,0,0),
                TextXAlignment=Enum.TextXAlignment.Right, Parent=header,
            })
            local arrow = New("TextLabel", {
                Text="▾", Font=Enum.Font.GothamBold, TextSize=14,
                TextColor3=CurrentTheme.Sub, BackgroundTransparency=1,
                Size=UDim2.fromOffset(24,34), Position=UDim2.new(1,-24,0,0), Parent=header,
            })

            local itemH      = 34
            local maxVisible = 5
            local dropH      = math.min(#cfg.Options, maxVisible)*itemH + 6

            local dropFrame = New("ScrollingFrame", {
                Size=UDim2.new(1,-24,0,dropH),
                Position=UDim2.new(0,12,0,46),
                BackgroundColor3=CurrentTheme.Btn, BorderSizePixel=0,
                ScrollBarThickness=3, ScrollBarImageColor3=CurrentTheme.Acc,
                CanvasSize=UDim2.new(0,0,0,#cfg.Options*itemH),
                Visible=false, ZIndex=20, Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(0,8), Parent=dropFrame})
            New("UIStroke", {Color=CurrentTheme.Brd, Thickness=1, Parent=dropFrame})
            New("UIListLayout", {Padding=UDim.new(0,0), Parent=dropFrame})

            local function UpdateCount()
                local c=0 for _ in pairs(selected) do c=c+1 end
                cntLbl.Text = c.." selected"
            end
            UpdateCount()

            local checkboxes = {}
            for _,opt in ipairs(cfg.Options) do
                local row = New("Frame", {
                    Size=UDim2.new(1,0,0,itemH), BackgroundTransparency=1, ZIndex=21, Parent=dropFrame,
                })
                New("TextLabel", {
                    Text="  "..opt, Font=Enum.Font.Gotham, TextSize=12,
                    TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                    Size=UDim2.new(1,-42,1,0), TextXAlignment=Enum.TextXAlignment.Left,
                    ZIndex=22, Parent=row,
                })
                local chkBg = New("Frame", {
                    Size=UDim2.fromOffset(20,20), Position=UDim2.new(1,-30,0.5,-10),
                    BackgroundColor3=selected[opt] and CurrentTheme.Acc or CurrentTheme.Brd,
                    BorderSizePixel=0, ZIndex=22, Parent=row,
                })
                New("UICorner", {CornerRadius=UDim.new(0,4), Parent=chkBg})
                local chk = New("TextLabel", {
                    Text="✓", Font=Enum.Font.GothamBold, TextSize=12,
                    TextColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=1,
                    Size=UDim2.fromScale(1,1), Visible=selected[opt]==true, ZIndex=23, Parent=chkBg,
                })
                checkboxes[opt] = {bg=chkBg, mark=chk}
                local rb = New("TextButton", {
                    Text="",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=24,Parent=row
                })
                rb.MouseButton1Click:Connect(function()
                    selected[opt] = not selected[opt]
                    chkBg.BackgroundColor3 = selected[opt] and CurrentTheme.Acc or CurrentTheme.Brd
                    chk.Visible = selected[opt]==true
                    UpdateCount()
                    local sel={}
                    for k,v in pairs(selected) do if v then table.insert(sel,k) end end
                    cfg.Callback(sel)
                end)
            end

            local hBtn = New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=5,Parent=header})
            hBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                dropFrame.Visible = isOpen
                if isOpen then
                    card.Size=UDim2.new(1,0,0,46+dropH+4); Tween(arrow,{Rotation=180},0.12)
                else
                    card.Size=UDim2.new(1,0,0,46); Tween(arrow,{Rotation=0},0.12)
                end
            end)

            if cfg.Flag then
                RegisteredElements[cfg.Flag]={
                    Type="MultiDropdown",
                    Get=function()
                        local sel={}
                        for k,v in pairs(selected) do if v then table.insert(sel,k) end end
                        return sel
                    end,
                    Set=function(v)
                        selected={}
                        for _,k in ipairs(v) do selected[k]=true end
                        for opt, cbs in pairs(checkboxes) do
                            cbs.bg.BackgroundColor3=selected[opt] and CurrentTheme.Acc or CurrentTheme.Brd
                            cbs.mark.Visible=selected[opt]==true
                        end
                        UpdateCount()
                    end,
                }
            end
            return {Get=function()
                local sel={}
                for k,v in pairs(selected) do if v then table.insert(sel,k) end end
                return sel
            end}
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 6: TEXTBOX
        -- ──────────────────────────────────────────────────────
        function Tab:AddTextBox(cfg)
            cfg = cfg or {}
            cfg.Name        = cfg.Name        or "TextBox"
            cfg.Placeholder = cfg.Placeholder or "Type here..."
            cfg.Default     = cfg.Default     or ""
            cfg.Callback    = cfg.Callback    or function() end

            local val  = cfg.Default
            local card = Card(72)

            New("TextLabel", {
                Text=cfg.Name, Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                Size=UDim2.new(1,0,0,22), Position=UDim2.fromOffset(12,6),
                TextXAlignment=Enum.TextXAlignment.Left, Parent=card,
            })
            local box = New("TextBox", {
                PlaceholderText=cfg.Placeholder, Text=val,
                Font=Enum.Font.Gotham, TextSize=13,
                TextColor3=CurrentTheme.Tx, PlaceholderColor3=CurrentTheme.Sub,
                BackgroundColor3=CurrentTheme.BG, BorderSizePixel=0,
                Size=UDim2.new(1,-24,0,32), Position=UDim2.fromOffset(12,32),
                ClearTextOnFocus=false, Parent=card,
            })
            New("UICorner",{CornerRadius=UDim.new(0,7), Parent=box})
            local bStroke = New("UIStroke", {Color=CurrentTheme.Brd, Thickness=1, Parent=box})
            New("UIPadding", {PaddingLeft=UDim.new(0,8), Parent=box})
            RegisterThemeProp(box,     "BackgroundColor3", "BG")
            RegisterThemeProp(box,     "TextColor3",       "Tx")
            RegisterThemeProp(bStroke, "Color",            "Brd")
            box.FocusLost:Connect(function() val=box.Text; cfg.Callback(val) end)

            if cfg.Flag then
                RegisteredElements[cfg.Flag]={
                    Type="TextBox",
                    Get=function() return val end,
                    Set=function(v) val=v; box.Text=v; cfg.Callback(v) end,
                }
            end
            return {Get=function() return val end}
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 7: LABEL
        -- ──────────────────────────────────────────────────────
        function Tab:AddLabel(cfg)
            cfg = cfg or {}
            cfg.Text = cfg.Text or "Label"
            local card = Card(34, true)
            card.BackgroundTransparency = 0.7
            New("TextLabel", {
                Text=cfg.Text, Font=Enum.Font.GothamSemibold, TextSize=12,
                TextColor3=CurrentTheme.Sub, BackgroundTransparency=1,
                Size=UDim2.fromScale(1,1), TextXAlignment=Enum.TextXAlignment.Left,
                Parent=card,
            })
            New("UIPadding", {PaddingLeft=UDim.new(0,12), Parent=card})
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 8: COLOR PICKER (RGB sliders)
        -- ──────────────────────────────────────────────────────
        function Tab:AddColorPicker(cfg)
            cfg = cfg or {}
            cfg.Name     = cfg.Name     or "Color Picker"
            cfg.Default  = cfg.Default  or Color3.fromRGB(0,200,100)
            cfg.Callback = cfg.Callback or function() end

            local r = math.floor(cfg.Default.R*255)
            local g = math.floor(cfg.Default.G*255)
            local b = math.floor(cfg.Default.B*255)
            local card = Card(136)

            New("TextLabel", {
                Text=cfg.Name, Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                Size=UDim2.new(0.7,0,0,24), Position=UDim2.fromOffset(12,4),
                TextXAlignment=Enum.TextXAlignment.Left, Parent=card,
            })
            local preview = New("Frame", {
                Size=UDim2.fromOffset(30,30), Position=UDim2.new(1,-44,0,4),
                BackgroundColor3=cfg.Default, BorderSizePixel=0, Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(0,6), Parent=preview})
            New("UIStroke", {Color=CurrentTheme.Brd, Thickness=1, Parent=preview})

            local labels  = {"R","G","B"}
            local getters = {function() return r end, function() return g end, function() return b end}
            local setters = {function(v) r=v end, function(v) g=v end, function(v) b=v end}
            local colors  = {Color3.fromRGB(220,60,60), Color3.fromRGB(60,200,60), Color3.fromRGB(60,100,220)}

            for i=1,3 do
                local y = 30 + (i-1)*32
                New("TextLabel", {
                    Text=labels[i], Font=Enum.Font.GothamBold, TextSize=11,
                    TextColor3=colors[i], BackgroundTransparency=1,
                    Size=UDim2.fromOffset(14,18), Position=UDim2.fromOffset(12,y+7), Parent=card,
                })
                local tBg = New("Frame", {
                    Size=UDim2.new(1,-60,0,6), Position=UDim2.fromOffset(28,y+11),
                    BackgroundColor3=CurrentTheme.Brd, BorderSizePixel=0, Parent=card,
                })
                New("UICorner", {CornerRadius=UDim.new(1,0), Parent=tBg})
                local fill = New("Frame", {
                    Size=UDim2.new(getters[i]()/255,0,1,0),
                    BackgroundColor3=colors[i], BorderSizePixel=0, Parent=tBg,
                })
                New("UICorner", {CornerRadius=UDim.new(1,0), Parent=fill})
                local vLbl = New("TextLabel", {
                    Text=tostring(getters[i]()), Font=Enum.Font.Gotham, TextSize=11,
                    TextColor3=CurrentTheme.Sub, BackgroundTransparency=1,
                    Size=UDim2.fromOffset(28,18), Position=UDim2.new(1,-30,0,y+7),
                    TextXAlignment=Enum.TextXAlignment.Right, Parent=card,
                })
                RegisterThemeProp(tBg,  "BackgroundColor3", "Brd")
                RegisterThemeProp(vLbl, "TextColor3",       "Sub")
                local dragging=false
                local sb=New("TextButton",{Text="",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=3,Parent=tBg})
                sb.InputBegan:Connect(function(inp)
                    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=true end
                end)
                local idx=i
                UserInputService.InputChanged:Connect(function(inp)
                    if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
                        local relX=math.clamp(inp.Position.X-tBg.AbsolutePosition.X,0,tBg.AbsoluteSize.X)
                        local pct=relX/tBg.AbsoluteSize.X
                        setters[idx](math.round(pct*255))
                        fill.Size=UDim2.new(pct,0,1,0)
                        vLbl.Text=tostring(getters[idx]())
                        preview.BackgroundColor3=Color3.fromRGB(r,g,b)
                        cfg.Callback(Color3.fromRGB(r,g,b))
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=false end
                end)
            end

            if cfg.Flag then
                RegisteredElements[cfg.Flag]={
                    Type="ColorPicker",
                    Get=function() return Color3.fromRGB(r,g,b) end,
                    Set=function(v)
                        r,g,b=math.floor(v.R*255),math.floor(v.G*255),math.floor(v.B*255)
                        preview.BackgroundColor3=v; cfg.Callback(v)
                    end,
                }
            end
            return {Get=function() return Color3.fromRGB(r,g,b) end}
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 9: KEYBIND
        -- ──────────────────────────────────────────────────────
        function Tab:AddKeybind(cfg)
            cfg = cfg or {}
            cfg.Name     = cfg.Name     or "Keybind"
            cfg.Default  = cfg.Default  or Enum.KeyCode.Unknown
            cfg.Callback = cfg.Callback or function() end

            local val       = cfg.Default
            local listening = false
            local card      = Card(48)

            New("TextLabel", {
                Text=cfg.Name, Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                Size=UDim2.new(0.55,0,1,0), Position=UDim2.fromOffset(12,0),
                TextXAlignment=Enum.TextXAlignment.Left, Parent=card,
            })
            local keyBtn = New("TextButton", {
                Text=val==Enum.KeyCode.Unknown and "[ None ]" or "[ "..val.Name.." ]",
                Font=Enum.Font.GothamSemibold, TextSize=12,
                TextColor3=CurrentTheme.Tx, BackgroundColor3=CurrentTheme.Btn, BorderSizePixel=0,
                Size=UDim2.fromOffset(90,28), Position=UDim2.new(1,-102,0.5,-14), Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(0,6), Parent=keyBtn})
            RegisterThemeProp(keyBtn, "BackgroundColor3", "Btn")
            RegisterThemeProp(keyBtn, "TextColor3",       "Tx")

            keyBtn.MouseButton1Click:Connect(function()
                listening=true; keyBtn.Text="[ ... ]"; keyBtn.TextColor3=CurrentTheme.Acc
            end)
            UserInputService.InputBegan:Connect(function(inp, gp)
                if listening and not gp and inp.UserInputType==Enum.UserInputType.Keyboard then
                    val=inp.KeyCode
                    keyBtn.Text="[ "..val.Name.." ]"
                    keyBtn.TextColor3=CurrentTheme.Tx; listening=false; cfg.Callback(val)
                end
            end)

            if cfg.Flag then
                RegisteredElements[cfg.Flag]={
                    Type="Keybind",
                    Get=function() return val end,
                    Set=function(v) val=v; keyBtn.Text="[ "..v.Name.." ]" end,
                }
            end
            return {Get=function() return val end}
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 10: SEPARATOR
        -- ──────────────────────────────────────────────────────
        function Tab:AddSeparator(cfg)
            cfg = cfg or {}
            cfg.Text = cfg.Text or ""
            local card = Card(24, true)
            card.BackgroundTransparency = 1
            if cfg.Text ~= "" then
                card.Size = UDim2.new(1,0,0,30)
                New("TextLabel", {
                    Text=cfg.Text, Font=Enum.Font.GothamSemibold, TextSize=11,
                    TextColor3=CurrentTheme.Sub, BackgroundTransparency=1,
                    Size=UDim2.fromScale(1,1), TextXAlignment=Enum.TextXAlignment.Center, Parent=card,
                })
            end
            New("Frame", {
                Size=UDim2.new(1,0,0,1), Position=UDim2.fromScale(0,0.5),
                BackgroundColor3=CurrentTheme.Brd, BorderSizePixel=0, Parent=card,
            })
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 11: PARAGRAPH
        -- ──────────────────────────────────────────────────────
        function Tab:AddParagraph(cfg)
            cfg = cfg or {}
            cfg.Title   = cfg.Title   or "Title"
            cfg.Content = cfg.Content or ""
            local card  = Card(72)
            New("TextLabel", {
                Text=cfg.Title, Font=Enum.Font.GothamBold, TextSize=13,
                TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                Size=UDim2.new(1,-24,0,22), Position=UDim2.fromOffset(12,6),
                TextXAlignment=Enum.TextXAlignment.Left, Parent=card,
            })
            New("TextLabel", {
                Text=cfg.Content, Font=Enum.Font.Gotham, TextSize=12,
                TextColor3=CurrentTheme.Sub, BackgroundTransparency=1,
                Size=UDim2.new(1,-24,0,38), Position=UDim2.fromOffset(12,28),
                TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top,
                TextWrapped=true, Parent=card,
            })
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 12: IMAGE BUTTON
        -- ──────────────────────────────────────────────────────
        function Tab:AddImageButton(cfg)
            cfg = cfg or {}
            cfg.Name     = cfg.Name     or "Image Button"
            cfg.ImageId  = cfg.ImageId  or ""
            cfg.Callback = cfg.Callback or function() end
            local card   = Card(52)
            if cfg.ImageId ~= "" then
                New("ImageLabel", {
                    Image="rbxassetid://"..cfg.ImageId,
                    Size=UDim2.fromOffset(32,32), Position=UDim2.fromOffset(12,10),
                    BackgroundTransparency=1, Parent=card,
                })
            end
            New("TextLabel", {
                Text=cfg.Name, Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                Size=UDim2.new(1,-120,1,0), Position=UDim2.fromOffset(cfg.ImageId~="" and 52 or 12,0),
                TextXAlignment=Enum.TextXAlignment.Left, Parent=card,
            })
            local btn = New("TextButton", {
                Text="▶  Run", Font=Enum.Font.GothamBold, TextSize=12,
                TextColor3=CurrentTheme.Acc, BackgroundColor3=CurrentTheme.Btn, BorderSizePixel=0,
                Size=UDim2.fromOffset(68,30), Position=UDim2.new(1,-80,0.5,-15), Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(0,8), Parent=btn})
            RegisterThemeProp(btn, "BackgroundColor3", "Btn")
            RegisterThemeProp(btn, "TextColor3",       "Acc")
            btn.MouseButton1Click:Connect(function()
                cfg.Callback()
                Tween(btn,{BackgroundColor3=CurrentTheme.Acc},0.08)
                task.delay(0.2, function() Tween(btn,{BackgroundColor3=CurrentTheme.Btn},0.12) end)
            end)
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 13: PROGRESS BAR
        -- ──────────────────────────────────────────────────────
        function Tab:AddProgressBar(cfg)
            cfg = cfg or {}
            cfg.Name  = cfg.Name  or "Progress"
            cfg.Value = cfg.Value or 0
            cfg.Max   = cfg.Max   or 100
            cfg.Color = cfg.Color or CurrentTheme.Acc
            local val = cfg.Value
            local card = Card(56)

            New("TextLabel", {
                Text=cfg.Name, Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                Size=UDim2.new(0.7,0,0,22), Position=UDim2.fromOffset(12,6),
                TextXAlignment=Enum.TextXAlignment.Left, Parent=card,
            })
            local pLbl = New("TextLabel", {
                Text=math.floor(val/cfg.Max*100).."%", Font=Enum.Font.GothamBold, TextSize=13,
                TextColor3=CurrentTheme.Acc, BackgroundTransparency=1,
                Size=UDim2.new(0.3,-12,0,22), Position=UDim2.new(0.7,0,0,6),
                TextXAlignment=Enum.TextXAlignment.Right, Parent=card,
            })
            local tBg = New("Frame", {
                Size=UDim2.new(1,-24,0,10), Position=UDim2.fromOffset(12,36),
                BackgroundColor3=CurrentTheme.Brd, BorderSizePixel=0, Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(1,0), Parent=tBg})
            local fill = New("Frame", {
                Size=UDim2.new(val/cfg.Max,0,1,0), BackgroundColor3=cfg.Color, BorderSizePixel=0, Parent=tBg,
            })
            New("UICorner", {CornerRadius=UDim.new(1,0), Parent=fill})
            RegisterThemeProp(tBg, "BackgroundColor3", "Brd")

            return {
                Set=function(v)
                    val=math.clamp(v,0,cfg.Max)
                    Tween(fill,{Size=UDim2.new(val/cfg.Max,0,1,0)},0.3)
                    pLbl.Text=math.floor(val/cfg.Max*100).."%"
                end,
                Get=function() return val end,
            }
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 14: NUMBER BOX (±)
        -- ──────────────────────────────────────────────────────
        function Tab:AddNumberBox(cfg)
            cfg = cfg or {}
            cfg.Name      = cfg.Name      or "Number"
            cfg.Min       = cfg.Min       or 0
            cfg.Max       = cfg.Max       or 999
            cfg.Default   = cfg.Default   or 0
            cfg.Increment = cfg.Increment or 1
            cfg.Callback  = cfg.Callback  or function() end
            local val     = cfg.Default
            local card    = Card(50)

            New("TextLabel", {
                Text=cfg.Name, Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=CurrentTheme.Tx, BackgroundTransparency=1,
                Size=UDim2.new(0.45,0,1,0), Position=UDim2.fromOffset(12,0),
                TextXAlignment=Enum.TextXAlignment.Left, Parent=card,
            })
            local minus = New("TextButton", {
                Text="−", Font=Enum.Font.GothamBold, TextSize=20,
                TextColor3=CurrentTheme.Tx, BackgroundColor3=CurrentTheme.Btn, BorderSizePixel=0,
                Size=UDim2.fromOffset(32,32), Position=UDim2.new(1,-120,0.5,-16), Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(0,7), Parent=minus})
            RegisterThemeProp(minus, "BackgroundColor3", "Btn")
            RegisterThemeProp(minus, "TextColor3",       "Tx")

            local numBox = New("TextBox", {
                Text=tostring(val), Font=Enum.Font.GothamBold, TextSize=14,
                TextColor3=CurrentTheme.Tx, BackgroundColor3=CurrentTheme.BG, BorderSizePixel=0,
                Size=UDim2.fromOffset(50,32), Position=UDim2.new(1,-84,0.5,-16),
                TextXAlignment=Enum.TextXAlignment.Center, Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(0,7), Parent=numBox})
            local nbStroke = New("UIStroke", {Color=CurrentTheme.Brd, Thickness=1, Parent=numBox})
            RegisterThemeProp(numBox,   "BackgroundColor3", "BG")
            RegisterThemeProp(numBox,   "TextColor3",       "Tx")
            RegisterThemeProp(nbStroke, "Color",            "Brd")

            local plus = New("TextButton", {
                Text="+", Font=Enum.Font.GothamBold, TextSize=20,
                TextColor3=CurrentTheme.Tx, BackgroundColor3=CurrentTheme.Btn, BorderSizePixel=0,
                Size=UDim2.fromOffset(32,32), Position=UDim2.new(1,-30,0.5,-16), Parent=card,
            })
            New("UICorner", {CornerRadius=UDim.new(0,7), Parent=plus})
            RegisterThemeProp(plus, "BackgroundColor3", "Btn")
            RegisterThemeProp(plus, "TextColor3",       "Tx")

            local function Update(v)
                val=math.clamp(math.round(v/cfg.Increment)*cfg.Increment, cfg.Min, cfg.Max)
                numBox.Text=tostring(val); cfg.Callback(val)
            end
            minus.MouseButton1Click:Connect(function() Update(val-cfg.Increment) end)
            plus.MouseButton1Click:Connect(function()  Update(val+cfg.Increment) end)
            numBox.FocusLost:Connect(function()
                local n=tonumber(numBox.Text)
                if n then Update(n) else numBox.Text=tostring(val) end
            end)

            if cfg.Flag then
                RegisteredElements[cfg.Flag]={Type="NumberBox",Get=function() return val end,Set=function(v) Update(v) end}
            end
            return {Get=function() return val end}
        end

        -- ──────────────────────────────────────────────────────
        --  ELEMENT 15: SECTION HEADER
        -- ──────────────────────────────────────────────────────
        function Tab:AddSection(cfg)
            cfg = cfg or {}
            cfg.Name = cfg.Name or "Section"
            local card = Card(30, true)
            card.BackgroundColor3 = CurrentTheme.Side
            card.BackgroundTransparency = LibConfig.Transparency and 0.55 or 0.2
            RegisterThemeProp(card, "BackgroundColor3", "Side")
            New("TextLabel", {
                Text="  "..cfg.Name:upper(), Font=Enum.Font.GothamBold, TextSize=11,
                TextColor3=CurrentTheme.Acc, BackgroundTransparency=1,
                Size=UDim2.fromScale(1,1), TextXAlignment=Enum.TextXAlignment.Left, Parent=card,
            })
        end

        return Tab
    end

    -- ══════════════════════════════════════════════════════════
    --  WIN:ADDCONFIG()
    --  CORREÇÃO: o dropdown de tema chama ApplyTheme() em tempo real
    -- ══════════════════════════════════════════════════════════
    function Win:AddConfig()
        local cfgTab = self:AddTab("⚙ Config")

        cfgTab:AddSection({Name="Appearance"})

        -- Transparência
        cfgTab:AddToggle({
            Name    = "UI Transparency (60%)",
            Default = LibConfig.Transparency,
            Callback = function(v)
                LibConfig.Transparency = v
                local tr = v and 0.4 or 0
                if _MainFrame  then _MainFrame.BackgroundTransparency  = tr end
                if _Sidebar    then _Sidebar.BackgroundTransparency    = tr end
                if _ToggleBtn  then _ToggleBtn.BackgroundTransparency  = tr end
            end,
        })

        -- ── DROPDOWN DE TEMA (aplica imediatamente) ───────────
        cfgTab:AddDropdown({
            Name    = "Theme",
            Options = ThemeNames,
            Default = LibConfig.Theme,
            Callback = function(themeName)
                ApplyTheme(themeName)

                -- Atualiza transparency do fundo (depende do tema/BG)
                local tr = LibConfig.Transparency and 0.4 or 0
                if _MainFrame then
                    _MainFrame.BackgroundTransparency = tr
                end
                if _Sidebar then
                    _Sidebar.BackgroundTransparency = tr
                end
                if _ToggleBtn then
                    _ToggleBtn.BackgroundTransparency = tr
                end

                -- Atualiza ScrollBars
                local T = CurrentTheme
                if SideList then SideList.ScrollBarImageColor3 = T.Acc end
            end,
        })

        cfgTab:AddSection({Name="Save & Load"})

        cfgTab:AddTextBox({
            Name        = "Save Name",
            Placeholder = "MySave",
            Default     = LibConfig.SaveName,
            Callback    = function(v) LibConfig.SaveName = v end,
        })

        cfgTab:AddButton({
            Name = "💾  Save Current State",
            Callback = function()
                local data = {}
                for flag, el in pairs(RegisteredElements) do
                    local ok, v = pcall(el.Get)
                    if ok then data[flag] = v end
                end
                data["__LibConfig"] = {
                    Theme        = LibConfig.Theme,
                    Transparency = LibConfig.Transparency,
                    SaveName     = LibConfig.SaveName,
                    AutoLoad     = LibConfig.AutoLoad,
                    AutoLoadSave = LibConfig.AutoLoadSave,
                }
                SaveData(LibConfig.SaveName, data)
            end,
        })

        local selectedLoad = ""
        cfgTab:AddDropdown({
            Name    = "Select Save",
            Options = GetSaves(),
            Default = "",
            Callback = function(v) selectedLoad = v end,
        })

        cfgTab:AddButton({
            Name = "📂  Load Selected Save",
            Callback = function()
                if selectedLoad == "" then return end
                local data = LoadData(selectedLoad)
                if not data then return end
                for flag, val in pairs(data) do
                    if flag ~= "__LibConfig" and RegisteredElements[flag] then
                        pcall(RegisteredElements[flag].Set, val)
                    end
                end
                if data["__LibConfig"] then
                    local lc = data["__LibConfig"]
                    LibConfig.Theme        = lc.Theme        or LibConfig.Theme
                    LibConfig.Transparency = lc.Transparency or false
                    LibConfig.SaveName     = lc.SaveName     or LibConfig.SaveName
                    LibConfig.AutoLoad     = lc.AutoLoad     or false
                    LibConfig.AutoLoadSave = lc.AutoLoadSave or ""
                    ApplyTheme(LibConfig.Theme)
                end
            end,
        })

        cfgTab:AddSection({Name="Auto Load"})

        cfgTab:AddDropdown({
            Name    = "Auto Load Save",
            Options = GetSaves(),
            Default = LibConfig.AutoLoadSave,
            Callback = function(v) LibConfig.AutoLoadSave = v end,
        })

        cfgTab:AddToggle({
            Name    = "Enable Auto Load",
            Default = LibConfig.AutoLoad,
            Callback = function(v)
                LibConfig.AutoLoad = v
                if v and LibConfig.AutoLoadSave ~= "" then
                    local data = LoadData(LibConfig.AutoLoadSave)
                    if data then
                        for flag, val in pairs(data) do
                            if flag ~= "__LibConfig" and RegisteredElements[flag] then
                                pcall(RegisteredElements[flag].Set, val)
                            end
                        end
                    end
                end
            end,
        })
    end

    -- Auto-load na inicialização
    task.defer(function()
        if LibConfig.AutoLoad and LibConfig.AutoLoadSave ~= "" then
            local data = LoadData(LibConfig.AutoLoadSave)
            if data then
                for flag, val in pairs(data) do
                    if flag ~= "__LibConfig" and RegisteredElements[flag] then
                        pcall(RegisteredElements[flag].Set, val)
                    end
                end
            end
        end
    end)

    return Win
end

return NeonHub

-- ══════════════════════════════════════════════════════════════
--  EXEMPLO DE USO COMPLETO
-- ══════════════════════════════════════════════════════════════
--[[

local NeonHub = loadstring(game:HttpGet("SUA_URL_AQUI"))()

-- ─── 1. Key System ───────────────────────────────────────────
-- Os parâmetros Minimize_button_image_id e UI_Library_Fund
-- devem ser passados aqui, no KeySystem.
local passed = NeonHub:KeySystem({
    Text         = "Key System",
    KeySystem    = true,
    Key          = "123",
    AutoSaveKey  = true,
    KeyJson      = "Key_NeonHub.json",
    GetKeyBySite = false,
    KeySite      = "",

    -- ID da imagem do botão de minimizar/abrir (deixe "" para ícone padrão ☰)
    Minimize_button_image_id = (""),   -- ex: ("7733960981")

    -- ID da imagem de fundo da UI (deixe "" para sem imagem)
    UI_Library_Fund = (""),            -- ex: ("12345678")
})
if not passed then return end

-- ─── 2. Loading Screen ───────────────────────────────────────
NeonHub:LoadingScreen({
    LoadingText = "Welcome Back!",
    Duration    = 5,
})

-- ─── 3. Window ───────────────────────────────────────────────
local Win = NeonHub:CreateWindow({
    Name     = "NeonHub",
    SubTitle = "by .ftgs",
})

-- ─── 4. Main Tab ─────────────────────────────────────────────
local Main = Win:AddTab("Main", "🏠")

Main:AddSection({Name = "Aimbot"})

Main:AddToggle({
    Name="Silent Aim", Default=false, Flag="SilentAim",
    Callback=function(v) print("Silent Aim:", v) end,
})

Main:AddSlider({
    Name="FOV Size", Min=1, Max=360, Default=90, Increment=1, Suffix="°", Flag="AimFOV",
    Callback=function(v) print("FOV:", v) end,
})

Main:AddSection({Name = "Visuals"})

Main:AddColorPicker({
    Name="ESP Color", Default=Color3.fromRGB(0,200,100), Flag="ESPColor",
    Callback=function(c) print("Color:", c) end,
})

Main:AddDropdown({
    Name="Bone Priority",
    Options={"Head","Neck","Chest","Waist","Left Arm","Right Arm","Left Leg","Right Leg"},
    Default="Head", Flag="BonePriority",
    Callback=function(v) print("Bone:", v) end,
})

Main:AddMultiDropdown({
    Name="ESP Parts",
    Options={"Box","Tracer","Name","Healthbar","Distance","Skeleton"},
    Default={"Box","Name"}, Flag="ESPParts",
    Callback=function(sel) print("Parts:", table.concat(sel,", ")) end,
})

-- ─── 5. Misc Tab ─────────────────────────────────────────────
local Misc = Win:AddTab("Misc", "⚡")

Misc:AddSection({Name = "Movement"})

Misc:AddSlider({
    Name="Walk Speed", Min=16, Max=250, Default=16, Flag="WalkSpeed",
    Callback=function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=v end,
})

Misc:AddSlider({
    Name="Jump Power", Min=50, Max=500, Default=50, Flag="JumpPower",
    Callback=function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower=v end,
})

Misc:AddSection({Name = "Tools"})

Misc:AddButton({
    Name="Teleport to Spawn",
    Callback=function()
        local spawn=workspace:FindFirstChild("SpawnLocation")
        if spawn then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=spawn.CFrame+Vector3.new(0,5,0) end
    end,
})

Misc:AddImageButton({
    Name="Copy Player ID", ImageId="",
    Callback=function() setclipboard(tostring(game.Players.LocalPlayer.UserId)) end,
})

Misc:AddKeybind({
    Name="Toggle UI Hotkey", Default=Enum.KeyCode.RightShift, Flag="UIHotkey",
    Callback=function(key) print("Hotkey set:", key.Name) end,
})

Misc:AddNumberBox({
    Name="Gravity", Min=0, Max=500, Default=196, Increment=1, Flag="Gravity",
    Callback=function(v) workspace.Gravity=v end,
})

Misc:AddTextBox({
    Name="Player Name Filter", Placeholder="Username...", Flag="NameFilter",
    Callback=function(v) print("Filter:", v) end,
})

Misc:AddParagraph({
    Title  = "NeonHub Info",
    Content= "Version 2.1 | Mobile Optimized | 20 Themes | 15 Elements",
})

local prog = Misc:AddProgressBar({
    Name="Server Health", Value=75, Max=100, Color=Color3.fromRGB(0,200,100),
})

Misc:AddLabel({Text="◉  All systems operational"})

Misc:AddSeparator({Text="──── End ────"})

-- ─── 6. Config Tab (built-in) ────────────────────────────────
Win:AddConfig()

--]]
