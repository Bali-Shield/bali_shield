module bali_shield::events {
    use sui::event;

    /// Evento cuando se crea un Shield
    public struct ShieldCreated has copy, drop {
        owner: address,
        shield_id: address,
        tier: u8,
    }

    /// Evento cuando se mejora un Shield
    public struct ShieldUpgraded has copy, drop {
        owner: address,
        shield_id: address,
        old_tier: u8,
        new_tier: u8,
    }

    /// Evento cuando se paga una comisión
    public struct FeePaid has copy, drop {
        payer: address,
        amount: u64,
        coin_symbol: vector<u8>,
    }

    // ----------------- Helpers -----------------

    public fun emit_shield_created(owner: address, shield_id: address, tier: u8) {
        event::emit(ShieldCreated { owner, shield_id, tier });
    }

    public fun emit_shield_upgraded(owner: address, shield_id: address, old_tier: u8, new_tier: u8) {
        event::emit(ShieldUpgraded { owner, shield_id, old_tier, new_tier });
    }

    public fun emit_fee_paid(payer: address, amount: u64, coin_symbol: vector<u8>) {
        event::emit(FeePaid { payer, amount, coin_symbol });
    }
}
