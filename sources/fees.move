module bali_shield::fees {
    use sui::coin;
    use sui::tx_context::{TxContext, sender};
    use sui::transfer;
    use bali_shield::events;
    use bali_shield::shield_coin;
    use bali_shield::errors;

    // ----------------------------------------------------
    // 💰 Configuración general
    // ----------------------------------------------------

    /// Dirección del tesoro del proyecto (definida en Move.toml)
    const TREASURY: address = @treasury;

    /// Decimales de SHLD (1 SHLD = 10^9 nano-SHLD)
    const DECIMALS: u8 = 9;

    // ----------------------------------------------------
    // ⚙️ Funciones principales
    // ----------------------------------------------------

    /// Cobra una tarifa (fee) en tokens SHLD y la transfiere al destinatario.
    ///
    /// - `from`: Coin del pagador.
    /// - `amount`: Cantidad en **nano-SHLD** (unidades mínimas).
    /// - `to`: Dirección destino (normalmente el Tesoro).
    /// - `ctx`: Contexto de transacción.
    ///
    /// Si el balance es insuficiente → aborta con `E_INSUFFICIENT_FEE`.
    public fun charge_fee(
        from: &mut coin::Coin<shield_coin::SHIELD_COIN>,
        amount: u64,
        to: address,
        ctx: &mut TxContext
    ) {
        if (coin::value(from) < amount) {
            abort errors::insufficient_fee();
        };

        let part = coin::split(from, amount, ctx);
        transfer::public_transfer(part, to);

        // Emite evento on-chain
        events::emit_fee_paid(sender(ctx), amount, b"SHLD");
    }

    /// Retorna la dirección del Tesoro (usado por el módulo `pricing`)
    public fun treasury(): address {
        TREASURY
    }

    /// Retorna los decimales de precisión del token SHLD.
    /// (Ejemplo: 9 = nano-SHLD)
    public fun decimals(): u8 {
        DECIMALS
    }
}
