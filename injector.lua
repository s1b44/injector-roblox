local LogService = game:GetService("LogService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LogScrolling = Instance.new("ScrollingFrame")
local EditorScrolling = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")
local ScriptEditor = Instance.new("TextBox")
local ExecuteBtn = Instance.new("TextButton")
local ClearBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton") -- Кнопка -
local OpenBtn = Instance.new("TextButton") -- Кнопка L

-- Настройка GUI
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
ScreenGui.Name = "Loodik_Injector_V2"
ScreenGui.ResetOnSpawn = false

local function round(obj, px)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, px or 8)
    c.Parent = obj
end

-- --- КНОПКА L (Плавающая) ---
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Text = "L"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.TextSize = 25
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true -- Можно таскать кнопку L
round(OpenBtn, 25)

-- Главное окно
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 700, 0, 520)
MainFrame.Active = true
MainFrame.Draggable = true -- Можно таскать инжектор
round(MainFrame)

-- Заголовок
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -80, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "   Mini injector by Loodik"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
round(Title)

-- Кнопка закрыть (X)
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -38, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
round(CloseBtn)

-- Кнопка сворачивания (-)
MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -76, 0, 2)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
MinimizeBtn.TextSize = 25
round(MinimizeBtn)

-- Логика кнопок
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Консоль
LogScrolling.Parent = MainFrame
LogScrolling.Position = UDim2.new(0, 10, 0, 50)
LogScrolling.Size = UDim2.new(1, -20, 0, 200)
LogScrolling.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LogScrolling.ScrollBarThickness = 4
round(LogScrolling, 5)

UIListLayout.Parent = LogScrolling
UIListLayout.Padding = UDim.new(0, 2)

local function log(msg, mType)
    local color = Color3.new(0.8, 0.8, 0.8)
    if mType == Enum.MessageType.MessageError then color = Color3.new(1, 0.3, 0.3) end
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -10, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = " [" .. os.date("%X") .. "] " .. tostring(msg)
    l.TextColor3 = color
    l.Font = Enum.Font.Code
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = LogScrolling
    LogScrolling.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

for _, d in pairs(LogService:GetLogHistory()) do log(d.message, d.messageType) end
LogService.MessageOut:Connect(function(m, t) log(m, t) end)

-- Редактор
EditorScrolling.Parent = MainFrame
EditorScrolling.Position = UDim2.new(0, 10, 0, 260)
EditorScrolling.Size = UDim2.new(1, -20, 0, 190)
EditorScrolling.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
round(EditorScrolling, 5)

ScriptEditor.Parent = EditorScrolling
ScriptEditor.Size = UDim2.new(1, 0, 1, 0)
ScriptEditor.AutomaticSize = Enum.AutomaticSize.Y
ScriptEditor.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ScriptEditor.TextColor3 = Color3.fromRGB(150, 255, 150)
ScriptEditor.Text = ""
ScriptEditor.MultiLine = true
ScriptEditor.ClearTextOnFocus = false
ScriptEditor.Font = Enum.Font.Code
ScriptEditor.TextXAlignment = Enum.TextXAlignment.Left
ScriptEditor.TextYAlignment = Enum.TextYAlignment.Top

ScriptEditor:GetPropertyChangedSignal("TextBounds"):Connect(function()
    EditorScrolling.CanvasSize = UDim2.new(0, 0, 0, ScriptEditor.TextBounds.Y + 20)
end)

-- Execute / Clear
ExecuteBtn.Parent = MainFrame
ExecuteBtn.Position = UDim2.new(0, 10, 0, 460)
ExecuteBtn.Size = UDim2.new(0, 335, 0, 50)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(45, 100, 45)
ExecuteBtn.Text = "EXECUTE"
ExecuteBtn.TextColor3 = Color3.new(1, 1, 1)
round(ExecuteBtn)

ClearBtn.Parent = MainFrame
ClearBtn.Position = UDim2.new(0, 355, 0, 460)
ClearBtn.Size = UDim2.new(0, 335, 0, 50)
ClearBtn.BackgroundColor3 = Color3.fromRGB(100, 45, 45)
ClearBtn.Text = "CLEAR ALL"
ClearBtn.TextColor3 = Color3.new(1, 1, 1)
round(ClearBtn)

ExecuteBtn.MouseButton1Click:Connect(function()
    local code = ScriptEditor.Text
    if code ~= "" then
        local success, err = pcall(function() loadstring(code)() end)
        if not success then log("ERROR: " .. err, Enum.MessageType.MessageError) end
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    ScriptEditor.Text = ""
    for _, v in pairs(LogScrolling:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
end)
