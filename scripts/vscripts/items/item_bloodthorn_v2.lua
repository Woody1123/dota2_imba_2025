item_bloodthorn_v2 = class({})

LinkLuaModifier("modifier_item_bloodthorn_v2_pa", "items/item_bloodthorn_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bloodthorn_v2_debuff", "items/item_bloodthorn_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bloodthorn_v2_debuff2", "items/item_bloodthorn_v2.lua", LUA_MODIFIER_MOTION_NONE)


function item_bloodthorn_v2:OnSpellStart()
    self.caster=self.caster or self:GetCaster()
    local target = self:GetCursorTarget()
    local dur = self:GetSpecialValueFor("dur")
    if  target:TG_TriggerSpellAbsorb(self)   then
        return
    end

    if not target:IsMagicImmune() then
        target:EmitSound("DOTA_Item.Bloodthorn.Activate")
        target:AddNewModifier_RS( self.caster,self,"modifier_item_bloodthorn_v2_debuff",{duration=dur})
    end
end


function item_bloodthorn_v2:GetIntrinsicModifierName()
    return "modifier_item_bloodthorn_v2_pa"
end


modifier_item_bloodthorn_v2_pa = class({})

function modifier_item_bloodthorn_v2_pa:IsHidden()
    return true
end

function modifier_item_bloodthorn_v2_pa:IsPurgable()
    return false
end

function modifier_item_bloodthorn_v2_pa:IsPurgeException()
    return false
end

function modifier_item_bloodthorn_v2_pa:AllowIllusionDuplicate()
    return false
end

function modifier_item_bloodthorn_v2_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		 MODIFIER_EVENT_ON_TAKEDAMAGE,
		 MODIFIER_PROPERTY_HEALTH_BONUS,
   }
end

function modifier_item_bloodthorn_v2_pa:OnCreated()
    self.parent=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.int=self.ability:GetSpecialValueFor("int")
    self.hp=self.ability:GetSpecialValueFor("hp")
    self.attsp=self.ability:GetSpecialValueFor("attsp")
	self.amp=self.ability:GetSpecialValueFor("amp")
	self.dam_atr = self.ability:GetSpecialValueFor("dam_atr")*0.01
	self.damageTable = {
			attacker = self:GetParent(),
			damage_type =DAMAGE_TYPE_MAGICAL,
			damage_flags=DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self:GetAbility(),
			}
	self.cd = true
end
function modifier_item_bloodthorn_v2_pa:OnIntervalThink()
	if not IsServer() then return end
	self.cd = true
end

function modifier_item_bloodthorn_v2_pa:GetModifierBonusStats_Intellect()
    return self.int
end

function modifier_item_bloodthorn_v2_pa:GetModifierAttackSpeedBonus_Constant()
    return self.attsp
end

function modifier_item_bloodthorn_v2_pa:GetModifierDamageOutgoing_Percentage()
	return self.amp
end

function modifier_item_bloodthorn_v2_pa:GetModifierHealthBonus()
	return self.hp
end

function modifier_item_bloodthorn_v2_pa:OnTakeDamage(tg)
    if IsServer() then
		if tg.attacker==self:GetParent() and tg.damage>=100 and self.cd then
				if not tg.unit:IsBuilding() and tg.unit:IsAlive() and tg.damage_type==DAMAGE_TYPE_MAGICAL and not tg.attacker:IsMagicImmune() then
					self:Damage_on(tg.attacker,tg.unit,self:GetAbility())
				end
		end
    end
end
function modifier_item_bloodthorn_v2_pa:Damage_on(attacker,target,ability)
	if self.damageTable~= nil then 
					self:StartIntervalThink(1)
					self.cd = false
					local damage = self:GetParent():GetPrimaryStatValue()*self.dam_atr
					self.damageTable.victim = target
					self.damageTable.damage = damage	
					target:AddNewModifier(attacker,ability,"modifier_item_bloodthorn_v2_debuff2",{duration=0.5})
					ApplyDamage(self.damageTable)
	end					
end

modifier_item_bloodthorn_v2_debuff =class({})

function modifier_item_bloodthorn_v2_debuff:IsDebuff()
    return true
end

function modifier_item_bloodthorn_v2_debuff:IsHidden()
    return false
end

function modifier_item_bloodthorn_v2_debuff:IsPurgable()
    return false
end

function modifier_item_bloodthorn_v2_debuff:IsPurgeException()
    return false
end


function modifier_item_bloodthorn_v2_debuff:GetEffectName()
    return "particles/items2_fx/orchid.vpcf"
end

function modifier_item_bloodthorn_v2_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_bloodthorn_v2_debuff:ShouldUseOverheadOffset()
    return true
end

function modifier_item_bloodthorn_v2_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_SILENCED] = self:GetParent():IsMagicImmune() and false or true,
        [MODIFIER_STATE_EVADE_DISABLED] = true,
    }
end

function modifier_item_bloodthorn_v2_debuff:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
   }
end

function modifier_item_bloodthorn_v2_debuff:OnCreated()
        self.ability,self.parent,self.caster=self:GetAbility(),self:GetParent(),self:GetCaster()
        self.dam=0
		if IsServer() then
			self:StartIntervalThink(1)
			self.mod = self:GetCaster():FindModifierByName("modifier_item_bloodthorn_v2_pa")
		end
end
function modifier_item_bloodthorn_v2_debuff:OnIntervalThink()
        self.ability,self.parent,self.caster=self:GetAbility(),self:GetParent(),self:GetCaster()
		if IsServer() then
			if self.mod~=nil then
				self.mod:Damage_on(self:GetCaster(),self:GetParent(),self:GetAbility())
			end
		end
end
function modifier_item_bloodthorn_v2_debuff:OnTakeDamage(tg)
    if not IsServer() then
        return
    end

    if tg.unit == self.parent and  self.dam then
            self.dam=self.dam+tg.damage
    end
end

function modifier_item_bloodthorn_v2_debuff:OnDestroy()
    if IsServer() then
        if self.dam>0 then
            local pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
            ParticleManager:SetParticleControl(pfx, 1, Vector(1,0,0))
            ParticleManager:SetParticleControl(pfx, 2, Vector(1,0,0))
            ParticleManager:ReleaseParticleIndex(pfx)
                local damageTable = {
                    victim = self.parent,
                    attacker = self.caster,
                    damage = self.dam*self.ability:GetSpecialValueFor("desdmg")*0.01,
                    damage_type =DAMAGE_TYPE_MAGICAL,
                    ability = self.ability,
                    }
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, self.parent, damageTable.damage, nil)
                ApplyDamage(damageTable)
        end
    end
end


modifier_item_bloodthorn_v2_debuff2=class({})


function modifier_item_bloodthorn_v2_debuff2:IsDebuff()
 return true
end

function modifier_item_bloodthorn_v2_debuff2:IsHidden()
 return true
end

function modifier_item_bloodthorn_v2_debuff2:IsPurgable()
 return false
end

function modifier_item_bloodthorn_v2_debuff2:IsPurgeException()
 return false
end

function modifier_item_bloodthorn_v2_debuff2:RemoveOnDeath()
 return true
end

function modifier_item_bloodthorn_v2_debuff2:GetEffectName() return "particles/items2_fx/veil_of_discord_debuff.vpcf" end
function modifier_item_bloodthorn_v2_debuff2:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_item_bloodthorn_v2_debuff2:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_item_bloodthorn_v2_debuff2:GetModifierMoveSpeedBonus_Percentage()
	return -50
end
function modifier_item_bloodthorn_v2_debuff2:GetModifierAttackSpeedBonus_Constant()
	return  -120
end