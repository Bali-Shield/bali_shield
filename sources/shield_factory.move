#[allow(lint(public_entry))]
module bali_shield::shield_factory {
    use sui::tx_context::{TxContext, sender};
    use sui::transfer;
    use std::option;
    use bali_shield::logic;
    use bali_shield::types;
    use bali_shield::events;

    const BASIC: u8 = 0;
    const ADVANCED: u8 = 1;
    const EPIC: u8 = 2;

    /// Crea un shield del tipo especificado y lo transfiere al destinatario (o al caller)
    public entry fun mint_shield(
        tier: u8,
        mut recipient: option::Option<address>, // 🔧 mutable para poder extraerlo
        ctx: &mut TxContext
    ) {
        let stype = types::from_u8(tier);

        let (base_resistance, base_power, base_value) = match (tier) {
            BASIC => (100, 50, 10),
            ADVANCED => (150, 100, 25),
            EPIC => (250, 200, 60),
            _ => abort 100,
        };


        let shield = logic::create_shield(base_resistance, base_power, base_value, stype, ctx);

        // Determinar destinatario
        let target_addr = if (option::is_some(&recipient)) {
            option::extract(&mut recipient)
        } else {
            sender(ctx)
        };

        let shield_addr = types::shield_id_address(&shield);

        transfer::public_transfer(shield, target_addr);

        events::emit_shield_created(target_addr, shield_addr, tier);
    }
}
