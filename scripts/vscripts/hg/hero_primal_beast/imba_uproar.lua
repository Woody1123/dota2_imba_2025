imba_uproar=class({})
LinkLuaModifier("modifier_imba_uproar_buff_1", "hg/hero_primal_beast/imba_uproar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_uproar_buff_2", "hg/hero_primal_beast/imba_uproar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_uproar_debuff", "hg/hero_primal_beast/imba_uproar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_uproar_stack_buff", "hg/hero_primal_beast/imba_uproar.lua", LUA_MODIFIER_MOTION_NONE)


function imba_uproar:IsHiddenWhenStolen() 		return false end
function imba_uproar:IsRefreshable() 			return false end
function imba_uproar:IsStealable() 				return true end



function imba_uproar:GetIntrinsicModifierName()
    return "modifier_imba_uproar_stack_buff"
end


function imba_uproar:CastFilterResult(tg)
    local caster=self:GetCaster()
    if not caster:HasModifier("modifier_imba_uproar_stack_buff") or  caster:GetModifierStackCount("modifier_imba_uproar_stack_buff", nil)<=0 then
        return UF_FAIL_CUSTOM
    end
	local buff_stack = caster:GetModifierStackCount("modifier_imba_uproar_stack_buff", nil)
    if (caster:IsStunned() or caster:IsNightmared() or caster:IsSilenced() )and not caster:TG_HasTalent("special_bonus_imba_primal_beast_7")then
            return UF_FAIL_CUSTOM
    end
    --caster:Purge(false, true, false, true, true)
end

function imba_uproar:GetCustomCastError(tg)
    return "无法释放"
end



function imba_uproar:OnSpellStart()
    self.caster=self:GetCaster()
    EmitSoundOn("Hero_PrimalBeast.Uproar.Cast", self.caster)
    if not self.caster:HasModifier("modifier_imba_uproar_stack_buff") or  self.caster:GetModifierStackCount("modifier_imba_uproar_stack_buff", nil)<=0 then
        return
    end
    self.max_stack=self:GetSpecialValueFor("stack_limit")
    local buff = self.caster:FindModifierByName("modifier_imba_uproar_stack_buff")
    self.radius=self:GetSpecialValueFor("radius")
    self.stun_duration=self:GetSpecialValueFor("stun_duration")
    local buff_stack=buff:GetStackCount()
    self.caster:AddNewModifier(self.caster, self, "modifier_imba_uproar_buff_1", {duration = self:GetSpecialValueFor("roar_duration"),stack_count=(buff_stack>=5 and 5 or buff_stack)})
    self:StartCooldown(self:GetSpecialValueFor("roar_duration"))
    local parent_loc	= self:GetCaster():GetAbsOrigin()
    if buff:GetStackCount()>=self.max_stack then
        self.caster:AddNewModifier(self.caster, self, "modifier_imba_uproar_buff_2", {duration = (buff_stack-self.max_stack)*self:GetSpecialValueFor("roar_res")})
    end

    local knockback_properties = {
         center_x 			= parent_loc.x,
         center_y 			= parent_loc.y,
         center_z 			= parent_loc.z,
         duration 			= 0.4,
         knockback_duration = 0.4,
         knockback_distance = 500,
         knockback_height 	= 150,
    }

    local enemies =FindUnitsInRadius(self.caster:GetTeamNumber(),
        self.caster:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
        FIND_ANY_ORDER,
        false)
    for _,enemy in pairs(enemies) do
        enemy:AddNewModifier_RS(self.caster, self, "modifier_imba_uproar_debuff", {duration = self:GetSpecialValueFor("slow_duration"),stack_count=(buff_stack>=5 and 5 or buff_stack)})
        if buff_stack>=self.max_stack*2 then
            if self.caster:IsStunned() or self.caster:IsNightmared() or self.caster:IsSilenced() or self.caster:IsRooted() then
                local knockback_modifier = enemy:AddNewModifier(self.caster, self, "modifier_knockback", knockback_properties)
                if knockback_modifier then
                    knockback_modifier:SetDuration(self.stun_duration, true)
                end
            else
                enemy:AddNewModifier_RS( self.caster, self, "modifier_stunned", {duration =  self.stun_duration})
            end

        end
    end
    if self.caster:TG_HasTalent("special_bonus_imba_primal_beast_7")then
        self.caster:Purge(false, true, false, true, true)
    end

    buff:SetStackCount(0)
end


modifier_imba_uproar_stack_buff=class({})

function modifier_imba_uproar_stack_buff:IsHidden()
    return false
end

function modifier_imba_uproar_stack_buff:IsPurgable()
    return false
end

function modifier_imba_uproar_stack_buff:IsPurgeException()
    return false
end

function modifier_imba_uproar_stack_buff:RemoveOnDeath()
    if self:GetParent():HasAbility("imba_uproar")then
        return false
    end
    return true
end

function modifier_imba_uproar_stack_buff:DeclareFunctions()
return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS
    }
end

function modifier_imba_uproar_stack_buff:OnCreated()
    if not IsServer() then
		return
	end
    self.stack_duration = self:GetAbility():GetSpecialValueFor("stack_duration")
    self.stack_limit = self:GetAbility():GetSpecialValueFor("stack_limit")
    self:StartIntervalThink(self.stack_duration)
end

function modifier_imba_uproar_stack_buff:OnRefresh()
    self:OnDestroy()
    self:OnCreated()
end

function modifier_imba_uproar_stack_buff:OnIntervalThink()
    if not IsServer() then
		return
	end
    if not self:GetAbility() then
        self:Destroy()
    end
    if self:GetParent():HasModifier("modifier_imba_uproar_buff_1") then
        return
    end
    if  self:GetStackCount()<self.stack_limit then
        self:SetStackCount(self:GetStackCount()+1)
    elseif self:GetStackCount()>self.stack_limit then
        self:SetStackCount(self:GetStackCount()-1)
    end
end


function modifier_imba_uproar_stack_buff:OnTakeDamage(tg)
    if tg.unit==self:GetParent() and tg.damage>self:GetAbility():GetSpecialValueFor("damage_limit") and IsHeroDamage(tg.attacker, tg.damage) then
        if self:GetParent():HasModifier("modifier_imba_uproar_buff_1") then
            return
        end
        if self:GetStackCount()<self.stack_limit*2 then
            self:SetStackCount(self:GetStackCount()+1)
        end
        self:StartIntervalThink(self.stack_duration)
    end
end



function modifier_imba_uproar_stack_buff:GetModifierExtraStrengthBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end


modifier_imba_uproar_buff_1=class({})
function modifier_imba_uproar_buff_1:IsHidden()
    return false
end

function modifier_imba_uproar_buff_1:IsPurgable()
    return false
end

function modifier_imba_uproar_buff_1:IsPurgeException()
    return false
end

function modifier_imba_uproar_buff_1:RemoveOnDeath()
    return true
end

function modifier_imba_uproar_buff_1:DeclareFunctions()
return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_imba_uproar_buff_1:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("roared_bonus_armor")*self:GetStackCount()
end

function modifier_imba_uproar_buff_1:GetModifierMagicalResistanceBonus()
    return self:GetAbility():GetSpecialValueFor("roared_bonus_magical")*self:GetStackCount()
end

function modifier_imba_uproar_buff_1:GetModifierBaseAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage_per_stack")*self:GetStackCount()
end



function modifier_imba_uproar_buff_1:OnCreated(key)
    local cast_particle = "particles/units/heroes/hero_primal_beast/primal_beast_uproar_magic_resist.vpcf"
    self.cast_effect = ParticleManager:CreateParticle(cast_particle, PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt(self.cast_effect,2,self:GetParent(),PATTACH_OVERHEAD_FOLLOW,"absorigin",Vector(0,0,300), true )
    self:AddParticle(self.cast_effect,false, false, -1, false, false )
    if key.stack_count then
        self:SetStackCount(key.stack_count)
    else
        self:SetStackCount(1)
    end
end


function modifier_imba_uproar_buff_1:ShouldUseOverheadOffset()return true
end


modifier_imba_uproar_buff_2=class({})
function modifier_imba_uproar_buff_2:IsHidden()
    return false
end

function modifier_imba_uproar_buff_2:IsPurgable()
    return false
end

function modifier_imba_uproar_buff_2:IsPurgeException()
    return false
end

function modifier_imba_uproar_buff_2:RemoveOnDeath()
    return true
end

function modifier_imba_uproar_buff_2:CheckState()
    return{ [MODIFIER_STATE_MAGIC_IMMUNE] = true}
end

function modifier_imba_uproar_buff_2:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_uproar_buff_2:GetEffectName()
    return "particles/tgp/items/bkbs/black_king_bar_avatar_w.vpcf"
end



modifier_imba_uproar_debuff=class({})
function modifier_imba_uproar_debuff:IsHidden()
    return false
end

function modifier_imba_uproar_debuff:IsPurgable()
    return true
end

function modifier_imba_uproar_debuff:IsPurgeException()
    return true
end

function modifier_imba_uproar_debuff:IsDebuff()
    return true
end

function modifier_imba_uproar_debuff:OnCreated(key)
    if key.stack_count then
        self:SetStackCount(key.stack_count)
    else
        self:SetStackCount(1)
    end
end


function modifier_imba_uproar_debuff:DeclareFunctions()
    return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_uproar_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -self:GetAbility():GetSpecialValueFor("move_slow_per_stack")*self:GetStackCount()
end