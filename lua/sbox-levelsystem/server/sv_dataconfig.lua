--------------------------
------- HTTP Fetch -------
--------------------------

function SLS.httpData()

    HTTP({
        method      = "get",
        url         = "https://raw.githubusercontent.com/SuperCALIENTITO/sbox-levelsystem/main/data/sbox-levelsystem/config.txt",
        headers     = {},

        success     = function(response, body, headers)
            if response == 200 then
                file.Write(sbox_ls.dir .. "/config.txt", body)
                SLS.mSV("Data has been restored")
            else
                SLS.mSV("ERROR: "..response)
                SLS.mSV("FAILED TO FETCH, YOU CAN'T USE CONFIG")
            end
        end,

        failed      = function(failed)
            SLS.mSV("ERROR: " .. failed)
        end
    })

end

--------------------------
------- Data Write -------
--------------------------

local dir = sbox_ls.dir .. "/"

function SLS.checkData()

    if file.Read(dir.."config.txt", "DATA") == "" then
        SLS.httpData()
    end

    if file.IsDir(sbox_ls.dir, "DATA") and file.Exists(dir.."config.txt", "DATA") then
        if not ( file.Read(dir.."config.txt", "DATA") == "" ) then
            SLS.mSV("Data is correct, eureka!")
        else
            SLS.mSV("Something is wrong with the Data")
            SLS.mSV("Maybe it is empty?")
        end
    end

    if not file.Exists(dir.."config.txt", "DATA") then
        file.CreateDir(sbox_ls.dir)
        file.Write(dir.."config.txt", "")
        file.Write(dir.."readme.txt", SLS.GetLanguage("readme"))
    end
end



function SLS.resetData()
    file.Delete(dir.."readme.txt")
    file.Delete(dir.."config.txt")

    SLS.checkData()
end

function SLS.removeData()
    file.Delete(sbox_ls.dir)
    file.CreateDir(sbox_ls.dir)
end

concommand.Add("sbox_ls_data_check", function() SLS.checkData() end, function() end, "Check the integrity of the data inside in "..sbox_ls.dir)
concommand.Add("sbox_ls_data_reset", function() SLS.resetData() end, function() end, "Reset to factory all data inside in "..sbox_ls.dir)
concommand.Add("sbox_ls_data_remove", function() SLS.removeData() end, function() end, "Remove all data inside in "..sbox_ls.dir)

timer.Simple(10, function() SLS.checkData() end)

--------------------------
-------- Data Read -------
--------------------------

function SLS.requestData()
    local dataConfig = file.Open(dir.."config.txt", "rb", "DATA")
    local tbl = {}
    
    while not dataConfig:EndOfFile() do
        local line = tostring(dataConfig:ReadLine())
        local lineStart, lineEnd = string.find(line, "=") 
    
        if string.StartWith(line, "#") then continue end
    
        if line == "" then continue end
    
        if not lineStart then continue end
    
        if string.find(line, "#") then
            local a = string.find(line, "#")
            line = string.Trim( string.sub(line, 0, a - 1) )
        end
    
        local var, value = string.sub(line, 0, lineEnd - 2), string.sub(line, lineStart + 2, -2)

        if sbox_ls.var_blacklist[var] then continue end
    
        tbl[var] = value
    end
    
    dataConfig:Close()

    return tbl
    
end

function SLS.asyncData(convar)
    local tbl = SLS.requestData()

    if not convar then
        for var, value in pairs(tbl) do
            if ConVarExists(var) and string.StartWith(var, "sbox_ls_") then
    
                print(GetConVar(var), value)

            elseif sbox_ls[var] then

                print(var, SLS.checkVal(value))

            end
        end

        return true, 1
    else
        if not tbl[convar] then return false, nil end

        if ConVarExists(convar) then
            return true, GetConVar(convar)
        end

        if sbox_ls[convar] 
    end
end

cvars.AddChangeCallback("sbox_ls_config", function(convar, old, new)
    if 
end)