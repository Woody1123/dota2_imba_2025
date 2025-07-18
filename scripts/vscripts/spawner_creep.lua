
if spawner_creep == nil then
    spawner_creep = class({})
end

LinkLuaModifier("modifier_camp_spawner", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_boss", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_boss_rage", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_boss_passive", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_boss_fight", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_boss_sound_cd", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_boss_debuff", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_boss_end", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_miniboss", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_miniboss_shield", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_miniboss_attacker_flag", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_miniboss_shield_pfx", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mniboss_defence", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mini_torrent", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cat_buff", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cat_buff2", "spawner_creep.lua", LUA_MODIFIER_MOTION_NONE)

function spawner_creep:Spawner_early() 
	 --创建中路全体视野
	 AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(0,0,0), 1300, 1000, false)
	 AddFOWViewer(DOTA_TEAM_BADGUYS, Vector(0,0,0), 1300, 1000, false)
	 --中路的猫
	local pos = Vector(0,0,0)
	local unit=CreateUnitByName("npc_cat", pos, true, nil, nil, 4) 
    unit:SetAbsAngles(0, -90, 0)
    unit:AddNewModifier(caster, self, "modifier_kill",  {duration=20})
	unit:AddNewModifier(caster, self, "modifier_unit_remove",  {duration=20})
    unit:AddNewModifier(caster, self, "modifier_imba_cat_buff",  {duration=20})
	
end


modifier_imba_cat_buff=class({})

function modifier_imba_cat_buff:IsPurgable()
    return false
end

function modifier_imba_cat_buff:IsPurgeException()
    return false
end

function modifier_imba_cat_buff:IsHidden()
    return true
end


function modifier_imba_cat_buff:IsAura()
    return true
end

function modifier_imba_cat_buff:GetAuraDuration()
    return 0.1
end

function modifier_imba_cat_buff:GetModifierAura()
    return "modifier_imba_cat_buff2"
end

function modifier_imba_cat_buff:GetAuraRadius()
     return 3500    
end

function modifier_imba_cat_buff:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_imba_cat_buff:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end
function modifier_imba_cat_buff:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_imba_cat_buff:OnCreated()
    if IsServer() then
        self.t=0
        local particle2 = ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
        ParticleManager:SetParticleControl(particle2, 1, Vector(3500, 0, 0))
        ParticleManager:SetParticleControl(particle2, 2, Vector(100, 0, 0))
        ParticleManager:SetParticleControl(particle2, 3, Vector(100, 0, 0))
        ParticleManager:SetParticleControl(particle2, 15, Vector(220, 20, 60))
        self:AddParticle(particle2, false, false, 15, false, false)
		
		
		self:StartIntervalThink(1)
    end
end


function modifier_imba_cat_buff:OnIntervalThink()
    if IsServer() then
		self.t = self.t+1
		if self.t == 10 then
			EmitGlobalSound("TG.bgm_MIDCAT")
		end
		
		if self.t == 10 then
			Notifications:TopToAll({text ="中路集合准备开干!", duration=14,style={color="#DC143C", ["font-size"]="60px"},continue = true})
		end
		if self.t >= 10 and  self.t <20 then
			Notifications:TopToAll({text =tostring(20-self.t), duration=0.7,style={color="#FFEFDB", ["font-size"]="80px"},continue = true})
		end
		if self.t ==20 then
			Notifications:TopToAll({text ="冲冲冲！！！！", duration=4,style={color="#DC143C", ["font-size"]="100px"},continue = true})
		end
	end
end


function modifier_imba_cat_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MODEL_SCALE,
    }
end

function modifier_imba_cat_buff:GetModifierModelScale()
    return  300
end


function modifier_imba_cat_buff:CheckState()
    return
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
    }
end

function modifier_imba_cat_buff:OnDestroy()
    if IsServer() then
		local pos = self:GetParent():GetAbsOrigin()
		local fx2 = ParticleManager:CreateParticle("particles/world_outpost/world_outpost_radiant_ambient_shockwave.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(fx2, 1, Vector(pos.x,pos.y,pos.z+300))		
		ParticleManager:ReleaseParticleIndex(fx2)	
		self:GetParent():EmitSound("Hero_Phoenix.SuperNova.Explode")
		local heros = FindUnitsInRadius(4, pos, nil, 4500, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,hero in pairs(heros) do
			hero:HeroLevelUp(true)
		end
		
		local end_pos = pos + pos:Normalized() * 700
		for i=0, 3 do
		
			local newpos =RotatePosition(pos, QAngle(0, i*90, 0), self:GetParent():GetForwardVector():Normalized() * 800)
			--local pos_end = GetRandomPosition2D(newpos,600)
			for j=0,3 do
				local coin = CreateItem("item_bag_of_gold", nil, nil)
				coin:SetPurchaseTime(0)
				coin:SetSellable(false)
				local drop = CreateItemOnPositionSync( pos, coin ) 
				coin:LaunchLoot(false, 500, 1, newpos + RandomVector(math.random(100,900)),nil)
			end
		end
    end
end
modifier_imba_cat_buff2=class({})

function modifier_imba_cat_buff2:IsPurgable()
    return false
end

function modifier_imba_cat_buff2:IsPurgeException()
    return false
end

function modifier_imba_cat_buff2:IsHidden()
    return false
end

function modifier_imba_cat_buff2:GetEffectAttachType()
   return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_cat_buff2:ShouldUseOverheadOffset()
   return true
end

function modifier_imba_cat_buff2:CheckState()
    return
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
end
function modifier_imba_cat_buff2:OnCreated()
	if IsServer() then
		self:StartIntervalThink(3)
	end
end

function modifier_imba_cat_buff2:OnIntervalThink()
	if IsServer() then
		
		self:GetParent():StartGesture(ACT_DOTA_TAUNT)
	end
end	
	--boss 兵 野 入口函数
	
function spawner_creep:GetGoodCreepSpawn()
	return self.good_creep_spwan
end
function spawner_creep:GetBadCreepSpawn()
	return self.bod_creep_spwan
end
function spawner_creep:InitSpawner()
	print("InitSpawner")

	self.time = -30
	self.creep_level = 0
	self.good_attack = false
	self.bad_attack = false
	self.clearTime = 0

	-- Safely get entity or return nil
	local function SafeGetPos(name)
		local ent = Entities:FindByName(nil, name)
		return ent and ent:GetOrigin() or Vector(0, 0, 0)
	end

	local function SafeGetEntity(name)
		return Entities:FindByName(nil, name)
	end

	-- Initialize positions
	self.roshan_spawn = SafeGetPos("imba_roshan")
	self.miniboss_spawn = SafeGetPos("imba_miniboss")
	self.imba_sentinel = SafeGetEntity("imba_sentinel")
	self.good_outpost_pos = SafeGetPos("good_outpost")
	self.bad_outpost_pos = SafeGetPos("bad_outpost")
	self.outpost_pos = Vector(0, 0, 128)
	self.outpost_oldteam = nil

	self.tower_good = SafeGetEntity("dota_goodguys_tower2_mid")
	self.tower_bad = SafeGetEntity("dota_badguys_tower2_mid")

	-- Trap positions and distances
	self.trap_table_newpos = {
		SafeGetPos("trap_newpos_01"),
		SafeGetPos("trap_newpos_02"),
		SafeGetPos("trap_newpos_03"),
		SafeGetPos("trap_newpos_04")
	}

	self.trap_table = {}
	self.trap_distance = {}
	for i = 1, 4 do
		local name = "imba_hook_trap_0" .. i
		local trigger = SafeGetEntity(name)
		if trigger then
			table.insert(self.trap_table, trigger)
			table.insert(self.trap_table, SafeGetEntity(name .. "_button"))
			table.insert(self.trap_table, SafeGetEntity(name .. "_model"))
			table.insert(self.trap_table, SafeGetEntity(name .. "_npc"))
			table.insert(self.trap_table, SafeGetEntity(name .. "_target"))
			table.insert(self.trap_distance, (self.trap_table_newpos[i] - trigger:GetOrigin()):Length2D())
		end
	end

	-- Neutral camp positions
	self.neutral = {}
	for i = 1, 8 do
		local pos = SafeGetPos("neutral_spawner_" .. i)
		if pos then
			table.insert(self.neutral, pos)
		end
	end

	-- Creep spawns
	self.good_rax_melee = SafeGetEntity("good_rax_melee_mid")
	self.good_rax_ranged = SafeGetEntity("dota_goodguys_tower3_mid")
	self.bad_rax_melee = SafeGetEntity("bad_rax_melee_mid")
	self.bad_rax_ranged = SafeGetEntity("dota_badguys_tower3_mid")

	self.good_creep_spwan = SafeGetPos("imba_radiant_creep_spawn")
	local good_path = SafeGetEntity("imba_radiant_mid_path_01")

	self.bad_creep_spwan = SafeGetPos("imba_dire_creep_spawn")
	local bad_path = SafeGetEntity("imba_dire_mid_path_01")

	local good_creep_table_1 = {"npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_ranged"}
	local good_creep_table_2 = {"npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_melee", "npc_dota_creep_goodguys_ranged", "npc_dota_goodguys_siege"}
	local bad_creep_table_1 = {"npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_ranged"}
	local bad_creep_table_2 = {"npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_melee", "npc_dota_creep_badguys_ranged", "npc_dota_badguys_siege"}

	local function SpawnWave()
		local good_level = self:GetCreepLevel(DOTA_TEAM_GOODGUYS)
		local bad_level = self:GetCreepLevel(DOTA_TEAM_BADGUYS)

		local gtable = (self.creep_level % 2 == 0) and good_creep_table_2 or good_creep_table_1
		local btable = (self.creep_level % 2 == 0) and bad_creep_table_2 or bad_creep_table_1

		for i, unit in ipairs(gtable) do
			Timers:CreateTimer(i * 1.8, function()
				self:Spawner_creep(unit, self.good_creep_spwan, good_path, DOTA_TEAM_GOODGUYS, good_level, nil)
			end)
		end

		for i, unit in ipairs(btable) do
			Timers:CreateTimer(i * 1.8, function()
				self:Spawner_creep(unit, self.bad_creep_spwan, bad_path, DOTA_TEAM_BADGUYS, bad_level, nil)
			end)
		end

		self.creep_level = self.creep_level + 1
	end

	-- 定时刷兵与机制逻辑
	Timers:CreateTimer("spawner_creep_timer", {
		useGameTime = true,
		endTime = 0,
		callback = function()
			SpawnWave()

			if self.time == 900 then
				for _, ent in ipairs(Entities:FindAllByClassname("npc_dota_neutral_spawner")) do
					UTIL_RemoveImmediate(ent)
				end
			end

			if self.time == 900 then
				for _, ent in ipairs(self.trap_table) do
					if ent and not ent:IsNull() then
						local name = ent:GetName()
						for i = 1, 4 do
							if string.find(name, "0" .. i) then
								local pos = ent:GetOrigin()
								local dir = (self.trap_table_newpos[i] - pos):Normalized()
								local distance = self.trap_distance[i] or 0
								local newPos = GetGroundPosition(pos + dir * distance, nil)
								newPos.z = 256
								ent:SetOrigin(newPos)
							end
						end
					end
				end
			end

			self.time = self.time + 30

			return 30.0
		end
	})
	print('创建泉水保护和Boss')
	-- 创建泉水保护和Boss
	self:createFountainDefence()
	print('创建泉水保护完成')
	self:SpawnBoss()
	print('创建泉水保护和Boss结束')
end
function spawner_creep:SpawnBoss()
	print('确认刷新点存在')
	if not self.roshan_spawn then
		print("[SpawnBoss] Error: Roshan spawn position is nil.")
		return
	end

	print("[SpawnBoss] Roshan spawn position: ", self.roshan_spawn)
	-- 判断是否已经存在活着的 Roshan
	if not CDOTA_PlayerResource.ROSHAN or CDOTA_PlayerResource.ROSHAN:IsNull() or not CDOTA_PlayerResource.ROSHAN:IsAlive() then
		local roshan = CreateUnitByName("npc_dota_imba_boss", self.roshan_spawn, true, nil, nil, DOTA_TEAM_NEUTRALS)
		if roshan then
			print('modifier_imba_boss Roshan')
			roshan:AddNewModifier(roshan, nil, "modifier_imba_boss", { duration = -1 })
			roshan:SetUnitCanRespawn(true)
			CDOTA_PlayerResource.ROSHAN = roshan
			print("[SpawnBoss] Roshan has been spawned successfully.")
		else
			print("[SpawnBoss] Error: Failed to create Roshan unit.")
		end
	else
		print("[SpawnBoss] Roshan already exists and is alive.")
	end
end




-- 泉水保护
function spawner_creep:createFountainDefence()
	local good = Vector(-5569, -5547, 584)
	local bad = Vector(5569, 5547, 584)

	if not CDOTAGameRules.IMBA_FOUNTAIN then
		print("[createFountainDefence] Error: IMBA_FOUNTAIN table not defined in CDOTAGameRules.")
		return
	end

	if not CDOTAGameRules.IMBA_FOUNTAIN[DOTA_TEAM_GOODGUYS] or CDOTAGameRules.IMBA_FOUNTAIN[DOTA_TEAM_GOODGUYS]:IsNull() then
		print("[createFountainDefence] Error: Good fountain is missing or invalid.")
	else
		CreateModifierThinker(
				CDOTAGameRules.IMBA_FOUNTAIN[DOTA_TEAM_GOODGUYS],
				nil,
				"modifier_home",
				{},
				good,
				DOTA_TEAM_GOODGUYS,
				false
		)
	end

	if not CDOTAGameRules.IMBA_FOUNTAIN[DOTA_TEAM_BADGUYS] or CDOTAGameRules.IMBA_FOUNTAIN[DOTA_TEAM_BADGUYS]:IsNull() then
		print("[createFountainDefence] Error: Bad fountain is missing or invalid.")
	else
		CreateModifierThinker(
				CDOTAGameRules.IMBA_FOUNTAIN[DOTA_TEAM_BADGUYS],
				nil,
				"modifier_home",
				{},
				bad,
				DOTA_TEAM_BADGUYS,
				false
		)
	end
end




--快速刷野
function spawner_creep:FastSpawnNetural(NeturalSpawner) 
	for k,v in pairs(NeturalSpawner)  do
		if not v:IsNull() then
			v:SelectSpawnType()
			v:CreatePendingUnits()
			v:CreatePendingUnits()
			v:CreatePendingUnits()
			v:CreatePendingUnits()
			v:CreatePendingUnits()
			v:CreatePendingUnits()
			v:CreatePendingUnits()
			v:CreatePendingUnits()
			v:SpawnNextBatch( false )
		end
   end
end
--刷怪等级 按顺序执行 
--远程兵营会先炸 炸了小兵等级翻倍
--近战兵营也炸了再翻12倍
--[[------------
75/900
115/1300
323/10100
------------
------------
95/1100
155/1700
467/14900
------------
------------
115/1300
195/2100
611/19700
------------]]--

function spawner_creep:GetCreepLevel(team) 	
	local level = self.creep_level
	if(team == DOTA_TEAM_GOODGUYS ) then
		
		if self.bad_rax_ranged:IsNull() then   
			level = level*4
		end
		
		if self.bad_rax_melee:IsNull() then
			level = level*2	     
		end		
	end
	if(team == DOTA_TEAM_BADGUYS) then
		if self.good_rax_ranged:IsNull() then
			level = level*4
		end
		if self.good_rax_melee:IsNull() then
			level = level*2	
		end
	end
	
	return level
end


 
--@parms 单位名字 出兵位置 路径 阵营 等级 buff
function spawner_creep:Spawner_creep(name,point,path,team,level,buff)
	
	local creep = CreateUnitByName(name,point,true,nil,nil,team)
	creep:SetMustReachEachGoalEntity(true)
    creep:SetInitialGoalEntity(path)			
	if buff ~= nil then
		--creep:AddNewModifier(creep,nil,buff,{duration = -1,level = level})
		else						
		creep:Set_HP(level*10,false)		 
		creep:SetPhysicalArmorBaseValue(20+level*1)
		creep:SetBaseMagicalResistanceValue(50)
		creep:SetBaseDamageMax(35+level*10)
		creep:SetBaseDamageMin(35+level*5)
		if string.find(name, "siege") then
			creep:SetBaseDamageMax(100+level*20)
			creep:SetBaseDamageMin(100+level*10)
			creep:SetPhysicalArmorBaseValue(20+level*5)
		end
		--creep:SetBaseMoveSpeed(creep:GetBaseMoveSpeed()+level/10)
		creep:SetMaximumGoldBounty(150+level*1.6) 
		--creep:AddNewModifier(creep,nil,"modifier_creep",{duration = -1,level = self.creep_level})
	end	
end



--野怪buff
modifier_camp_spawner=class({})
function modifier_camp_spawner:IsDebuff()
    return false
end
function modifier_camp_spawner:IsHidden()
    return true
end
function modifier_camp_spawner:IsPurgable()
    return false
end
function modifier_camp_spawner:IsPurgeException()
    return false
end
function modifier_camp_spawner:RemoveOnDeath()
    return true
end

function modifier_camp_spawner:OnDestroy()
    if IsServer() then
		for i=0,2 do
			local creep = CreateUnitByName(NEATRUAL_CREEP_TABLE[RandomInt(1,#NEATRUAL_CREEP_TABLE)],self:GetParent():GetAbsOrigin(),true,nil,nil,DOTA_TEAM_NEUTRALS)
		end
	end
end





--刷小boss
function spawner_creep:SpawnMiniBoss()			
			-- 魔方会炸
			--local miniboss_token = CreateUnitByName("npc_dota_imba_miniboss_token",self.miniboss_spawn,true,nil,nil,0)
			local miniboss = CreateUnitByName("npc_dota_imba_miniboss",self.miniboss_spawn,true,nil,nil,0)
			miniboss:AddNewModifier(miniboss,nil,"modifier_imba_miniboss",{duration = -1})							--初始buff
			miniboss:SetUnitCanRespawn(true) 
			--miniboss:AddNewModifier(miniboss,nil,"modifier_imba_miniboss_shield",{duration = -1,token = miniboss_token:entindex()})			  
end
--刷两个前哨
function spawner_creep:SpawnOutpost()
	 if self.tower_good:IsNull() and  self.tower_bad:IsNull() then
		self.outpost = CreateUnitByName("npc_dota_watch_tower",self.outpost_pos,true,nil,nil,DOTA_TEAM_BADGUYS)
		self.outpost_pos.z = 128
		self.outpost:RemoveModifierByName("modifier_invulnerable")
		self.outpost:SetAbsOrigin(self.outpost_pos)
		self.outpost:SetTeam(DOTA_TEAM_BADGUYS)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(0,0,0), 800, 99999, false)
		AddFOWViewer(DOTA_TEAM_BADGUYS, Vector(0,0,0), 800, 99999, false)
		self.outpost_oldteam = DOTA_TEAM_BADGUYS
	 end
end
function spawner_creep:SpawnMeteorite()
	if self.outpost and self.outpost:GetTeamNumber()~= 5  and not self.outpost:HasModifier("modifier_imba_miniboss_shield_pfx") then
			local pos = Vector(0,0,0)
			--print(self.bad_outpost:GetTeamNumber())
			if self.outpost:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				pos = self.bad_creep_spwan
			end
			if self.outpost:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				pos = self.good_creep_spwan
			end
			pos.z = 286
			--print("123")
			local enemies = FindUnitsInRadius(self.outpost:GetTeamNumber(), pos, nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local end_target = nil
			for _, target in pairs(enemies) do
				--print(target:GetName())
				target:EmitSound("DOTA_Item.MeteorHammer.Cast")
				end_target = target
				break
			end
			if end_target~=nil then
			
				for i=1, #CDOTA_PlayerResource.TG_HERO do
					if CDOTA_PlayerResource.TG_HERO[i] then
						local other = CDOTA_PlayerResource.TG_HERO[i]
						if other~= nil and  other:IsAlive() then
							if  not Is_Chinese_TG(self.outpost,other) then
								Notifications:Top(other:GetPlayerOwnerID(), {text="快去抢回前哨停止陨石！！", duration=2, style={color="#66ccff",["font-size"]="60px"}})		
							end
						end
					end
				end
				
				local particle3	= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(particle3, 0, Vector(0, 0, 1000)) -- 1000 feels kinda arbitrary but it also feels correct
				ParticleManager:SetParticleControl(particle3, 1, end_target:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle3, 2, Vector(0.6, 0, 0))
				ParticleManager:ReleaseParticleIndex(particle3)
				
				Timers:CreateTimer(0.6, function()
				ParticleManager:DestroyParticle(particle3, true)
				EmitSoundOnLocationWithCaster(end_target:GetAbsOrigin(), "DOTA_Item.MeteorHammer.Impact", nil)
				local hp_d = 999
				if string.find(end_target:GetName(), "_fort") then
					hp_d = 1499
				end
					if end_target:GetHealth()<=hp_d then
						end_target:Kill(nil,self.outpost)
						else
						end_target:SetHealth(math.max(1,end_target:GetHealth()-hp_d))
					end
					--陨石掉落神符
					local index = RandomInt(1,#IMBA_RUNE)
					local run = IMBA_RUNE[index]
					for i = 0,RandomInt(1,2) do
						CreateRune( pos, run )
					end
				end)
			end			
			if self.outpost_oldteam~=self.outpost:GetTeamNumber() then
				self.outpost_oldteam = self.outpost:GetTeamNumber()
				self.outpost:AddNewModifier(self.outpost,nil,"modifier_imba_miniboss_shield_pfx",{duration = 60})
			end			
	end	
end

--[[
function spawner_creep:SpawnOutpost()	
	 
	
	 self.good_outpost = CreateUnitByName("npc_dota_watch_tower",self.good_outpost_pos,true,nil,nil,0)
	 self.good_outpost_pos.z = 280
	 self.good_outpost:RemoveModifierByName("modifier_invulnerable")
	 self.good_outpost:SetAbsOrigin(self.good_outpost_pos)
	 self.bad_outpost = CreateUnitByName("npc_dota_watch_tower",self.bad_outpost_pos,true,nil,nil,0)
	 self.bad_outpost_pos.z = 280
	 self.bad_outpost:RemoveModifierByName("modifier_invulnerable")
	 self.bad_outpost:SetAbsOrigin(self.bad_outpost_pos)
end

function spawner_creep:SpawnMeteorite()
	if self.good_outpost and self.bad_outpost then
		if self.good_outpost:GetTeamNumber() == self.bad_outpost:GetTeamNumber() then
			local pos = Vector(0,0,0)
			--print(self.bad_outpost:GetTeamNumber())
			if self.good_outpost:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				pos = self.bad_creep_spwan
			end
			if self.good_outpost:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				pos = self.good_creep_spwan
			end
			pos.z = 286
			--print("123")
			local enemies = FindUnitsInRadius(self.good_outpost:GetTeamNumber(), pos, nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local end_target = nil
			for _, target in pairs(enemies) do
				--print(target:GetName())
				target:EmitSound("DOTA_Item.MeteorHammer.Cast")
				end_target = target
				break
			end
			if end_target~=nil then
			
				for i=1, #CDOTA_PlayerResource.TG_HERO do
					if CDOTA_PlayerResource.TG_HERO[i] then
						local other = CDOTA_PlayerResource.TG_HERO[i]
						if other~= nil and  other:IsAlive() then
							if  not Is_Chinese_TG(self.good_outpost,other) then
								Notifications:Top(other:GetPlayerOwnerID(), {text="快去抢回前哨停止陨石！！", duration=2, style={color="#66ccff",["font-size"]="60px"}})		
							end
						end
					end
				end
				
				local particle3	= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(particle3, 0, Vector(0, 0, 1000)) -- 1000 feels kinda arbitrary but it also feels correct
				ParticleManager:SetParticleControl(particle3, 1, end_target:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle3, 2, Vector(0.6, 0, 0))
				ParticleManager:ReleaseParticleIndex(particle3)
				
				Timers:CreateTimer(0.6, function()
				ParticleManager:DestroyParticle(particle3, true)
				EmitSoundOnLocationWithCaster(end_target:GetAbsOrigin(), "DOTA_Item.MeteorHammer.Impact", nil)
				local hp_d = 1000
				if string.find(end_target:GetName(), "_fort") then
					hp_d = 1500
				end
					if end_target:GetHealth()<=hp_d then
						end_target:Kill(nil,self.good_outpost)
						else
						end_target:SetHealth(math.max(1,end_target:GetHealth()-hp_d))
					end
					--陨石掉落神符
					local index = RandomInt(1,#IMBA_RUNE)
					local run = IMBA_RUNE[index]
					for i = 0,RandomInt(1,2) do
						CreateRune( pos, run )
					end
				end)
			end
		end	
	end
end
]]
		

--清理前哨旁边的中立装备 10分钟清理一次 并不完善 只是根据模型清理 名字太麻烦了
function spawner_creep:clearNeutralItem()
	local pos_t = {self.good_outpost_pos,self.bad_outpost_pos}
	for _,pos in pairs(pos_t) do
		local items = Entities:FindAllInSphere(pos,2000)
		for _,item in pairs(items) do
			if item  then
				if item:GetModelName()=="models/props_gameplay/neutral_box.vmdl" then
					UTIL_Remove( item )
				end
			end
		end
	end
end
							----------------------
							----------------------
								   --BOSS--
							----------------------
							----------------------



--boss普通buff 基础属性以及成长属性 和死亡事件
modifier_imba_boss=class({})
function modifier_imba_boss:IsDebuff()
    return false
end
function modifier_imba_boss:IsHidden()
    return false
end
function modifier_imba_boss:IsPurgable()
    return false
end
function modifier_imba_boss:IsPurgeException()
    return false
end
function modifier_imba_boss:RemoveOnDeath()
    return false
end

function modifier_imba_boss:GetPriority() 		return MODIFIER_PRIORITY_SUPER_ULTRA+999 end
function modifier_imba_boss:CheckState()
    return 
    {
        [MODIFIER_STATE_STUNNED] = false, 
        [MODIFIER_STATE_CANNOT_MISS] = true, 
        [MODIFIER_STATE_DISARMED] = false, 
        [MODIFIER_STATE_SILENCED] = false, 
        [MODIFIER_STATE_ROOTED] = false, 
        [MODIFIER_STATE_UNSLOWABLE] = true, 
        [MODIFIER_STATE_PASSIVES_DISABLED] = false,		
    }
end

function modifier_imba_boss:GetModifierStatusResistanceStacking() return 70 end
function modifier_imba_boss:DeclareFunctions() return
	{		
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		
	}
end



function modifier_imba_boss:GetModifierIncomingDamage_Percentage()
	return -95
end

function modifier_imba_boss:GetModifierProcAttack_BonusDamage_Magical()
	return self.attmagic*self:GetStackCount()
end

function modifier_imba_boss:GetModifierAttackSpeedBonus_Constant()
	return self.attsp*self:GetStackCount() + 75
end
function modifier_imba_boss:GetModifierConstantHealthRegen()
	return self.hp_regen*self:GetStackCount()
end

function modifier_imba_boss:OnAttackLanded(keys)
    if not IsServer() then
        return
    end
	if keys.target == self.parent then
		if (keys.attacker:GetAbsOrigin() - self.position):Length2D() > 499 then
			keys.attacker:AddNewModifier(self.parent,nil,"modifier_disarmed",{duration=1.5})
		end
		self.parent:AddNewModifier(self.parent,nil,"modifier_imba_boss_fight",{duration=5}) --战斗状态flag
	end
	if keys.attacker == self.parent and keys.target:IsIllusion() then
		TrueKill(self.parent, keys.target, nil)
	end
	if keys.attacker == self.parent then
        TG_Modifier_Num_ADD2({
            target= keys.target,
            caster=self.parent,
            ability=nil,
            modifier="modifier_imba_boss_debuff",
            init= 2,
            stack= 2,
            duration= 3,
        })
		
	end
	   
end

function modifier_imba_boss:OnCreated(keys)		
			self.level = 1
			self.buff_level = 0
			self.position = self:GetParent():GetAbsOrigin()
			self.parent = self:GetParent()		
			self.health = 8000
			self.armor = -99999
			self.attack = 75
			self.attmagic = 75
			self.hp_regen = 100
			self.attsp = 50
			self.hp_per = 0
			if IsServer() then	
				self:StartIntervalThink(1)
				self:OnRefresh()				
			end
end	

function modifier_imba_boss:OnRefresh()
	if IsServer() then
	self:SetStackCount(self.level)
		if self.parent then
			self.parent:Set_HP(3000+self.health*self.level,true)
			self.parent:SetPhysicalArmorBaseValue(self.armor)
			self.parent:SetBaseMagicalResistanceValue(0)
			self.parent:SetBaseDamageMax(self.attack*self.level)
			self.parent:SetBaseDamageMin(self.attack*self.level)
		end
	end
end



function modifier_imba_boss:OnIntervalThink()
	if IsServer() then					
		
			self.hp_per = self.parent:GetHealth()/self.parent:GetMaxHealth()
					
			if self.parent:HasModifier("modifier_imba_boss_fight") then
				
				if self.hp_per<0.30 and not self.parent:HasModifier("modifier_imba_boss_sound_cd") then
					EmitSoundOn( "TG.BOSS_DIE", self.parent )
					self.parent:AddNewModifier(self.parent,nil,"modifier_imba_boss_sound_cd",{duration = 15})
					local nearby_units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, self.position, nil, 700, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
					if #nearby_units >= 1 then
						for _,unit in pairs(nearby_units) do
							if unit ~= self.parent  then
								local Knockback ={
										  should_stun = 1.75, 
										  knockback_duration = 0.5, 
										  duration = 1.75, 
										  knockback_distance = 120,
										  knockback_height = 400,	
										  center_x =  self.position.x,	
										  center_y =  self.position.y,
										  center_z =  self.position.z,
									  }
									unit:AddNewModifier(self.parent, nil, "modifier_knockback", Knockback)
							end
						end
					end
				end
						--self.parent:AddNewModifier(self.parent,nil,"modifier_imba_boss_ex",{duration = 9})
				self.parent:AddNewModifier(self.parent,nil,"modifier_imba_boss_rage",{duration = 9})
			end
			
			if not self.parent:HasModifier("modifier_imba_boss_fight") then
				self.parent:Heal(3000,nil)
			end
	end
end


function modifier_imba_boss:OnDeath(tg)
    if not IsServer() then
        return
    end
	local pos=self:GetParent():GetAbsOrigin()
	
    if tg.unit == self:GetParent() then
		tg.unit:EmitSound("RoshanDT.Death2")
		self:StartIntervalThink(-1)
			local text = "-巨虫已被击杀-"
			Notifications:TopToAll({text = text, duration=3.0,style={color="#FFEFDB", ["font-size"]="40px", border="5px solid #FFEFDB"},continue = true})
		
		--亡语惹
		self.parent:EmitSound("Hero_Venomancer.PoisonNova")
		local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:ReleaseParticleIndex(p1)
		local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN, self.parent)
		ParticleManager:SetParticleControl(p2, 1, Vector(700, 1,700))
		ParticleManager:ReleaseParticleIndex(p2)
		local heros = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #heros>0 then
        for _, target in pairs(heros) do
				target:AddNewModifier(self.parent,nil,"modifier_imba_boss_end",{duration = 6})
        end
			if  self.level>0 then 
				
				local aegis = CreateItem("item_aegis_v2", nil, nil)
				local book = CreateItem("item_neutral_lvlup", nil, nil)
				book:SetSellable(true)
				CreateItemOnPositionSync( pos, book ) 
				local hero = tg.attacker
				for i=1, #CDOTA_PlayerResource.TG_HERO do
					if CDOTA_PlayerResource.TG_HERO[i] then
						local other = CDOTA_PlayerResource.TG_HERO[i]
						if other~= nil and  other:IsAlive() then
							if  Is_Chinese_TG(hero,other) then
								other:ModifyGold( 3500 , true, DOTA_ModifyGold_Unspecified )
								SendOverheadEventMessage(other, OVERHEAD_ALERT_GOLD, other,3500, other)
							end
						end
					end
				end
				
				--[[
				local DropInfo = GameRules.DropTable["roshan_items"]
				--改为随机掉落一个
				local ra = RandomInt(1,3)
				local happycat_items = CreateItem(DropInfo[tostring(ra)].name, nil, nil)
				CreateItemOnPositionSync(pos, happycat_items)

				if RollPseudoRandomPercentage(25,0,nil) then
					ra = RandomInt(1,3)
					happycat_items = CreateItem(DropInfo[tostring(ra)].name, nil, nil)
					CreateItemOnPositionSync(pos, happycat_items)
				end]]
				--[[
				for intI,item_name in pairs(DropInfo) do
					local happycat_items = CreateItem(item_name.name, nil, nil)
					if happycat_items then
						CreateItemOnPositionSync(pos, happycat_items)
					end
				end]]
				
				if aegis then
					CreateItemOnPositionSync(pos, aegis)
				end				
			end
--[[
			if self.level==5 then 
				local rapier_cursed = CreateItem("item_imba_rapier_cursed", nil, nil)
				if rapier_cursed then
					CreateItemOnPositionSync(pos, rapier_cursed)
				end
			end]]
			
			self.parent=self:GetParent()
			Timers:CreateTimer(120, function()
				
				Notifications:TopToAll({text="-BOSS已复活-", duration=3.0,style={color="#FFEFDB", ["font-size"]="40px", border="5px solid #FFEFDB"},continue = true})
				
				self.parent:RespawnUnit()
				self.parent:SetAbsOrigin(self.position)
				Timers:CreateTimer(1, function()
				   -- self.parent:AddNewModifier( self.parent, nil, "modifier_roshan_attribute",{})
					FindClearSpaceForUnit(  self.parent, self.parent:GetAbsOrigin(), true)
					self.level = self.level + 1
					self:OnRefresh()
					self:StartIntervalThink(1)
					
					return nil
				end)
				return nil
			end)
		end		
	end
end



--boss狂暴buff 纯增加属性
modifier_imba_boss_rage=class({})
function modifier_imba_boss_rage:IsDebuff()
    return false
end
function modifier_imba_boss_rage:IsHidden()
    return false
end
function modifier_imba_boss_rage:IsPurgable()
    return false
end
function modifier_imba_boss_rage:IsPurgeException()
    return false
end
function modifier_imba_boss_rage:RemoveOnDeath()
    return true
end

function modifier_imba_boss_rage:DeclareFunctions() return
	{		
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		--MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	}
end

function modifier_imba_boss_rage:GetModifierProcAttack_BonusDamage_Magical()
	return 10*self:GetStackCount()
end

function modifier_imba_boss_rage:GetModifierAttackSpeedBonus_Constant()
	return 10*self:GetStackCount()
end

function modifier_imba_boss_rage:GetModifierConstantHealthRegen()
	return self:GetParent():IsStunned() and 60*self:GetStackCount() or 10*self:GetStackCount()
end

--[[
function modifier_imba_boss_rage:GetModifierPhysicalArmorBonus()
	return math.min(10*self:GetStackCount(),100)
end
]]
function modifier_imba_boss_rage:GetModifierBaseAttack_BonusDamage()
	return 10*self:GetStackCount()
end
function modifier_imba_boss_rage:OnCreated()
	self:SetStackCount(1)
	self:OnRefresh()
end
function modifier_imba_boss_rage:OnRefresh()
	self:IncrementStackCount()
end

--boss战斗状态flag
modifier_imba_boss_fight=class({})

function modifier_imba_boss_fight:IsDebuff()
	return false
end

function modifier_imba_boss_fight:IsPurgable()
    return false
end

function modifier_imba_boss_fight:IsPurgeException()
    return false
end
function modifier_imba_boss_fight:IsHidden()
    return true
end
--boss残血吼叫cd
modifier_imba_boss_sound_cd=class({})

function modifier_imba_boss_sound_cd:IsDebuff()
	return false
end

function modifier_imba_boss_sound_cd:IsPurgable()
    return false
end

function modifier_imba_boss_sound_cd:IsPurgeException()
    return false
end
function modifier_imba_boss_sound_cd:IsHidden()
    return true
end

--boss被动毒
modifier_imba_boss_debuff=class({})

function modifier_imba_boss_debuff:IsDebuff()
	return true
end

function modifier_imba_boss_debuff:IsPurgable()
    return false
end

function modifier_imba_boss_debuff:IsPurgeException()
    return false
end

function modifier_imba_boss_debuff:IsHidden()
    return false
end

function modifier_imba_boss_debuff:CheckState()
    return --{[MODIFIER_STATE_PASSIVES_DISABLED] = true}
end

function modifier_imba_boss_debuff:Heal()
    return {[MODIFIER_STATE_PASSIVES_DISABLED] = true}
end

function modifier_imba_boss_debuff:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(tg.num)
end


function modifier_imba_boss_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,		
	    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_imba_boss_debuff:GetModifierHPRegenAmplify_Percentage()
	return -65
end

function modifier_imba_boss_debuff:GetModifierHealAmplify_PercentageTarget()
	return -65
end

function modifier_imba_boss_debuff:GetModifierMoveSpeedBonus_Percentage(tg)
    return math.max(0-self:GetStackCount(),-60)
end

function modifier_imba_boss_debuff:GetModifierMagicalResistanceBonus(tg)
    return 0-self:GetStackCount()
end

function modifier_imba_boss_debuff:GetModifierIncomingDamage_Percentage(tg)
    return self:GetStackCount()
end



--boss死亡大
modifier_imba_boss_end=class({})

function modifier_imba_boss_end:IsDebuff()
	return true
end

function modifier_imba_boss_end:IsPurgable()
    return true
end

function modifier_imba_boss_end:IsHidden()
    return false
end

function modifier_imba_boss_end:OnCreated()
    if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_boss_end:OnIntervalThink()
    if IsServer() then
		 local damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = self:GetParent():GetMaxHealth()*0.1,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = nil,
            }
        ApplyDamage(damageTable)
	end
end


	---------------------------------------------------
	---------------魔方 miniboss ----------------------
	---------------------------------------------------
	
modifier_imba_miniboss=class({})
function modifier_imba_miniboss:IsDebuff()
    return false
end

function modifier_imba_miniboss:IsHidden()
    return false
end

function modifier_imba_miniboss:IsPurgable()
    return false
end

function modifier_imba_miniboss:DeclareFunctions()
    return {MODIFIER_EVENT_ON_DEATH}
end

function modifier_imba_miniboss:IsPurgeException()
    return false
end

function modifier_imba_miniboss:RemoveOnDeath()
    return false
end

function modifier_imba_miniboss:OnCreated()		
	if IsServer() then
		self.position = self:GetParent():GetAbsOrigin()
		self.parent = self:GetParent()		
		self.parent:Set_HP(10000,true)
		self.parent:SetPhysicalArmorBaseValue(30)
		self.parent:SetBaseHealthRegen(0)
		self.parent:SetBaseMagicalResistanceValue(95)
		self.parent:AddNewModifier(self.parent,nil,"modifier_imba_miniboss_shield",{duration = -1})
	end		
end	
function modifier_imba_miniboss:OnDeath(tg)
	if not IsServer() then return end
	if tg.unit == self:GetParent() then
		for i =1,5 do
		   local pos = self.position+RandomVector(RandomFloat(0,700))
		   CreateRune( pos, DOTA_RUNE_BOUNTY )
		   --[[
	       local item = CreateItem("item_bag_of_gold", nil, nil)
           item:SetPurchaseTime(0)
                    local drop = CreateItemOnPositionSync( self.position, item )
					local pos = self.position+RandomVector(RandomFloat(0,700))
                    item:LaunchLoot(false, 500, 1.3, pos,nil)]]
					
		end
			CreateRune( self.position, DOTA_RUNE_SHIELD )
		local nearby_units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, self.position, nil, 1400, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES  + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		if #nearby_units >= 1 then
			for _,unit in pairs(nearby_units) do
				if unit ~= self.parent then
					local Knockback ={
							  should_stun = 2, 
							  knockback_duration = 0.5, 
							  duration = 2, 
							  knockback_distance = 800,
							  knockback_height = 400,	
							  center_x =  self.position.x,	
							  center_y =  self.position.y,
							  center_z =  self.position.z,
						  }
						unit:AddNewModifier(unit, nil, "modifier_knockback", Knockback)
				end
			end
		end
			Timers:CreateTimer(100, function()
				
				Notifications:TopToAll({text="-魔方已复活-", duration=3.0,style={color="#FFEFDB", ["font-size"]="40px", border="5px solid #FFEFDB"},continue = true})
				
				self.parent:RespawnUnit()
				self.parent:SetAbsOrigin(self.position)
				Timers:CreateTimer(1, function()
				   -- self.parent:AddNewModifier( self.parent, nil, "modifier_roshan_attribute",{})
					FindClearSpaceForUnit(  self.parent, self.parent:GetAbsOrigin(), true)					
					self.parent:AddNewModifier(self.parent,nil,"modifier_imba_miniboss_shield",{duration = -1})
					return nil
				end)
				return nil
			end)
	end
end
--魔方的护盾
modifier_imba_miniboss_shield=class({})


function modifier_imba_miniboss_shield:IsHidden()
    return false
end

function modifier_imba_miniboss_shield:IsPurgable()
    return false
end

function modifier_imba_miniboss_shield:IsPurgeException()
    return false
end
function modifier_imba_miniboss_shield:RemoveOnDeath()
    return true
end
function modifier_imba_miniboss_shield:OnCreated(keys)

	self.parent = self:GetParent()
	self.damage = 0		--承受的伤害量
	self.level = 1
	if  IsServer() then
		self.parent:AddNewModifier(self.parent,nil,"modifier_imba_miniboss_shield_pfx",{duration = -1})
		self.level = math.ceil(GameRules:GetGameTime()/60)
		self.parent:Set_HP(10000+self.level*600,true)
	end	
end


function modifier_imba_miniboss_shield:DeclareFunctions()
    return
    {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		--MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		--MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
		--MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
		
	}
end



function modifier_imba_miniboss_shield:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	
	if keys.unit == self.parent and keys.attacker:IsHero() then
		self.damage = keys.damage
		local nearby_units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, self.parent:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES  + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		if #nearby_units >= 1 then
			EmitSoundOn("Hero_Zuus.StaticField", self.parent)
			for _,unit in pairs(nearby_units) do
				if unit ~= self.parent then
					local pfx = "particles/neutral_fx/miniboss_damage_reflect_dire.vpcf"
					local fx = ParticleManager:CreateParticle(pfx, PATTACH_CUSTOMORIGIN, self.parent)
					ParticleManager:SetParticleControlEnt(fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(fx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(fx)
					local damage = math.max(self.damage/#nearby_units,self.damage/5)
					if unit:GetHealth() > damage then
						unit:SetHealth(math.max(1,unit:GetHealth() - damage))
						else
						TrueKill(self.parent, unit, nil)
					end
				end
			end
		end
	end
end
--[[
			local pfx = ParticleManager:CreateParticle("particles/world_outpost/world_outpost_dire_ambient_shockwave.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControl(pfx, 1, self:GetCaster():GetAbsOrigin())		
			ParticleManager:ReleaseParticleIndex(pfx)
			local nearby_units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, self.parent:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES  + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			if #nearby_units >= 1 then
				for _,unit in pairs(nearby_units) do
					if unit ~= self.parent then
						local Knockback ={
								  should_stun = 1, 
								  knockback_duration = 0.5, 
								  duration = 1, 
								  knockback_distance = 800,
								  knockback_height = 400,	
								  center_x =  self.parent:GetAbsOrigin().x,	
								  center_y =  self.parent:GetAbsOrigin().y,
								  center_z =  self.parent:GetAbsOrigin().z,
							  }
							unit:AddNewModifier(unit, nil, "modifier_knockback", Knockback)
							local damage = math.max(self.damage/#nearby_units,self.damage/5)
						if unit:GetHealth() > damage then
							unit:SetHealth(math.max(1,unit:GetHealth() - damage))
							else
							TrueKill(self.parent, unit, nil)
						end
					end
				end
			end
			self.damage = 0
			]]

--魔方特效
modifier_imba_miniboss_shield_pfx=class({})

function modifier_imba_miniboss_shield_pfx:IsHidden()
    return false
end

function modifier_imba_miniboss_shield_pfx:IsPurgable()
    return false
end

function modifier_imba_miniboss_shield_pfx:IsPurgeException()
    return false
end
function modifier_imba_miniboss_shield_pfx:RemoveOnDeath()
    return true
end
function modifier_imba_miniboss_shield_pfx:CheckState()
    return {[MODIFIER_STATE_INVULNERABLE] = true}
end


function modifier_imba_miniboss_shield_pfx:OnCreated()
    if IsServer() then
		local pfx = "particles/neutral_fx/miniboss_shield_dire.vpcf"
		local pos=self:GetParent():GetAbsOrigin()
		self.statu_fx= ParticleManager:CreateParticle(pfx, PATTACH_CUSTOMORIGIN_FOLLOW ,self:GetParent())
		ParticleManager:SetParticleControl(self.statu_fx, 0,Vector(pos.x,pos.y,pos.z+100))
		ParticleManager:SetParticleControl(self.statu_fx, 1,Vector(pos.x,pos.y,pos.z+100))
		ParticleManager:SetParticleControl(self.statu_fx, 5,Vector(pos.x,pos.y,pos.z+100))
		self:AddParticle( self.statu_fx, false, false, 20, false, false )
	end
end



function modifier_imba_miniboss_shield_pfx:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.statu_fx,false)
		

		local pfx = "particles/neutral_fx/miniboss_death_dire.vpcf"
		local pfx2 = "particles/world_outpost/world_outpost_dire_ambient_shockwave.vpcf"

		local fx = ParticleManager:CreateParticle(pfx, PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(fx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(fx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(fx)
		if pfx2 ~= nil then
		--print("特效2")
			local pos = self:GetParent():GetAbsOrigin()
			local fx2 = ParticleManager:CreateParticle(pfx2, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(fx2, 1, Vector(pos.x,pos.y,pos.z+300))		
			ParticleManager:ReleaseParticleIndex(fx2)
		end
		self:GetParent():EmitSound("Hero_Phoenix.SuperNova.Explode")
	end	
end



 
function spawner_creep:SpawnMiniTorrent()			
			-- 魔方会炸
			CreateModifierThinker(nil, nil, "modifier_mini_torrent", {duration=RandomInt(1, 6)}, self.miniboss_spawn, 1, false)
			--miniboss:AddNewModifier(miniboss,nil,"modifier_imba_miniboss_shield",{duration = -1,token = miniboss_token:entindex()})			  
end

modifier_mini_torrent=class({})

function modifier_mini_torrent:IsHidden()
	return true
end

function modifier_mini_torrent:IsPurgable()
	return false
end

function modifier_mini_torrent:IsPurgeException()
	return false
end

function modifier_mini_torrent:GetPriority()
	return 10
end

function modifier_mini_torrent:OnCreated()
    if not IsServer() then
        return
    end
    local particle= ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf", PATTACH_ABSORIGIN,self:GetParent())
    ParticleManager:SetParticleControl(particle, 0,self:GetParent():GetAbsOrigin())
    self:AddParticle(particle, false, false, 20, false, false)
end


function modifier_mini_torrent:OnDestroy()
    if not IsServer() then
        return
    end
    EmitSoundOnLocationForAllies(self:GetParent():GetAbsOrigin(), "Ability.Torrent", self:GetParent())
    local particle1 = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_CUSTOMORIGIN,nil)
    ParticleManager:SetParticleControl(particle1, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle1)
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        200,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false)
    if #heros>0 then
        for _, hero in pairs(heros) do
                    local Knockback ={
                    should_stun = 1,
                    knockback_duration = 1,
                    duration = 1,
                    knockback_distance = 0,
                    knockback_height = 400,
                    center_x =  hero:GetAbsOrigin().x,
                    center_y =  hero:GetAbsOrigin().y,
                    center_z =  hero:GetAbsOrigin().z
                }
                hero:AddNewModifier(self:GetParent(),self:GetAbility(), "modifier_knockback", Knockback)
        end
    end
	if RollPseudoRandomPercentage(25,0,self) then
		if RollPseudoRandomPercentage(15,0,self) then
				for i = 1, RandomInt(3, 10) do
					self:torrent_drop("item_bag_of_gold",true)
				end
			else
				for i = 1, RandomInt(1, 3) do
					self:torrent_drop("item_bag_of_gold",true)
				end
		end
		else
		if RollPseudoRandomPercentage(80,0,self) then
				self:torrent_drop("item_bag_of_gold",true)
			else
				self:torrent_drop("item_gift",false)
		end
	end	
	
	if RollPseudoRandomPercentage(1,0,self) and math.ceil(GameRules:GetGameTime()/60)>10 then
		self:torrent_drop("item_rd_bookfun",false)
	end
	
	if RollPseudoRandomPercentage(3,0,self) then
			self:torrent_drop("item_neutral_lvlup",true)
	end
	
	local a = RandomInt(1, 200)
	local b = RandomInt(1, 200)
	if a == b and math.ceil(GameRules:GetGameTime()/60)>10 then
		self:torrent_drop("item_imba_rapier_cursed",false)
	end
end

function modifier_mini_torrent:torrent_drop(name,sell)
		local coin = CreateItem(name, nil, nil)
        coin:SetPurchaseTime(0)
		coin:SetSellable(sell)
        local pos =  self:GetParent():GetAbsOrigin()
        local drop = CreateItemOnPositionSync( pos, coin ) 
        local pos_launch = pos
        coin:LaunchLoot(false, 500, 1, pos_launch + RandomVector(math.random(200,300)),nil)
end