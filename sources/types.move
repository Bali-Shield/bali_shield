module bali_shield::types {
    use sui::object;
    use sui::object::UID;
    use sui::tx_context::TxContext;
    use bali_shield::errors;

    // -------------------------
    // 🎖️ Definiciones base
    // -------------------------

    /// Identificadores numéricos para los tipos de Shield
    const BASIC_TIER: u8 = 0;
    const ADVANCED_TIER: u8 = 1;
    const EPIC_TIER: u8 = 2;

    /// Tipos de Shield disponibles
    public enum ShieldType has store, drop {
        Basic,
        Advanced,
        Epic,
    }

    /// 🛡️ Estructura base de un Shield
    /// Cada Shield posee atributos de combate, tipo y nivel de mejora.
    public struct Shield has key, store {
        id: UID,
        owner: address,      // 👈 dueño actual del Shield
        resistance: u64,
        power: u64,
        value: u64,
        durability: u64,     // 👈 puntos de vida actuales del Shield
        stype: ShieldType,
        level: u8,
    }

    // -------------------------
    // 🏗️ Constructor
    // -------------------------

    /// Crea un nuevo Shield con valores fijos y nivel inicial 1.
    public fun new(
        resistance: u64,
        power: u64,
        value: u64,
        stype: ShieldType,
        ctx: &mut TxContext
    ): Shield {
        let sender_addr = tx_context::sender(ctx);
        Shield {
            id: object::new(ctx),
            owner: sender_addr,          // 👈 nuevo campo
            resistance,
            power,
            value,
            durability: resistance,      // 👈 nuevo campo (por defecto igual a resistencia)
            stype,
            level: 1u8,
        }
    }

    // -------------------------
    // 🔍 Getters y conversores
    // -------------------------

    /// Retorna el tipo de Shield
    public fun shield_type(s: &Shield): &ShieldType {
        &s.stype
    }

    /// Verifica si un ShieldType corresponde al tag indicado
    public fun is_type(s: &ShieldType, tag: u8): bool {
        match (s) {
            ShieldType::Basic => tag == BASIC_TIER,
            ShieldType::Advanced => tag == ADVANCED_TIER,
            ShieldType::Epic => tag == EPIC_TIER,
        }
    }

    /// Convierte un número en un tipo de Shield (abortando si es inválido)
    public fun from_u8(tag: u8): ShieldType {
        match (tag) {
            BASIC_TIER => ShieldType::Basic,
            ADVANCED_TIER => ShieldType::Advanced,
            EPIC_TIER => ShieldType::Epic,
            _ => abort errors::wrong_tier(),
        }
    }

    /// Retorna el valor numérico del tipo de Shield (inverso de from_u8)
    public fun tier_of(stype: &ShieldType): u8 {
        match (stype) {
            ShieldType::Basic => BASIC_TIER,
            ShieldType::Advanced => ADVANCED_TIER,
            ShieldType::Epic => EPIC_TIER,
        }
    }

    /// Convierte un UID o un Shield a dirección
    public fun id_as_address(id: &UID): address {
        object::uid_to_address(id)
    }

    // -------------------------
    // 📊 Getters de atributos
    // -------------------------

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

    public fun level_of(s: &Shield): u8 {
        s.level
    }

    /// 📖 Devuelve la dirección del owner del Shield.
    public fun owner_of(shield: &Shield): address {
        shield.owner
    }

    /// 📖 Devuelve la durabilidad actual del Shield.
    public fun durability_of(shield: &Shield): u64 {
        shield.durability
    }

    public fun shield_id_address(shield: &Shield): address {
        object::uid_to_address(&shield.id)
    }



    // -------------------------
    // 🔧 Setters seguros
    // -------------------------

    /// Incrementa el nivel de un Shield (+1).
    public fun increment_level(s: &mut Shield) {
        s.level = s.level + 1;
    }

    /// Actualiza los atributos principales del Shield.
    /// Usado durante upgrades, para aplicar mejoras de poder y valor.
    public fun update_attributes(
        s: &mut Shield,
        new_res: u64,
        new_pow: u64,
        new_val: u64,
        new_lvl: u8
    ) {
        s.resistance = new_res;
        s.power = new_pow;
        s.value = new_val;
        s.level = new_lvl;
    }

    /// 🔧 Reduce la durabilidad del escudo.
    /// Si el daño excede la durabilidad actual, se fija en 0.
    public fun apply_damage(shield: &mut Shield, damage: u64) {
        let current = shield.durability;
        if (damage >= current) {
            shield.durability = 0;
        } else {
            shield.durability = current - damage;
        };
    }

    /// ⚡ Restaura durabilidad (por ejemplo al reparar)
    public fun repair(shield: &mut Shield, amount: u64, max_durability: u64) {
        let new_dur = shield.durability + amount;
        if (new_dur > max_durability) {
            shield.durability = max_durability;
        } else {
            shield.durability = new_dur;
        };
    }

}