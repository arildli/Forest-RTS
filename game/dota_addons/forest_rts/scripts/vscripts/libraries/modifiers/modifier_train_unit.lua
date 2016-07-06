modifier_train_unit = class({})

-- building:RemoveModifierByName("modifier_train_unit")
-- entity:AddNewModifier(entity, nil, "modifier_train_unit", {})

function modifier_train_unit:OnCreated()
    local caster = self:GetParent()
    local particle = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_radiant_lvl2.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    caster._modifier_train_unit_particle = particle
end

function modifier_train_unit:OnDestroy()
    local caster = self:GetParent()
    ParticleManager:DestroyParticle(caster._modifier_train_unit_particle, true)
end