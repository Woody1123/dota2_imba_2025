item_butterfly_ex = class({})
LinkLuaModifier("modifier_butterfly_ex_passive", "ting/items/item_butterfly_ex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_butterfly_ex_damage", "ting/items/item_butterfly_ex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_butterfly_ex_agi", "ting/items/item_butterfly_ex", LUA_MODIFIER_MOTION_NONE)
function item_butterfly_ex:GetIntrinsicModifierName() return "modifier_butterfly_ex_passive" end
function item_butterfly_ex:GetAbilityTextureName() return "butterfly_ex"  end
function item_butterfly_ex:OnProjectileHit(target, location, keys)
	if not target  then
		return
	end
    target:EmitSound("Hero_PhantomAssassin.Dagger.Target")
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_butterfly_ex_damage", {duration = 1}) 
	self.ex = false	
	caster:PerformAttack(target, true, true, true, false, false, false, true)
	self.ex = true
	caster:RemoveModifierByName("modifier_butterfly_ex_damage")
    return true	
end

modifier_butterfly_ex_agi = class({})
function modifier_butterfly_ex_agi:IsDebuff()			return false end
function modifier_butterfly_ex_agi:IsHidden() 			return false end
function modifier_butterfly_ex_agi:IsPurgable() 			return false end
function modifier_butterfly_ex_agi:IsPurgeException() 	return false end
function modifier_butterfly_ex_agi:DeclareFunctions() return { MODIFIER_PROPERTY_STATS_AGILITY_BONUS,} end
function modifier_butterfly_ex_agi:GetModifierBonusStats_Agility() return self:GetStackCount() end
function modifier_butterfly_ex_agi:GetTexture()			return "item_butterfly_ex" end
function modifier_butterfly_ex_agi:OnCreated()
	if self:GetAbility() == nil then return end
	self:SetStackCount(self:GetParent():GetAgility() * (self:GetAbility():GetSpecialValueFor("agi_per") / 100))
end

modifier_butterfly_ex_damage = class({})
function modifier_butterfly_ex_damage:IsDebuff()			return false end
function modifier_butterfly_ex_damage:IsHidden() 			return true end
function modifier_butterfly_ex_damage:IsPurgable() 			return false end
function modifier_butterfly_ex_damage:IsPurgeException() 	return false end
function modifier_butterfly_ex_damage:DeclareFunctions() return { MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,} end
function modifier_butterfly_ex_damage:GetModifierTotalDamageOutgoing_Percentage() return -60 end


--被动
modifier_butterfly_ex_passive = class({})
function modifier_butterfly_ex_passive:IsDebuff()			return false end
function modifier_butterfly_ex_passive:IsHidden() 			return true end
function modifier_butterfly_ex_passive:IsPurgable() 			return false end
function modifier_butterfly_ex_passive:IsPurgeException() 	return false end


function modifier_butterfly_ex_passive:OnCreated()		
	if self:GetAbility() == nil  then   
		return  
	end 
	self.ability = self:GetAbility()
	self.parent  = self:GetParent()
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.agi = self.ability:GetSpecialValueFor("agi")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.asp = self.ability:GetSpecialValueFor("asp")
	self.count_max = 4

	if IsServer() then
		if self.ability.ex == nil then
			self.ability.ex = true
		end
		self.p =
			{
				Ability = self.ability,
				EffectName = "particles/items/butterfly_ex/butterfly_execon/items/drow/drow_bow_monarch/drow_frost_arrow_monarch.vpcf",
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
				iMoveSpeed = 2000,
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,
			}
	end
end



function modifier_butterfly_ex_passive:DeclareFunctions() return { MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_STATS_AGILITY_BONUS,} end
function modifier_butterfly_ex_passive:GetModifierAttackSpeedBonus_Constant() return self.asp end
function modifier_butterfly_ex_passive:GetModifierPreAttack_BonusDamage() return self.damage end
function modifier_butterfly_ex_passive:GetModifierBonusStats_Agility() return self.agi end
function modifier_butterfly_ex_passive:OnAttackLanded(tg)
    if not IsServer()  then
        return
    end
        if tg.attacker == self.parent and not self.parent:IsIllusion() and self.ability:IsCooldownReady() and self.ability.ex == true then
				local count = self.count_max
                local heros = FindUnitsInRadius(
                self.parent:GetTeamNumber(),
                tg.target:GetAbsOrigin(),
                nil,
                800,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                FIND_ANY_ORDER,
                false)
				
                if #heros>1 then
					self.ability:UseResources(true,false,  true, true)
                    for _,target in pairs(heros) do
                                if target~=tg.target then
								count = count - 1
									local p  =
												{
													Ability = self.ability,
													EffectName = "particles/items/butterfly_ex/butterfly_execon/items/drow/drow_bow_monarch/drow_frost_arrow_monarch.vpcf",
													iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
													iMoveSpeed = 2000,
													bDrawsOnMinimap = false,
													bDodgeable = true,
													bIsAttack = false,
													bVisibleToEnemies = true,
													bReplaceExisting = false,
													bProvidesVision = false,
													Target = target,
													Source = tg.target,	
												}									
                                        ProjectileManager:CreateTrackingProjectile(p)
										local particle = ParticleManager:CreateParticle("particles/items/butterfly_ex/butterfly_execon/items/drow/drow_bow_monarch/drow_frost_arrow_monarch_b.vpcf", PATTACH_POINT, tg.target)
										ParticleManager:SetParticleControl(particle, 1, tg.target:GetAbsOrigin())
										ParticleManager:ReleaseParticleIndex(particle)

                                end
								if count == 0 then
									break
								end
                        end
                end
				
				if PseudoRandom:RollPseudoRandom(self.ability, self.chance) then
					if not self.parent:HasModifier("modifier_butterfly_ex_agi") then
						self.parent:AddNewModifier(self.parent,self.ability,"modifier_butterfly_ex_agi",{duration = 6})
					end
				end
        end
end




