local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game:GetService("Players").LocalPlayer

local Losses = 0
local CurrentScore = 0

-- Очистка старых версий
local old = game:GetService("CoreGui"):FindFirstChild("BB_Final_Pro") or Player:WaitForChild("PlayerGui"):FindFirstChild("BB_Final_Pro")
if old then old:Destroy() end

local SG = Instance.new("ScreenGui", game:GetService("CoreGui"))
SG.Name = "BB_Final_Pro"

-- Звук отскока (надежный ID)
local HitSound = Instance.new("Sound", game:GetService("SoundService"))
HitSound.SoundId = "rbxassetid://130706003"
HitSound.Volume = 1

-- Функция перетаскивания меню
local function MakeDraggable(f)
    local d, s, sp
    f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; s = i.Position; sp = f.Position end end)
    UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - s; f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
    f.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
end

-- ГЛАВНОЕ МЕНЮ
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 250, 0, 180); Main.Position = UDim2.new(0.5, -125, 0.5, -90); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Main)
MakeDraggable(Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "BB BALL HUB [Y]"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1

local LossLabel = Instance.new("TextLabel", Main)
LossLabel.Size = UDim2.new(1, 0, 0, 30); LossLabel.Position = UDim2.new(0, 0, 0, 45); LossLabel.Text = "ПРОИГРЫШИ: 0"; LossLabel.TextColor3 = Color3.fromRGB(255, 60, 60); LossLabel.BackgroundTransparency = 1

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -35, 0, 5); MinBtn.Text = "-"; MinBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); MinBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1,0)

local PlayBtn = Instance.new("TextButton", Main)
PlayBtn.Size = UDim2.new(0, 150, 0, 45); PlayBtn.Position = UDim2.new(0.5, -75, 0.65, 0); PlayBtn.Text = "ИГРАТЬ"; PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0); PlayBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", PlayBtn)

-- КНОПКА Y
local FlyY = Instance.new("TextButton", SG)
FlyY.Size = UDim2.new(0, 45, 0, 45); FlyY.Position = UDim2.new(0, 10, 0.5, 0); FlyY.Text = "Y"; FlyY.Visible = false; FlyY.BackgroundColor3 = Color3.fromRGB(255, 160, 0); Instance.new("UICorner", FlyY).CornerRadius = UDim.new(1,0); MakeDraggable(FlyY)

local function toggle() Main.Visible = not Main.Visible; FlyY.Visible = not Main.Visible end
MinBtn.MouseButton1Click:Connect(toggle); FlyY.MouseButton1Click:Connect(toggle)
UIS.InputBegan:Connect(function(k) if k.KeyCode == Enum.KeyCode.Y then toggle() end end)

-- ИГРА
PlayBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    CurrentScore = 0
    
    local Char = Player.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then Char.HumanoidRootPart.Anchored = true end

    local C = Instance.new("Frame", SG); C.Size = UDim2.new(1,0,1,0); C.BackgroundColor3 = Color3.new(0,0,0); C.ZIndex = 2000; C.Active = true

    local UI_Score = Instance.new("TextLabel", C); UI_Score.Size = UDim2.new(1,0,0,100); UI_Score.Text = "ОЧКИ: 0 | ПРОИГРЫШИ: "..Losses; UI_Score.TextColor3 = Color3.new(1,1,1); UI_Score.BackgroundTransparency = 1; UI_Score.TextSize = 25; UI_Score.ZIndex = 2010

    local Exit = Instance.new("TextButton", C); Exit.Size = UDim2.new(0,100,0,40); Exit.Position = UDim2.new(0.5,-50,0.9,0); Exit.Text = "ВЫХОД"; Exit.ZIndex = 2010; 
    Exit.MouseButton1Click:Connect(function() 
        C:Destroy(); Main.Visible = true; 
        if Char and Char:FindFirstChild("HumanoidRootPart") then Char.HumanoidRootPart.Anchored = false end 
    end)

    local P = Instance.new("Frame", C); P.Size = UDim2.new(0,160,0,25); P.Position = UDim2.new(0.5,-80,0.85,0); P.BackgroundColor3 = Color3.new(1,1,1); P.ZIndex = 2010; Instance.new("UICorner", P)
    local B = Instance.new("Frame", C); B.Size = UDim2.new(0,22,0,22); B.BackgroundColor3 = Color3.fromRGB(255, 255, 0); B.Position = UDim2.new(0.5,0,0.5,0); B.ZIndex = 2010; Instance.new("UICorner", B).CornerRadius = UDim.new(1,0)

    local vel = Vector2.new(16, -16)
    local r = RunService.RenderStepped:Connect(function()
        if not C.Parent then return end
        
        -- Управление
        if UIS:IsKeyDown(Enum.KeyCode.A) then 
            P.Position = P.Position + UDim2.new(0, -22, 0, 0) 
        elseif UIS:IsKeyDown(Enum.KeyCode.D) then 
            P.Position = P.Position + UDim2.new(0, 22, 0, 0) 
        else
            P.Position = UDim2.new(0, UIS:GetMouseLocation().X - 80, 0.85, 0)
        end

        -- Границы ракетки
        if P.AbsolutePosition.X < 0 then P.Position = UDim2.new(0,0,0.85,0) end
        if P.AbsolutePosition.X > C.AbsoluteSize.X - 160 then P.Position = UDim2.new(0, C.AbsoluteSize.X - 160, 0.85, 0) end

        B.Position = B.Position + UDim2.new(0, vel.X, 0, vel.Y)
        
        -- Стенки
        if B.AbsolutePosition.X < 0 or B.AbsolutePosition.X > C.AbsoluteSize.X-22 then vel = Vector2.new(-vel.X, vel.Y) end
        if B.AbsolutePosition.Y < 0 then vel = Vector2.new(vel.X, -vel.Y) end
        
        -- Ракетка
        if B.AbsolutePosition.Y >= P.AbsolutePosition.Y-22 and 
           B.AbsolutePosition.X > P.AbsolutePosition.X - 10 and 
           B.AbsolutePosition.X < P.AbsolutePosition.X + 170 then
            vel = Vector2.new(vel.X, -math.abs(vel.Y))
            CurrentScore = CurrentScore + 1
            UI_Score.Text = "ОЧКИ: "..CurrentScore.." | ПРОИГРЫШИ: "..Losses
            HitSound:Play()
        end
        
        -- Проигрыш
        if B.AbsolutePosition.Y > C.AbsoluteSize.Y then
            Losses = Losses + 1; CurrentScore = 0
            B.Position = UDim2.new(0.5, 0, 0.5, 0); vel = Vector2.new(16, -16)
            LossLabel.Text = "ПРОИГРЫШИ: "..Losses; UI_Score.Text = "ОЧКИ: 0 | ПРОИГРЫШИ: "..Losses
        end
    end)
    C.Destroying:Connect(function() r:Disconnect() end)
end)
