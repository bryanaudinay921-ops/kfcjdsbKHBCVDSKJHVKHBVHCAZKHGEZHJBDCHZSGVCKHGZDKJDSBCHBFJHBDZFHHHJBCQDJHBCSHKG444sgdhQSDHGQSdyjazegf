local url = "https://jonas-unfragile-coquettishly.ngrok-free.dev"

-- On utilise la fonction de requête avancée obligatoire pour les headers
local requestFunc = request or (http and http.request) or (syn and syn.request)

if not requestFunc then
    warn("Delta ne semble pas supporter la fonction 'request' sur cette version.")
    return
end

-- Envoi de la requête avec le token de bypass Ngrok
local success, response = pcall(function()
    return requestFunc({
        Url = url,
        Method = "GET",
        Headers = {
            ["ngrok-skip-browser-warning"] = "any-value-here", -- C'est CE HEADER qui fait sauter la page blanche !
            ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        }
    })
end)

if not success or not response then
    warn("Impossible de joindre ton serveur Python.")
    return
end

local content = response.Body

-- Sécurité au cas où Ngrok ferait de la résistance
if string.find(content, "ERR_NGROK") then
    warn("Mince, Ngrok a encore bloqué la requête malgré le bypass.")
    print(string.sub(content, 1, 200))
    return
end

-- Extraction du Lua si jamais ton serveur envoie un mix HTML/Lua
local luaCode = string.match(content, "<pre[^>]*>(.-)</pre>") or content

-- Nettoyage rapide des retours à la ligne Windows pour l'éditeur mobile
luaCode = string.gsub(luaCode, "\r", "")

-- Exécution du vrai code reçu
local loadedScript, err = loadstring(luaCode)
if loadedScript then
    print("Succès ! Le serveur a renvoyé le script et Delta l'exécute.")
    loadedScript()
else
    warn("Erreur de syntaxe Lua : " .. tostring(err))
    print("Contenu reçu par l'éditeur :")
    print(string.sub(luaCode, 1, 300))
end
