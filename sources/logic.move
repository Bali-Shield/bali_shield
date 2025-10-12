module bali_shield::logic {
    use sui::tx_context::{TxContext, sender};
    use bali_shield::types;
    use bali_shield::events;

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

    /// Crea un escudo básico y emite el evento correspondiente
    public fun create_basic_shield(ctx: &mut TxContext): types::Shield {
        let shield = types::make_basic(ctx);
        events::emit_shield_created(sender(ctx), types::shield_id_address(&shield), 0);
        shield
    }
}
