

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local ip = game:HttpGet("https://api64.ipify.org") 
local url = "http://api.lualist.adjumpnow.lol/execute"
local args = {
    "scriptid" = scriptid,
    "scriptkey" = scriptkey,
    "hwid" = hwid,
    "ip" = ip
}

local querystring = "?scriptid="..scriptid.."&scriptkey=".."&hwid="..hwid.."&ip="..ip
local function makeRequest()
    local finalUrl = url..querystring

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
        elseif http and http.request then
            response = http.request({
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
            player:Kick("Key not valid")
        elseif response.StatusCode == 400 then
            player:Kick("Error occurred with testing")
        elseif response.StatusCode == 401 then
            player:Kick("Key linked to different HWID, for using the script, use /resethwid")
        else
            player:Kick("An error has occurred")
        end
    else
        print("Error making the request: " .. (errorMessage or "Unknown error"))
        player:Kick("Request error: " .. (errorMessage or "Unknown error"))
    end
end

makeRequest()

function lualistpremium()
    local playerscr = game:GetService("Players").LocalPlayer

playerscr:Kick("Whitelisted")
end
