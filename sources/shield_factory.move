#[allow(lint(public_entry))]
module bali_shield::shield_factory {
    use sui::tx_context::{TxContext, sender};
    use sui::transfer;
    use std::option;
    use sui::coin;
    use bali_shield::types;
    use bali_shield::events;
    use bali_shield::errors;
    use bali_shield::pricing;
    use bali_shield::shield_coin;

    const BASIC: u8 = 0;
    const ADVANCED: u8 = 1;
    const EPIC: u8 = 2;

    // ----------------------------------------------------
    // 🛠️ Función interna
    // ----------------------------------------------------

    /// Crea un Shield con los valores base indicados.
    fun create_shield(
        base_resistance: u64,
        base_power: u64,
        base_value: u64,
        stype: types::ShieldType,
        ctx: &mut TxContext
    ): types::Shield {
        types::new(base_resistance, base_power, base_value, stype, ctx)
    }

    // ----------------------------------------------------
    // 💰 Creación de Shield con tarifa
    // ----------------------------------------------------

    /// Crea un Shield y cobra la tarifa correspondiente según el tier.
    ///
    /// El caller debe adjuntar un `Coin<SHLD>` con suficiente saldo para pagar la creación.
    /// El cobro se gestiona a través del módulo `pricing`, que decide cuánto cuesta y
    /// utiliza internamente `fees::charge_fee`.
    ///
    /// - 0 = Basic → Gratis  
    /// - 1 = Advanced → 1 000 nano-SHLD  
    /// - 2 = Epic → 2 000 nano-SHLD
    public entry fun mint_shield_with_fee(
        tier: u8,
        mut recipient: option::Option<address>,
        mut payment: coin::Coin<shield_coin::SHIELD_COIN>,
        ctx: &mut TxContext
    ) {
        // Determinar tipo y atributos base
        let (stype, base_resistance, base_power, base_value) = match (tier) {
            BASIC => (types::from_u8(BASIC), 100, 50, 10),
            ADVANCED => (types::from_u8(ADVANCED), 150, 100, 25),
            EPIC => (types::from_u8(EPIC), 250, 200, 60),
            _ => abort errors::wrong_tier(),
        };

        // Cobrar tarifa según el tier (manejado por pricing)
        pricing::charge_creation_fee_for_tier(tier, &mut payment, ctx);

        // Crear el Shield
        let shield = create_shield(base_resistance, base_power, base_value, stype, ctx);

        // Determinar destinatario
        let target_addr = if (option::is_some(&recipient)) {
            option::extract(&mut recipient)
        } else {
            sender(ctx)
        };

        let shield_addr = types::shield_id_address(&shield);

        // Transferir el Shield
        transfer::public_transfer(shield, target_addr);

        // Emitir evento
        events::emit_shield_created(target_addr, shield_addr, tier);

        // Devolver cualquier resto de pago al usuario
        transfer::public_transfer(payment, sender(ctx));
    }

    // ----------------------------------------------------
    // ⚙️ Mejora (upgrade) de Shield existente
    // ----------------------------------------------------

    /// Mejora un Shield existente, incrementando sus estadísticas y nivel.
    /// El usuario debe ser el owner del Shield y pagar la tarifa dinámica.
    public entry fun upgrade_shield(
        mut shield: types::Shield,
        mut payment: coin::Coin<shield_coin::SHIELD_COIN>,
        ctx: &mut TxContext
    ) {
        let caller = sender(ctx);

        // 💰 Cobrar el costo dinámico del upgrade
        pricing::charge_upgrade_fee(&shield, &mut payment, ctx);

        // 📊 Guardar los valores antiguos
        let old_res = types::resistance_of(&shield);
        let old_pow = types::power_of(&shield);
        let old_val = types::value_of(&shield);
        let old_lvl = types::level_of(&shield);

        // 📈 Calcular mejoras (por ejemplo +20 %)
        let new_res = old_res + (old_res / 5);
        let new_pow = old_pow + (old_pow / 5);
        let new_val = old_val + (old_val / 5);
        let new_lvl = old_lvl + 1;

        // 🔁 Actualizar atributos del Shield existente
        types::update_attributes(&mut shield, new_res, new_pow, new_val, new_lvl);

        // 📡 Emitir evento con los valores actualizados
        let shield_addr = types::shield_id_address(&shield);
        events::emit_shield_upgraded(
            caller,
            shield_addr,
            old_res,
            old_pow,
            old_val,
            new_res,
            new_pow,
            new_val,
            new_lvl,
        );

        // ✅ Transferir el Shield actualizado y cualquier pago restante al caller
        transfer::public_transfer(shield, caller);
        transfer::public_transfer(payment, caller);
    }

    /// 🔥 Consume durabilidad del escudo al recibir daño.
    /// Solo el owner del escudo puede invocarla.
    public entry fun consume_durability(
        mut shield: types::Shield,
        damage: u64,
        ctx: &mut TxContext
    ) {
        let caller = sender(ctx);
        let old_dur = types::durability_of(&shield);

        // Verificar propiedad
        assert!(caller == types::owner_of(&shield), errors::unauthorized());

        // Aplicar daño
        types::apply_damage(&mut shield, damage);
        let new_dur = types::durability_of(&shield);

        // Emitir evento
        let shield_addr = types::shield_id_address(&shield);
        events::emit_shield_damaged(caller, shield_addr, old_dur, new_dur, damage, ctx);

        // Transferir el Shield modificado al jugador
        transfer::public_transfer(shield, caller);
    }

}
