SLS = {}
sbox_ls = {}
sbox_ls.config = {}
sbox_ls.language = {}
sbox_ls.db = "sbox_levelsystem"
sbox_ls.dir = "sbox-levelsystem"
sbox_ls.display_level = CreateConVar("sbox_ls_displaylevel", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Announce the level up of a player?")
sbox_ls.prefix = CreateConVar("sbox_ls_prefix", "[SBOX-LS]", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Set the prefix of Sandbox Level System")
sbox_ls.prefix_color = Color(91, 123, 227)


------------------------
----- Config Module ----
------------------------
sbox_ls.usecfg = CreateConVar("sbox_ls_config", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Use the config file instead of convars?")
sbox_ls.var_blacklist = {
    ["var_blacklist"] = true,
    ["language"] = true,
    ["levels"] = true,
    ["config"] = true,
    ["lang"] = true,
}

----------------------------------
------------ Language ------------
----------------------------------
-- https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes

sbox_ls.lang = {
    ["en"] = "english",
    ["es"] = "spanish",
}
CreateConVar("sbox_ls_lang", "en", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The language to use for the level system.")

function SLS.GetLanguage(phrase)
    local lang = sbox_ls.lang[GetConVar("sbox_ls_lang"):GetString()] or "english"
    return sbox_ls.language[lang][phrase] or phrase
end


----------------------------------
------------- Convars ------------
----------------------------------

local function addCV(str, int, desc)
    CreateConVar(str, int, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, desc)
end

addCV("sbox_ls_connections",    15, "The amount of xp to get when a player connects.")
addCV("sbox_ls_kills",          15, "The amount of xp to get when a player kills someone.")
addCV("sbox_ls_deaths",          3, "The amount of xp to get when a player dies.")
addCV("sbox_ls_chats",           1, "The amount of xp to get when a player talks.")
addCV("sbox_ls_physgun",         2, "The amount of xp to get when a player uses the physgun.")
addCV("sbox_ls_noclip",          2, "The amount of xp to get when a player uses noclip.")
addCV("sbox_ls_npc_killed",      5, "The amount of xp to get when a player kills an NPC.")
addCV("sbox_ls_spawned_vehicle", 2, "The amount of xp to get when a player spawns a vehicle.")
addCV("sbox_ls_spawned_npc",     2, "The amount of xp to get when a player spawns a npc.")
addCV("sbox_ls_spawned_prop",    1, "The amount of xp to get when a player spawns a prop.")
addCV("sbox_ls_spawned_sent",    2, "The amount of xp to get when a player spawns a SENT.")
addCV("sbox_ls_spawned_ragdoll", 2, "The amount of xp to get when a player spawns a ragdoll.")

------------------------
---- Credits Module ----
------------------------
addCV("sbox_ls_module_credits",  0, "Enable the credits module.")
addCV("sbox_ls_module_credits_onlevelup", 4000, "Amount of credit to given to players.")

------------------------
----- Maths Module -----
------------------------
addCV("sbox_ls_module_maths",    0, "Enable the maths module.")
addCV("sbox_ls_module_maths_answered", 20, "Amount of xp to given to players.")

------------------------
------ Perk Module -----
------------------------
addCV("sbox_ls_module_perk",                  0, "Enable the perk module.")
addCV("sbox_ls_module_perk_health_min",      50, "The level minimum to get the health perk.")
addCV("sbox_ls_module_perk_armor_min",       50, "The level minimum to get the armor perk.")
addCV("sbox_ls_module_perk_jump_min",       100, "The level minimum to get the jump perk.")
addCV("sbox_ls_module_perk_speed_min",      100, "The level minimum to get the speed perk.")
addCV("sbox_ls_module_perk_delay",            1, "Delay to apply changes to the player")


if SERVER then
resource.AddWorkshop("2838145642")

util.AddNetworkString("sandbox_levelsystem_levelup")
util.AddNetworkString("sandbox_levelsystem_menu")
util.AddNetworkString("sandbox_levelsystem_perks")
util.AddNetworkString("sandbox_levelsystem_perks_admin")
util.AddNetworkString("sandbox_levelsystem_config")
end

if CLIENT then
CreateClientConVar("sbox_ls_notify", 1, true, true, "Should the player be notified when they level up?")
CreateClientConVar("sbox_ls_notify_sound", 1, true, true, "Should the player be notified with a sound when they level up?")
CreateClientConVar("sbox_ls_notify_chat", 0, true, true, "Should the player be notified with a chat message when they level up?")
end

if SERVER and not sql.TableExists(sbox_ls.db) then
    sql.Query([[CREATE TABLE IF NOT EXISTS ]] .. sbox_ls.db .. [[ (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        player INTEGER NOT NULL,
        plyname VARCHAR(255) NOT NULL,
        level INTEGER NOT NULL DEFAULT 1,
        xp INTEGER NOT NULL DEFAULT 0
    )]])
end


----------------------------------
----------- Extensions -----------
----------------------------------

-- GDR
-- https://github.com/SuperCALIENTITO/gdr_addon
sbox_ls.gdr_enable = false -- Enable/disable the GDR addon.
sbox_ls.gdr_picture = "https://i.imgur.com/EKHWx6Y.png"
sbox_ls.gdr_name = "Sandbox Level System"
sbox_ls.gdr_message = " has reached level "

-- Gmod Stats
-- https://steamcommunity.com/sharedfiles/filedetails/?id=2829026660
sbox_ls.gmodstats_enable = true -- Enable/Disable the gmodstats integration.
sbox_ls.gmodstats_db = "stats_mp"

-- Math Problems
-- https://steamcommunity.com/sharedfiles/filedetails/?id=2805623775
sbox_ls.maths_enable = true -- Enable/Disable the maths integration.
sbox_ls.math_db = "math_points"

----------------------------------
------------ Functions -----------
----------------------------------

function SLS.mSV(...)
    MsgC( Color(56, 228, 255, 200), string.Trim(sbox_ls.prefix:GetString()), " ", Color(184, 246, 255, 200), unpack({...}))
    MsgC("\n")
end

function SLS.mCL(...)
    MsgC( Color(255, 235, 56, 200), string.Trim(sbox_ls.prefix:GetString()), " ", Color(184, 246, 255, 200), unpack({...}))
    MsgC("\n")
end

function SLS.mSH(...)
    MsgC( Color(167, 255, 167, 200), string.Trim(sbox_ls.prefix:GetString()), " ", Color(184, 246, 255, 200), unpack({...}))
    MsgC("\n")
end


print("-----------------------------------------")
print("---------- Sandbox Level System ---------")
print("-----------------------------------------\n")

local function AddFile(file, dir)
    local prefix = string.lower(string.Left(file, 3))
    if SERVER and (prefix == "sv_") then
        include(dir .. file)
        SLS.mSV("SERVER INCLUDE:  " .. string.sub(dir, 18) .. file)
    elseif (prefix == "sh_") then
        if SERVER then
            AddCSLuaFile(dir .. file)
            SLS.mSH("SHARED ADDCS:    " .. string.sub(dir, 18) .. file)
        end
        include(dir .. file)
        SLS.mSH("SHARED INCLUDE:  " .. string.sub(dir, 18) .. file)
    elseif (prefix == "cl_") then
        if SERVER then
            AddCSLuaFile(dir .. file)
            SLS.mCL("CLIENT ADDCS:    " .. string.sub(dir, 18) .. file)
        elseif CLIENT then
            include(dir .. file)
            SLS.mCL("CLIENT INCLUDE:  " .. string.sub(dir, 18) .. file)
        end
    end
end

local function AddDir(dir)
    dir = dir .. "/"

    local files, directories = file.Find(dir .. "*", "LUA")
    for _, v in ipairs(files) do
        if string.EndsWith(v, ".lua") then
            AddFile(v, dir)
        end
    end

    for _, v in ipairs(directories) do AddDir(dir .. v) end
end
AddDir(sbox_ls.dir)

print("\n- Made by vicentefelipechile and Lugent -")
print("-----------------------------------------\n")