module bali_shield::fees {
    use sui::coin;
    use sui::tx_context::TxContext;

    // Internal constants (not public directly)
    const BASIC_TO_ADVANCED_FEE: u64 = 100_000_000;  // 0.1 SUI
    const ADVANCED_TO_EPIC_FEE: u64  = 200_000_000;  // 0.2 SUI
    const TREASURY: address = @treasury;

    // Public getters
    public fun basic_to_advanced_fee(): u64 { BASIC_TO_ADVANCED_FEE }
    public fun advanced_to_epic_fee(): u64 { ADVANCED_TO_EPIC_FEE }
    public fun treasury(): address { TREASURY }

    /// Generic fee charger
    public fun charge_fee<T>(
        from: &mut coin::Coin<T>,
        amount: u64,
        to: address,
        insufficient_fee_err: u64,
        ctx: &mut TxContext
    ) {
        if (coin::value(from) < amount) {
            abort insufficient_fee_err;
        };
        let fee_part = coin::split(from, amount, ctx);
        sui::transfer::public_transfer(fee_part, to);
    }
}
