modifier_dummy_thinker = class({})

function modifier_dummy_thinker:IsDebuff()			return false end
function modifier_dummy_thinker:IsHidden() 			return true end
function modifier_dummy_thinker:IsPurgable() 		return false end
function modifier_dummy_thinker:IsPurgeException() 	return false end
function modifier_dummy_thinker:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end

--[[
	@params:
	string: destroy_sound
	string: create_sound
]]

function modifier_dummy_thinker:OnCreated(keys)
	if IsServer() and IsInToolsMode() and self:GetParent():GetName() == "npc_dota_thinker" then
		self:StartIntervalThink(0.3)
		self:OnIntervalThink()
	end
	if IsServer() then
		self.kvtable = keys
		if self.kvtable.create_sound then
			self:GetParent():EmitSound(self.kvtable.create_sound)
		end
	end
end

function modifier_dummy_thinker:OnIntervalThink()
	DebugDrawCircle(self:GetParent():GetAbsOrigin(), Vector(255,0,0), 100, 50, true, 0.3)
	if self:GetAbility() then
		DebugDrawText(self:GetParent():GetAbsOrigin(), self:GetAbility():GetAbilityName(), false, 0.3)
	end
end

function modifier_dummy_thinker:OnDestroy()
	if IsServer() then
		if self.kvtable.destroy_sound then
			self:GetParent():EmitSound(self.kvtable.destroy_sound)
		end
		self.kvtable = nil
		self:GetParent():RemoveSelf()
	end
end

-- DO NO THING

modifier_imba_base_protect = class({})

function modifier_imba_base_protect:IsDebuff()			return false end
function modifier_imba_base_protect:IsHidden() 			return true end
function modifier_imba_base_protect:IsPurgable() 		return false end
function modifier_imba_base_protect:IsPurgeException() 	return false end
function modifier_imba_base_protect:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end

function modifier_imba_base_protect:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_base_protect:OnIntervalThink()
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if #units>0 then
		for _, unit in pairs(units) do
			if not unit:IsControllableByAnyPlayer() then
				unit:ForceKill(false)
			end
		end
	end
end

modifier_imba_t2_tower_vision = class({})

function modifier_imba_t2_tower_vision:IsDebuff()			return false end
function modifier_imba_t2_tower_vision:IsHidden() 			return true end
function modifier_imba_t2_tower_vision:IsPurgable() 		return false end
function modifier_imba_t2_tower_vision:IsPurgeException() 	return false end

function modifier_imba_t2_tower_vision:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_t2_tower_vision:OnIntervalThink()
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if self:GetParent():IsAlive() then
			AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 1400, 1, false)
		else
			self:Destroy()
		end
	end
end
modifier_imba_test_1 = class({})
function modifier_imba_test_1:DeclareFunctions()
    return { MODIFIER_PROPERTY_CASTTIME_PERCENTAGE }
end
function modifier_imba_test_1:GetModifierPercentageCasttime()
    return 200
end

modifier_imba_test = class({})
function modifier_imba_test:IsDebuff()			return false end
function modifier_imba_test:IsHidden() 			return true end
function modifier_imba_test:IsPurgable() 		return false end
function modifier_imba_test:IsPurgeException() 	return false end

function modifier_imba_test:OnCreated()
	if IsServer() then
		self.item = true
		self.item_1 = 
		{
			"item_imba_greatwyrm_plate",
			"item_nullifier_v2",
			"item_desolator_v2",
			"item_red_cape",
			"item_premium_phase_boots",
			"item_greater_crit_v2",
			"item_bloodthorn_v2",
			"item_sheepstick_v2",
			"item_monkey_king_bar_v2",
			"item_bkbs",
			"item_greaves_v2",
			"item_veil_of_evil",
			"item_four_knives",

		}
		
		self.time = 0
		self.time2 = 0
		self:StartIntervalThink(1)
	end
end
function modifier_imba_test:OnIntervalThink()
	if TESTAI or TESTAI == nil then
		return
	end
	local all_hero = HeroList:GetAllHeroes()
	if self.time2 > 3 then
		for i=1 ,#all_hero do
			all_hero[i]:MoveToPositionAggressive(Vector(0,0,0))
			all_hero[i]:AddNewModifier(nil, nil, "modifier_imba_test_1", {duration = -1})
			if self.item then
				for o = 1 , 4 do
					local ran = math.random(1,#self.item_1)
					all_hero[i]:AddItemByName(self.item_1[ran])
				end
			end
			FindClearSpaceForUnit(all_hero[i], GetRandomPosition2D(Vector(0,0,0),800), false)
		end
		self.time2 = 0
	end
	SendToServerConsole("respawn")
	for i=1 ,#all_hero do
		Timers:CreateTimer(FrameTime()*i*RandomInt(2,8) , function()
			if not (all_hero[i] ~= nil and all_hero[i]:IsNull() == false and all_hero[i]:IsAlive()) then return end
			all_hero[i]:Heal(10000, nil)
			all_hero[i]:SetMana(10000)
			
			HeroMaxLevel(all_hero[i])
			-- for k=1,30 do
			-- 	all_hero[i]:HeroLevelUp(true)
			-- end
			for k = 0, 23 do
				Timers:CreateTimer(FrameTime()*k*RandomInt(3,10) , function()
					if not (all_hero[i] ~= nil and all_hero[i]:IsNull() == false and all_hero[i]:IsAlive()) then return end
					local current_ability = all_hero[i]:GetAbilityByIndex(k)
					if current_ability then
						if bit.band(current_ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_NO_TARGET ) == DOTA_ABILITY_BEHAVIOR_NO_TARGET  and current_ability:IsCooldownReady() then
							all_hero[i]:CastAbilityNoTarget(current_ability, all_hero[i]:GetPlayerOwnerID())
						elseif bit.band(current_ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET  and current_ability:IsCooldownReady() then
							all_hero[i]:CastAbilityOnTarget(all_hero[math.random(1,#all_hero) ],current_ability, all_hero[i]:GetPlayerOwnerID())
						elseif bit.band(current_ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_POINT ) == DOTA_ABILITY_BEHAVIOR_POINT  and current_ability:IsCooldownReady() then
							all_hero[i]:CastAbilityOnPosition(GetRandomPosition2D(Vector(0,0,0),800),current_ability, all_hero[i]:GetPlayerOwnerID())
						elseif bit.band(current_ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_TOGGLE ) == DOTA_ABILITY_BEHAVIOR_TOGGLE  and current_ability:IsCooldownReady() then
							all_hero[i]:CastAbilityToggle(current_ability, all_hero[i]:GetPlayerOwnerID())
						end
					end
				return nil
				end)
			end
			return nil
		end)
	end
	if self.time > 10 then
		for i=1 ,#all_hero do
			for o = 0,8 do 
				if all_hero[i]:GetItemInSlot(o) ~= nil then
					all_hero[i]:RemoveItem(all_hero[i]:GetItemInSlot(o))
				end
			end
			for k = 0, 23 do
				local current_ability = all_hero[i]:GetAbilityByIndex(k)
				if current_ability then
					current_ability:EndCooldown()
				end
			end
		end
		
		self.time = 0
	end
	self.time2 = self.time2 + 1
	self.time = self.time + 1
	-- self.item = false
end