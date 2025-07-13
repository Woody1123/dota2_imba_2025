c_return = class({})
LinkLuaModifier("modifier_c_return", "heros/hero_centaur/c_return.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_c_return_buff", "heros/hero_centaur/c_return.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_c_return_buffsp", "heros/hero_centaur/c_return.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_c_return_dam", "heros/hero_centaur/c_return.lua", LUA_MODIFIER_MOTION_NONE)
function c_return:GetIntrinsicModifierName() 
    return "modifier_c_return" 
end


modifier_c_return=class({})

function modifier_c_return:IsHidden() 			
	return true 
end

function modifier_c_return:IsPurgable() 		
	return false 
end

function modifier_c_return:IsPurgeException() 	
	return false 
end


function modifier_c_return:OnCreated() 	
	if self:GetAbility() == nil then return end
    if not IsServer() then
		return
    end
    if not  self:GetParent():IsIllusion() then 
        self:GetParent():AddNewModifier(self:GetParent(),  self:GetAbility(), "modifier_c_return_dam", {num=0})
        self:StartIntervalThink(5)
    end
end

function modifier_c_return:OnIntervalThink() 	
    if self:GetAbility():IsCooldownReady() then
    if self:GetParent():HasModifier("modifier_c_return_buff")  then 
        self:GetParent():RemoveModifierByName("modifier_c_return_buff")
    end 
        self:GetParent():AddNewModifier(self:GetParent(),  self:GetAbility(), "modifier_c_return_buff", {})
        self:GetAbility():UseResources(false,  false,false, true)
    end
end

function modifier_c_return:DeclareFunctions() 
    return 
    {
       
        MODIFIER_EVENT_ON_DEATH
    } 
end


function modifier_c_return:OnDeath(tg) 
    if not IsServer() then
		return
    end
    if tg.attacker==self:GetParent() then 
        if tg.unit~=self:GetParent() then
            if self:GetParent():HasModifier("modifier_c_return_dam") then 
                local modifier=self:GetParent():FindModifierByName("modifier_c_return_dam")
                if modifier~=nil and modifier:GetStackCount()<25 then 
                    --TG_Modifier_Num_ADD(self:GetParent(),"modifier_c_return_dam",1,1)
                    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_c_return_dam", {num=5})
                end 
            end
        end
    end
end

modifier_c_return_buff=class({})

function modifier_c_return_buff:IsHidden() 			
	return false 
end

function modifier_c_return_buff:IsPurgable() 		
	return false 
end

function modifier_c_return_buff:IsPurgeException() 	
	return false 
end

function modifier_c_return_buff:GetEffectName() 	
	return "particles/heros/centaur/shield.vpcf" 
end

function modifier_c_return_buff:GetEffectAttachType() 	
	return PATTACH_OVERHEAD_FOLLOW 
end

function modifier_c_return_buff:ShouldUseOverheadOffset() 
    return true 
end

function modifier_c_return_buff:OnCreated() 
	if self:GetAbility() == nil then return end
    if not IsServer() then
		return
    end
	self.shield_count = self:GetAbility():GetSpecialValueFor( "return_ar" )+self:GetParent():TG_GetTalentValue("special_bonus_centaur_4")+math.floor(self:GetParent():GetStrength()*self:GetAbility():GetSpecialValueFor( "return_str" )*0.01)
	self:SetStackCount(self.shield_count)
end

function modifier_c_return_buff:OnRefresh()
    self:OnCreated()
end

function modifier_c_return_buff:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,		
	}
end

function modifier_c_return_buff:GetModifierIncomingDamageConstant(keys)
		if not IsServer() then
			 return self:GetStackCount() 
		end		 
		--print(self:GetParent():GetHealth())
		 self.shield_count = self.shield_count - keys.damage     		
		 self:SetStackCount(math.max(1,self.shield_count))
		 if self:GetStackCount() == 1 then
			self:Destroy()
		 end
		return -(self.shield_count + keys.damage) 
end

modifier_c_return_buffsp=class({})

function modifier_c_return_buffsp:IsHidden() 			
	return false 
end

function modifier_c_return_buffsp:IsPurgable() 		
	return false 
end

function modifier_c_return_buffsp:IsPurgeException() 	
	return false 
end

function modifier_c_return_buffsp:GetEffectName() 
    return "particles/units/heroes/hero_centaur/centaur_stampede.vpcf" 
end

function modifier_c_return_buffsp:GetEffectAttachType()
     return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_c_return_buffsp:OnCreated() 
	if self:GetAbility() == nil then return end
    self.sp=self:GetAbility():GetSpecialValueFor( "spdes" )	
end

function modifier_c_return_buffsp:OnRefresh()
    self:OnCreated()
end

function modifier_c_return_buffsp:DeclareFunctions() 
    return 
    {
       
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    } 
end


function modifier_c_return_buffsp:GetModifierMoveSpeedBonus_Percentage() 
    return self.sp
end

modifier_c_return_dam=class({})

function modifier_c_return_dam:IsHidden() 			
	return false 
end

function modifier_c_return_dam:IsPurgable() 		
	return false 
end

function modifier_c_return_dam:IsPurgeException() 	
	return false 
end

function modifier_c_return_dam:IsPermanent() 	
	return true 
end

function modifier_c_return_dam:RemoveOnDeath() 	
	return false 
end

function modifier_c_return_dam:GetTexture() 	
	return "centaur_return" 
end

function modifier_c_return_dam:OnCreated(tg) 
	if self:GetAbility() == nil then return end
    if not IsServer() then
		return
    end
	self.broken = (self:GetParent():GetName() == "npc_dota_hero_centaur") and false or true
	self.broken = true
	if self:GetParent():GetName() == "npc_dota_hero_centaur" then
		self.broken = false
	end
    self:SetStackCount(self:GetStackCount()+tg.num)
end

function modifier_c_return_dam:OnRefresh(tg) 
    self:OnCreated(tg)
end

function modifier_c_return_dam:DeclareFunctions() 
    return 
    {
       
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    } 
end


function modifier_c_return_dam:GetModifierIncomingDamage_Percentage() 
    return  (self:GetParent():PassivesDisabled() and self.broken) and 0 or (self:GetStackCount()*-1)
end