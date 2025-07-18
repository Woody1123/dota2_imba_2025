item_manta_v2=class({})
LinkLuaModifier("modifier_item_manta_v2", "items/item_manta_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_illusions_item_manta_v2", "items/item_manta_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_manta_v2_invuln", "items/item_manta_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_manta_v2_cd", "items/item_manta_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_manta_v2_reduce", "items/item_manta_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bkb_buff", "items/item_bkb.lua", LUA_MODIFIER_MOTION_NONE)


function item_manta_v2:IsRefreshable() 			
    return true 
end

function item_manta_v2:OnSpellStart()
    local caster=self:GetCaster()
    local images_do_damage_percent=self:GetSpecialValueFor("images_do_damage_percent")
    local images_take_damage_percent= self:GetSpecialValueFor("images_take_damage_percent")-100
    local images_count=1--self:GetSpecialValueFor("images_count")
    local invuln_duration=self:GetSpecialValueFor("invuln_duration")
    local tooltip_illusion_duration=self:GetSpecialValueFor("tooltip_illusion_duration")
    caster:AddNewModifier(caster, self, "modifier_item_manta_v2_invuln", {duration=invuln_duration})
    caster:Purge(false, true, false, true, true)
    local modifier=
    {
        outgoing_damage=images_do_damage_percent,
        incoming_damage=images_take_damage_percent,
        bounty_base=0,
        bounty_growth=0,
        outgoing_damage_structure=images_do_damage_percent,
        outgoing_damage_roshan=images_do_damage_percent,
    }
	
	caster.item_manta_v2illusions=CreateIllusions(caster, caster, modifier, images_count, 77, true, true)
    for _, target in pairs(caster.item_manta_v2illusions) do
        target:AddNewModifier(caster, self, "modifier_kill", {duration=tooltip_illusion_duration})
		--target:AddNewModifier(caster, self, "modifier_unit_remove", {duration=tooltip_illusion_duration})
        target:AddNewModifier(caster, self, "modifier_illusions_item_manta_v2", {duration=tooltip_illusion_duration})
        local mod =caster:FindModifierByName("modifier_item_attsp_book")
        if mod then   
            target:AddNewModifier(caster, nil, "modifier_item_attsp_book", {num=mod:GetStackCount()})
        end 
    end
end

function item_manta_v2:GetIntrinsicModifierName() 
    return "modifier_item_manta_v2" 
end


modifier_item_manta_v2=class({})

function modifier_item_manta_v2:IsPassive()			
    return true 
end

function modifier_item_manta_v2:IsHidden() 		
    return true 
end

function modifier_item_manta_v2:IsPurgable() 		
    return false 
end

function modifier_item_manta_v2:IsPurgeException() 
    return false 
end

function modifier_item_manta_v2:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
    } 
end

function modifier_item_manta_v2:OnCreated() 
    self.parent = self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.bonus_strength=self.ability:GetSpecialValueFor("bonus_strength")
    self.bonus_agility=self.ability:GetSpecialValueFor("bonus_agility")
    self.bonus_intellect=self.ability:GetSpecialValueFor("bonus_intellect")
    self.bonus_attack_speed=self.ability:GetSpecialValueFor("bonus_attack_speed")
    self.bonus_movement_speed=self.ability:GetSpecialValueFor("bonus_movement_speed")
end

function modifier_item_manta_v2:GetModifierBonusStats_Strength() 
    return self.bonus_strength
end

function modifier_item_manta_v2:GetModifierBonusStats_Agility() 
    return self.bonus_agility 
end

function modifier_item_manta_v2:GetModifierBonusStats_Intellect() 
    return self.bonus_intellect
 end

 function modifier_item_manta_v2:GetModifierAttackSpeedBonus_Constant() 
    return self.bonus_attack_speed
 end

 function modifier_item_manta_v2:GetModifierMoveSpeedBonus_Percentage_Unique() 
    return  self.bonus_movement_speed
 end

modifier_illusions_item_manta_v2=class({})

function modifier_illusions_item_manta_v2:IsHidden() 		
    return true 
end

function modifier_illusions_item_manta_v2:IsPurgable() 		
    return false 
end

function modifier_illusions_item_manta_v2:IsPurgeException() 
    return false 
end

function modifier_illusions_item_manta_v2:IsIllusion() 
    return true 
end

function modifier_illusions_item_manta_v2:DeclareFunctions() 
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_IS_ILLUSION,
    } 
end

function modifier_illusions_item_manta_v2:GetIsIllusion() 
    return 1
end

function modifier_illusions_item_manta_v2:OnCreated() 
	if self:GetAbility() == nil then return end
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
	self.caster = self:GetCaster()
	self.duration = self.ability:GetSpecialValueFor("inv")
	self.cd = self.ability:GetSpecialValueFor("cd")
	self.cd_range = self.ability:GetSpecialValueFor("cd_range")
	if IsServer() then 
		local item = self:GetCaster():FindItemInInventory("item_bkb") 
		if item then
			self.caster:EmitSound("DOTA_Item.BlackKingBar.Activate")
			self.parent:AddNewModifier(self.caster,item,"modifier_item_bkb_buff",{duration = 5})
		end
	end
end


function modifier_illusions_item_manta_v2:OnAttackLanded(tg) 
    if not IsServer() then
		return
    end
	if tg.attacker == self.parent and tg.target:IsAlive() and self.caster:IsAlive() and not tg.target:IsBuilding() then
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_item_manta_v2_reduce", {int = self.int})
		self.caster:PerformAttack(tg.target, true, true, true, false, false, false, true)	
		self.caster:RemoveModifierByName("modifier_item_manta_v2_reduce")
	end
	if tg.target == self.caster and tg.target:IsAlive() then
		if not tg.target:HasModifier("modifier_item_manta_v2_cd") then
			if tg.target:IsRangedAttacker() and  tg.attacker:IsRangedAttacker() then
				return
			end

			local cd = self.cd
			if tg.target:IsRangedAttacker()  then 
				cd = self.cd_range
			end

			tg.target:AddNewModifier(tg.target,self:GetAbility(),"modifier_item_manta_v2_cd",{duration = cd})
			tg.target:AddNewModifier(tg.target,self:GetAbility(),"modifier_item_manta_v2_invuln",{duration = self.duration})
			self.parent:SetOrigin(GetRandomPosition2D(tg.target:GetAbsOrigin(),250)) 
		end
	end

end


modifier_item_manta_v2_reduce = class({})

function modifier_item_manta_v2_reduce:IsDebuff()				return true end
function modifier_item_manta_v2_reduce:IsHidden() 			return true end
function modifier_item_manta_v2_reduce:IsPurgable() 			return false end
function modifier_item_manta_v2_reduce:IsPurgeException() 	return false end
function modifier_item_manta_v2_reduce:DeclareFunctions() 
	return {
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
			} 
end

function modifier_item_manta_v2_reduce:GetModifierTotalDamageOutgoing_Percentage()
  return -70
end

modifier_item_manta_v2_invuln=class({})

function modifier_item_manta_v2_invuln:IsHidden() 		
    return true 
end

function modifier_item_manta_v2_invuln:IsPurgable() 		
    return false 
end

function modifier_item_manta_v2_invuln:IsPurgeException() 
    return false 
end

function modifier_item_manta_v2_invuln:GetEffectAttachType() 	
    return PATTACH_ABSORIGIN_FOLLOW 
end


function modifier_item_manta_v2_invuln:CheckState()
	return
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, 
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
end

function modifier_item_manta_v2_invuln:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_DODGE_PROJECTILE 
    } 
end

function modifier_item_manta_v2_invuln:GetModifierDodgeProjectile()
    return 1
end

modifier_item_manta_v2_cd=class({})

function modifier_item_manta_v2_cd:IsHidden() 		
    return true 
end

function modifier_item_manta_v2_cd:IsPurgable() 		
    return false 
end

function modifier_item_manta_v2_cd:IsPurgeException() 
    return false 
end

function modifier_item_manta_v2_cd:GetEffectAttachType() 	
    return PATTACH_ABSORIGIN_FOLLOW 
end
function modifier_item_manta_v2_cd:CheckState()
	return
	{
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
end
function modifier_item_manta_v2_cd:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_DODGE_PROJECTILE 
    } 
end

function modifier_item_manta_v2_cd:GetModifierDodgeProjectile()
    return 1
end
function modifier_item_manta_v2_cd:OnCreated()
	if not IsServer() then return end
	self.parent = self:GetParent()
	local pos=	self.parent:GetAbsOrigin()
	local dir = self.parent:GetForwardVector():Normalized()
	local dis = nil
	if not self:GetParent():IsRangedAttacker() then
		dir = dir*-1
		dis = pos+ dir * RandomInt(150,250)
		else
		dis = pos+ dir * RandomInt(150,250)
	end
	local newpos =RotatePosition(pos, QAngle(0, RandomInt(120,240)), dis)
	self.parent:SetOrigin(newpos)
end