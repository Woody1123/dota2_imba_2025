--额外降低50%克敌机先
item_imba_blade_mail=class({})
LinkLuaModifier("modifier_item_imba_blade_mail", "ting/items/item_imba_blade_mail.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_blade_mail_pa", "ting/items/item_imba_blade_mail.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_item_imba_blade_mail_cd", "ting/items/item_imba_blade_mail.lua", LUA_MODIFIER_MOTION_NONE)



function item_imba_blade_mail:GetIntrinsicModifierName()
    return "modifier_item_imba_blade_mail_pa"
end
function item_imba_blade_mail:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_item_blade_mail_reflect",{duration = self:GetSpecialValueFor("duration")})
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_item_blade_mail",{duration = self:GetSpecialValueFor("duration")})
end

modifier_item_imba_blade_mail_pa=class({})

function modifier_item_imba_blade_mail_pa:IsPassive()
    return true
end

function modifier_item_imba_blade_mail_pa:IsHidden()
    return true
end

function modifier_item_imba_blade_mail_pa:IsPurgable()
    return false
end

function modifier_item_imba_blade_mail_pa:IsPurgeException()
    return false
end

function modifier_item_imba_blade_mail_pa:AllowIllusionDuplicate()
    return false
end

function modifier_item_imba_blade_mail_pa:OnCreated()
	if self:GetAbility() == nil  then
        return
    end
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
	--self.cd = true
	self.team=self.parent:GetTeamNumber()
    self.attack=self.ability:GetSpecialValueFor("attack")
    self.evasion=self.ability:GetSpecialValueFor("evasion")
	self.armor=self.ability:GetSpecialValueFor("armor")
	self.damage=self.ability:GetSpecialValueFor("damage")
	self.per=self.ability:GetSpecialValueFor("per")*0.01
	self.damageTable =
        {
            attacker = self.parent,
            damage_type=DAMAGE_TYPE_PURE,
            damage_flags=DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            ability = self.ability,
        }
	self.fx=ParticleManager:CreateParticle("particles/econ/events/ti6/radiance_owner_ti6_pnt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
    self:AddParticle(self.fx, true, false, 1, false, false)
    if IsServer() then
        self:StartIntervalThink(2)
    end
end


function modifier_item_imba_blade_mail_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
		--MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_imba_blade_mail_pa:GetModifierPhysicalArmorBonus() 
	return self.armor
end
function modifier_item_imba_blade_mail_pa:GetModifierPreAttack_BonusDamage()
    return self.attack
end

function modifier_item_imba_blade_mail_pa:GetModifierEvasion_Constant()
    return self.evasion
end
--[[
function modifier_item_imba_blade_mail_pa:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	
	if keys.target == self.parent and keys.attacker:IsAlive() and keys.attacker:IsHero() and not keys.attacker:IsMagicImmune() and self.cd then
		self:fire(keys.attacker)	
		self.cd = false
	end
end]]
function modifier_item_imba_blade_mail_pa:OnIntervalThink()
    if  self.parent and  self.parent:IsAlive() then
        local units = FindUnitsInRadius(
        self.team,
        self.parent:GetAbsOrigin(),
        nil,
        500,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)
		self.damageTable.damage = self.parent:GetMaxHealth()*self.per + self.damage 
		--self.cd = true
        if #units>0 then
            for _, unit in pairs(units) do
				if not (unit:IsHero() and self.parent:IsInvisible()) then
					self:fire(unit)
				end
            end
        end
    end
end




function modifier_item_imba_blade_mail_pa:fire(unit)
	if IsServer() then
		self.damageTable.victim = unit
		--[[
		if unit:HasModifier("modifier_item_imba_blade_mail_cd") then
			return 
			else
			unit:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_item_imba_blade_mail_cd",{duration = 1.9})
		end]]
		ApplyDamage(self.damageTable)
	end
end

--[[
modifier_item_imba_blade_mail_cd=class({})


function modifier_item_imba_blade_mail_cd:IsHidden()
    return true
end

function modifier_item_imba_blade_mail_cd:IsPurgable()
    return false
end

function modifier_item_imba_blade_mail_cd:IsPurgeException()
    return false
end
]]









--------------------------------------------











