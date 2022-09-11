function Healing(event)
    local caster = event.caster
    local ability = event.ability
    local radius = ability:GetSpecialValueFor("radius")
    local health_restored = ability:GetSpecialValueFor("health_restored")
    local allies = FindOrganicAlliesInRadius(caster, radius)

    for _,unit in pairs(allies) do
        local hpGain = math.min(health_restored, unit:GetHealthDeficit())
        unit:Heal(hpGain,caster)

        if hpGain > 0 then
            PopupHealing(unit, hpGain)
        end
    end
end