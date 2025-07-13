item_rd_book2=class({})

function item_rd_book2:OnSpellStart()
      local caster=self:GetCaster()
      if caster.Random_Skill then
                  caster:EmitSound("DOTA_Item.Tango.Activate")
                  local name=caster:GetAbilityByIndex(1):GetName()
                  local modifier_count = caster:GetModifierCount()
                  if modifier_count>0 then
                        for i = 0, modifier_count do
                              local modifier_name = caster:GetModifierNameByIndex(i)
                              if modifier_name then
                                    local mod=caster:FindModifierByName(modifier_name)
                                    if mod and mod:GetAbility()==caster:GetAbilityByIndex(1) then
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
                  local abname=TG_AbilityBook_Get_Normal(caster)
                  while(caster:HasAbility(abname))
                  do
                        abname=TG_AbilityBook_Get_Normal(caster)
                  end
                  if abname then
                        local ab=caster:AddAbility(abname)
                        ab:SetLevel(4)
                        -- caster.Random_Skill=ab
                        -- CDOTA_PlayerResource.RD_SK[caster:GetPlayerOwnerID()]=ab:GetName()
                        -- CustomNetTables:SetTableValue("rd_skills", "RDSK", CDOTA_PlayerResource.RD_SK)
                         if abname=="tower" then
                                    ab:StartDefense()
                        end
                  end
      end
      self:SpendCharge(0)
end