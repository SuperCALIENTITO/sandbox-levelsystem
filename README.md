# Sandbox Level System
a simple system that adds levels to the sandbox (may be compatible with other game modes)

### Cvars Server-side
| CVAR                  | Value | Description   | 
| -------------         | :---: | ------------- |
| sbox_ls_connections   | 15    | The amount of xp to get when a player connects.           |
| sbox_ls_kills         | 15    | The amount of xp to get when a player kills someone.      |
| sbox_ls_deaths        | 3     | The amount of xp to get when a player dies.               |
| sbox_ls_chats         | 1     | The amount of xp to get when a player talks.              |
| sbox_ls_physgun       | 2     | The amount of xp to get when a player uses the physgun.   |
| sbox_ls_noclip        | 2     | The amount of xp to get when a player uses noclip.        |

### Cvars Client-side
| CVAR                  | Value | Description   | 
| -------------         | :---: | ------------- |
| sbox_ls_notify        | 1     | Should the player be notified when they level up? |
| sbox_ls_notify_sound  | 1     | Should the player be notified with a sound when they level up? |
| sbox_ls_notify_chat   | 0     | Should the player be notified with a chat message when they level up? |

# Global Functions
you can find all functions in [this file](https://github.com/SuperCALIENTITO/sbox-levelsystem/blob/main/lua/sbox-levelsystem/shared/sh_core.lua)

```lua
SLS_getLevelPlayer(ply)

-- returns the current level of the player,
-- if the level exceeds the number of existing levels,
-- the last level will be returned as value
```

```lua
SLS_getXPPlayer(ply)

-- returns the player's current experience
```

```lua
SLS_getLevelExp(level)

-- returns the amount of experience for the level
```

```lua
SLS_checkPlayerDatabase(ply)

-- check if the player exists in the database,
-- if it doesn't exist, it adds it.
-- doesn't return any value
```

```lua
SLS_addXPToPlayer(ply, xp)

-- add the player an amount of XP with the xp arg
```

```lua
SLS_updatePlayerName(ply)

-- update the name of the player in the database
```

# Global Meta Statements
you can find all statements in [this file](https://github.com/SuperCALIENTITO/sbox-levelsystem/blob/main/lua/includes/extensions/sandbox_level/player_level.lua)

```lua
ply:GetPlayerLevel()

-- returns the player level
```

```lua
ply:GetPlayerXP()

-- returns the current xp of player
```

```lua
ply:GetPlayerXPToNextLevel()

-- returns the amount needed to level up
```

```lua
ply:IsPlayerLevelEqualTo(level)

-- (boolean)
-- returns if the player is in the same level
```

```lua
ply:IsPlayerLevelMoreThan(level)

-- (boolean)
-- returns if the player is equal or greater than the level
```

```lua
ply:IsPlayerLevelLessThan(level)

-- (boolean)
-- returns if the player is less than the level
```
