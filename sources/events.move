module bali_shield::events {
    use sui::event;

    // ----------------------------------------------------
    // 🛡️ Definiciones de eventos
    // ----------------------------------------------------

    /// 📦 Evento emitido cuando se crea un nuevo Shield.
    /// Contiene el owner, el ID del objeto y el tier elegido.
    public struct ShieldCreated has copy, drop {
        owner: address,
        shield_id: address,
        tier: u8,
    }

    /// ⚙️ Evento emitido cuando un Shield es mejorado (upgrade).
    /// Incluye los valores antiguos, los nuevos y el nivel resultante.
    public struct ShieldUpgraded has copy, drop {
        owner: address,
        shield_id: address,
        old_resistance: u64,
        old_power: u64,
        old_value: u64,
        new_resistance: u64,
        new_power: u64,
        new_value: u64,
        new_level: u8,
    }

    /// 💰 Evento emitido cuando se paga una comisión en SHLD.
    /// Utilizado tanto en creaciones como en mejoras.
    public struct FeePaid has copy, drop {
        payer: address,
        amount: u64,
        coin_symbol: vector<u8>,
    }

    /// 🧩 Evento emitido durante una migración de Shield.
    /// (Opcional: facilita trazabilidad al importar objetos antiguos.)
    public struct ShieldMigrated has copy, drop {
        admin: address,
        recipient: address,
        shield_id: address,
        resistance: u64,
        power: u64,
        value: u64,
        level: u8,
    }

    // ----------------------------------------------------
    // 🚀 Emisores de eventos
    // ----------------------------------------------------

    /// Emite un evento de creación de Shield.
    public fun emit_shield_created(owner: address, shield_id: address, tier: u8) {
        event::emit(ShieldCreated { owner, shield_id, tier });
    }

    /// Emite un evento de mejora de Shield.
    public fun emit_shield_upgraded(
        owner: address,
        shield_id: address,
        old_res: u64,
        old_pow: u64,
        old_val: u64,
        new_res: u64,
        new_pow: u64,
        new_val: u64,
        new_lvl: u8,
    ) {
        event::emit(ShieldUpgraded {
            owner,
            shield_id,
            old_resistance: old_res,
            old_power: old_pow,
            old_value: old_val,
            new_resistance: new_res,
            new_power: new_pow,
            new_value: new_val,
            new_level: new_lvl,
        });
    }

    /// Emite un evento de pago de comisión.
    public fun emit_fee_paid(payer: address, amount: u64, coin_symbol: vector<u8>) {
        event::emit(FeePaid { payer, amount, coin_symbol });
    }

    /// Emite un evento de migración de Shield.
    /// (Usado desde `migration.move`.)
    public fun emit_shield_migrated(
        admin: address,
        recipient: address,
        shield_id: address,
        resistance: u64,
        power: u64,
        value: u64,
        level: u8,
    ) {
        event::emit(ShieldMigrated {
            admin,
            recipient,
            shield_id,
            resistance,
            power,
            value,
            level,
        });
    }
        
    public struct ShieldDamaged has copy, drop, store {
        owner: address,
        shield_id: address,
        old_durability: u64,
        new_durability: u64,
        damage: u64,
    }


    public fun emit_shield_damaged(
        owner: address,
        shield_id: address,
        old: u64,
        new: u64,
        damage: u64,
        ctx: &mut TxContext,
    ) {
        event::emit(ShieldDamaged {
            owner,
            shield_id,
            old_durability: old,
            new_durability: new,
            damage,
        });
    }

}
