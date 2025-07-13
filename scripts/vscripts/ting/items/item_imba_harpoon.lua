item_imba_harpoon = class({})

LinkLuaModifier("modifier_imba_harpoon_force_ally", "ting/items/item_imba_harpoon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_harpoon_debuff", "ting/items/item_imba_harpoon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_harpoon_passive", "ting/items/item_imba_harpoon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_harpoon_cd", "ting/items/item_imba_harpoon", LUA_MODIFIER_MOTION_NONE)

function item_imba_harpoon:GetIntrinsicModifierName()
	return "modifier_imba_harpoon_passive"
end


function item_imba_harpoon:OnSpellStart()
	if not IsServer() then return end
	
	local ability = self
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local caster_location = caster:GetAbsOrigin()
	local duration = ability:GetSpecialValueFor("duration")
	if GridNav:IsNearbyTree(self:GetCursorPosition(),1,false) then
		target = CreateModifierThinker(caster, nil, "modifier_dummy_thinker", {duration = 1.0}, self:GetCursorPosition(), caster:GetTeamNumber(), false)
	end
	
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", self:GetCaster())

	local projectile =
		{
			Target 				= target,
			Source 				= caster,
			Ability 			= self,
			EffectName 			= "particles/items_fx/harpoon_projectile.vpcf",
			iMoveSpeed			= 2200,
			vSourceLoc 			= caster_location,
			bDrawsOnMinimap 	= false,
			bDodgeable 			= false,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			bProvidesVision 	= false,
		}
		TG_CreateProjectile({id=1,team=caster:GetTeamNumber(),owner=caster,p=projectile})
end

function item_imba_harpoon:OnProjectileHit(target, location)
	local caster = self:GetCaster()
	local duration = 0.25
	caster:TG_IS_ProjectilesValue(function()
		target=nil
  	end)
	if target then
		--if target:TriggerSpellAbsorb(self) then return nil end
		target:EmitSound("DOTA_Item.RodOfAtos.Target")
		local tar = 1
		if Is_Chinese_TG(target,caster) and target ~= caster then
			caster:AddNewModifier(target, self, "modifier_imba_harpoon_force_ally", {duration = duration,tar = 2})
			else
				if target:IsMagicImmune() or (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()>1200 or not target:IsHero() then
					caster:AddNewModifier(target, self, "modifier_imba_harpoon_force_ally", {duration = duration,tar = 2})
					else
					target:AddNewModifier(caster, self, "modifier_imba_harpoon_force_ally", {duration = duration,tar = 1}) 
					caster:AddNewModifier(target, self, "modifier_imba_harpoon_force_ally", {duration = duration,tar = 1})
				end			
			end

		end

end



modifier_imba_harpoon_passive = class({})
LinkLuaModifier("modifier_imba_harpoon_nerf", "ting/items/item_imba_harpoon", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_harpoon_passive:IsDebuff()			return false end
function modifier_imba_harpoon_passive:IsHidden() 			return true end
function modifier_imba_harpoon_passive:IsPurgable() 		return false end
function modifier_imba_harpoon_passive:IsPurgeException() 	return false end
function modifier_imba_harpoon_passive:GetModifierBonusStats_Intellect() return self.int end
function modifier_imba_harpoon_passive:GetModifierBonusStats_Agility() return self.agi end
function modifier_imba_harpoon_passive:GetModifierBonusStats_Strength() return self.str end
function modifier_imba_harpoon_passive:GetModifierHealthBonus() return self.hp end

function modifier_imba_harpoon_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.ability=self:GetAbility()
	self.parent = self:GetParent()
    self.stats=self.ability:GetSpecialValueFor("stat") or 0
    self.asp=self.ability:GetSpecialValueFor("asp") or 0
    self.mp_re=self.ability:GetSpecialValueFor("mp_re") or 0
    self.att=self.ability:GetSpecialValueFor("att") or 0
	self.damage = self.ability:GetSpecialValueFor("damage") or 0
	self.cd_d = self.ability:GetSpecialValueFor("cd") or 0
	if IsServer() then
		self.attack_speed = math.max(900-self.parent:GetDisplayAttackSpeed(),100)
	end
	self.buff = false
	self.cd = false
end
function modifier_imba_harpoon_passive:OnIntervalThink()
	if IsServer() then
		self.buff = false
		self:StartIntervalThink(-1)
	end
end

function modifier_imba_harpoon_passive:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end
--[[
function modifier_imba_harpoon_passive:GetModifierBaseAttackTimeConstant()
	if self.buff == true then
		return 1.6
	end
end]]

function modifier_imba_harpoon_passive:GetModifierProcAttack_BonusDamage_Magical(keys)
	if not self:GetParent():IsIllusion() and not keys.target:IsBuilding() and self.buff == true then
		keys.target:AddNewModifier(self:GetParent(),self.ability,"modifier_imba_harpoon_debuff",{duration = 1})
		return 100
	end
end	

function modifier_imba_harpoon_passive:OnAttack(tg)
    if not IsServer() or tg.attacker:IsIllusion() then
        return
    end
    if tg.attacker == self:GetParent()  and not self.parent:HasModifier("modifier_imba_harpoon_cd") and not self:GetParent():IsRangedAttacker() then
		self.attack_speed = math.max(900-self.parent:GetDisplayAttackSpeed(),100)
		self.buff = true
		self:StartIntervalThink(0.6)
        self.parent:AddNewModifier(self.parent,self.ability,"modifier_imba_harpoon_cd",{duration = self.cd_d})
    end
end

function modifier_imba_harpoon_passive:OnDeath(tg)
    if not IsServer() or tg.attacker:IsIllusion() then
        return
    end
    if tg.attacker == self:GetParent() and tg.unit:IsHero() then
		
        self.parent:RemoveModifierByName("modifier_imba_harpoon_cd")
		self.ability:EndCooldown()
    end
end

function modifier_imba_harpoon_passive:GetModifierBonusStats_Intellect()
    return  self.stats
end

function modifier_imba_harpoon_passive:GetModifierBonusStats_Agility()
    return  self.stats
end

function modifier_imba_harpoon_passive:GetModifierBonusStats_Strength()
    return  self.stats
end

function modifier_imba_harpoon_passive:GetModifierAttackSpeedBonus_Constant()
    return self.buff == true and self.attack_speed or self.asp
end

function modifier_imba_harpoon_passive:GetModifierPreAttack_BonusDamage()
    return self.att
end

function modifier_imba_harpoon_passive:GetModifierConstantManaRegen()
    return self.mp_re
end

modifier_imba_harpoon_cd= class({})
function modifier_imba_harpoon_cd:GetTexture() 		return "item_imba_harpoon" end

function modifier_imba_harpoon_cd:IsHidden()
    return false
end

function modifier_imba_harpoon_cd:IsPurgable()
    return false
end
function modifier_imba_harpoon_cd:IsDebuff()
    return true
end
function modifier_imba_harpoon_cd:IsPurgeException()
    return false
end

modifier_imba_harpoon_debuff= class({})


function modifier_imba_harpoon_debuff:IsHidden()
    return false
end

function modifier_imba_harpoon_debuff:IsPurgable()
    return false
end

function modifier_imba_harpoon_debuff:IsPurgeException()
    return false
end

function modifier_imba_harpoon_debuff:GetTexture() 		
	return "item_imba_harpoon" 
end

function modifier_imba_harpoon_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_imba_harpoon_debuff:GetModifierMoveSpeedBonus_Percentage()
   return  -100
end



modifier_imba_harpoon_force_ally = class({})

function modifier_imba_harpoon_force_ally:IsDebuff() return false end
function modifier_imba_harpoon_force_ally:IsHidden() return true end
function modifier_imba_harpoon_force_ally:IsPurgable() return false end

function modifier_imba_harpoon_force_ally:OnCreated(params)
	if self:GetAbility() == nil then return end
	if not IsServer() then return end
	--对时间结界，决斗或黑洞内的单位无效。
	if self:GetParent():HasModifier("modifier_imba_legion_commander_duel") or self:GetParent():HasModifier("modifier_black_hole_debuff2") or self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_debuff") or self:GetParent():HasModifier("modifier_seer_vacuum_m") then
		self:Destroy()
		return
	end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.distance = 1000
	self.tar = params.tar or 1
	self.distance_per = 0.45
	if self.tar and self.tar==2 then
		self.distance_per=0.98
	end
	--特效
	local pfx_name = "particles/econ/events/fall_2021/force_staff_fall_2021.vpcf"
	
	self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	
	self.angle = (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
	self.distance = math.min((self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()*self.distance_per,9999)

	--speed
	self.force_pos = GetGroundPosition(( self:GetParent():GetAbsOrigin() + self.angle * self.distance ), nil)
	self.speed = self.distance / self:GetDuration()
	self.dis = self.speed*FrameTime()
	self:StartIntervalThink(FrameTime())
	
end

function modifier_imba_harpoon_force_ally:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	--over motion
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 200, false)
	--remove kv
	self.pfx = nil 
	self.angle = nil 
	self.distance = nil 
	self.force_pos = nil 
	self.speed = nil
end

function modifier_imba_harpoon_force_ally:OnIntervalThink()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local distance = self.distance
	local direction = (self.force_pos - self.parent:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + direction * self.dis, nil)
	self:GetParent():SetOrigin(next_pos)
	GridNav:DestroyTreesAroundPoint(next_pos, 150, false)
end

function modifier_imba_harpoon_force_ally:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_harpoon_force_ally:CheckState()
	if Is_Chinese_TG(self:GetParent(),self:GetCaster()) then
		local state =
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_UNSELECTABLE]	= true,
			[MODIFIER_STATE_STUNNED] = true,
		}
	return state
	end
	return
end


