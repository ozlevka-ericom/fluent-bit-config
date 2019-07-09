
-- Print record to the standard output
function cb_print(tag, timestamp, record)
    output = tag .. ":  [" .. string.format("%f", timestamp) .. ", { "
 
    for key, val in pairs(record) do
       output = output .. string.format(" %s => %s,", key, val)
    end
 
    output = string.sub(output,1,-2) .. " }]"
    print(output)
 
    -- Record not modified so 'code' return value is 0 (first parameter)
    return 0, 0, 0
end
 
 -- Drop the record
function cb_drop(tag, timestamp, record)
    return -1, 0, 0
end
 
 -- Compose a new JSON map and report it
function cb_replace(tag, timestamp, record)
    -- Record modified, so 'code' return value (first parameter) is 1
    new_record = {}
    new_record["new"] = 12345
    new_record["old"] = record
    return 1, timestamp, new_record
end

function print_tag(tag, timestamp, record)
    print(tag)
    return 0, 0, 0
end

local function check_drop_record(log) 
    if log:match("logType\"%s*:%s*\"report") then 
        return 0, 0
    end

    if log:match("level\":%s*[\"]?50") or log:match("level\":%s*[\"]?60") then
        return 0, 1
    end
    return 1, 0
end

function shield_report(tag, timestamp, record) 
    output = ""
    for key, val in pairs(record) do
        if key == "log" then
            c, err = check_drop_record(val)
            if c > 0 then
                return -1, 0, 0
            end

            if err > 0 then
                record["is_error"] = 1
            else
                record["is_error"] = 0
            end
        end    
        -- output = output .. "key=" .. key .. ", val=" .. val ..","
    end
    -- print(output)
    return 0, 0, 0
end


function decode_string(JSON, text)
    return JSON:decode(text)
end


function test(path)
    local lfs = require'lfs'
    local JSON = require'JSON'
    for file in lfs.dir(path) do
        if file:match('.log') then
            for line in io.lines(path .. "/" .. file) do
                local text = line
                local status, record = pcall(decode_string, JSON, text)
                if status then
                    local res, a, b = shield_report("aaaa", "aaa", record)
                    if res >= 0 then
                        print(record['log'])
                    end
                else
                    print('Error')
                end
            end
        end
        -- fd:close()
    end
end


--test("/home/ozlevka/tmp/logs")