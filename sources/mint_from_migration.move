module bali_shield::migration {
    use sui::tx_context::{TxContext, sender};
    use sui::transfer;
    use bali_shield::types;

    /// Mint especial para migración
    public entry fun mint_from_migration(
        resistance: u64,
        power: u64,
        value: u64,
        stype_tag: u8,
        recipient: address,
        ctx: &mut TxContext
    ) {
        // Usar el constructor público definido en types.move
        let stype = types::from_u8(stype_tag);

        let shield = types::new(resistance, power, value, stype, ctx);
        transfer::public_transfer(shield, recipient);
    }
}
