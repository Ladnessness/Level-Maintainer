local term = require("term")
local gpu = require("component").gpu

function dump(o, depth)
    if depth == nil then depth = 0 end
    if depth > 10 then return "..." end
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v, depth + 1) .. ',\n'
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function parser(string)
    if type(string) == "string" then
        local numberString = string.gsub(string, "([^0-9]+)", "")
        if tonumber(numberString) then
            return math.floor(tonumber(numberString) + 0)
        end
        return 0
    else
        return 0
    end
end

function logInfo(message, status)
    if type(message) == "string" then
        local gpu = require("component").gpu
        if status == "threshold" then
            gpu.setForeground(0x00FF00)  -- green: item exceeds threshold
        elseif status == "requested" then
            gpu.setForeground(0xFFFF00)  -- yellow: item was requested
        elseif status == "failed" then
            gpu.setForeground(0xFF0000)  -- red: request failed
        else
            gpu.setForeground(0xFFFFFF)  -- white: default/unknown
        end
        print("[" .. os.date("%H:%M:%S") .. "] " .. message)
        gpu.setForeground(0xFFFFFF)  -- reset to white after printing
    end
end