local UI = loadstring(game:HttpGetAsync("https://pastebin.com/raw/QAwr1iuM"))()
local Window = UI:Window("TaxiBoss")
UI:Notification("Scrpt By:", "VertigoCool#1636", "Okay!")
local FarmingTab = Window:Tab("Farming")
FarmingTab:Toggle("Autofarm", false, function(arg)
	getgenv().Autofarm = arg
	local old = game:GetService("Players").LocalPlayer.variables.inMission.Value
	game:GetService("Players").LocalPlayer.variables.inMission.Value = not old
	game:GetService("Players").LocalPlayer.variables.inMission.Value = old
end)
FarmingTab:Slider("Speed", 50, 200, 135, function(arg)
	getgenv().CarSettings.speed = arg
end)
FarmingTab:Slider("Distance", 100, 5000, 1000, function(arg)
	getgenv().Mag = arg
end)

game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
	prompt.HoldDuration = 0
end)

getgenv().CarSettings = {
    speed = 135
}

if getgenv().Mag == 0 or getgenv().Mag == nil then
	getgenv().Mag = 1000
end

function GetCar()
	for i,v in pairs(game:GetService("Workspace").Vehicles:GetDescendants()) do
		if v.ClassName == "ObjectValue" and v.Name == "Player" and v.Value == game.Players.LocalPlayer then
			return v.Parent.Parent
		end
	end
end

function GetCustomerCframe()
	if game:GetService("Players").LocalPlayer.variables.inMission.Value == false then
		for i,v in pairs(game:GetService("Workspace").NewCustomers:GetDescendants()) do
			if v.Name == "PromptPart" then
				if (GetCar().PrimaryPart.Position - v.Position).Magnitude <= getgenv().Mag then
					Big = tonumber(GetCar().FAKE.PLATE.SurfaceGui.Rating.Text)
					if v.Name == "PromptPart" and tonumber(v.Rating.Frame.Rating.Text) <= tonumber(GetCar().FAKE.PLATE.SurfaceGui.Rating.Text) then
						if tonumber(v.Rating.Frame.Rating.Text) > Big then
							Big = tonumber(v.Rating.Frame.Rating.Text)
						end
						return v.CFrame
					end
				end
			end
		end
	end
end

function GetCustomer()
	if GetCustomerCframe() == nil then
			if game:GetService("Players").LocalPlayer.variables.inMission.Value == false then
		for i,v in pairs(game:GetService("Workspace").NewCustomers:GetDescendants()) do
			if v.Name == "PromptPart" then
				if (GetCar().PrimaryPart.Position - v.Position).Magnitude <= getgenv().Mag then
					Big = tonumber(GetCar().FAKE.PLATE.SurfaceGui.Rating.Text)
					if v.Name == "PromptPart" and tonumber(v.Rating.Frame.Rating.Text) <= tonumber(GetCar().FAKE.PLATE.SurfaceGui.Rating.Text) then
						if tonumber(v.Rating.Frame.Rating.Text) > Big then
							Big = tonumber(v.Rating.Frame.Rating.Text)
						end
						b = v.CFrame
					end
				end
			end
		end
	end
	else
	local CusCF = GetCustomerCframe() or b
	local goal = CusCF + Vector3.new(math.random(0, 1.5),0,math.random(0, 1.5))
	local Car = GetCar() 
    Car:SetPrimaryPartCFrame(goal)
	task.wait(.15)
	local virtualUser = game:GetService('VirtualUser')
	virtualUser:CaptureController()
	virtualUser:SetKeyDown('0x72')
	wait(.1)
	virtualUser:SetKeyUp('0x72')
	end
end

function GotoDestination()
	wait(.45)
	local goal = game:GetService("Workspace").ParkingMarkers.destinationPart.CFrame + Vector3.new(math.random(0, 1.2), 0, math.random(0, 1.2))
	local Car = GetCar() 

	local CFrameValue = Instance.new("CFrameValue")
	CFrameValue.Value = Car:GetPrimaryPartCFrame()

	CFrameValue:GetPropertyChangedSignal("Value"):connect(function()
        Car:SetPrimaryPartCFrame(CFrameValue.Value)
    end)

	local dist = (Car.PrimaryPart.Position - goal.Position).Magnitude
	getgenv().CarSettings.tweenspeed = dist/tonumber(getgenv().CarSettings.speed)
	local info = TweenInfo.new(getgenv().CarSettings.tweenspeed, Enum.EasingStyle.Linear)
	local info2 = TweenInfo.new(.25, Enum.EasingStyle.Linear)
	local tween = game:GetService("TweenService"):Create(CFrameValue, info, {Value = goal})
    tween:Play()
	local tween2 = game:GetService("TweenService"):Create(CFrameValue, info2, {Value = goal})
	tween.Completed:connect(function()
		wait(.15)
		tween2:Play()
	end)
	tween2.Completed:connect(function()
		CFrameValue:Destroy()
	end)
end

game:GetService("Players").LocalPlayer.variables.inMission:GetPropertyChangedSignal("Value"):Connect(function()
	if getgenv().Autofarm == true then
		if game:GetService("Players").LocalPlayer.variables.inMission.Value == false then
			wait(.1)
			GetCustomer()
			wait(2)
			GotoDestination()
		end
	end
end)
