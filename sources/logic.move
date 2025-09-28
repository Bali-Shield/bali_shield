module bali_shield::logic {
    use sui::tx_context::TxContext;
    use bali_shield::types;

    public(package) fun create_shield(
        base_resistance: u64,
        base_power: u64,
        base_value: u64,
        stype: types::ShieldType,
        ctx: &mut TxContext
    ): types::Shield {
        let resistance =
            base_resistance
            + types::bonus_resistance_of(&stype)
            + (if (types::is_epic(&stype)) { 50 } else { 0 });

        let power =
            base_power
            + types::bonus_power_of(&stype)
            + (if (types::is_epic(&stype)) { 50 } else { 0 });

        let value =
            base_value
            + types::bonus_value_of(&stype);

        types::new(resistance, power, value, stype, ctx)
    }

    public(package) fun upgrade_shield(shield: &mut types::Shield) {
        types::upgrade(shield)
    }
}
