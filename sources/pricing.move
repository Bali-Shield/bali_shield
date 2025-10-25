module bali_shield::pricing {
    use sui::tx_context::TxContext;
    use sui::coin;
    use bali_shield::fees;
    use bali_shield::shield_coin;
    use bali_shield::errors;
    use bali_shield::types;

    /// Tipos de tiers de Shield
    const BASIC: u8 = 0;
    const ADVANCED: u8 = 1;
    const EPIC: u8 = 2;

    /// Tarifas fijas por tipo de Shield (en nano-SHLD)
    const FEE_BASIC: u64 = 0;        // Gratis
    const FEE_ADVANCED: u64 = 1_000; // 0.000001000 SHLD
    const FEE_EPIC: u64 = 2_000;     // 0.000002000 SHLD

    // ----------------------------------------------------
    // 🎯 Funciones públicas
    // ----------------------------------------------------

    /// Retorna el costo de crear un Shield según su tier.
    /// (No cobra, solo informa.)
    public fun get_creation_fee_for_tier(tier: u8): u64 {
        match (tier) {
            BASIC => FEE_BASIC,
            ADVANCED => FEE_ADVANCED,
            EPIC => FEE_EPIC,
            _ => abort errors::wrong_tier(),
        }
    }

    /// Cobra la tarifa correspondiente para crear un Shield del tipo dado.
    /// Recibe el coin del usuario y descuenta el monto según el tier.
    public fun charge_creation_fee_for_tier(
        tier: u8,
        from: &mut coin::Coin<shield_coin::SHIELD_COIN>,
        ctx: &mut TxContext
    ) {
        let fee = get_creation_fee_for_tier(tier);

        if (fee == 0) {
            return; // Basic: gratuito
        };

        fees::charge_fee(from, fee, fees::treasury(), ctx);
    }

    // ----------------------------------------------------
    // ⚙️ Funciones relacionadas con upgrades
    // ----------------------------------------------------

    /// Calcula el costo dinámico de mejora de un Shield en base a sus atributos actuales.
    /// Cuanto más poder o resistencia tiene el Shield, más caro será mejorarlo.
    public fun get_upgrade_fee(shield: &types::Shield): u64 {
        let base_val = types::value_of(shield);
        let pow = types::power_of(shield);
        let res = types::resistance_of(shield);

        // Costo proporcional al promedio de atributos
        let avg_stat = (res + pow + base_val) / 3;

        // Cada punto promedio cuesta 2 SHLD (en nano)
        let fee = avg_stat * 2;

        fee
    }

    /// Cobra automáticamente la tarifa de mejora en función de las estadísticas del Shield.
    public fun charge_upgrade_fee(
        shield: &types::Shield,
        from: &mut coin::Coin<shield_coin::SHIELD_COIN>,
        ctx: &mut TxContext
    ) {
        let fee = get_upgrade_fee(shield);

        if (fee == 0) {
            return;
        };

        fees::charge_fee(from, fee, fees::treasury(), ctx);
    }
}
