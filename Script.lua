
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local ip = game:HttpGet("https://api64.ipify.org")
local url = "https://api.lualist.adjumpnow.lol/execute"

local querystring = "?scriptid=" .. scriptid .. "&scriptkey=" .. scriptkey .. "&hwid=" .. hwid .. "&ip=" .. ip

local function makeRequest()
    print("makeRequest called")
    local finalUrl = url .. querystring
    print("Final URL: " .. finalUrl)

    local response
    local success, errorMessage = pcall(function()
        if syn and syn.request then
            response = syn.request({
                Url = finalUrl,
                Method = "GET"
            })
        elseif request then
            response = request({
                Url = finalUrl,
                Method = "GET"
            })
        elseif http_request then
            response = http_request({
                Url = finalUrl,
                Method = "GET"
            })
        else
            error("No supported HTTP request function found.")
        end
    end)

    if success and response then
        print("Request successful")
        print("Status Code: " .. response.StatusCode)
        print("Response Body: " .. response.Body)

        if response.StatusCode == 200 then
            local responseData = game:GetService("HttpService"):JSONDecode(response.Body)
            print("Response Data: ", responseData)
            lualistpremium()
        elseif response.StatusCode == 402 then
            print("Key not valid")
            player:Kick("Key not valid")
        elseif response.StatusCode == 400 then
            print("Error occurred with testing")
            player:Kick("Error occurred with testing")
        elseif response.StatusCode == 401 then
            print("Key linked to different HWID, for using the script, use /resethwid")
            player:Kick("Key linked to different HWID, for using the script, use /resethwid")
        else
            print("An error has occurred")
            player:Kick("An error has occurred")
        end
    else
        print("Error making the request: " .. (errorMessage or "Unknown error"))
        player:Kick("Request error: " .. (errorMessage or "Unknown error"))
    end
end

function lualistpremium()
    print("Whitelisted - Kicking player")
    local playerscr = game:GetService("Players").LocalPlayer
    playerscr:Kick("Whitelisted")
end

print("Calling makeRequest")
makeRequest()
print("makeRequest finished")
