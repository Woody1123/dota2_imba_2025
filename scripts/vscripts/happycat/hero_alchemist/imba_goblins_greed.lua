imba_goblins_greed=class({})
LinkLuaModifier("modifier_imba_goblins_greed_bet", "happycat/hero_alchemist/imba_goblins_greed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_goblins_greed_pa", "happycat/hero_alchemist/imba_goblins_greed.lua", LUA_MODIFIER_MOTION_NONE)

function imba_goblins_greed:Init()
    self.caster=self:GetCaster()
end
function imba_goblins_greed:IsHiddenWhenStolen()
    return false
end
function imba_goblins_greed:IsStealable()
    return true
end
function imba_goblins_greed:IsRefreshable()
    return false
end
function imba_goblins_greed:OnSpellStart()
      EmitSoundOn("DOTA_Item.Hand_Of_Midas", self.caster)
      local target=self:GetCursorTarget()
      local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN, self.caster)
      self.gold=self:GetSpecialValueFor("bet_gold")
      self.bet_mul=self:GetSpecialValueFor("bet_mul")
      self.point=self:GetSpecialValueFor("point")

      ParticleManager:SetParticleControl(fx, 1,  self.caster:GetAbsOrigin())
      ParticleManager:ReleaseParticleIndex(fx)
      target:AddNewModifier(self.caster, self, "modifier_imba_goblins_greed_pa", {duration=self:GetSpecialValueFor("dur")})     
end
function imba_goblins_greed:GetIntrinsicModifierName()
    return "modifier_imba_goblins_greed_bet"
end

modifier_imba_goblins_greed_bet=class({})


function modifier_imba_goblins_greed_bet:IsPassive()
    return true
end

function modifier_imba_goblins_greed_bet:IsPurgable()
    return false
end

function modifier_imba_goblins_greed_bet:IsPurgeException()
    return false
end

function modifier_imba_goblins_greed_bet:RemoveOnDeath()
    return false
end

function modifier_imba_goblins_greed_bet:IsPermanent()
    return true
end

function modifier_imba_goblins_greed_bet:AllowIllusionDuplicate()
    return false
end
function modifier_imba_goblins_greed_bet:IsStealable()
     return false 
end
function modifier_imba_goblins_greed_bet:OnCreated()
      if self:GetAbility() == nil then return end
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
      if IsServer() then
            self:SetStackCount(0)
      end
end

function modifier_imba_goblins_greed_bet:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_imba_goblins_greed_bet:OnDeath(tg)
        if IsServer() then
            if tg.attacker:IsTrueHero() and  tg.unit:IsTrueHero() then 
                if   tg.attacker:GetTeamNumber()==self.team  then
                  if  tg.attacker:FindModifierByName('modifier_imba_goblins_greed_pa') then 
                        self:IncrementStackCount()
                        local gold=self.ability.gold
                        local num=tonumber(#tostring(gold))+1
                        PlayerResource:ModifyGold(tg.attacker:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified)
                        local fx = ParticleManager:CreateParticle("particles/tgp/alchemist/msg_gold.vpcf", PATTACH_ABSORIGIN,  tg.attacker)
                        ParticleManager:SetParticleControl(fx, 1, Vector(5, gold, 0))
                        ParticleManager:SetParticleControl(fx, 2, Vector(1,num, 0))
                        ParticleManager:SetParticleControl(fx, 3, Vector(255, 208, 0))
                        ParticleManager:ReleaseParticleIndex(fx)

                        PlayerResource:ModifyGold(self.caster:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified)
                        local fx2 = ParticleManager:CreateParticle("particles/tgp/alchemist/msg_gold.vpcf", PATTACH_ABSORIGIN, self.caster)
                        ParticleManager:SetParticleControl(fx2, 1, Vector(5, gold, 0))
                        ParticleManager:SetParticleControl(fx2, 2, Vector(1,num, 0))
                        ParticleManager:SetParticleControl(fx2, 3, Vector(255, 208, 0))
                        ParticleManager:ReleaseParticleIndex(fx2)
                  end
                  if tg.unit:FindModifierByName('modifier_imba_goblins_greed_pa') then 
                        self:IncrementStackCount()
                        local gold=self.ability.gold
                        local num=tonumber(#tostring(gold))+1
                        PlayerResource:ModifyGold(tg.attacker:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified)
                        local fx = ParticleManager:CreateParticle("particles/tgp/alchemist/msg_gold.vpcf", PATTACH_ABSORIGIN,  tg.attacker)
                        ParticleManager:SetParticleControl(fx, 1, Vector(5, gold, 0))
                        ParticleManager:SetParticleControl(fx, 2, Vector(1,num, 0))
                        ParticleManager:SetParticleControl(fx, 3, Vector(255, 208, 0))
                        ParticleManager:ReleaseParticleIndex(fx)

                        PlayerResource:ModifyGold(self.caster:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified)
                        local fx2 = ParticleManager:CreateParticle("particles/tgp/alchemist/msg_gold.vpcf", PATTACH_ABSORIGIN, self.caster)
                        ParticleManager:SetParticleControl(fx2, 1, Vector(5, gold, 0))
                        ParticleManager:SetParticleControl(fx2, 2, Vector(1,num, 0))
                        ParticleManager:SetParticleControl(fx2, 3, Vector(255, 208, 0))
                        ParticleManager:ReleaseParticleIndex(fx2)

                  end
            else
                  if  tg.attacker:FindModifierByName('modifier_imba_goblins_greed_pa') then 
                        self:IncrementStackCount()
                        local gold=0-self.ability.gold
                        local num=0-tonumber(#tostring(gold))+1
                        PlayerResource:ModifyGold(tg.attacker:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified)
                        local fx = ParticleManager:CreateParticle("particles/tgp/alchemist/msg_gold.vpcf", PATTACH_ABSORIGIN,  tg.attacker)
                        ParticleManager:SetParticleControl(fx, 1, Vector(5, gold, 0))
                        ParticleManager:SetParticleControl(fx, 2, Vector(1,num, 0))
                        ParticleManager:SetParticleControl(fx, 3, Vector(255, 208, 0))
                        ParticleManager:ReleaseParticleIndex(fx)

                        PlayerResource:ModifyGold(self.caster:GetPlayerOwnerID(), 0-gold, false, DOTA_ModifyGold_Unspecified)
                        local fx2 = ParticleManager:CreateParticle("particles/tgp/alchemist/msg_gold.vpcf", PATTACH_ABSORIGIN, self.caster)
                        ParticleManager:SetParticleControl(fx2, 1, Vector(5, 0-gold, 0))
                        ParticleManager:SetParticleControl(fx2, 2, Vector(1,0-num, 0))
                        ParticleManager:SetParticleControl(fx2, 3, Vector(255, 208, 0))
                        ParticleManager:ReleaseParticleIndex(fx2)
                  end
                  if tg.unit:FindModifierByName('modifier_imba_goblins_greed_pa') then 
                        self:IncrementStackCount()
                        local gold=self.ability.gold
                        local num=tonumber(#tostring(gold))+1
                        PlayerResource:ModifyGold(tg.attacker:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified)
                        local fx = ParticleManager:CreateParticle("particles/tgp/alchemist/msg_gold.vpcf", PATTACH_ABSORIGIN,  tg.attacker)
                        ParticleManager:SetParticleControl(fx, 1, Vector(5, gold, 0))
                        ParticleManager:SetParticleControl(fx, 2, Vector(1,num, 0))
                        ParticleManager:SetParticleControl(fx, 3, Vector(255, 208, 0))
                        ParticleManager:ReleaseParticleIndex(fx)

                        PlayerResource:ModifyGold(self.caster:GetPlayerOwnerID(), 0-gold, false, DOTA_ModifyGold_Unspecified)
                        local fx2 = ParticleManager:CreateParticle("particles/tgp/alchemist/msg_gold.vpcf", PATTACH_ABSORIGIN, self.caster)
                        ParticleManager:SetParticleControl(fx2, 1, Vector(5, 0-gold, 0))
                        ParticleManager:SetParticleControl(fx2, 2, Vector(1,0-num, 0))
                        ParticleManager:SetParticleControl(fx2, 3, Vector(255, 208, 0))
                        ParticleManager:ReleaseParticleIndex(fx2)

                  end       
            end
                
        end
      end
end


modifier_imba_goblins_greed_pa=class({})

function modifier_imba_goblins_greed_pa:IsDebuff()
      return false
end
function modifier_imba_goblins_greed_pa:IsPurgable()
      return false
end
function modifier_imba_goblins_greed_pa:IsPurgeException()
      return false
end
function modifier_imba_goblins_greed_pa:AllowIllusionDuplicate()
      return true
end
function modifier_imba_goblins_greed_pa:RemoveOnDeath()
      return true
end
