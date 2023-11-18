function GetActivePlayerCount()
    local playerCount = 0

    for _, player in ipairs(GetPlayers()) do
        playerCount = playerCount + 1
    end

    return playerCount
end

if server_config.enableHeartbeat then
    if heartbeat_config.APIKey ~= nil then
        Citizen.CreateThread(function()
            while true do
                local requestData = { 
                    serverName = GetConvar('sv_projectName'), 
                    maxPlayers = GetConvar('sv_maxclients'), 
                    playerCount = GetActivePlayerCount() 
                } 
                
                PerformHttpRequest('https://servers.ndcore.dev/backend/heartbeat' , function(statusCode, responseText, headers) 
                    if statusCode == 200 then 
                        -- Successful request, handle the response if needed 
                    else 
                        -- Handle error, display status code and response text 
                    end 
                end, 'POST', json.encode(requestData), { ['Content-Type'] = 'application/json' })

                Citizen.Wait(300000)
            end
        end)
    else
        print("Error! To list your server, you must set your API key obtained from servers.ndcore.dev")
    end
end
