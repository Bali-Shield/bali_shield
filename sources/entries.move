module bali_shield::entries {
    use sui::tx_context::{TxContext, sender};
    use sui::coin;
    use bali_shield::types;
    use bali_shield::logic;
    use bali_shield::fees;
    use bali_shield::errors;
    use bali_shield::events;
    use bali_shield::shield_coin;

    public fun upgrade_basic_to_advanced(
        shield: &mut types::Shield,
        fee_coin: &mut coin::Coin<shield_coin::SHIELD_COIN>,
        ctx: &mut TxContext
    ) {
        if (!types::is_basic(types::shield_type(shield))) {
            abort errors::wrong_tier()
        };

        fees::charge_fee(
            fee_coin,
            fees::basic_to_advanced_fee(),
            fees::treasury(),
            errors::insufficient_fee(),
            ctx
        );

        logic::upgrade_shield(shield);

        events::emit_shield_upgraded(
            sender(ctx),
            types::shield_id_address(shield),
            0, 1
        );
    }

    public fun upgrade_advanced_to_epic(
        shield: &mut types::Shield,
        fee_coin: &mut coin::Coin<shield_coin::SHIELD_COIN>,
        ctx: &mut TxContext
    ) {
        if (!types::is_advanced(types::shield_type(shield))) {
            abort errors::wrong_tier()
        };

        fees::charge_fee(
            fee_coin,
            fees::advanced_to_epic_fee(),
            fees::treasury(),
            errors::insufficient_fee(),
            ctx
        );

        logic::upgrade_shield(shield);

        events::emit_shield_upgraded(
            sender(ctx),
            types::shield_id_address(shield),
            1, 2
        );
    }

    public entry fun create_basic_shield(ctx: &mut TxContext) {
        use sui::transfer;

        let shield = logic::create_basic_shield(ctx);
        transfer::public_transfer(shield, sender(ctx));
    }

}
