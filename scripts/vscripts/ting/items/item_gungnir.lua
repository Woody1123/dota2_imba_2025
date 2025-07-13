item_imba_gungnir = class({})

LinkLuaModifier("modifier_imba_gungnir_force_ally", "ting/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gungnir_range", "ting/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gungnir_fow_position", "ting/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gungnir_buff", "ting/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_imba_gungnir_asp", "ting/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gungnir_passive", "ting/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gungnir_extr", "ting/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)

function item_imba_gungnir:GetIntrinsicModifierName()
	return "modifier_imba_gungnir_passive"
end

--[[
function item_imba_gungnir:CastFilterResultTarget(target)
	if self:GetCaster() == target or target:HasModifier("modifier_imba_gyrocopter_homing_missile") then
		return UF_SUCCESS
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_CUSTOM, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, self:GetCaster():GetTeamNumber())
	end
end

function item_imba_gungnir:GetCastRange(location, target)
	if not target or target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self:GetSpecialValueFor("cast_range_enemy")
	end
end
]]
function item_imba_gungnir:OnSpellStart()
	if not IsServer() then return end
	
	local ability = self
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local tar_pos = self:GetCursorPosition()
	local duration = ability:GetSpecialValueFor("duration")
	if target~=nil and not target:IsMagicImmune() then
		if caster:GetTeamNumber() == target:GetTeamNumber() then
			EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
			target:AddNewModifier(caster, ability, "modifier_imba_gungnir_force_ally", {duration = duration,tar = 1})
		else
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
			target:AddNewModifier(caster, ability, "modifier_imba_gungnir_force_ally", {duration = duration,tar = 2})
			caster:AddNewModifier(target, ability, "modifier_imba_gungnir_force_ally", {duration = duration,tar = 2})
			target:AddNewModifier(caster, ability, "modifier_imba_gungnir_fow_position", {duration = ability:GetSpecialValueFor("range_duration")})
			--射程buff 
			local buff = caster:AddNewModifier(caster, ability, "modifier_imba_gungnir_range", {duration = ability:GetSpecialValueFor("range_duration")})
			buff.target = target
			buff:SetStackCount(ability:GetSpecialValueFor("max_attacks"))
					
			--[[
			local buff3 = caster:AddNewModifier(caster, ability, "modifier_imba_gungnir_asp", {duration = ability:GetSpecialValueFor("range_duration")})
			buff3.target = target
			buff3:SetStackCount(ability:GetSpecialValueFor("max_attacks"))]]
			--caster:AddNewModifier(caster, ability, "modifier_imba_gungnir_buff", {duration = ability:GetSpecialValueFor("range_duration")})
			EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
			EmitSoundOn("DOTA_Item.ForceStaff.Activate", self:GetCaster())
		end
		else
			if target~= nil and target:IsMagicImmune() then
				tar_pos = (self:GetCaster():GetAbsOrigin() - tar_pos):Normalized()*10000
			end
			local dummy = CreateUnitByName("npc_dummy_unit", tar_pos, false, nil, nil, self:GetCaster():GetTeamNumber())
			dummy:SetOrigin(tar_pos)
			dummy:AddNewModifier(dummy, nil, "modifier_kill", {duration = 2})
			dummy:AddNewModifier(dummy, nil, "modifier_unit_remove", {duration = 2})
			caster:AddNewModifier(dummy, ability, "modifier_imba_gungnir_force_ally", {duration = duration,tar = 3})
	end
end

modifier_imba_gungnir_passive = class({})
LinkLuaModifier("modifier_imba_gungnir_nerf", "ting/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_gungnir_passive:IsDebuff()			return false end
function modifier_imba_gungnir_passive:IsHidden() 			return true end
function modifier_imba_gungnir_passive:IsPurgable() 		return false end
function modifier_imba_gungnir_passive:IsPurgeException() 	return false end
function modifier_imba_gungnir_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,MODIFIER_EVENT_ON_ATTACK_FAIL,MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,MODIFIER_PROPERTY_STATS_AGILITY_BONUS,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_HEALTH_BONUS}end
function modifier_imba_gungnir_passive:GetModifierBonusStats_Intellect() return self.int end
function modifier_imba_gungnir_passive:GetModifierBonusStats_Agility() return self.agi end
function modifier_imba_gungnir_passive:GetModifierBonusStats_Strength() return self.str end
function modifier_imba_gungnir_passive:GetModifierProjectileSpeedBonus() return self.project_speed end
function modifier_imba_gungnir_passive:GetModifierProcAttack_BonusDamage_Pure() return self.pure end
function modifier_imba_gungnir_passive:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() and not self:GetParent():HasModifier("modifier_item_hurricane_pike") and not self:GetParent():HasModifier("modifier_item_dragon_lance")then
		return self.ran
	end
end
function modifier_imba_gungnir_passive:OnAttackFail(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() or self:GetParent():IsIllusion() or not (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		return
	end
	keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_imba_gungnir_buff", {duration = self.duration_pa})
	--keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_imba_gungnir_extr", {duration = self.duration_pa})
end

function modifier_imba_gungnir_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.parent = self:GetParent()
	self.int = self:GetAbility():GetSpecialValueFor("stat")
	self.project_speed = self:GetAbility():GetSpecialValueFor("project_speed_bonus")
	self.str = self:GetAbility():GetSpecialValueFor("stat")
	self.agi = self:GetAbility():GetSpecialValueFor("stat")
	self.ran = self:GetAbility():GetSpecialValueFor("ran")
	self.pure = self:GetAbility():GetSpecialValueFor("pure_pass")
	self.duration_pa = self:GetAbility():GetSpecialValueFor("duration_pa")
	self.cd = false
	if IsServer() then
		self:StartIntervalThink(2.5)
	end
end

function modifier_imba_gungnir_passive:OnIntervalThink()
	if IsServer() then
		self.parent:RemoveModifierByName("modifier_imba_gungnir_extr")
		self.parent:AddNewModifier(self.parent,self:GetAbility(),"modifier_imba_gungnir_extr",{duration=2.5})
	end
end



modifier_imba_gungnir_extr = class({})

function modifier_imba_gungnir_extr:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_gungnir_extr:IsDebuff() return false end
function modifier_imba_gungnir_extr:IsHidden() return true end
function modifier_imba_gungnir_extr:IsPurgable() return false end
function modifier_imba_gungnir_extr:GetTexture()			
    return "item_gungnir"
end
function modifier_imba_gungnir_extr:DeclareFunctions() 
	return 
		{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		}
		end
function modifier_imba_gungnir_extr:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_imba_gungnir_extr:GetModifierAttackRangeBonus()
	return self.range--self.ar
end		

function modifier_imba_gungnir_extr:OnCreated()
	if IsServer() then
		if self:GetAbility()==nil then return end
		self.parent = self:GetParent()
		self.attack_speed = math.max(900-self.parent:GetDisplayAttackSpeed(),100)
		self.count = self:GetAbility():GetSpecialValueFor("ex_count")
		self.range = self:GetAbility():GetSpecialValueFor("ex_range")
		self.cd = self:GetAbility():GetSpecialValueFor("ex_cd")
		self:OnRefresh()
	end
end
function modifier_imba_gungnir_extr:OnRefresh()
	if IsServer() then
		local count = RandomInt(1, self.count)
		self.num = count
	end
end
function modifier_imba_gungnir_extr:OnAttack( keys )
	if not IsServer() then return end
	if keys.attacker == self:GetParent() then
		if self.num > 1 then
			self.num = self.num - 1
		else
			self:Destroy()
		end
	end
end




modifier_imba_gungnir_force_ally = class({})

function modifier_imba_gungnir_force_ally:IsDebuff() return false end
function modifier_imba_gungnir_force_ally:IsHidden() return true end
function modifier_imba_gungnir_force_ally:IsPurgable() return false end

function modifier_imba_gungnir_force_ally:OnCreated(params)
	if self:GetAbility() == nil then return end
	if not IsServer() then return end
	--对时间结界，决斗或黑洞内的单位无效。
	if self:GetParent():HasModifier("modifier_imba_legion_commander_duel") or self:GetParent():HasModifier("modifier_black_hole_debuff2") or self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_debuff") or self:GetParent():HasModifier("modifier_seer_vacuum_m") then
		self:Destroy()
		return
	end
	--特效
	local pfx_name = "particles/econ/events/fall_2021/force_staff_fall_2021.vpcf"
	
	self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
		--	self.distance = self:GetAbility():GetSpecialValueFor("push_length")
	--kv
	if params.tar == 1 then 
		self.angle = self:GetParent():GetForwardVector()
		self.distance = self:GetAbility():GetSpecialValueFor("push_length")
	end
	if params.tar == 2 then
		self.angle = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
		self.distance = self:GetAbility():GetSpecialValueFor("enemy_length")
	end
	if params.tar == 3 then	
		self.angle = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()*-1
		self.distance = self:GetAbility():GetSpecialValueFor("push_length")
	end
	--speed
	self.force_pos = GetGroundPosition(( self:GetParent():GetAbsOrigin() + self.angle * self.distance ), nil)
	self.speed = self.distance / self:GetDuration()
	self.dis = self.speed*FrameTime()
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_gungnir_force_ally:OnIntervalThink()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local distance = self.distance
	local direction = (self.force_pos - self:GetParent():GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + direction * self.dis, nil)
	self:GetParent():SetOrigin(next_pos)
	GridNav:DestroyTreesAroundPoint(next_pos, 150, false)
end

function modifier_imba_gungnir_force_ally:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	--over motion

	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	--remove kv
	self.pfx = nil 
	self.angle = nil 
	self.distance = nil 
	self.force_pos = nil 
	self.speed = nil
end



function modifier_imba_gungnir_force_ally:CheckState()
	if Is_Chinese_TG(self:GetParent(),self:GetCaster()) then
		local state =
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_STUNNED] = true,
		}
	return state
	end
	return
end

--无视距离数次攻击目标
modifier_imba_gungnir_range = class({})
function modifier_imba_gungnir_range:IsDebuff() return false end
function modifier_imba_gungnir_range:IsHidden() return false end
function modifier_imba_gungnir_range:IsPurgable() return false end
function modifier_imba_gungnir_range:IsStunDebuff() return false end
function modifier_imba_gungnir_range:IgnoreTenacity() return true end
function modifier_imba_gungnir_range:GetEffectName() 
    return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf" 
end
function modifier_imba_gungnir_range:GetTexture()			
    return "item_gungnir"
end
function modifier_imba_gungnir_range:OnCreated()
	if self:GetAbility() == nil then return end
	if not IsServer() then return end
	self.ar = 0
	self.as = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_gungnir_range:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():GetAttackTarget() == self.target then
		if self:GetParent():IsRangedAttacker() then
			self.ar = 999999
		end
	else
		self.ar = 0
	end
end

function modifier_imba_gungnir_range:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,}
	return decFuncs
end

function modifier_imba_gungnir_range:GetModifierAttackSpeedBonus_Constant()
	return self.as
end

function modifier_imba_gungnir_range:GetModifierAttackRangeBonus()
	if not IsServer() then return end
	return self.ar
end

function modifier_imba_gungnir_range:OnAttack( keys )
	if not IsServer() then return end
	if keys.target == self.target and keys.attacker == self:GetParent() then
		if self:GetStackCount() > 1 then
			self:DecrementStackCount()
		else
			--keys.attacker:RemoveModifierByName("modifier_imba_gungnir_buff")
			self:Destroy()
		end
	end
end

function modifier_imba_gungnir_range:OnOrder( keys )
	if not IsServer() then return end
	
	if keys.target == self.target and keys.unit == self:GetParent() and keys.order_type == 4 then
		if self:GetParent():IsRangedAttacker() then
			self.ar = 999999
		end		
	end
end
--获得敌人视野
modifier_imba_gungnir_fow_position = class({})
function modifier_imba_gungnir_fow_position:IsDebuff()			return true end
function modifier_imba_gungnir_fow_position:IsHidden() 			return true end
function modifier_imba_gungnir_fow_position:IsPurgable() 			return false end
function modifier_imba_gungnir_fow_position:IsPurgeException() 	return true end
function modifier_imba_gungnir_fow_position:CheckState() 			return {[MODIFIER_STATE_PROVIDES_VISION] = true} end
function modifier_imba_gungnir_fow_position:DeclareFunctions() return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_imba_gungnir_fow_position:GetModifierProvidesFOWVision() return 1 end


modifier_imba_gungnir_buff = class({})
function modifier_imba_gungnir_buff:IsDebuff()			return false end
function modifier_imba_gungnir_buff:IsHidden() 			return false end
function modifier_imba_gungnir_buff:IsPurgable() 			return false end
function modifier_imba_gungnir_buff:IsPurgeException() 	return true end
function modifier_imba_gungnir_buff:GetEffectName() return "particles/units/heroes/hero_silencer/silencer_last_word_status_ring_ember.vpcf" end
function modifier_imba_gungnir_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_gungnir_buff:GetTexture()			
    return "item_imba_gungnir"
end
function modifier_imba_gungnir_buff:DeclareFunctions() return {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE} end
function modifier_imba_gungnir_buff:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true} end
function modifier_imba_gungnir_buff:GetModifierProcAttack_BonusDamage_Pure() return self.pure end
function modifier_imba_gungnir_buff:OnCreated()
	if self:GetAbility() == nil then return end
	self.pure = self:GetAbility():GetSpecialValueFor("pure_damage")
end
--[[
modifier_imba_gungnir_asp = class({})
function modifier_imba_gungnir_asp:IsDebuff()			return false end
function modifier_imba_gungnir_asp:IsHidden() 			return false end
function modifier_imba_gungnir_asp:IsPurgable() 			return false end
function modifier_imba_gungnir_asp:IsPurgeException() 	return false end
function modifier_imba_gungnir_asp:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_gungnir_asp:GetEffectName() 
    return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf" 
end
function modifier_imba_gungnir_asp:GetTexture()			
    return "item_gungnir"
end
function modifier_imba_gungnir_asp:OnCreated()
	if self:GetAbility() == nil then return end
	self.as = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.dur = self:GetAbility():GetSpecialValueFor("sil_dur")
end
function modifier_imba_gungnir_asp:GetModifierAttackSpeedBonus_Constant()
	return self.as
end
function modifier_imba_gungnir_asp:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and keys.target == self.target and not self.target:IsMagicImmune() and self:GetStackCount() ~= 0 then
	
		if self:GetStackCount() > 0 then 
			self:DecrementStackCount()
		else
			self:SetStackCount(0) 
			keys.attacker:RemoveModifierByName("modifier_imba_gungnir_buff")
		end
	end	
end
]]
		