-- mob_spawner.lua 内容

-- 引用刷怪配置

if MobSpawner == nil then
    MobSpawner = class({})
end

-- 启动刷怪逻辑
function MobSpawner:Start()
    -- 注册 Thinker https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/ThinkerFunctions
    GameRules:GetGameModeEntity():SetThink("OnThink", self)
    -- 初始化波数，当前第0波
    self.wave = 0
end

-- 每1秒判断一次，时间到了就刷怪，然后停止这个 Thinker
function MobSpawner:OnThink()
    -- 拿 Dota 时间 https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/API/CDOTAGamerules.GetDOTATime
    local now = GameRules:GetDOTATime(false, false)
    if GetMapName() =="10v10mid" then
        if self.wave*30 < now then
            self:SpawnNextWave()
            return 1
        end
    end
    return 1
end

-- 刷下一波怪
function MobSpawner:SpawnNextWave()
    self.wave = self.wave + 1
    self:SpawnMob("npc_dota_creep_goodguys_melee", "lane_bot_pathcorner_goodguys_1", self.wave,DOTA_TEAM_GOODGUYS)
    self:SpawnMob("npc_dota_creep_goodguys_ranged", "lane_bot_pathcorner_goodguys_1", self.wave,DOTA_TEAM_GOODGUYS)
    self:SpawnMob("npc_dota_goodguys_siege", "lane_bot_pathcorner_goodguys_1", self.wave,DOTA_TEAM_GOODGUYS)
    self:SpawnMob("npc_dota_creep_goodguys_melee", "lane_top_pathcorner_goodguys_1", self.wave,DOTA_TEAM_GOODGUYS)
    self:SpawnMob("npc_dota_creep_goodguys_ranged", "lane_top_pathcorner_goodguys_1", self.wave,DOTA_TEAM_GOODGUYS)
    self:SpawnMob("npc_dota_goodguys_siege", "lane_top_pathcorner_goodguys_1", self.wave,DOTA_TEAM_GOODGUYS)
    self:SpawnMob("npc_dota_creep_badguys_melee", "lane_bot_pathcorner_badguys_1", self.wave,DOTA_TEAM_BADGUYS)
    self:SpawnMob("npc_dota_creep_badguys_ranged", "lane_bot_pathcorner_badguys_1", self.wave,DOTA_TEAM_BADGUYS)
    self:SpawnMob("npc_dota_badguys_siege", "lane_bot_pathcorner_badguys_1", self.wave,DOTA_TEAM_BADGUYS)
    self:SpawnMob("npc_dota_creep_badguys_melee", "lane_top_pathcorner_badguys_1", self.wave,DOTA_TEAM_BADGUYS)
    self:SpawnMob("npc_dota_creep_badguys_ranged", "lane_top_pathcorner_badguys_1", self.wave,DOTA_TEAM_BADGUYS)
    self:SpawnMob("npc_dota_badguys_siege", "lane_top_pathcorner_badguys_1", self.wave,DOTA_TEAM_BADGUYS)
    
end

-- 刷单个怪
function MobSpawner:SpawnMob(name, location, wave,team)
    -- 找刷怪点实体 https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/API/CEntities.FindByName
    local location_ent = Entities:FindByName(nil, location)
    -- 拿到刷怪点的坐标 
    local position = location_ent:GetOrigin()
    -- 创建单位 https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/API/Global.CreateUnitByName
    local mob = CreateUnitByName(name, position, true, nil, nil, team)
    -- 设置怪物等级
    if location then
        -- 设置怪物必须按路线走
        mob:SetMustReachEachGoalEntity(true)
        local path_ent = Entities:FindByName(nil, location)
        -- 设置怪物寻路的第一个路径点
        mob:SetInitialGoalEntity(path_ent)
    end
end