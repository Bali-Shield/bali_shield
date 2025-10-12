module bali_shield::fees {
    use sui::coin;
    use sui::tx_context::{TxContext, sender};
    use sui::transfer;
    use bali_shield::events;
    use bali_shield::shield_coin;

    const BASIC_TO_ADVANCED_FEE: u64 = 1_000; // 1,000 SHLD (con 9 decimales, equivale a 0.000001000 si lo ves como entero base10^9)
    const ADVANCED_TO_EPIC_FEE: u64  = 2_000; // 2,000 SHLD
    const TREASURY: address = @treasury;

    public fun basic_to_advanced_fee(): u64 { BASIC_TO_ADVANCED_FEE }
    public fun advanced_to_epic_fee(): u64 { ADVANCED_TO_EPIC_FEE }
    public fun treasury(): address { TREASURY }

    /// Cobrador específico para ShieldCoin (no genérico).
    public fun charge_fee(
        from: &mut coin::Coin<shield_coin::SHIELD_COIN>,
        amount: u64,
        to: address,
        insufficient_fee_err: u64,
        ctx: &mut TxContext
    ) {
        if (coin::value(from) < amount) {
            abort insufficient_fee_err;
        };
        let part = coin::split(from, amount, ctx);
        transfer::public_transfer(part, to);

        events::emit_fee_paid(sender(ctx), amount, b"SHLD");
    }
}
