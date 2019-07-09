
local function check_drop_record(log)
    if log:match("logType\"%s*:%s*\"report") then
        return false
    end

    if log:match("level\":%s*[\"]?50") or log:match("level\":%s*[\"]?60") then
        return false
    end
    return true
end

function shield_report(tag, timestamp, record)
    output = ""
    for key, val in pairs(record) do
        if key == "log" then
            local drop = check_drop_record(val)
            if  drop  then
                return -1, 0, 0
            end
        end
        -- output = output .. "key=" .. key .. ", val=" .. val ..","
    end
    -- print(output)
    return 0, 0, 0
end