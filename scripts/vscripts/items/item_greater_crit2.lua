item_greater_crit2 = class({})

LinkLuaModifier("modifier_item_greater_crit2_pa", "items/item_greater_crit2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_laojie_pa", "items/item_laojie.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_laojie_debuff", "items/item_laojie.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_laojie_f", "items/item_laojie.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_laojie_e", "items/item_laojie.lua", LUA_MODIFIER_MOTION_NONE)
function item_greater_crit2:GetIntrinsicModifierName()
    return "modifier_item_greater_crit2_pa"
end

function item_greater_crit2:OnSpellStart()
    -- local target=self:GetCursorTarget()
     local caster=self:GetCaster()
     local dur=self:GetSpecialValueFor("dur")
     --local dur1=self:GetSpecialValueFor("dur1")
     EmitSoundOn("DOTA_Item.SpiderLegs.Cast", target)
     caster:AddNewModifier(caster, self, "modifier_item_laojie_f", {duration=dur})
     --[[
     if Is_Chinese_TG(caster,target) then
         target:AddNewModifier(caster, self, "modifier_item_laojie_f", {duration=dur})
     else
         target:AddNewModifier_RS(caster, self, "modifier_item_laojie_e", {duration=dur1})
     end]]
 end
modifier_item_greater_crit2_pa = class({})

function modifier_item_greater_crit2_pa:GetTexture()
    return "item_greater_crit2"
end

function modifier_item_greater_crit2_pa:IsHidden()
    return true
end

function modifier_item_greater_crit2_pa:IsPurgable()
    return false
end

function modifier_item_greater_crit2_pa:IsPurgeException()
    return false
end

function modifier_item_greater_crit2_pa:AllowIllusionDuplicate()
    return false
end

function modifier_item_greater_crit2_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
       -- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
       -- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
     --   MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
      --  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
      --  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT

   }
end


function modifier_item_greater_crit2_pa:OnCreated()
    self.crit = {}
    self.parent=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.crit_=self.ability:GetSpecialValueFor("crit")
    self.dam=self.ability:GetSpecialValueFor("dam")
    self.crit_ch=self.ability:GetSpecialValueFor("crit_ch")
    self.crit_ch2=self.ability:GetSpecialValueFor("crit_ch2")
    self.crit_m=self.ability:GetSpecialValueFor("crit_m")
    self.crit_m2=self.ability:GetSpecialValueFor("crit_m2")
    self.ability,self.parent=self:GetAbility(),self:GetParent()
    self.bonus_damage=self.ability:GetSpecialValueFor("bonus_damage")
    self.dur=self.ability:GetSpecialValueFor("dur")
   -- self.armor=self.ability:GetSpecialValueFor("armor")
    self.armor1=self.ability:GetSpecialValueFor("armor1")
    self.armor2=self.ability:GetSpecialValueFor("armor2")
   -- self.ab=self.ability:GetSpecialValueFor("ab")
end


 

function modifier_item_greater_crit2_pa:GetModifierPreAttack_CriticalStrike(tg)
        if tg.attacker == self.parent and not tg.target:IsBuilding() and not self.parent:IsIllusion()  then
            self.crit[tg.record] = true
            if RollPseudoRandomPercentage( self.crit_ch,0,self.parent) then
                self.crit[tg.record] = false
                self.parent:EmitSound("DOTA_Item.Daedelus.Crit")
                    return self.crit_m
            elseif RollPseudoRandomPercentage(self.crit_ch2,0,self.parent) then
                self.parent:EmitSound("DOTA_Item.Daedelus.Crit")
                    return self.crit_m2
            else
                return 0
            end
        end
end

function modifier_item_greater_crit2_pa:GetModifierPreAttack_BonusDamage()
        return self.dam
end
function modifier_item_greater_crit2_pa:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker ==self.parent and not self.parent:IsIllusion() then
	tg.target:AddNewModifier(tg.attacker,self:GetAbility(),"modifier_item_laojie_debuff",{duration = 4})
       --[[local ar=tg.target:IsBuilding() and self.armor1 or self.armor2
            TG_Modifier_Num_ADD2({
                target=tg.target,
                caster=self.parent,
                ability= self.ability,
                modifier="modifier_item_laojie_debuff",
                init= 7,
                stack= ar,
                duration=self.dur
            })]]
    end
end
function modifier_item_greater_crit2_pa:GetModifierPreAttack_BonusDamage()
    return  self.bonus_damage
end

 --[[
 function modifier_item_greater_crit2_pa:GetModifierPhysicalArmorBonus()
     return self.armor
  end
 
  function modifier_item_greater_crit2_pa:GetModifierBonusStats_Agility()
     return self.ab
  end
 
  function modifier_item_greater_crit2_pa:GetModifierBonusStats_Intellect()
     return self.ab
  end
 
  function modifier_item_greater_crit2_pa:GetModifierBonusStats_Strength()
     return self.ab
  end
 
  function modifier_item_greater_crit2_pa:GetModifierMoveSpeedBonus_Constant()
     return 30
  end]]
