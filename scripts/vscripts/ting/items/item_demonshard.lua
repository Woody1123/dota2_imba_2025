
item_demonshard = class({})
LinkLuaModifier("modifier_demonshard_passive", "ting/items/item_demonshard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demonshard_passive_test", "ting/items/item_demonshard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demonshard_motion", "ting/items/item_demonshard", LUA_MODIFIER_MOTION_NONE)
function item_demonshard:GetIntrinsicModifierName() return "modifier_demonshard_passive" end
function item_demonshard:IsRefreshable() return false end

function item_demonshard:OnSpellStart()
	local caster = self:GetCaster()
	local max_dis = 1200--self:GetSpecialValueFor("toss_dis") + caster:GetCastRangeBonus()
	local dur = 1--self:GetSpecialValueFor("duration")
	local stun_dur = 1--self:GetSpecialValueFor("stun_duration")
	local pos = self:GetCursorPosition()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local height = 700
	local distance = (pos - caster:GetAbsOrigin()):Length2D() + height/2
	local tralve_duration = 0.9


	--print(caster:GetAttackSpeed(true))
	--print(caster:GetAttackSpeed(false))
	
	
	--print(caster:GetIncreasedAttackSpeed(false))
	--print(caster:GetIncreasedAttackSpeed(true))
	--GetIncreasedAttackSpeed
		--caster:AddNewModifier(caster, self, "modifier_demonshard_motion", {duration = tralve_duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z, dis = distance,height = height ,damage = 1 ,impact_radius = 300})

--[[

	end]]
	--print(self:GetCaster():GetOrigin())
	local ab = self:GetCaster():AddAbility("ra_powanfa")
	ab:SetLevel(4)
	--self:GetCaster():SetMaxHealth(20000)
	--[[
	local tab = {"serpent_ward",
  "silencer_global_silence",
  "imba_tidehunter_ravage",
  "stampede"}
	for _,n in pairs(tab) do
		local ab = self:GetCaster():AddAbility()
	ab:SetLevel(4)
	end
	]]
	--self:GetCaster():AddAbility("test_vector_targeting_lua")
		local mod = self:GetCaster():FindModifierByName("modifier_seasonal_party_hat")
		if mod then
			print("季节"..tostring(mod:GetParent():GetName()))
		end
		 local t1 =GetSystemTimeMS()
	--for i =1,100 do
		--self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_demonshard_passive_test",{duration = 10})
		
		--local enemy_hero = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
	--self:GetCaster():GetAbsOrigin(), nil, 1600, 
	--DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_ANY_ORDER, false)
	--end
	--[[
	local tar = self:GetCursorTarget()
		for i =1,200 do
		self:GetCaster():PerformAttack(tar, true, true, true, false, false, false, true)
		end
	    local t2 =GetSystemTimeMS()
		local t3 = t2 - t1
		GameRules:SendCustomMessage("time:"..t3, DOTA_TEAM_GOODGUYS, 0)
		]]
      -- print(string.format("time: %.10f\n", t2 - t1))
end



modifier_demonshard_passive = class({})

function modifier_demonshard_passive:IsDebuff()			return false end
function modifier_demonshard_passive:IsHidden() 			return false end
function modifier_demonshard_passive:IsPurgable() 		return false end
function modifier_demonshard_passive:DeclareFunctions() return {MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,MODIFIER_PROPERTY_PROCATTACK_CONVERT_PHYSICAL_TO_MAGICAL,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,MODIFIER_PROPERTY_HEALTH_BONUS} end
function modifier_demonshard_passive:GetModifierProcAttack_ConvertPhysicalToMagical()
	return 0
end

function modifier_demonshard_passive:GetModifierHealthBonus() 
		return 1
end
function modifier_demonshard_passive:GetModifierIncomingDamage_Percentage() 
		return 0
end
function modifier_demonshard_passive:GetModifierPercentageRespawnTime()
		return -90
end

function modifier_demonshard_passive:OnCreated()
	self.hp = 100
	self:SetStackCount(100)
end


modifier_demonshard_passive_test = class({})
function modifier_demonshard_passive_test:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_demonshard_passive_test:IsDebuff()			return false end
function modifier_demonshard_passive_test:AllowIllusionDuplicate()			return false end
function modifier_demonshard_passive_test:IsHidden() 			return false end
function modifier_demonshard_passive_test:IsPurgable() 		return true end
function modifier_demonshard_passive_test:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,MODIFIER_PROPERTY_HEALTH_BONUS} end
function modifier_demonshard_passive_test:GetModifierHealthBonus() 
		return 1
end
function modifier_demonshard_passive_test:OnCreated()
		if IsServer() then
			self:GetCaster():AddActivityModifier("tide_2022_taunt")
			--self:GetCaster():AddActivityModifier("dive")
			self:GetCaster():StartGesture(ACT_DOTA_TAUNT)
		end
end
function modifier_demonshard_passive_test:OnDestroy()
	if IsServer() then
	self:GetCaster():ClearActivityModifiers()
	end
end

modifier_demonshard_motion = class({})

function modifier_demonshard_motion:IsDebuff()			return false end
function modifier_demonshard_motion:IsHidden() 			return true end
function modifier_demonshard_motion:IsPurgable() 		return false end
function modifier_demonshard_motion:IsPurgeException() 	return false end

function modifier_demonshard_motion:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end


function modifier_demonshard_motion:IsMotionController() return true end
function modifier_demonshard_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_demonshard_motion:OnCreated(keys)
	if IsServer() then
				self:GetCaster():AddActivityModifier("tide_2022_taunt")
			--self:GetCaster():AddActivityModifier("dive")
			self:GetCaster():StartGesture(ACT_DOTA_TAUNT)
		if self:CheckMotionControllers() then
			self.impact_radius = keys.impact_radius
			--print(self.impact_radius)
			self.duration = keys.duration
			self.damage = keys.damage 
			self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
			self.dis = keys.dis
			local dis_t =(self.dis/self.duration)
			self.distance = dis_t*FrameTime()
			self.height = keys.height
			self.dist_a = 0
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
			
		else
			self:Destroy()
		end
	end
end

function modifier_demonshard_motion:OnIntervalThink()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local distance = self.distance
	local direction = (self.pos - self:GetParent():GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + direction * distance, nil)
	next_pos.z = next_pos.z - 2 * self.height * motion_progress ^ 2 + 2 * self.height * motion_progress
	self:GetParent():SetOrigin(next_pos)
end

function modifier_demonshard_motion:OnDestroy()
	if IsServer() then
		self.pos = nil
		self.height = nil
		self:GetCaster():ClearActivityModifiers()
		EmitSoundOn("Ability.TossImpact", self:GetParent())
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
end