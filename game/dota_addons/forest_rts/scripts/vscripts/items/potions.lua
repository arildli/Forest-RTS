function InstantHealing(event)
    local caster = event.caster
    local ability = event.ability
    local health_restored = ability:GetSpecialValueFor("health_restored")

    local hpGain = math.min(health_restored, caster:GetHealthDeficit())
    caster:Heal(hpGain,caster)
    PopupHealing(caster, hpGain)
end