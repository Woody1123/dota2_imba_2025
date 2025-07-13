build_mana_loss=class({})
LinkLuaModifier("modifier_build_mana_loss", "towers/build_mana_loss.lua", LUA_MODIFIER_MOTION_NONE)

function build_mana_loss:GetIntrinsicModifierName()
    return "modifier_build_mana_loss"
end

modifier_build_mana_loss = class({})

function modifier_build_mana_loss:IsHidden()
    return true
end

function modifier_build_mana_loss:IsPurgable()
    return false
end

function modifier_build_mana_loss:IsPurgeException()
    return false
end

function modifier_build_mana_loss:OnCreated()
      self.ability=self:GetAbility()
      self.parent=self:GetParent()
      self.team=self.parent:GetTeamNumber()
      if not self.ability then
            return
      end
      self.rd=self.ability:GetSpecialValueFor("rd")
      self.mana=self.ability:GetSpecialValueFor("mana")*0.01
     if not IsServer() then
            return
      end
	self:StartIntervalThink(1)
end


function modifier_build_mana_loss:OnIntervalThink()
    if not  self.ability:IsCooldownReady() or not  self.parent:IsAlive()  then
		return
    end

    local heros = FindUnitsInRadius(
		self.team,
		self.parent:GetAbsOrigin(),
		nil,
		1000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
            false)
        if #heros>0 then
                  EmitSoundOn("Hero_NyxAssassin.ManaBurn.Target", self.parent)
                  for _, hero in pairs(heros) do
                        local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf", PATTACH_CENTER_FOLLOW, hero)
                        ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
                        ParticleManager:SetParticleControl(pfx, 1, Vector(1, 0, 0))
                        ParticleManager:ReleaseParticleIndex(pfx)
                        local mana=0.4*hero:GetMaxMana()
                        hero:Script_ReduceMana(mana,self:GetAbility())
                        SendOverheadEventMessage(hero, OVERHEAD_ALERT_MANA_LOSS, hero,mana, nil)
                  end
                  self.ability:UseResources(true, false, false, true)
        end
end
