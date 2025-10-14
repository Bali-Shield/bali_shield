module bali_shield::types {
    use sui::object::{UID};
    use sui::tx_context::TxContext;

    /// Tipos de Shield disponibles
    public enum ShieldType has store, drop {
        Basic,
        Advanced,
        Epic,
    }

    /// Estructura base de un Shield
    public struct Shield has key, store {
        id: UID,
        resistance: u64,
        power: u64,
        value: u64,
        stype: ShieldType,
    }

    /// Crea un nuevo Shield con valores fijos
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

    // -------- Getters seguros --------

    public fun shield_type(s: &Shield): &ShieldType {
        &s.stype
    }

    public fun is_basic(s: &ShieldType): bool {
        match (s) {
            ShieldType::Basic => true,
            _ => false
        }
    }

    public fun is_advanced(s: &ShieldType): bool {
        match (s) {
            ShieldType::Advanced => true,
            _ => false
        }
    }

    public fun is_epic(s: &ShieldType): bool {
        match (s) {
            ShieldType::Epic => true,
            _ => false
        }
    }

    /// Convierte un número en un tipo de Shield
    public fun from_u8(tag: u8): ShieldType {
        match (tag) {
            0 => ShieldType::Basic,
            1 => ShieldType::Advanced,
            2 => ShieldType::Epic,
            _ => ShieldType::Basic,
        }
    }

    /// Convierte UID o Shield a address
    public fun id_as_address(id: &UID): address {
        object::uid_to_address(id)
    }

    public fun shield_id_address(s: &Shield): address {
        object::uid_to_address(&s.id)
    }

    /// Getters de atributos
    public fun resistance_of(s: &Shield): u64 {
        s.resistance
    }

    public fun power_of(s: &Shield): u64 {  
        s.power
    }

    public fun value_of(s: &Shield): u64 {
        s.value
    }

    public fun shield_type_of(s: &Shield): &ShieldType {
        &s.stype
    }
}
