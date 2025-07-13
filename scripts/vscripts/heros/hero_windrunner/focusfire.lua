
focusfire=class({})
LinkLuaModifier("modifier_focusfire_att", "heros/hero_windrunner/focusfire.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_focusfire_passive", "heros/hero_windrunner/focusfire.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_focusfire_buff", "heros/hero_windrunner/focusfire.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_focusfire_debuff", "heros/hero_windrunner/focusfire.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_focusfire_cd", "heros/hero_windrunner/focusfire.lua", LUA_MODIFIER_MOTION_NONE)


function focusfire:IsHiddenWhenStolen()
    return false
end

function focusfire:IsStealable()
    return true
end


function focusfire:GetIntrinsicModifierName()
    return "modifier_focusfire_passive"
end

function focusfire:OnSpellStart()
	EmitSoundOn("Ability.Windrun", self:GetCaster())
    self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_focusfire_buff",{duration = self:GetSpecialValueFor("dur")})
end

modifier_focusfire_buff = class({})
function modifier_focusfire_buff:IsPassive()
	return true
end

function modifier_focusfire_buff:IsPurgable()
    return false
end

function modifier_focusfire_buff:IsPurgeException()
    return false
end
function modifier_focusfire_buff:RemoveOnDeath()
    return true
end
function modifier_focusfire_buff:IsHidden()
    return false
end
function modifier_focusfire_buff:GetEffectAttachType()				
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_focusfire_buff:GetEffectName()				
    return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_focusfire_wind_tube_pnt.vpcf" 
end
function modifier_focusfire_buff:GetModifierProjectileName()
    return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_focusfire_attack.vpcf"
end
function modifier_focusfire_buff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_PROJECTILE_NAME,		
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,	
	}
end


function modifier_focusfire_buff:GetModifierMoveSpeedBonus_Constant()
	return self.msp
end
function modifier_focusfire_buff:GetModifierAttackRangeBonus()
	return self.range
end
function modifier_focusfire_buff:GetActivityTranslationModifiers()
    return "focusfire"
end
function modifier_focusfire_buff:GetModifierDisableTurning() 
    return (self.bFocusing and self.target)  and 1 or 0
end
function modifier_focusfire_buff:GetModifierIgnoreCastAngle()
    return (self.bFocusing and self.target) and  1 or 0
end
function modifier_focusfire_buff:OnCreated()
	if self:GetAbility() == nil then return end
	self.range = self:GetAbility():GetSpecialValueFor("att_range")
	self.msp=self:GetAbility():GetSpecialValueFor( "msp" )
	if IsServer() then
		self.ch=self:GetAbility():GetSpecialValueFor( "ch" )
		self.dur = self:GetAbility():GetSpecialValueFor("debuff_duration")
		self.target = nil
		self.caster = self:GetCaster()
		self.bFocusing = false
		self.stop = false
		self:StartIntervalThink(0.03)
		self.caster:ClearActivityModifiers()
		self.caster:AddActivityModifier("focusfire")
		self.caster:AddActivityModifier("haste")
		self.flag = 1
		self.inv_flga = 0
	end
end
function modifier_focusfire_buff:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end
function modifier_focusfire_buff:OnIntervalThink()
	if self:GetAbility() == nil then return end
	if IsServer() then
		self.flag = 1	--多个OnAttackLanded 减去第一个剩下的都是各种连击触发的
		if self.caster:IsDisarmed() or self.caster:IsInvisible() or self.caster:IsStunned() then
				if self.inv_flga ==0 then
					self.caster:Stop()
					self.inv_flga = self.inv_flga +1
				end
				self.bFocusing = false
				self.target = nil
		end
		if self.target~= nil and self.target:IsAlive() and not self.target:IsAttackImmune() and not self.target:IsInvisible() then
			local pos_1 = self.target:GetAbsOrigin()
			local pos_2 = self.caster:GetAbsOrigin()
			if (pos_1 - pos_2):Length2D() < (self.caster:Script_GetAttackRange()+40) then
				if self.caster:AttackReady()  and self.target:IsAlive() and self.bFocusing then
					self.caster:FaceTowards(pos_1)
					self.caster:SetForwardVector((pos_1 - pos_2 ):Normalized())
					self.caster:StartGesture(ACT_DOTA_ATTACK)
					self.caster:PerformAttack(self.target, true, true, false, true, true, false, false)
				end
				else
				self.bFocusing = false
			end
			else
			self.bFocusing = false
			
		end

	end
	
end

function modifier_focusfire_buff:OnAttackStart(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self.caster and self.caster:IsRangedAttacker() then
		self.target = keys.target
		self.stop = false
	end
end

function modifier_focusfire_buff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self.caster and not keys.target:IsBuilding() and not self.caster:IsInvisible()then
		if not self.caster:HasModifier("modifier_focusfire_cd") then
			if PseudoRandom:RollPseudoRandom(self:GetAbility() ,self.ch) then
			self.caster:AddNewModifier(self.caster,self:GetAbility(),"modifier_focusfire_cd",{duration = 0.1})
			self.caster:PerformAttack(keys.target, true, true, true, false, false, false, true)
			end
		end
		self.flag = self.flag - 1
		if self.flag<0 then
			keys.target:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_paralyzed",{duration = 0.8})
		end
	end
end
function modifier_focusfire_buff:OnOrder(keys)
	if keys.unit == self.caster then
		if keys.order_type == DOTA_UNIT_ORDER_STOP or keys.order_type == DOTA_UNIT_ORDER_CONTINUE then
			self.bFocusing	= false
			self.target = nil
			self.stop = true
		else
			self.bFocusing	= true
		end
		
		if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
			self.target = keys.target
		end
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET  then
			if self.target~=nil and not self.stop  then
			
				self:OnIntervalThink()
				--self.caster:MoveToTargetToAttack(self.target)
			end
		end
	end
end

modifier_focusfire_cd =  class({})

function modifier_focusfire_cd:IsPurgable()
    return false
end

function modifier_focusfire_cd:IsPurgeException()
    return false
end

function modifier_focusfire_cd:IsHidden()
    return true
end




modifier_focusfire_debuff=class({})

function modifier_focusfire_debuff:IsHidden()
	return false
end

function modifier_focusfire_debuff:IsPurgable()
	return false
end

function modifier_focusfire_debuff:IsPurgeException()
	return false
end
function modifier_focusfire_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		}
end
function modifier_focusfire_debuff:GetModifierPhysicalArmorBonus() return self:GetStackCount()*self.armor end
function modifier_focusfire_debuff:OnCreated()
	if self:GetAbility()==nil then return end
	self.armor = self:GetAbility():GetSpecialValueFor("armor")*-1
	if not IsServer() then return end
	self:SetStackCount(0)
	self:OnRefresh()
end

function modifier_focusfire_debuff:OnRefresh()
	if IsServer() then
		local pos_1 = self:GetCaster():GetOrigin()
		local pos_2 = self:GetParent():GetOrigin()
		local dir = TG_Direction(pos_2,pos_1)
		local particle = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_focusfire_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetCaster())
		ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
		self:SetStackCount(self:GetStackCount() + 1)
	end
end


modifier_focusfire_passive = class({})


function modifier_focusfire_passive:IsHidden()
	return true
end

function modifier_focusfire_passive:IsPurgable()
	return false
end

function modifier_focusfire_passive:IsPurgeException()
	return false
end
function modifier_focusfire_passive:DeclareFunctions()
	return
	{MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,	
	}
end

function modifier_focusfire_passive:GetModifierAttackSpeedBonus_Constant()
	if not self:GetParent():PassivesDisabled() then
			return self:GetAbility():GetSpecialValueFor("attsp")
	end
end