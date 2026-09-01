-- Tải thư viện Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Biến điều khiển
local BringAllEnabled = false
local TrollTargetEnabled = false
local TargetInputName = ""

-- Hàm hỗ trợ tìm kiếm Model Player trong Workspace theo từ khóa tên
local function FindPlayerModel(query)
	if not query or query == "" then return nil end
	query = string.lower(query)
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local name = string.lower(player.Name)
			local displayName = string.lower(player.DisplayName)
			
			-- Kiểm tra nếu tên hoặc DisplayName chứa từ khóa nhập vào
			if string.find(name, query, 1, true) or string.find(displayName, query, 1, true) then
				if player.Character and player.Character.Parent == workspace then
					return player.Character
				end
			end
		end
	end
	return nil
end

-- Khởi tạo Cửa sổ Menu với tên "wallhop slap tower"
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

MainTab:CreateToggle({
   Name = "Bring All Players",
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
                        slapTool.Event:FireServer(
                           "slash",
                           v.Character,
                           Vector3.new(4.3126339912415, -5.1616577678715e-08, -2.530056476593)
                        )
                     end
                  end
               end
               task.wait(0.1)
            end
         end)
      end
   end,
})

-- ==========================================
-- TAB 2: TROLL
-- ==========================================
local TrollTab = Window:CreateTab("Troll", 4483362458)

-- Ô nhập chữ để nhận diện tên Player
TrollTab:CreateInput({
   Name = "Nhập tên Player Target",
   PlaceholderText = "Ví dụ: toi, vn, alex...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      TargetInputName = Text
   end,
})

-- Công tắc Bật/Tắt tấn công Target đã chọn
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
                     -- Gửi Event trực tiếp tới Model Player nhận diện được trong Workspace
                     slapTool.Event:FireServer(
                        "slash",
                        targetCharacter,
                        Vector3.new(4.6536865234375, 1.9944470847965e-39, 1.8284423351288)
                     )
                  end
               end
               task.wait(0.1)
            end
         end)
      end
   end,
})

-- ==========================================
-- TAB 3: MISC (CREDITS)
-- ==========================================
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateSection("Script Credits")

MiscTab:CreateLabel("Script Creator: by kobtgihetaok")

-- Thông báo khi tải thành công
Rayfield:Notify({
   Title = "wallhop slap tower",
   Content = "Đã tải thành công GUI by kobtgihetaok!",
   Duration = 3,
   Image = 4483362458,
})
