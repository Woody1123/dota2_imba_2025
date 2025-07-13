ra_roll_out = class({})
LinkLuaModifier("modifier_ra_roll_out_pa", "ting/random_ab/ra_roll_out", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ra_roll_out_buff", "ting/random_ab/ra_roll_out", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ra_roll_out_big_buff", "ting/random_ab/ra_roll_out", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ra_roll_out_flag_buff", "ting/random_ab/ra_roll_out", LUA_MODIFIER_MOTION_BOTH)
function ra_roll_out:IsStealable() return false end
function ra_roll_out:CastFilterResultTarget(target)
	if IsServer() then
		if target ~= self:GetCaster() then
			if target:IsHero() and not target:HasModifier("modifier_ra_roll_out_big_buff")  and  Is_Chinese_TG(self:GetCaster(),target) then
				return UF_SUCCESS
			else
				return UF_FAIL_CUSTOM
			end
		end
		return UF_FAIL_CUSTOM
	end
end
function ra_roll_out:GetCustomCastErrorTarget(target)
	if IsServer() then
		if not Is_Chinese_TG(self:GetCaster(),target) then
			return "不能骑他惹"
		end
		if target == self:GetCaster() then
			return "你xp很奇怪惹"
		end
		return "你怎么什么都想骑"
	end
end

function ra_roll_out:GetBehavior()
	if self:GetCaster():HasModifier("modifier_ra_roll_out_flag_buff") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE+DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end

	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
function ra_roll_out:GetIntrinsicModifierName() return "modifier_ra_roll_out_pa" end
function ra_roll_out:IsHiddenWhenStolen() 		return false end
function ra_roll_out:IsStealable() return false end
function ra_roll_out:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	if caster:HasModifier("modifier_ra_roll_out_flag_buff") then
		caster:RemoveModifierByName("modifier_ra_roll_out_flag_buff")
		return
	end
	
	local tar = self:GetCursorTarget()
	local dur = self:GetSpecialValueFor("duration")
	
		if self:GetAutoCastState()  then
			caster:AddNewModifier(tar,self,"modifier_ra_roll_out_buff",{duration = duration,caster = caster:entindex()})
			tar:AddNewModifier(caster,self,"modifier_ra_roll_out_big_buff",{duration = duration})
			
			caster:AddNewModifier(tar,self,"modifier_ra_roll_out_flag_buff",{duration = duration,caster = tar:entindex(),parent = caster:entindex()})
			else
		
			tar:AddNewModifier(caster,self,"modifier_ra_roll_out_buff",{duration = duration,caster = caster:entindex()})
			caster:AddNewModifier(tar,self,"modifier_ra_roll_out_big_buff",{duration = duration})
			caster:AddNewModifier(tar,self,"modifier_ra_roll_out_flag_buff",{duration = duration,caster = caster:entindex(),parent = tar:entindex()})
		end
end





modifier_ra_roll_out_buff = class({})

function modifier_ra_roll_out_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end


function modifier_ra_roll_out_buff:IsHidden()
	return false
end

function modifier_ra_roll_out_buff:IsPurgable()
	return false
end
function modifier_ra_roll_out_buff:IsPurgeException()
	return false
end
function modifier_ra_roll_out_buff:RemoveOnDeath()
	return true
end
function modifier_ra_roll_out_buff:OnCreated(keys)
	if self:GetAbility() ~= nil then
		self.attack_range = self:GetAbility():GetSpecialValueFor("range")
		
		if IsServer() then
			if keys.caster then
				self.caster = EntIndexToHScript(keys.caster)
			end
			self.stop = 0
			self:StartIntervalThink( 0.02 )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_ra_roll_out_buff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,	
		
	}
	return funcs
end

function modifier_ra_roll_out_buff:GetModifierModelScale()
	return -40
end
--------------------------------------------------------------------------------
function modifier_ra_roll_out_buff:GetModifierAttackRangeBonus()
	return self.attack_range
end

function modifier_ra_roll_out_buff:CheckState()
	local state =
	{	[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_TETHERED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		--[MODIFIER_STATE_STUNNED] = true,
		--[MODIFIER_STATE_INVULNERABLE] = Is_Chinese_TG(self:GetParent(),self:GetCaster()),
		--[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		--[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end

--------------------------------------------------------------------------------
function modifier_ra_roll_out_buff:OnOrder(keys)
	if not IsServer() then
		return
	end
	if keys.unit==self:GetParent() and Is_Chinese_TG(self:GetParent(),self:GetCaster())then
		if  keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
			self.stop = self.stop + 1
			if self.stop > 20 then
				self:Destroy()
			end
		end
	end
end

function modifier_ra_roll_out_buff:OnDestroy()
	if IsServer() then

		self:GetCaster():RemoveModifierByNameAndCaster("modifier_ra_roll_out_big_buff",self:GetParent())
		if self.caster then
			self.caster:RemoveModifierByName("modifier_ra_roll_out_flag_buff")
		end
		
	end
end

--------------------------------------------------------------------------------

function modifier_ra_roll_out_buff:OnIntervalThink()
	if IsServer() then
		local forward = self:GetCaster():GetForwardVector()
		local vLocation = self:GetCaster():GetAbsOrigin() - forward*60
		self:GetParent():SetOrigin( Vector(vLocation.x,vLocation.y,vLocation.z+200))
	end
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------



function modifier_ra_roll_out_buff:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetCaster() or  params.unit == self:GetParent() then
			self:Destroy()
		end
	end

	return 0
end


modifier_ra_roll_out_big_buff = class({})

function modifier_ra_roll_out_big_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_ra_roll_out_big_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		}
end


function modifier_ra_roll_out_big_buff:IsHidden()
	return false
end

function modifier_ra_roll_out_big_buff:IsPurgable()
	return false
end
function modifier_ra_roll_out_big_buff:IsPurgeException()
	return false
end
function modifier_ra_roll_out_big_buff:RemoveOnDeath()
	return true
end
--------------------------------------------------------------------------------

function modifier_ra_roll_out_big_buff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_ra_roll_out_big_buff:OnCreated()
	if self:GetAbility() ~= nil then
		self.ab = self:GetAbility()
		self.move = self.ab:GetSpecialValueFor("move_speed")
		self.re = self.ab:GetSpecialValueFor("re")*-1
	end
end
function modifier_ra_roll_out_big_buff:GetModifierMoveSpeedBonus_Constant() return self.move end
function modifier_ra_roll_out_big_buff:GetModifierIncomingDamage_Percentage()
		return self.re
end

function modifier_ra_roll_out_big_buff:GetModifierModelScale()
	return 50
end

modifier_ra_roll_out_flag_buff = class({})

function modifier_ra_roll_out_flag_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end


function modifier_ra_roll_out_flag_buff:IsHidden()
	return true
end

function modifier_ra_roll_out_flag_buff:IsPurgable()
	return false
end
function modifier_ra_roll_out_flag_buff:IsPurgeException()
	return false
end
function modifier_ra_roll_out_flag_buff:RemoveOnDeath()
	return true
end

function modifier_ra_roll_out_flag_buff:OnCreated(keys)
	if IsServer() then
		if keys.caster then
			self.caster = EntIndexToHScript(keys.caster)
			self.parent = EntIndexToHScript(keys.parent)
		end
	end
end

function modifier_ra_roll_out_flag_buff:OnDestroy()
	if IsServer() then

		
		self.parent:RemoveModifierByNameAndCaster("modifier_ra_roll_out_buff",self.caster)
		
		
	end
end