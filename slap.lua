-- Tải thư viện Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Biến điều khiển
local BringAllEnabled = false
local SlashMode = "Normal"
local TargetInputName = ""
local TrollTargetEnabled = false

-- Biến cho Super Knockback & Anti Slap
local SuperKnockbackEnabled = false
local AntiSlapEnabled = false
local KnockbackPower = 100000 -- Lực văng mặc định

local function FindPlayerModel(query)
	if not query or query == "" then return nil end
	query = string.lower(query)
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local name = string.lower(player.Name)
			local displayName = string.lower(player.DisplayName)
			if string.find(name, query, 1, true) or string.find(displayName, query, 1, true) then
				if player.Character and player.Character.Parent == workspace then
					return player.Character
				end
			end
		end
	end
	return nil
end

local function GetSlashVector(customPower)
	local p = customPower or KnockbackPower
	if SlashMode == "Fling" then
		return Vector3.new(math.random(-p, p), p * 1.5, math.random(-p, p))
	elseif SlashMode == "Orbit" then
		local t = tick() * 12
		return Vector3.new(math.cos(t) * 15, 5, math.sin(t) * 15)
	else
		return Vector3.new(4.3126339912415, -5.1616577678715e-08, -2.530056476593)
	end
end

-- Khởi tạo Cửa sổ Menu
local Window = Rayfield:CreateWindow({
   Name = "wallhop slap tower",
   LoadingTitle = "wallhop slap tower Interface",
   LoadingSubtitle = "by kobtgihetaok",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- ==========================================
-- TAB 1: MAIN
-- ==========================================
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateDropdown({
   Name = "Chế độ Slash Vector",
   Options = {"Normal", "Fling", "Orbit"},
   CurrentOption = {"Normal"},
   MultipleOptions = false,
   Flag = "SlashModeDropdown",
   Callback = function(Option)
      SlashMode = Option[1]
   end,
})

MainTab:CreateToggle({
   Name = "Bring / Slash All Players (Lặp liên tục)",
   CurrentValue = false,
   Flag = "BringAllToggle",
   Callback = function(Value)
      BringAllEnabled = Value
      
      if BringAllEnabled then
         task.spawn(function()
            while BringAllEnabled do
               local backpack = LocalPlayer:FindFirstChild("Backpack")
               local character = LocalPlayer.Character
               local slapTool = (backpack and backpack:FindFirstChild("Slap")) or (character and character:FindFirstChild("Slap"))
               
               if slapTool and slapTool:FindFirstChild("Event") then
                  for _, v in pairs(Players:GetPlayers()) do
                     if v ~= LocalPlayer and v.Character then
                        slapTool.Event:FireServer("slash", v.Character, GetSlashVector())
                     end
                  end
               end
               task.wait(0.05)
            end
         end)
      end
   end,
})

-- NÚT FLING ALL PLAYER 1 LẦN (KHÔNG LẶP)
MainTab:CreateButton({
   Name = "Fling All Players (Bấm 1 Lần)",
   Callback = function()
      local backpack = LocalPlayer:FindFirstChild("Backpack")
      local character = LocalPlayer.Character
      local slapTool = (backpack and backpack:FindFirstChild("Slap")) or (character and character:FindFirstChild("Slap"))
      
      if slapTool and slapTool:FindFirstChild("Event") then
         for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
               local flingVector = Vector3.new(math.random(-999999, 999999), 999999, math.random(-999999, 999999))
               slapTool.Event:FireServer("slash", v.Character, flingVector)
            end
         end
         Rayfield:Notify({ Title = "Fling All", Content = "Đã Fling tất cả người chơi 1 lần!", Duration = 2 })
      else
         Rayfield:Notify({ Title = "Lỗi", Content = "Không tìm thấy Tool Slap!", Duration = 2 })
      end
   end,
})

-- ==========================================
-- TAB 2: TROLL
-- ==========================================
local TrollTab = Window:CreateTab("Troll", 4483362458)

TrollTab:CreateSection("Target Player")

TrollTab:CreateInput({
   Name = "Nhập tên Player Target",
   PlaceholderText = "Ví dụ: toi, vn, alex...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      TargetInputName = Text
   end,
})

TrollTab:CreateToggle({
   Name = "Troll Target Player",
   CurrentValue = false,
   Flag = "TrollTargetToggle",
   Callback = function(Value)
      TrollTargetEnabled = Value
      
      if TrollTargetEnabled then
         task.spawn(function()
            while TrollTargetEnabled do
               local targetCharacter = FindPlayerModel(TargetInputName)
               
               if targetCharacter then
                  local backpack = LocalPlayer:FindFirstChild("Backpack")
                  local character = LocalPlayer.Character
                  local slapTool = (backpack and backpack:FindFirstChild("Slap")) or (character and character:FindFirstChild("Slap"))
                  
                  if slapTool and slapTool:FindFirstChild("Event") then
                     slapTool.Event:FireServer("slash", targetCharacter, GetSlashVector())
                  end
               end
               task.wait(0.05)
            end
         end)
      end
   end,
})

TrollTab:CreateSection("Custom Knockback & Anti Slap")

-- Ô NHẬP SỐ LỰC VĂNG (INPUT)
TrollTab:CreateInput({
   Name = "Nhập số lực văng (Knockback Power)",
   PlaceholderText = "Mặc định: 100000",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then
         KnockbackPower = num
      end
   end,
})

-- TOGGLE SUPER KNOCKBACK ON HIT
TrollTab:CreateToggle({
   Name = "Super Knockback On Hit (Đánh văng xa)",
   CurrentValue = false,
   Flag = "SuperKnockbackToggle",
   Callback = function(Value)
      SuperKnockbackEnabled = Value
   end,
})

-- TOGGLE ANTI SLAP (CHẠM VÀO LÀ FLING)
TrollTab:CreateToggle({
   Name = "Anti Slap (Lại gần/Chạm là Fling cực mạnh)",
   CurrentValue = false,
   Flag = "AntiSlapToggle",
   Callback = function(Value)
      AntiSlapEnabled = Value
   end,
})

-- Vòng lặp kiểm tra va chạm / khoảng cách cho Anti Slap
task.spawn(function()
   while true do
      if AntiSlapEnabled then
         local character = LocalPlayer.Character
         local myRoot = character and character:FindFirstChild("HumanoidRootPart")
         
         if myRoot then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local slapTool = (backpack and backpack:FindFirstChild("Slap")) or (character and character:FindFirstChild("Slap"))
            
            if slapTool and slapTool:FindFirstChild("Event") then
               for _, v in pairs(Players:GetPlayers()) do
                  if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                     local targetRoot = v.Character.HumanoidRootPart
                     local dist = (targetRoot.Position - myRoot.Position).Magnitude
                     
                     -- Khoảng cách chạm / xuyên qua nhân vật (dưới 6 studs)
                     if dist <= 6 then
                        local superFlingVector = Vector3.new(math.random(-999999, 999999), 999999, math.random(-999999, 999999))
                        slapTool.Event:FireServer("slash", v.Character, superFlingVector)
                     end
                  end
               end
            end
         end
      end
      task.wait(0.03) -- Quét liên tục để phản hồi Anti Slap cực nhanh
   end
end)

-- Vòng lặp cho Super Knockback On Hit
task.spawn(function()
   while true do
      if SuperKnockbackEnabled then
         local character = LocalPlayer.Character
         local backpack = LocalPlayer:FindFirstChild("Backpack")
         local slapTool = (backpack and backpack:FindFirstChild("Slap")) or (character and character:FindFirstChild("Slap"))
         
         if slapTool and slapTool:FindFirstChild("Event") then
            local connection
            connection = slapTool.Activated:Connect(function()
               if not SuperKnockbackEnabled then
                  connection:Disconnect()
                  return
               end
               
               local myRoot = character and character:FindFirstChild("HumanoidRootPart")
               if myRoot then
                  for _, v in pairs(Players:GetPlayers()) do
                     if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (v.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                        if dist <= 15 then
                           local customVector = Vector3.new(
                              math.random(-KnockbackPower, KnockbackPower),
                              KnockbackPower * 1.5,
                              math.random(-KnockbackPower, KnockbackPower)
                           )
                           slapTool.Event:FireServer("slash", v.Character, customVector)
                        end
                     end
                  end
               end
            end)
            
            repeat task.wait(0.2) until not SuperKnockbackEnabled or slapTool.Parent == nil
            connection:Disconnect()
         end
      end
      task.wait(0.5)
   end
end)

-- ==========================================
-- TAB 3: MISC
-- ==========================================
local MiscTab = Window:CreateTab("Misc", 4483362458)
MiscTab:CreateSection("Script Credits")
MiscTab:CreateLabel("Script Creator: by kobtgihetaok")

-- Thông báo tải xong
Rayfield:Notify({
   Title = "wallhop slap tower",
   Content = "Đã cập nhật Fling All (1 lần), Anti Slap và Nhập số lực văng!",
   Duration = 3,
   Image = 4483362458,
})
