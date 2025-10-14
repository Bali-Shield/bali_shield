module bali_shield::entries {
    use sui::tx_context::{TxContext};
    use std::option;
    use bali_shield::shield_factory;

    /// Crea un Shield del tipo especificado y lo asigna al usuario o al destinatario indicado.
    ///
    /// - `tier`: 0 = Basic, 1 = Advanced, 2 = Epic
    /// - `recipient`: dirección opcional (si `None`, se mintea al caller)
    public entry fun create_shield(
        tier: u8,
        recipient: option::Option<address>,
        ctx: &mut TxContext
    ) {
        // Llama directamente a la factory para crear el tipo correcto
        shield_factory::mint_shield(tier, recipient, ctx);
    }
}
