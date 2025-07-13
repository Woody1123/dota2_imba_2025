imba_trample=class({})
LinkLuaModifier("modifier_imba_trample_buff", "hg/hero_primal_beast/imba_trample.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trample_debuff", "hg/hero_primal_beast/imba_trample.lua", LUA_MODIFIER_MOTION_NONE)
function imba_trample:IsHiddenWhenStolen() return false end
function imba_trample:IsStealable() return true end

function imba_trample:OnSpellStart()
    self.caster=self:GetCaster()
    self.duration=self:GetSpecialValueFor("duration")
    self.caster:AddNewModifier(self.caster, self, "modifier_imba_trample_buff", {duration = self.duration })
end

--伤害事件
function imba_trample:Attack()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local radius=self:GetSpecialValueFor("effect_radius")
    local stacks=0
    local mag=self:GetSpecialValueFor("again_mag")
    if caster:HasModifier("modifier_imba_onslaught_charge") then
        stacks=self:GetCaster():FindModifierByName("modifier_imba_onslaught_charge"):GetStackCount()
    end
    --此处应该播放动画、特效声音
    local sound_cast = "Hero_PrimalBeast.Trample"
    EmitSoundOn(sound_cast, caster)
    local cast_particle = "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf"
	self.cast_effect = ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.cast_effect, 0, caster:GetAbsOrigin()) -- 0: Spotlight position,
	ParticleManager:SetParticleControl(self.cast_effect, 1, Vector(radius*(stacks*mag+1),1,1)) --3: shell and sprint effect position,
	


    --caster:StartGesture(ACT_DOTA_CHANNEL_ABILITY_4)

    local damage=self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("attack_damage")*caster:GetBaseDamageMax()/100

    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetAbsOrigin(),
			nil,
			radius*(stacks*mag+1)  ,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
			FIND_ANY_ORDER,
			false)
		for _,enemy in pairs(enemies) do
            local damageTable = {
						victim 			= enemy,
						damage 			= damage,
						damage_type		= self:GetAbilityDamageType(),
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self
						}
            enemy:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_trample_debuff", {duration = self:GetSpecialValueFor("debuff_duration")})
            ApplyDamage(damageTable)
		end
end

--自身BUFF
modifier_imba_trample_buff=class({})
function modifier_imba_trample_buff:IsHidden() return false end
function modifier_imba_trample_buff:IsPurgable() return false end
function modifier_imba_trample_buff:IsPermanent() return false end
function modifier_imba_trample_buff:IsDebuff() return false end


function modifier_imba_trample_buff:CheckState()
    --此处应有缴械
    return
    {
        [MODIFIER_STATE_DISARMED] = true,
    }
end

function modifier_imba_trample_buff:OnCreated()
    self:GetAbility():Attack()
    self:StartIntervalThink(0.05)
    self.pos=self:GetParent():GetAbsOrigin()
    self.distance=0
end

function modifier_imba_trample_buff:OnIntervalThink()
    local new_pos=self:GetParent():GetAbsOrigin()
    local new_distance=(new_pos - self.pos):Length2D()
    self.pos=new_pos
    if new_distance>1200 then
        return
    end
    self.distance=new_distance+self.distance
    if self.distance>=140 then
        self.distance=self.distance-140
        self:GetAbility():Attack()
    end

end

function modifier_imba_trample_buff:OnDestroy()
    self:StartIntervalThink(-1)
end


function modifier_imba_trample_buff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
function modifier_imba_trample_buff:GetEffectName()
        return "particles/generic_gameplay/generic_disarm.vpcf"
end



modifier_imba_trample_debuff=class({})
function modifier_imba_trample_debuff:IsHidden() return false end
function modifier_imba_trample_debuff:IsPurgable() return false end
function modifier_imba_trample_debuff:IsPermanent() return false end
function modifier_imba_trample_debuff:IsDebuff() return false end

function modifier_imba_trample_debuff:OnRefresh()
	if IsServer() then
        if self:GetStackCount()<self:GetAbility():GetSpecialValueFor("max_debuff") then
            self:SetStackCount(self:GetStackCount()+1)
        end
	end
end


function modifier_imba_trample_debuff:DeclareFunctions()
    return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_imba_trample_debuff:GetModifierMagicalResistanceBonus()
    return -self:GetAbility():GetSpecialValueFor('magic_res')*self:GetStackCount()
end
