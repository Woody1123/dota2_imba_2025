
modifier_dlnec_reaper_judge = class({})

function modifier_dlnec_reaper_judge:IsHidden() return true end
function modifier_dlnec_reaper_judge:IsDebuff() return true end
function modifier_dlnec_reaper_judge:IsStunDebuff() return false end
function modifier_dlnec_reaper_judge:IsPurgable() return false end
function modifier_dlnec_reaper_judge:IsPurgeException() return false end
function modifier_dlnec_reaper_judge:RemoveOnDeath() return self:GetParent():IsIllusion() end
function modifier_dlnec_reaper_judge:DeclareFunctions()
    return
     {
		 MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,	
    }
end

function modifier_dlnec_reaper_judge:GetModifierIncomingDamageConstant(keys)	 
	if IsServer() then
		if not keys.target:HasModifier("modifier_winter_wyvern_winters_curse_aura") then
			if keys.target:GetHealth() - keys.damage <=0 then 
				self.death = true
				return -keys.damage-100
			end
		end		
		return 0
	end
end

function modifier_dlnec_reaper_judge:OnDestroy()	 
	if IsServer() then
		if self.death then
			TG_Kill(self:GetCaster(), self:GetParent(), self:GetAbility())
			--[[
			local damageTable = {
									victim = self:GetParent(),
									attacker = self:GetCaster(),
									damage = self:GetParent():GetHealth() + 10,
									damage_type = DAMAGE_TYPE_PURE,
									damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT, --Optional.
									ability = self:GetAbility(),
									}
				ApplyDamage(damageTable)]]
		end
	end
end

modifier_dlnec_reaper_judge2 = class({})

function modifier_dlnec_reaper_judge2:IsHidden() return true end
function modifier_dlnec_reaper_judge2:IsDebuff() return true end
function modifier_dlnec_reaper_judge2:IsStunDebuff() return false end
function modifier_dlnec_reaper_judge2:IsPurgable() return false end
function modifier_dlnec_reaper_judge2:IsPurgeException() return false end
function modifier_dlnec_reaper_judge2:RemoveOnDeath() return false end
--虽然onremove只用一个modi就确保了击杀者为nec，但无法在ondeath中判断镰刀状态下死亡。还是得有个比伤害modi长几帧的判断modi
