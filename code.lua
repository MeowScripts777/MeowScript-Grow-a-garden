local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()
local Window = Library.CreateLib("MeowScript", "RJTheme7")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local radius = 5
local speed = 0.1
local center = hrp.Position
local angle = 0

local farmON = false
local SellON = false
local AFKON = false

local TabFarm = Window:NewTab("Автофарм")
local SectionFarm = TabFarm:NewSection("Автофарм")

SectionFarm:NewButton("Включить/Выключить", "Собирает только редкие мутации.", function()
    farmON = not farmON
    print("Автофарм:", farmON)
    if farmON then
        task.spawn(function()
            local attrs = {"Celestial", "Shocked", "Rainbow", "Moonlit", "Bloodlit"}
            while farmON do
                for _, plot in ipairs(workspace.Farm:GetChildren()) do
                    local ownerData = plot:FindFirstChild("Important") and plot.Important:FindFirstChild("Data")
                    if ownerData and plot.Important.Data.Owner.Value == player.Name then
                        for _, plant in ipairs(plot.Important.Plants_Physical:GetChildren()) do
                            for _, fruitGroup in ipairs(plant:GetChildren()) do
                                for _, fruit in ipairs(fruitGroup:GetChildren()) do
                                    for _, attr in ipairs(attrs) do
                                        if fruit:GetAttribute(attr) then
                                            local part = fruit:FindFirstChildWhichIsA("BasePart", true)
                                            if part then
                                                hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                                                task.wait(0.1)
                                                for _, prompt in ipairs(fruit:GetDescendants()) do
                                                    if prompt:IsA("ProximityPrompt") then
                                                        fireproximityprompt(prompt)
                                                        task.wait(0.1)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end)

local TabSell = Window:NewTab("Автопродажа")
local SectionSell = TabSell:NewSection("Автопродажа")

SectionSell:NewButton("Включить/Выключить", "Автопродажа фруктов каждые 10 минут.", function()
    SellON = not SellON
    print("Автопродажа: ", SellON)
    if SellON then
        task.spawn(function()
            while SellON do
                hrp.CFrame = CFrame.new(63, 3, -0.27) * CFrame.Angles(0, math.rad(10), 0)
                game:GetService("ReplicatedStorage").GameEvents.Sell_Inventory:FireServer()
                task.wait(0.2)
                game:GetService("ReplicatedStorage").GameEvents.Sell_Inventory:FireServer()
                task.wait(600)
            end
        end)
    end
end)

local TabAFK = Window:NewTab("АнтиАФК")
local SectionAFK = TabAFK:NewSection("АнтиАФК")

SectionAFK:NewButton("Включить/Выключить", "Обязателен для всего!", function()
    AFKON = not AFKON
    print("АнтиАФК ", AFKON)
    if AFKON then
        task.spawn(function()
            local pointsCount = 36
            local step = (2 * math.pi) / pointsCount
            local currentPoint = 1
            local points = {}

            for i = 1, pointsCount do
                local ang = step * i
                table.insert(points, center + Vector3.new(math.cos(ang) * radius, 0, math.sin(ang) * radius))
            end

            while AFKON do
                humanoid:MoveTo(points[currentPoint])
                humanoid.MoveToFinished:Wait()
                currentPoint = currentPoint + 1
                if currentPoint > pointsCount then
                    currentPoint = 1
					task.wait(60)
                end
            end
        end)
    end
end)
