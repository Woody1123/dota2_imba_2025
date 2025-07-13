item_rd_book=class({})

function item_rd_book:OnSpellStart()
      local caster=self:GetCaster()
      if caster.Random_Skill then
                  caster:EmitSound("DOTA_Item.Tango.Activate")
                  local name=caster.Random_Skill:GetName()
                  --print(name)
                  local modifier_count = caster:GetModifierCount()
                  if modifier_count>0 then
                        for i = 0, modifier_count do
                              local modifier_name = caster:GetModifierNameByIndex(i)
                              if modifier_name then
                                    local mod=caster:FindModifierByName(modifier_name)
                                    if mod and mod:GetAbility()==caster.Random_Skill then
                                          caster:RemoveModifierByName(modifier_name)
                                    end
                              end
                        end
                  end
                  if name=="prot" then
                              caster:StopSound("Hero_Pudge.Rot")
                  elseif name=="flame_guard" then
                              caster:StopSound("Hero_EmberSpirit.FlameGuard.Loop")
                  end
                  caster:RemoveAbility(name)
                  local abname=TG_AbilityBook_Get(caster)
                  while(caster:HasAbility(abname))
                  do
                        abname=TG_AbilityBook_Get(caster)
                  end
                  if abname then
                        local ab=caster:AddAbility(abname)
                        ab:SetLevel(4)
                        caster.Random_Skill=ab
                        CDOTA_PlayerResource.RD_SK[caster:GetPlayerOwnerID()]=ab:GetName()
                        CustomNetTables:SetTableValue("rd_skills", "RDSK", CDOTA_PlayerResource.RD_SK)
						--print(ab:GetName())
                         if abname=="tower" then
                                    ab:StartDefense()
                        end
                  end
      end
	  
	  if caster.Random_Skill == nil then
				 
	              local abname=TG_AbilityBook_Get(caster)
                  while(caster:HasAbility(abname))
                  do
                        abname=TG_AbilityBook_Get(caster)
                  end
                  if abname then
                        local ab=caster:AddAbility(abname)
                        ab:SetLevel(4)
                        caster.Random_Skill=ab
                        CDOTA_PlayerResource.RD_SK[caster:GetPlayerOwnerID()]=ab:GetName()
                        CustomNetTables:SetTableValue("rd_skills", "RDSK", CDOTA_PlayerResource.RD_SK)
                         if abname=="tower" then
                              ab:StartDefense()
                        end
						caster:SwapAbilities(caster.Random_Skill:GetAbilityName(), "generic_hidden", true, false)
                  end
	  end
      self:SpendCharge(0)
end