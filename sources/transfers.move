module bali_shield::transfers {
    use sui::transfer;
    use sui::tx_context::TxContext;
    use bali_shield::logic;
    use bali_shield::types;
    
    /// Crea un shield básico y lo transfiere a un destinatario
    public entry fun mint_basic_and_send_to(
        recipient: address,
        ctx: &mut TxContext
    ) {        

        let stype = types::from_u8(0); // 0 = BASIC
        let shield = logic::create_shield(100, 50, 10, stype, ctx);

        transfer::public_transfer(shield, recipient);
    }
}
