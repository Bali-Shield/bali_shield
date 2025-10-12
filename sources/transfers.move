module bali_shield::transfers {
    use sui::transfer;
    use sui::tx_context::TxContext;
    use bali_shield::logic;

    /// Crea un shield básico y lo transfiere a un destinatario
    public entry fun mint_basic_and_send_to(
        recipient: address,
        ctx: &mut TxContext
    ) {
        let shield = logic::create_basic_shield(ctx);
        transfer::public_transfer(shield, recipient);
    }
}
