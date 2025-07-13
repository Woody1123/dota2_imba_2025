item_def_book=class({})
LinkLuaModifier("modifier_item_def_book", "items/item_def_book.lua", LUA_MODIFIER_MOTION_NONE)







function item_def_book:OnSpellStart()
    local caster=self:GetCaster()
    TG_Modifier_Num_ADD(caster,"modifier_item_def_book",1,1)
    self:SpendCharge(0)
end

modifier_item_def_book=class({})

function modifier_item_def_book:GetTexture()
    return "item_def_book"
end

function modifier_item_def_book:IsHidden()
    return false
end

function modifier_item_def_book:IsPurgable()
    return false
end

function modifier_item_def_book:IsPurgeException()
    return false
end

function modifier_item_def_book:IsPermanent()
    return true
end


function modifier_item_def_book:AllowIllusionDuplicate()
    return false
end

function modifier_item_def_book:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(tg.num)
end


function modifier_item_def_book:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS

    }
end

function modifier_item_def_book:GetModifierPhysicalArmorBonus()
    return  self:GetStackCount()
end

function modifier_item_def_book:GetModifierMagicalResistanceBonus()
    return  self:GetStackCount()
end