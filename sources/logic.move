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
        types::new(base_resistance, base_power, base_value, stype, ctx)
    }
}
