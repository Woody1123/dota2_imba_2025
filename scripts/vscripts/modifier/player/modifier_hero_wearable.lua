modifier_hero_wearable=class({})

function modifier_hero_wearable:IsHidden()
    return true
end

function modifier_hero_wearable:IsPurgable()
    return false
end

function modifier_hero_wearable:IsPurgeException()
    return false
end

function modifier_hero_wearable:RemoveOnDeath()
    return false
end

function modifier_hero_wearable:IsPermanent()
    return true
end

function modifier_hero_wearable:OnCreated()
      self.parent=self:GetParent()
      self.isWHide=false
      if IsServer() then
            self:StartIntervalThink(0.1)
      end
end

function modifier_hero_wearable:OnIntervalThink()
      if  not self.parent:IsAlive() or self.parent:IsIllusion()  then return end
      if self.parent.WearablesTable~=nil then
            if ( self.parent:IsHexed() or self.parent:IsOutOfGame() ) or self:HasWearableBuff()  and self.isWHide==false then
                  self.isWHide=true
                  wearable:HideClothing(self.parent.WearablesTable)
            elseif  self.isWHide==true  and not self.parent:IsHexed() and not self.parent:IsOutOfGame()  and not self:HasWearableBuff() then
                  self.isWHide=false
                  wearable:ShowClothing(self.parent.WearablesTable)
            end
      end
end

function modifier_hero_wearable:HasWearableBuff()
	for i=1, #HIDE_BUFF_Wearables do
            if   self.parent:HasModifier( HIDE_BUFF_Wearables[i] ) then
                  return true
            end
      end
      return false
end