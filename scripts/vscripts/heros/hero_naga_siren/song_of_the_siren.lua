song_of_the_siren=class({})
LinkLuaModifier("modifier_song_of_the_siren_buff", "heros/hero_naga_siren/song_of_the_siren.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_song_of_the_siren_debuff", "heros/hero_naga_siren/song_of_the_siren.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_song_of_the_siren_buff2", "heros/hero_naga_siren/song_of_the_siren.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rip_tide_buff", "heros/hero_naga_siren/rip_tide.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rip_tide_buff2", "heros/hero_naga_siren/rip_tide.lua", LUA_MODIFIER_MOTION_NONE)
function song_of_the_siren:IsHiddenWhenStolen() 
    return false 
end

function song_of_the_siren:IsStealable() 
    return true 
end

function song_of_the_siren:IsRefreshable() 			
    return true 
end


function song_of_the_siren:OnSpellStart()
    local caster = self:GetCaster()
    local caster_team = caster:GetTeamNumber()
    local caster_pos = caster:GetAbsOrigin()
    local target = self:GetCursorTarget()
    local stack=0
    local fx= ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_siren_song_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW,caster)
    self.duration=self:GetSpecialValueFor( "duration" )+caster:TG_GetTalentValue("special_bonus_naga_siren_1")
    self.radius=self:GetSpecialValueFor( "radius" )
    ParticleManager:SetParticleControl(fx,0,  caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(fx, 60, Vector(math.random(0,255),math.random(0,255),math.random(0,255)))
    ParticleManager:SetParticleControl(fx, 61, Vector(1,1,1))
    ParticleManager:ReleaseParticleIndex(fx)
    caster:AddNewModifier(caster, self, "modifier_song_of_the_siren_buff", {duration=self.duration})
    local illusions=FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        self.radius+caster:GetCastRangeBonus(),
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
        FIND_ANY_ORDER,false)
    for _,illusion in pairs(illusions) do
        --print("找到了")
        if illusion:HasModifier("modifier_illusions_mirror_image") then
            --print("是我的幻象")
            illusion:AddNewModifier(caster, self, "modifier_song_of_the_siren_buff", {duration=self.duration})
        end
    end


    if caster:Has_Aghanims_Shard() and caster:HasAbility("rip_tide") then
        CreateModifierThinker(caster, self, "modifier_rip_tide_buff", {duration=self.duration,radius=self.radius}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
    end
    if caster:Has_Aghanims_Shard() then
    local heros = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        25000,
        DOTA_UNIT_TARGET_TEAM_BOTH, 
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        FIND_ANY_ORDER,false)
    if #heros>0 then
        for _, hero in pairs(heros) do
            if hero:GetName()=="npc_dota_hero_slark" then 
                if hero:HasModifier("modifier_imba_slark_essence_shift") then 
                    local BUFF=hero:FindModifierByName("modifier_imba_slark_essence_shift")
                    if BUFF~=nil and BUFF:GetStackCount()>0 then 
                        if caster:HasModifier("modifier_song_of_the_siren_buff2") then 
                            local  BUFF2=caster:FindModifierByName("modifier_song_of_the_siren_buff2")
                            if BUFF2~=nil and BUFF2:GetStackCount()<BUFF:GetStackCount() then 
                                caster:AddNewModifier(caster, self, "modifier_song_of_the_siren_buff2", {num=BUFF:GetStackCount()})  
                            end 
                        else
                            caster:AddNewModifier(caster, self, "modifier_song_of_the_siren_buff2", {num=BUFF:GetStackCount()})  
                        end
                    end 
                end
            end
        end
    end
end  
end

modifier_song_of_the_siren_buff=class({})

function modifier_song_of_the_siren_buff:IsDebuff() 			
    return false 
end

function modifier_song_of_the_siren_buff:IsHidden()
    return false 
end

function modifier_song_of_the_siren_buff:IsPurgable() 			
    return false 
end

function modifier_song_of_the_siren_buff:IsPurgeException() 	
    return false 
end

function modifier_song_of_the_siren_buff:StatusEffectPriority() 
    return 20
end

function modifier_song_of_the_siren_buff:GetStatusEffectName() 	
    return "particles/status_fx/status_effect_siren_song.vpcf" 
end

function modifier_song_of_the_siren_buff:CheckState()
	return {[MODIFIER_STATE_LOW_ATTACK_PRIORITY]=true}
end


function modifier_song_of_the_siren_buff:OnCreated() 
	if self:GetAbility() == nil then return end
    self.radius=self:GetAbility():GetSpecialValueFor( "radius" )
    self.duration=self:GetAbility():GetSpecialValueFor( "duration" )+self:GetCaster():TG_GetTalentValue("special_bonus_naga_siren_1")
    self.attsp=self:GetAbility():GetSpecialValueFor( "attsp" )	
    self.sp=self:GetAbility():GetSpecialValueFor( "sp" )
    self.rege_scepter=self:GetAbility():GetSpecialValueFor( "rege_scepter" )
    if not IsServer() then
        return
    end 
    self.radius=self.radius+self:GetCaster():GetCastRangeBonus()
    local fx= ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_song_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
    ParticleManager:SetParticleControl(fx,0,  self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(fx, 60, Vector(math.random(0,255),math.random(0,255),math.random(0,255)))
    ParticleManager:SetParticleControl(fx, 61, Vector(1,1,1))
    self:AddParticle(fx, false, false, 20, false, false)
    self:GetParent():EmitSound("Hero_NagaSiren.SongOfTheSiren")
    self:StartIntervalThink(1)
end

function modifier_song_of_the_siren_buff:OnIntervalThink()
     	
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self.radius, 
        DOTA_UNIT_TARGET_TEAM_BOTH, 
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER,false)
    if #heros>0 then
        for _, hero in pairs(heros) do
            if Is_Chinese_TG(hero,self:GetParent()) then 
                if  self:GetParent():HasScepter() and not self:GetParent():HasModifier("modifier_illusions_mirror_image") then
                    local hp=self.rege_scepter*0.01*hero:GetMaxHealth()
                    hero:Heal(hp , self:GetParent() )
                    SendOverheadEventMessage(hero, OVERHEAD_ALERT_HEAL, hero,hp, nil)
                end
            else 
                if hero:IsAlive() and not hero:IsMagicImmune() and not self:GetParent():IsChanneling()  then
                    hero:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_song_of_the_siren_debuff", {duration= 1})
                end
            end
        end
    end
end

function modifier_song_of_the_siren_buff:OnDestroy() 
    self.sp=nil	
    self.attsp=nil	
    self.radius=nil
    self.duration=nil
    self.rege_scepter=nil
    if not IsServer() then
        return
    end 
    self:GetParent():StopSound("Hero_NagaSiren.SongOfTheSiren")
end

function modifier_song_of_the_siren_buff:DeclareFunctions() 
    return 
    { 
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    } 
end

function modifier_song_of_the_siren_buff:GetModifierMoveSpeedBonus_Percentage()
    return self.sp
end


function modifier_song_of_the_siren_buff:GetModifierAttackSpeedBonus_Constant()
    return self.attsp
end

function modifier_song_of_the_siren_buff:GetModifierIgnoreMovespeedLimit()
    if self:GetCaster():Has_Aghanims_Shard() then
        return 1
    end
        return false
end


modifier_song_of_the_siren_debuff=class({})

function modifier_song_of_the_siren_debuff:IsDebuff() 			
    return true 
end

function modifier_song_of_the_siren_debuff:IsHidden() 			
    return false 
end

function modifier_song_of_the_siren_debuff:IsPurgable() 			
    return true 
end

function modifier_song_of_the_siren_debuff:IsPurgeException() 	
    return true 
end

function modifier_song_of_the_siren_debuff:GetEffectAttachType() 	
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_song_of_the_siren_debuff:GetEffectName() 	
    return "particles/units/heroes/hero_siren/naga_siren_song_debuff.vpcf" 
end

function modifier_song_of_the_siren_debuff:CheckState()
	return { [MODIFIER_STATE_ATTACK_ALLIES] = true,
}
end
function modifier_song_of_the_siren_debuff:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end
function modifier_song_of_the_siren_debuff:OnCreated() 
	if self:GetAbility() == nil then return end
	if IsServer() then
		local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        1000, 
        DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_CLOSEST,false)
		if #heros>1 then
			for _,hero in pairs(heros) do
				if hero~=self:GetParent()  then  
					self:GetParent():MoveToTargetToAttack(hero)
					break
				end
			end
		end
	end
end

modifier_song_of_the_siren_buff2=class({})

function modifier_song_of_the_siren_buff2:GetTexture() 			
    return "slark_hphover" 
end

function modifier_song_of_the_siren_buff2:IsDebuff() 			
    return false 
end

function modifier_song_of_the_siren_buff2:IsHidden() 			
    return false 
end

function modifier_song_of_the_siren_buff2:IsPurgable() 			
    return false 
end

function modifier_song_of_the_siren_buff2:IsPurgeException() 	
    return false 
end

function modifier_song_of_the_siren_buff2:OnCreated(tg) 	
	if self:GetAbility() == nil then return end
   if IsServer() then 
    self:SetStackCount(tg.num)
   end
end

function modifier_song_of_the_siren_buff2:OnRefresh(tg) 	
     self:OnCreated(tg) 
 end

function modifier_song_of_the_siren_buff2:DeclareFunctions() 
    return 
    { 
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS
    } 
end

function modifier_song_of_the_siren_buff2:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end