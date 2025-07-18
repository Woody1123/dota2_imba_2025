tower=class({})

function tower:OnHeroLevelUp()
   self:StartDefense()
end

function tower:StartDefense()
        local CASTER=self:GetCaster()
        local LV=CASTER:GetLevel()
        if LV==6 then
            CASTER:TG_Find_Tower(function(tower)
                if tower==nil then return end
                tower:Set_HP(self:GetSpecialValueFor("hp"),false)
            end)
        elseif LV==10 then
            CASTER:TG_Find_Tower(function(tower)
                if tower==nil then return end
                tower:SetPhysicalArmorBaseValue(tower:GetPhysicalArmorBaseValue()+self:GetSpecialValueFor("ar"))
            end)
        elseif LV==14 then
            CASTER:TG_Find_Tower(function(tower)
                if tower==nil then return end
                if not tower:HasAbility("filler_ability") then
                    tower:AddAbility("filler_ability"):SetLevel(1)
                end
            end)
        elseif LV==18 then
            CASTER:TG_Find_Tower(function(tower)
                if tower==nil then return end
            if not tower:HasAbility("clinkz_searing_arrows") then
                local ab=tower:AddAbility("clinkz_searing_arrows")
                ab:SetLevel(4)
                ab:ToggleAutoCast()
            end
        end)
        end
end
