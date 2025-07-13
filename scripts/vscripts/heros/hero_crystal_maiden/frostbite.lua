frostbite=class({})
LinkLuaModifier("modifier_frostbite_debuff", "heros/hero_crystal_maiden/frostbite.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostbite_buff", "heros/hero_crystal_maiden/frostbite.lua", LUA_MODIFIER_MOTION_NONE)
function frostbite:IsHiddenWhenStolen()
    return false
end

function frostbite:IsStealable()
    return true
end


function frostbite:IsRefreshable()
    return true
end


function frostbite:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")
    local damage = self:GetSpecialValueFor("total_damage")
    if  target:TG_TriggerSpellAbsorb(self)   then
        return
    end
    EmitSoundOn("hero_Crystal.frostbite",target)

                    local damageTable = {
                        attacker = caster,
                        victim = target,
                        damage = damage,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self
                    }
                    ApplyDamage(damageTable)
            target:AddNewModifier_RS(caster, self, "modifier_frostbite_debuff", {duration = duration,count = self:GetSpecialValueFor("count")})
    



end

function frostbite:OnProjectileHit_ExtraData(target, location,kv)
        if not target then
            return
        end
        if not target:IsMagicImmune() then
			local damageTable = {
                        attacker = self:GetCaster(),
                        victim = target,
                        damage = self:GetCaster():GetIntellect(false),
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self
                    }
                    ApplyDamage(damageTable)
             --self:GetCaster():PerformAttack(target, true, true, true, false, false, false, false)
        end
end

modifier_frostbite_debuff=class({})

function modifier_frostbite_debuff:IsDebuff()
    return true
end

function modifier_frostbite_debuff:IsPurgable()
    return true
end

function modifier_frostbite_debuff:IsPurgeException()
    return true
end

function modifier_frostbite_debuff:IsHidden()
    return false
end

function modifier_frostbite_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_frostbite_debuff:GetEffectName()
    return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_frostbite_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_frostbite_debuff:OnCreated(keys)
    if self:GetAbility() == nil then return end
    self.rd=self:GetAbility():GetSpecialValueFor("rd")
    self.total_damage=self:GetAbility():GetSpecialValueFor("total_damage")
    self.duration=self:GetAbility():GetSpecialValueFor("duration")
	self.count = keys.count
        if IsServer() then
            if self:GetCaster():Has_Aghanims_Shard() then
                    self:StartIntervalThink(0.5)
            end
        end
end

function modifier_frostbite_debuff:OnIntervalThink()
    if self:GetAbility() == nil  or not self:GetParent():IsAlive() then
            return
    end
            local enemies = FindUnitsInRadius(
                self:GetCaster():GetTeamNumber(),
                self:GetParent():GetAbsOrigin(),
                self:GetCaster(),
                1000,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE,
                FIND_FARTHEST,
                false)
                if  #enemies>0 then
                        local enemy=enemies[RandomInt(1,#enemies)]
                        		local P =
                                {
                                    Target = enemy,
                                    Source = self:GetParent(),
                                    Ability = self:GetAbility(),
                                    EffectName = "particles/econ/events/snowball/snowball_projectile.vpcf",
                                    iMoveSpeed = 1200,
                                    vSourceLoc = self:GetParent():GetAbsOrigin(),
                                    bDrawsOnMinimap = false,
                                    bDodgeable = false,
                                    bIsAttack = false,
                                    bVisibleToEnemies = true,
                                    bReplaceExisting = false,
                                    bProvidesVision = false,
                                }
                            ProjectileManager:CreateTrackingProjectile(P)
                end
end

function modifier_frostbite_debuff:CheckState()
    return
    {	
        [MODIFIER_STATE_ROOTED] = not self:GetParent():IsMagicImmune(),
        [MODIFIER_STATE_DISARMED] = not self:GetParent():IsMagicImmune(),
        [MODIFIER_STATE_TETHERED] = not self:GetParent():IsMagicImmune(),
    }
end

function modifier_frostbite_debuff:OnDestroy()
        if IsServer() then
            local enemies = FindUnitsInRadius(
                self:GetCaster():GetTeamNumber(),
                self:GetParent():GetAbsOrigin(),
                self:GetCaster(),
                self.rd,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                FIND_FARTHEST,
                false)
				if self.count > 0 then
					if  #enemies>0 then
							for _,target in pairs(enemies) do
								if   target~=self:GetParent() then
										EmitSoundOn("hero_Crystal.frostbite",target)
										if   self:GetCaster():TG_HasTalent("special_bonus_crystal_maiden_3") then
												local damageTable = {
												attacker =  self:GetCaster(),
												victim = target,
												damage =  self.total_damage,
												damage_type = DAMAGE_TYPE_MAGICAL,
												ability = self:GetAbility()
											}
											ApplyDamage(damageTable)
										end
										target:AddNewModifier_RS(self:GetCaster(), self:GetAbility(), "modifier_frostbite_debuff", {duration =  self.duration,count = self.count - 1})
										return
								end
							end
					end
				end
        end
end
