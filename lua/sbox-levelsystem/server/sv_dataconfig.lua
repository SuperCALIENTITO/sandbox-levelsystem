--------------------------
------- HTTP Fetch -------
--------------------------

function SLS.requestData()
    local config = ""

    http.Fetch("https://raw.githubusercontent.com/SuperCALIENTITO/sbox-levelsystem/main/data/sbox-levelsystem/config.txt",
        function(body, _, _, response)
            if response == 200 then
                file.Write(sbox_ls.dir .. "/config.txt", body)
                SLS.mSV("Data has been restored")
                config = response
            else
                SLS.mSV("ERROR: "..response)
                SLS.mSV("FAILED TO FETCH, YOU CAN'T USE CONFIG")
            end
        end,

        function(failed)
            SLS.mSV("ERROR: " .. failed)
        end,
        {}
    )

    return config
end

--------------------------
------- Data Write -------
--------------------------

local dir = sbox_ls.dir .. "/"

function SLS.checkData()
    if file.IsDir(sbox_ls.dir, "DATA") and file.Exists(dir.."config.txt", "DATA") then
        SLS.mSV("Data is correct, eureka!")
    end

    if not file.Exists(dir.."config.txt", "DATA") then
        file.CreateDir(sbox_ls.dir)
        file.Write(dir.."config.txt", "")
        file.Write(dir.."readme.txt", SLS.GetLanguage("readme"))
    end

    if file.Read(dir.."config.txt", "DATA") == "" then
        SLS.requestData()
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

timer.Simple(12, function() SLS.checkData() end)

--------------------------
-------- Data Read -------
--------------------------

local dataConfig = file.Open(dir.."config.txt", "rb", "DATA")
local sbox_vars = {}
local modules_vars = {}

while not dataConfig:EndOfFile() do
    local line = tostring(dataConfig:ReadLine())

    if string.StartWith(line, "#") then continue end
    
    if line == "" then continue end

    print(line)
end