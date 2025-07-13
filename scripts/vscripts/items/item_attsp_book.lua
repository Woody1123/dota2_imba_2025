item_attsp_book=class({})
LinkLuaModifier("modifier_item_attsp_book", "items/item_attsp_book.lua", LUA_MODIFIER_MOTION_NONE)

function item_attsp_book:CastFilterResult()
    self.caster=self.caster or self:GetCaster()
    if not IsServer() then return end
end


function item_attsp_book:OnSpellStart()
    TG_Modifier_Num_ADD(self.caster,"modifier_item_attsp_book",5,5)
    self:SpendCharge(0)
end

modifier_item_attsp_book=class({})

function modifier_item_attsp_book:GetTexture()return "item_attsp_book"
end
function modifier_item_attsp_book:IsHidden()return false
end
function modifier_item_attsp_book:IsPurgable()return false
end
function modifier_item_attsp_book:IsPurgeException()return false
end
function modifier_item_attsp_book:IsPermanent()return true
end
function modifier_item_attsp_book:AllowIllusionDuplicate()return false
end

function modifier_item_attsp_book:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(tg.num)
end

function modifier_item_attsp_book:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_item_attsp_book:GetModifierBonusStats_Agility()return self:GetStackCount()
end