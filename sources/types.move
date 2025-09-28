module bali_shield::types {
    use sui::object::{UID};
    use sui::tx_context::TxContext;

    public enum ShieldType has store, drop {
        Basic { bonus_resistance: u64 },
        Advanced { bonus_power: u64 },
        Epic { bonus_value: u64 },
    }

    public struct Shield has key, store {
        id: UID,
        resistance: u64,
        power: u64,
        value: u64,
        stype: ShieldType,
    }

    public fun new(
        resistance: u64,
        power: u64,
        value: u64,
        stype: ShieldType,
        ctx: &mut TxContext
    ): Shield {
        Shield {
            id: object::new(ctx),
            resistance,
            power,
            value,
            stype,
        }
    }

    public fun make_basic(ctx: &mut TxContext): Shield {
        new(100, 50, 10, ShieldType::Basic { bonus_resistance: 10 }, ctx)
    }

    // -------- Getters seguros --------
    public fun shield_type(s: &Shield): &ShieldType {
        &s.stype
    }

    public fun is_basic(s: &ShieldType): bool {
        match (s) {
            ShieldType::Basic { .. } => true,
            _ => false
        }
    }
    public fun is_advanced(s: &ShieldType): bool {
        match (s) {
            ShieldType::Advanced { .. } => true,
            _ => false
        }
    }
    public fun is_epic(s: &ShieldType): bool {
        match (s) {
            ShieldType::Epic { .. } => true,
            _ => false
        }
    }

    public fun bonus_resistance_of(s: &ShieldType): u64 {
        match (s) {
            ShieldType::Basic { bonus_resistance } => *bonus_resistance,
            _ => 0
        }
    }
    public fun bonus_power_of(s: &ShieldType): u64 {
        match (s) {
            ShieldType::Advanced { bonus_power } => *bonus_power,
            _ => 0
        }
    }
    public fun bonus_value_of(s: &ShieldType): u64 {
        match (s) {
            ShieldType::Epic { bonus_value } => *bonus_value,
            _ => 0
        }
    }

    public fun upgrade(shield: &mut Shield) {
        match (&shield.stype) {
            ShieldType::Basic { .. } => {
                shield.stype = ShieldType::Advanced { bonus_power: 30 };
                shield.power = shield.power + 30;
            },
            ShieldType::Advanced { .. } => {
                shield.stype = ShieldType::Epic { bonus_value: 50 };
                shield.resistance = shield.resistance + 50;
                shield.power      = shield.power + 50;
                shield.value      = shield.value + 50;
            },
            ShieldType::Epic { .. } => { /* max tier */ },
        }
    }
}
