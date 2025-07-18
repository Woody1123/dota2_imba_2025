CreateTalents("npc_dota_hero_leshrac", "traveler/leshrac_abilities.lua")

        --------------------------------------------------------------------
-- 拉席克
--------------------------------------------------------------------

    LinkLuaModifier("modifier_imba_leshrac_split_earth_thinker", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_leshrac_split_earth_stunned", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)

    LinkLuaModifier("modifier_imba_leshrac_diabolic_edict_aura", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_leshrac_diabolic_edict_aura_effect", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)

    LinkLuaModifier("modifier_imba_leshrac_lightning_storm", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_leshrac_lightning_storm_slow", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_leshrac_lightning_storm_thinker", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)

    LinkLuaModifier("modifier_imba_leshrac_pulse_nova", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_leshrac_pulse_nova_armor", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)



    

    imba_leshrac_split_earth = class({})
    imba_leshrac_diabolic_edict = class({})
    imba_leshrac_lightning_storm = class({})
    imba_leshrac_pulse_nova = class({})


    
    modifier_imba_leshrac_split_earth_thinker = class({}) -- 魔晶也在其中
    modifier_imba_leshrac_split_earth_stunned = class({})

    modifier_imba_leshrac_diabolic_edict_aura = class({})  -- 光环效果用于与脉冲新星的效果核算
    modifier_imba_leshrac_diabolic_edict_aura_effect = class({})

    modifier_imba_leshrac_lightning_storm = class({}) 
    modifier_imba_leshrac_lightning_storm_slow = class({})
    modifier_imba_leshrac_lightning_storm_thinker = class({}) -- 脉冲新星的弹射

    modifier_imba_leshrac_pulse_nova = class({})
    modifier_imba_leshrac_pulse_nova_armor = class({}) --


    --------------------------------------------------------------------
    --音效
    --------------------------------------------------------------------
    -- 
    -- 
    -- 
    -- 
    -- 
    -- 

    --------------------------------------------------------------------
    --台词
    --------------------------------------------------------------------
    -- 
    -- 
    -- 
    -- 
    -- 
    -- 

    --------------------------------------------------------------------
    --特效
    --------------------------------------------------------------------
    -- 
    -- 
    -- 
    -- 
    -- 
    --
    -- 
    -- 
    -- 
    -- 
    -- 
    --
    function Tsplit(inputstr, sep)
        if sep == nil then sep = "%s" end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
        end
        return t
    end  
    
    --------------------------------------------------------------------
    -- 撕裂大地  DeepPrintTable
    --------------------------------------------------------------------
        function imba_leshrac_split_earth:IsHiddenWhenStolen()  return false end
        function imba_leshrac_split_earth:IsRefreshable() return true end
        function imba_leshrac_split_earth:IsStealable() return true end
        function imba_leshrac_split_earth:GetAOERadius() return self:GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_leshrac_1") end
        function imba_leshrac_split_earth:OnAbilityPhaseStart()
            local caster = self:GetCaster()
            if 1 then
                self:SetOverrideCastPoint(0)
            end
            return true
        end
        function imba_leshrac_split_earth:OnSpellStart()
            local caster = self:GetCaster()
            local pos = self:GetCursorPosition()
            if caster:GetName() == "npc_dota_hero_leshrac" then
                if RandomInt(1, 100) <= 40 then
                    caster:EmitSound("leshrac_lesh_ability_split_0"..math.random(1,5))
                end
            end
            local delay = self:GetSpecialValueFor("delay")
            local auto = 1--self:GetAutoCastState() and 1 or 0
            CreateModifierThinker(caster,self,"modifier_imba_leshrac_split_earth_thinker",{duration = delay, auto = auto},pos,caster:GetTeamNumber(),false)
            if auto == 1 then
                local castpoint = tonumber( Tsplit(self:GetAbilityKeyValues()["AbilityCastPoint"])[self:GetLevel()] )   
                self:SetOverrideCastPoint( castpoint )
               -- self:EndCooldown()
                --self:StartCooldown( self:GetCooldown(-1)*self:GetSpecialValueFor("imba_cd_mul") )
            end
        end
        --------------------------------------------------------------------
        --撕裂大地延迟
        --------------------------------------------------------------------
        function SplitEarthEffect( caster, ability, pos, radius, damage, duration, bShard )
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(),pos,nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)
            for _,enemy in pairs(enemies) do
                enemy:AddNewModifier(caster, ability, "modifier_imba_leshrac_split_earth_stunned",{duration = duration})
                ApplyDamage({victim = enemy,attacker = caster,damage = damage,damage_type = ability:GetAbilityDamageType(), ability = ability})
                if bShard then
                    FindClearSpaceForUnit( enemy, pos, true )
                end
            end
            EmitSoundOnLocationWithCaster(pos, "Hero_Leshrac.Split_Earth", caster)
            GridNav:DestroyTreesAroundPoint(pos, radius, true)
            local effectname = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf" 
            local pfx = ParticleManager:CreateParticle(effectname, PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, pos)
            ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 1, 1))
            ParticleManager:ReleaseParticleIndex(pfx) 
        end
        function PlaySplitEarthShardEffect(  pos, radius )
            local effectname = "particles/units/heroes/hero_leshrac/leshrac_split_earth_aoe.vpcf"
            local pfx = ParticleManager:CreateParticle(effectname, PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, pos)
            ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 1, 1)) 
            return pfx
        end
        function modifier_imba_leshrac_split_earth_thinker:OnCreated(keys)
			if self:GetAbility() == nil then return end
            if IsServer() then 
                self.auto = keys.auto
            end
        end
        function modifier_imba_leshrac_split_earth_thinker:OnDestroy()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            local pos = parent:GetAbsOrigin()
            local radius = ability:GetAOERadius()
            local duration = ability:GetSpecialValueFor("duration")
            local damage = ability:GetAbilityDamage()
            SplitEarthEffect( caster, ability, pos, radius, damage, duration )           
            if self.auto == 1 then
                Timers:CreateTimer(0.03, function()     
                    local imba_count = ability:GetSpecialValueFor("imba_count")
                    local imba_radius = ability:GetSpecialValueFor("imba_radius")
                    local imba_range = ability:GetSpecialValueFor("imba_range")
                    for i=1,imba_count do
                        local imba_pos = caster:GetAbsOrigin() + RandomVector( RandomInt( imba_radius, imba_range) )
                        SplitEarthEffect( caster, ability, imba_pos, imba_radius, imba_radius, duration )              
                    end
                    return nil
                    end)
            end
            if caster:Has_Aghanims_Shard() then
                local shard_interval = ability:GetSpecialValueFor("shard_interval")
                local shard_radius_increase = ability:GetSpecialValueFor("shard_radius_increase")
                local shard_count = ability:GetSpecialValueFor("shard_count")   
                local shard_pfx = PlaySplitEarthShardEffect(  pos, radius + shard_radius_increase )
                Timers:CreateTimer( shard_interval, function()
                    radius = radius + shard_radius_increase
                    SplitEarthEffect( caster, ability, pos, radius, damage, duration, true )
                    ParticleManager:DestroyParticle( shard_pfx, false )
                    ParticleManager:ReleaseParticleIndex(shard_pfx)
                    shard_count = shard_count - 1 
                    if shard_count > 0 then
                        shard_pfx = PlaySplitEarthShardEffect(  pos, radius + shard_radius_increase )
                        return shard_interval
                    else   
                        return nil
                    end
                end)

            end
        end
        --------------------------------------------------------------------
        --撕裂大地晕眩
        --------------------------------------------------------------------
        function modifier_imba_leshrac_split_earth_stunned:IsDebuff()        return true end
        function modifier_imba_leshrac_split_earth_stunned:IsHidden()        return false end
        function modifier_imba_leshrac_split_earth_stunned:IsPurgable()      return false end
        function modifier_imba_leshrac_split_earth_stunned:IsPurgeException() return true  end
        function modifier_imba_leshrac_split_earth_stunned:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
        function modifier_imba_leshrac_split_earth_stunned:GetOverrideAnimation() return ACT_DOTA_DISABLED end
        function modifier_imba_leshrac_split_earth_stunned:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
        function modifier_imba_leshrac_split_earth_stunned:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
        function modifier_imba_leshrac_split_earth_stunned:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
        function modifier_imba_leshrac_split_earth_stunned:ShouldUseOverheadOffset() return true end
        function modifier_imba_leshrac_split_earth_stunned:IsStunDebuff() return true end
    --------------------------------------------------------------------
    -- 恶魔敕令
    --------------------------------------------------------------------
        function imba_leshrac_diabolic_edict:IsHiddenWhenStolen() return false end
        function imba_leshrac_diabolic_edict:IsRefreshable() return true end
        function imba_leshrac_diabolic_edict:IsStealable() return true end
        function imba_leshrac_diabolic_edict:GetCastRange() return self:GetSpecialValueFor("radius") end
        function imba_leshrac_diabolic_edict:OnSpellStart()
            local caster = self:GetCaster() 
            if caster:GetName() == "npc_dota_hero_leshrac" then
                if RandomInt(1, 100) <= 40 then
                    caster:EmitSound("leshrac_lesh_ability_edict_0"..math.random(1,5))
                end
            end
            local duration = self:GetSpecialValueFor("duration") + caster:TG_GetTalentValue("special_bonus_imba_leshrac_6")
            caster:AddNewModifier(caster, self, "modifier_imba_leshrac_diabolic_edict_aura",{duration = duration})
        end
        --------------------------------------------------------------------
        --恶魔敕令爆炸
        --------------------------------------------------------------------
        function modifier_imba_leshrac_diabolic_edict_aura:IsDebuff() return false end
        function modifier_imba_leshrac_diabolic_edict_aura:IsPurgable() return false end
        function modifier_imba_leshrac_diabolic_edict_aura:IsHidden() return false end
        function modifier_imba_leshrac_diabolic_edict_aura:RemoveOnDeath() return false end
        function modifier_imba_leshrac_diabolic_edict_aura:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
        function modifier_imba_leshrac_diabolic_edict_aura:OnCreated()
			if self:GetAbility() == nil then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            self.radius = ability:GetSpecialValueFor("radius")
            if not IsServer() then return end   
            local duration = ability:GetSpecialValueFor("duration") --self:GetDuration()
            local num_explosions = ability:GetSpecialValueFor("num_explosions") + caster:TG_GetTalentValue("special_bonus_imba_leshrac_7")
            local interval = duration/num_explosions
			self.num = ability:GetSpecialValueFor("num")
			self.damage = ability:GetSpecialValueFor("damage")
            parent:EmitSound("Hero_Leshrac.Diabolic_Edict_lp")
			self.damage_table = {
				damage = self.damage,
				attacker = caster,
				damage_type = ability:GetAbilityDamageType(), 
				ability = ability,
			}
            self:StartIntervalThink(interval)
        end
        function modifier_imba_leshrac_diabolic_edict_aura:OnIntervalThink()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            local pos = parent:GetAbsOrigin()
            local radius = self.radius
            local effectname = "particles/units/heroes/hero_leshrac/leshrac_diabolic_edict.vpcf"
            local pfx = ParticleManager:CreateParticle(effectname, PATTACH_CUSTOMORIGIN, nil)
			local num = self.num
			self:GetParent():Heal(self.damage*(1+caster:GetSpellAmplification(false)),self:GetCaster())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.damage*(1+caster:GetSpellAmplification(false)), nil)
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(),pos,nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,ability:GetAbilityTargetType(),
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_ANY_ORDER,false)
            if #enemies > 0 then
					for _,enemy in pairs( enemies ) do
						self.damage_table.victim = enemy
						if enemy:IsDisarmed() then
								self.damage_table.damage_type = DAMAGE_TYPE_PURE				
							else
								if enemy:IsBuilding() then
								self.damage_table.damage = self.damage*(1+ability:GetSpecialValueFor("tower_bonus")/100) 	
								end
						end		
						ApplyDamage(self.damage_table)							
						ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true) 
						num = num -1 
						if num == 0 then break end
					end
				else
					ParticleManager:SetParticleControl( pfx, 1, parent:GetAbsOrigin() + RandomVector(RandomInt(1,radius)) )
				end
            parent:EmitSound("Hero_Leshrac.Diabolic_Edict")
            ParticleManager:ReleaseParticleIndex(pfx)
        end
        function modifier_imba_leshrac_diabolic_edict_aura:OnDestroy()
            if not IsServer() then return end
            local parent = self:GetParent()
            parent:StopSound("Hero_Leshrac.Diabolic_Edict_lp")
        end
        
    --------------------------------------------------------------------
    -- 闪电风暴
    --------------------------------------------------------------------
        function imba_leshrac_lightning_storm:IsHiddenWhenStolen() return false end
        function imba_leshrac_lightning_storm:IsStealable() return true end
        function imba_leshrac_lightning_storm:IsRefreshable() return true end

        function imba_leshrac_lightning_storm:OnSpellStart()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local target = self:GetCursorTarget()
            local auto = self:GetAutoCastState()
            caster:AddNewModifier(caster, self, "modifier_imba_leshrac_lightning_storm", {target = target:entindex(), auto = auto})
        end
        --------------------------------------------------------------------
        --闪电风暴跳跃
        --------------------------------------------------------------------
        function modifier_imba_leshrac_lightning_storm:IsDebuff() return false end
        function modifier_imba_leshrac_lightning_storm:IsHidden() return true end
        function modifier_imba_leshrac_lightning_storm:IsPurgable() return false end
        function modifier_imba_leshrac_lightning_storm:RemoveOnDeath() return false end
        function modifier_imba_leshrac_lightning_storm:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
        function modifier_imba_leshrac_lightning_storm:OnCreated(keys)
			if self:GetAbility() == nil then return end
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            self.target = EntIndexToHScript(keys.target)
            self.auto = keys.auto 
            local jump_delay = ability:GetSpecialValueFor("jump_delay")
            self.jump_count = ability:GetSpecialValueFor("jump_count") + caster:TG_GetTalentValue("special_bonus_imba_leshrac_2")
			if self.auto == 1 then
				self.jump_count = self.jump_count/2
			end
            self.damage = ability:GetSpecialValueFor("damage") 
            self.slow_duration = ability:GetSpecialValueFor("slow_duration") + caster:TG_GetTalentValue("special_bonus_imba_leshrac_3") 
            self.count = 0
            self.hitted = {}
            self:StartIntervalThink(jump_delay)
        end
        function modifier_imba_leshrac_lightning_storm:OnIntervalThink()
            if not IsServer() then return end
            local target = self.target
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            local damage = self.damage
            local slow_duration = self.slow_duration
            target:EmitSound("Hero_Leshrac.Lightning_Storm")
            local effectname = "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf"
            local pfx = ParticleManager:CreateParticle(effectname, PATTACH_CUSTOMORIGIN, target)
            ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0,0,2000))
            ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true) 
            ParticleManager:ReleaseParticleIndex(pfx)
            if not target:IsMagicImmune() and not target:IsOutOfGame() and not target:IsInvulnerable() then
                ApplyDamage({victim = target,attacker = parent,damage = damage,damage_type = ability:GetAbilityDamageType(), ability = ability})
                target:AddNewModifier(caster, ability, "modifier_imba_leshrac_lightning_storm_slow", {duration = slow_duration})
            end
            self.count = self.count + 1
            if self.count >= self.jump_count then self:Destroy() return end
            table.insert(self.hitted,target)
            local next_target = nil 
            local radius = ability:GetSpecialValueFor("radius")
            local enemies = FindUnitsInRadius(parent:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,FIND_CLOSEST,false)
            if self.auto ~= 1 then-- 不弹射给自身
                for i=#enemies,1,-1 do
                    if enemies[i] == target then
                        table.remove( enemies, i )
                        break
                    end
                end
                next_target = enemies[RandomInt(1,#enemies)]
            else
                for _,enemy in pairs(enemies) do
                    if not IsInTable(self.hitted, enemy) then
                        next_target = enemy
                        break
                    end
                end
            end
            if next_target == nil then
                self:Destroy() 
                return
            else
                self.target = next_target
            end
        end
        --------------------------------------------------------------------
        --闪电风暴减速
        --------------------------------------------------------------------
        function modifier_imba_leshrac_lightning_storm_slow:IsHidden() return false end
        function modifier_imba_leshrac_lightning_storm_slow:IsDebuff() return true end
        function modifier_imba_leshrac_lightning_storm_slow:IsPurgable() return true end
        function modifier_imba_leshrac_lightning_storm_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
        function modifier_imba_leshrac_lightning_storm_slow:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("slow_movement_speed") end
        function modifier_imba_leshrac_lightning_storm_slow:GetEffectName() return "particles/units/heroes/hero_leshrac/leshrac_lightning_slow.vpcf" end
        function modifier_imba_leshrac_lightning_storm_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
        --------------------------------------------------------------------
        --闪电风暴-神杖
        --------------------------------------------------------------------
        function modifier_imba_leshrac_lightning_storm_thinker:IsDebuff() return false end
        function modifier_imba_leshrac_lightning_storm_thinker:IsPurgable() return false end
        function modifier_imba_leshrac_lightning_storm_thinker:IsHidden() return true end
        function modifier_imba_leshrac_lightning_storm_thinker:RemoveOnDeath() return false end
        function modifier_imba_leshrac_lightning_storm_thinker:OnCreated()
			if self:GetAbility() == nil then return end
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            local interval = ability:GetSpecialValueFor("interval_scepter")
            self:StartIntervalThink(interval)
        end
        function modifier_imba_leshrac_lightning_storm_thinker:OnIntervalThink()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            if not parent:HasModifier("modifier_imba_leshrac_pulse_nova") then return end
            local damage = ability:GetSpecialValueFor("damage")
            local slow_duration = ability:GetSpecialValueFor("slow_duration") + caster:TG_GetTalentValue("special_bonus_imba_leshrac_3") 
            local count = 1
            local radius = ability:GetSpecialValueFor("radius_scepter")
            local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS ,FIND_ANY_ORDER,false)
            local effectname = "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf"
            for i=1,count do
                if enemies[i] == nil then
                    break
                else
                    enemies[i]:EmitSound("Hero_Leshrac.Lightning_Storm")
                    local pfx = ParticleManager:CreateParticle(effectname, PATTACH_CUSTOMORIGIN, enemies[i])
                    ParticleManager:SetParticleControl(pfx, 0, enemies[i]:GetAbsOrigin() + Vector(0,0,2000))
                    ParticleManager:SetParticleControlEnt(pfx, 1, enemies[i], PATTACH_POINT_FOLLOW, "attach_hitloc", enemies[i]:GetAbsOrigin(), true) 
                    ParticleManager:ReleaseParticleIndex(pfx)
                    ApplyDamage({victim = enemies[i],attacker = parent,damage = damage,damage_type = ability:GetAbilityDamageType(), ability = ability})
                    enemies[i]:AddNewModifier(caster, ability, "modifier_imba_leshrac_lightning_storm_slow", {duration = slow_duration})
                end
            end
        end
    --------------------------------------------------------------------
    -- 脉冲新星
    --------------------------------------------------------------------
        function imba_leshrac_pulse_nova:IsHiddenWhenStolen() return false end
        function imba_leshrac_pulse_nova:IsRefreshable() return true end
        function imba_leshrac_pulse_nova:IsStealable() return true end
        function imba_leshrac_pulse_nova:OnInventoryContentsChanged()
            local caster = self:GetCaster()
            local ability = caster:FindAbilityByName("imba_leshrac_greater_lightning_storm")
            if caster:HasScepter() and ( ability ~= nil and ability:IsHidden() ) then
                ability:SetLevel(1)
                ability:SetHidden(false)                
            elseif not caster:HasScepter() and ( ability ~= nil and not ability:IsHidden() ) then
                ability:SetHidden(true)
            end
        end
        function imba_leshrac_pulse_nova:GetCastRange() 
            local caster = self:GetCaster()
            return self:GetSpecialValueFor("radius") + caster:TG_GetTalentValue("special_bonus_imba_leshrac_4")
        end
        function imba_leshrac_pulse_nova:OnToggle()
            if not IsServer() then return end
            local caster = self:GetCaster()
            caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
            if self:GetToggleState() then
                caster:AddNewModifier(caster, self, "modifier_imba_leshrac_pulse_nova", {})
            else
                caster:RemoveModifierByName("modifier_imba_leshrac_pulse_nova")
            end
        end
        --------------------------------------------------------------------
        --脉冲新星-开
        --------------------------------------------------------------------
        function modifier_imba_leshrac_pulse_nova:IsDebuff() return false end
        function modifier_imba_leshrac_pulse_nova:IsPurgable() return  false end
        function modifier_imba_leshrac_pulse_nova:IsHidden() return false end
        function modifier_imba_leshrac_pulse_nova:OnCreated()
			if self:GetAbility() == nil then return end
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            local interval = ability:GetSpecialValueFor("interval")
            parent:EmitSound("Hero_Leshrac.Pulse_Nova")
            self:StartIntervalThink(interval)
            local mana_cost_per_second = ability:GetSpecialValueFor("mana_cost_per_second")
            parent:SpendMana(mana_cost_per_second, ability)
            self:PulseNovaStrike()
        end
        function modifier_imba_leshrac_pulse_nova:OnIntervalThink()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            local mana_cost_per_second = ability:GetSpecialValueFor("mana_cost_per_second")
            if parent:GetMana() < mana_cost_per_second then
                self:Destroy()
                return
            end
            parent:SpendMana(mana_cost_per_second, ability)
            self:PulseNovaStrike()
        end
        function modifier_imba_leshrac_pulse_nova:PulseNovaStrike()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            local duration = ability:GetSpecialValueFor("duration")
            local damage = ability:GetSpecialValueFor("damage") + caster:TG_GetTalentValue("special_bonus_imba_leshrac_5")
            local radius = ability:GetSpecialValueFor("radius") + caster:TG_GetTalentValue("special_bonus_imba_leshrac_4")
            local effectname = "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf"
            local enemies = FindUnitsInRadius(parent:GetTeamNumber(),parent:GetAbsOrigin(),nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)
            for _,enemy in pairs(enemies) do
                EmitSoundOn("Hero_Leshrac.Pulse_Nova_Strike", enemy)
                local pfx = ParticleManager:CreateParticle(effectname, PATTACH_ABSORIGIN, parent)
                ParticleManager:SetParticleControl(pfx, 0, enemy:GetAbsOrigin())
                ParticleManager:SetParticleControl(pfx, 1, Vector(1,0,0))
                ParticleManager:ReleaseParticleIndex(pfx)
				--[[
                if enemy:HasModifier("modifier_imba_leshrac_diabolic_edict_aura_effect") then
                    enemy:AddNewModifier( caster, ability, "modifier_imba_leshrac_pulse_nova_armor", {duration = duration})
                end]]
			if enemy:IsHero() then
				if enemy:IsDisarmed() then 
					self:SetStackCount(self:GetStackCount()+1)
					else
					if self:GetStackCount()>0 then
						self:SetStackCount(self:GetStackCount()-1)
						caster:AddNewModifier(caster, ability,"modifier_imba_leshrac_pulse_nova_armor",{duration = 0.5})
						enemy:AddNewModifier(caster, ability,"modifier_imba_leshrac_pulse_nova_armor",{duration = 0.5})
					end
				end
			end
                ApplyDamage({victim = enemy,attacker = parent,damage = damage,damage_type = ability:GetAbilityDamageType(), ability = ability})
            end
        end
		
        function modifier_imba_leshrac_pulse_nova:OnDestroy()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            if ability:GetToggleState() then
                ability:ToggleAbility()
            end
            parent:StopSound("Hero_Leshrac.Pulse_Nova")
        end
        function modifier_imba_leshrac_pulse_nova:GetEffectName() return "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf" end
        function modifier_imba_leshrac_pulse_nova:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
    --------------------------------------------------------------------
    -- 脉冲新星-护甲削弱
    --------------------------------------------------------------------
	
		function modifier_imba_leshrac_pulse_nova_armor:GetEffectName() return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf" end
		function modifier_imba_leshrac_pulse_nova_armor:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
		function modifier_imba_leshrac_pulse_nova_armor:CheckState() return {
		[MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_ATTACK_IMMUNE] = Is_Chinese_TG(self:GetParent(),self:GetCaster())} end
        function modifier_imba_leshrac_pulse_nova_armor:IsHidden() return false end
        function modifier_imba_leshrac_pulse_nova_armor:IsPurgable() return true end
        function modifier_imba_leshrac_pulse_nova_armor:IsDebuff() return (self:GetParent()==self:GetCaster()) and true or false end
        function modifier_imba_leshrac_pulse_nova_armor:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
        function modifier_imba_leshrac_pulse_nova_armor:GetModifierMagicalResistanceBonus() return (self:GetParent()==self:GetCaster()) and 0 or -40 end
		
		
-----虚无主义-------------------

imba_leshrac_greater_lightning_storm = class({})
LinkLuaModifier("modifier_imba_leshrac_greater_lightning_storm_aura", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leshrac_greater_lightning_storm_buff", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leshrac_greater_lightning_storm_debuff", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_leshrac_greater_lightning_storm_life", "traveler/leshrac_abilities.lua", LUA_MODIFIER_MOTION_NONE)
function imba_leshrac_greater_lightning_storm:IsHiddenWhenStolen() return false end
function imba_leshrac_greater_lightning_storm:IsRefreshable() return true end
function imba_leshrac_greater_lightning_storm:IsStealable() return true end

function imba_leshrac_greater_lightning_storm:OnSpellStart()
	local charge = self:GetCurrentAbilityCharges()+1
	self:SetCurrentAbilityCharges(0)
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_imba_leshrac_greater_lightning_storm_aura",{duration = charge*self:GetSpecialValueFor("duration")})
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_imba_leshrac_greater_lightning_storm_buff",{duration = charge*self:GetSpecialValueFor("duration")})
	EmitSoundOn("Hero_Leshrac.Nihilism.Cast", self:GetCaster())
end	

modifier_imba_leshrac_greater_lightning_storm_life = class({})
function modifier_imba_leshrac_greater_lightning_storm_life:IsDebuff() return false end
function modifier_imba_leshrac_greater_lightning_storm_life:IsPurgable() return  false end
function modifier_imba_leshrac_greater_lightning_storm_life:IsHidden() return true end
function modifier_imba_leshrac_greater_lightning_storm_life:AllowIllusionDuplicate() 
    return false 
end

function modifier_imba_leshrac_greater_lightning_storm_life:DeclareFunctions() 
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    } 
end

function modifier_imba_leshrac_greater_lightning_storm_life:GetModifierIncomingDamage_Percentage()
	return -50
end
function modifier_imba_leshrac_greater_lightning_storm_life:OnCreated()
	if self:GetAbility() == nil then
		return 
	end
	if IsServer() then		
		local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_scepter_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle2, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(particle2, true, false, -1, false, false)	
	end
end
modifier_imba_leshrac_greater_lightning_storm_buff = class({})
function modifier_imba_leshrac_greater_lightning_storm_buff:IsDebuff() return false end
function modifier_imba_leshrac_greater_lightning_storm_buff:IsPurgable() return  true end
function modifier_imba_leshrac_greater_lightning_storm_buff:IsPurgeException() return  true end
function modifier_imba_leshrac_greater_lightning_storm_buff:IsHidden() return true end
function modifier_imba_leshrac_greater_lightning_storm_buff:CheckState()
	return {[MODIFIER_STATE_ATTACK_IMMUNE ] = true}
end
function modifier_imba_leshrac_greater_lightning_storm_buff:DeclareFunctions() 
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		}
end

function modifier_imba_leshrac_greater_lightning_storm_buff:GetAbsoluteNoDamagePhysical()return 1
end
function modifier_imba_leshrac_greater_lightning_storm_buff:GetModifierMoveSpeedBonus_Percentage() 
	return self.msp
end
function modifier_imba_leshrac_greater_lightning_storm_buff:GetModifierMagicalResistanceBonus() 
	return self.mgr
end	
function modifier_imba_leshrac_greater_lightning_storm_buff:OnCreated()
	if self:GetAbility() == nil then
		return 
	end
	self.msp = self:GetAbility():GetSpecialValueFor("msp")
	self.mgr = self:GetAbility():GetSpecialValueFor("magic_amp")
end
function modifier_imba_leshrac_greater_lightning_storm_buff:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_imba_leshrac_greater_lightning_storm_aura")
		if self:GetRemainingTime() > 0.1 and self:GetParent():IsAlive() then
			self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_imba_leshrac_greater_lightning_storm_life",{duration = self:GetRemainingTime()+1})
		end
	end
end
modifier_imba_leshrac_greater_lightning_storm_aura = class({})

function modifier_imba_leshrac_greater_lightning_storm_aura:IsAura() return true end
function modifier_imba_leshrac_greater_lightning_storm_aura:GetAuraDuration() return 0.5 end
function modifier_imba_leshrac_greater_lightning_storm_aura:GetModifierAura() return "modifier_imba_leshrac_greater_lightning_storm_debuff" end
function modifier_imba_leshrac_greater_lightning_storm_aura:GetAuraRadius() return self.radius end
function modifier_imba_leshrac_greater_lightning_storm_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_leshrac_greater_lightning_storm_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_leshrac_greater_lightning_storm_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_imba_leshrac_greater_lightning_storm_aura:OnCreated()
	if self:GetAbility() == nil then
		return 
	end
	self.radius =  self:GetAbility():GetSpecialValueFor("radius")
	if IsServer() then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_scepter_nihilism_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(particle, true, false, -1, false, false)	
		
		local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_scepter_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle2, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(particle2, true, false, -1, false, false)	
	end
end

modifier_imba_leshrac_greater_lightning_storm_debuff = class({})
function modifier_imba_leshrac_greater_lightning_storm_debuff:IsDebuff() return true end
function modifier_imba_leshrac_greater_lightning_storm_debuff:IsPurgable() return  true end
function modifier_imba_leshrac_greater_lightning_storm_debuff:IsHidden() return false end

function modifier_imba_leshrac_greater_lightning_storm_debuff:CheckState()
	return {[MODIFIER_STATE_DISARMED ] = true}
end

function modifier_imba_leshrac_greater_lightning_storm_debuff:DeclareFunctions() 
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    } 
end
function modifier_imba_leshrac_greater_lightning_storm_debuff:GetModifierMoveSpeedBonus_Percentage() 
	return self.msp
end
function modifier_imba_leshrac_greater_lightning_storm_debuff:GetModifierMagicalResistanceBonus() 
	return self.mgr
end		
function modifier_imba_leshrac_greater_lightning_storm_debuff:OnCreated()
	--particles/units/heroes/hero_leshrac/leshrac_scepter_target.vpcf
	if self:GetAbility() == nil then return end
	self.msp = self:GetAbility():GetSpecialValueFor("msp")*-1
	self.mgr = self:GetAbility():GetSpecialValueFor("magic_amp")*-1
	EmitSoundOn("Hero_Leshrac.Nihilism.Target", self:GetParent())
	if IsServer() then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_scepter_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(particle, true, false, -1, false, false)	
	end
end
