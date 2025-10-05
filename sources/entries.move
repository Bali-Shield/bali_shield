module bali_shield::entries {
    use sui::tx_context::{TxContext, sender};
    use sui::coin;
    use sui::sui::SUI;

    use bali_shield::types;
    use bali_shield::logic;
    use bali_shield::fees;
    use bali_shield::errors;
    use bali_shield::events;

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

        events::emit_shield_upgraded(
            sender(ctx),
            types::shield_id_address(shield),
            0, // old_tier
            1  // new_tier
        );
    }

    public fun upgrade_advanced_to_epic(
        shield: &mut types::Shield,
        fee_coin: &mut coin::Coin<SUI>,
        ctx: &mut TxContext
    ) {
        if (!types::is_advanced(types::shield_type(shield))) {
            abort errors::wrong_tier()
        };

        fees::charge_fee<SUI>(
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
            1, // old_tier
            2  // new_tier
        );
    }

    public fun create_basic_shield(ctx: &mut TxContext): types::Shield {
        let shield = types::make_basic(ctx);

        events::emit_shield_created(
            sender(ctx),
            types::shield_id_address(&shield),
            0
        );

        shield
    }
}
