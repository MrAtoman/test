local GUI = Instance.new("ScreenGui", script.Parent)
local Button = Instance.new("TextButton", GUI)
Button.Size = UDim2.new(0, 100, 0, 50)
Button.Position = UDim2.new(0.5, -50, 0.5, -25)
Button.Text = "TextButton"
local skyboxAssetId = "http://www.roblox.com/asset/?id=133052728208506" -- ID текстур
local textureScale = 2 -- Размер текстур
local function changeSky()
	local NewSky = Instance.new("Sky")
	NewSky.Name = "CustomSky"
	NewSky.Parent = game:GetService("Lighting")
	NewSky.MoonTextureId = skyboxAssetId
	NewSky.SkyboxBk = skyboxAssetId
	NewSky.SkyboxDn = skyboxAssetId
	NewSky.SkyboxFt = skyboxAssetId
	NewSky.SkyboxLf = skyboxAssetId
	NewSky.SkyboxRt = skyboxAssetId
	NewSky.SkyboxUp = skyboxAssetId
	NewSky.SunTextureId = skyboxAssetId
end

local function changeTextures(object)
	for _, child in ipairs(object:GetChildren()) do
		if child:IsA("Texture") or child:IsA("Decal") then
			child:Destroy()
		end
	end

	for _, face in pairs(Enum.NormalId:GetEnumItems()) do
		local texture = Instance.new("Texture")
		texture.Texture = skyboxAssetId
		texture.Face = face
		texture.StudsPerTileU = textureScale
		texture.StudsPerTileV = textureScale
		texture.Parent = object
	end
end

local function processInstance(instance)
	if instance:IsA("BasePart") or instance:IsA("MeshPart") or instance:IsA("UnionOperation") then
		changeTextures(instance)
	elseif instance:IsA("Model") then
		for _, child in ipairs(instance:GetDescendants()) do
			if instance:IsA("BasePart") or instance:IsA("MeshPart") or instance:IsA("UnionOperation") then
				changeTextures(child)
			end
		end
	end
end

local function onClick()
	changeSky()
	for _, instance in ipairs(workspace:GetDescendants()) do
		processInstance(instance)
	end

	game:GetService("Players").PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			processInstance(character)
		end)
	end)

	workspace.DescendantAdded:Connect(function(descendant)
		task.wait(0.1)
		processInstance(descendant)
	end)
end

-- Подключаем функцию к событию нажатия кнопки
Button.MouseButton1Click:Connect(onClick)
