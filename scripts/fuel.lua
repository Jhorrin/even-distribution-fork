local fuel = {}
function fuel.is_fuel(prototype)
    local categories = prototype and prototype.fuel_categories
    return categories ~= nil and next(categories) ~= nil
end
function fuel.accepts(burner, prototype)
    if not burner then return false end
    for _, category in pairs(prototype.fuel_categories or {}) do
        if burner.fuel_categories[category] then return true end
    end
    return false
end
function fuel.less(a,b)
    for _, key in ipairs({"fuel_value", "fuel_acceleration_multiplier", "fuel_top_speed_multiplier", "fuel_emissions_multiplier"}) do
        if a[key] ~= b[key] then return a[key] < b[key] end
    end
    return a.name < b.name
end
return fuel
