module bali_shield::entries {
    use sui::tx_context::TxContext;
    use sui::coin;
    use sui::sui::SUI;

    use bali_shield::types;
    use bali_shield::logic;
    use bali_shield::fees;
    use bali_shield::errors;

    public fun upgrade_basic_to_advanced(
        shield: &mut types::Shield,
        fee_coin: &mut coin::Coin<SUI>,
        ctx: &mut TxContext
    ) {
        if (!types::is_basic(types::shield_type(shield))) {
            abort errors::wrong_tier()
        };

        fees::charge_fee<SUI>(
            fee_coin,
            fees::basic_to_advanced_fee(),
            fees::treasury(),
            errors::insufficient_fee(),
            ctx
        );

        logic::upgrade_shield(shield);
    }

    // Crear un shield básico
    public fun create_basic_shield(ctx: &mut TxContext): types::Shield {
        types::make_basic(ctx)
    }
}
