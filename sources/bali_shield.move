module bali_shield::bali_shield {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    // Define an enum for shield types (simulates the "hierarchy")
    public enum ShieldType has store, drop {
        Basic { bonus_resistance: u64 },  // Low cost, low resistance
        Advanced { bonus_power: u64 },    // More power, medium value
        Epic { bonus_value: u64 },        // High value, high resistance and power
    }

    // Base struct for Shield
    public struct Shield has key, store {
        id: UID,
        resistance: u64,  // Life or durability
        power: u64,       // Damage or strength
        value: u64,       // Price or rarity in the game
        stype: ShieldType // The type that defines variations
    }

    // Function to create a basic shield, returns Shield
    public fun create_basic_shield(ctx: &mut TxContext): Shield {
        create_shield(
            100,
            50,
            10,
            ShieldType::Basic { bonus_resistance: 20 },
            ctx
        )
    }

    // Function to create an advanced shield
    public fun create_advanced_shield(ctx: &mut TxContext): Shield {
        create_shield(
            150,
            100,
            50,
            ShieldType::Advanced { bonus_power: 30 },
            ctx
        )
    }

    // Function to create an epic shield
    public fun create_epic_shield(ctx: &mut TxContext): Shield {
        create_shield(
            200,
            150,
            100,
            ShieldType::Epic { bonus_value: 50 },
            ctx
        )
    }

    // Internal function to create the shield applying the type
    fun create_shield(
        base_resistance: u64,
        base_power: u64,
        base_value: u64,
        stype: ShieldType,
        ctx: &mut TxContext
    ): Shield {
        let (resistance, power, value) = match (&stype) {
            ShieldType::Basic { bonus_resistance } => (base_resistance + *bonus_resistance, base_power, base_value),
            ShieldType::Advanced { bonus_power } => (base_resistance, base_power + *bonus_power, base_value),
            ShieldType::Epic { bonus_value } => (base_resistance + 50, base_power + 50, base_value + *bonus_value),
        };

        Shield {
            id: object::new(ctx),
            resistance,
            power,
            value,
            stype,
        }
    }

    // Function to get attributes
    public fun get_attributes(shield: &Shield): (u64, u64, u64) {
        (shield.resistance, shield.power, shield.value)
    }

    // Function for upgrading
    public fun upgrade_shield(shield: &mut Shield) {
        match (&shield.stype) {
            ShieldType::Basic { bonus_resistance: _ } => {
                shield.stype = ShieldType::Advanced { bonus_power: 30 };
                shield.power = shield.power + 30;
            },
            ShieldType::Advanced { bonus_power: _ } => {
                shield.stype = ShieldType::Epic { bonus_value: 50 };
                shield.resistance = shield.resistance + 50;
                shield.power = shield.power + 50;
                shield.value = shield.value + 50;
            },
            _ => (),
        }
    }

    // Helper function to transfer a shield
    public fun transfer_shield(shield: Shield, recipient: address) {
        transfer::public_transfer(shield, recipient);
    }

    // NEW: entry function to create and transfer a basic shield in a single transaction
    public entry fun create_and_transfer_basic_shield(ctx: &mut TxContext) {
        let shield = create_basic_shield(ctx);
        transfer::public_transfer(shield, tx_context::sender(ctx));
    }
}
