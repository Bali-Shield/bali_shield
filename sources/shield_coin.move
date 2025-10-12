module bali_shield::shield_coin {
    use sui::tx_context::{TxContext, sender};
    use sui::coin::{Self, TreasuryCap};
    use sui::coin_registry;
    use sui::transfer;
    use std::string;

    /// Witness para OTW (One-Time Witness). Debe tener `drop`.
    public struct SHIELD_COIN has drop {}

    /// Se ejecuta automáticamente al publicar el paquete (no `public`, no `entry`).
    fun init(witness: SHIELD_COIN, ctx: &mut TxContext) {
        // Strings en Sui 1.57/1.58: usa std::string::utf8(b"...")
        let symbol = string::utf8(b"SHLD");
        let name = string::utf8(b"ShieldCoin");
        let description = string::utf8(b"Moneda oficial Bali Shield");
        let icon_url = string::utf8(b"https://example.com/icon.png");

        // Firma correcta: (witness, decimals: u8, symbol, name, description, icon_url, ctx)
        let (builder, treasury_cap) = coin_registry::new_currency_with_otw<SHIELD_COIN>(
            witness,
            9u8,
            symbol,
            name,
            description,
            icon_url,
            ctx
        );

        // Finaliza metadata y transfiere las caps al publicador
        let metadata_cap = builder.finalize(ctx); // método del builder ( açúcar para coin_registry::finalize(builder, ctx) )
        let me = sender(ctx);
        transfer::public_transfer(treasury_cap, me);
        transfer::public_transfer(metadata_cap, me);
    }

    /// Mint: quien tenga la TreasuryCap puede acuñar
    public entry fun mint(
        cap: &mut TreasuryCap<SHIELD_COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let c = sui::coin::mint<SHIELD_COIN>(cap, amount, ctx);
        transfer::public_transfer(c, recipient);
    }
}
