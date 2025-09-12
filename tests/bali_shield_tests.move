#[test_only]
module bali_shield::bali_shield_tests {
    use std::unit_test::assert_eq;
    use bali_shield::bali_shield;
    use sui::test_scenario;

    // --- Helpers ---
    /// Assert tuple of (resistance, power, value) against expected values.
    fun expect_attrs(shield: &bali_shield::Shield, r: u64, p: u64, v: u64) {
        let (rr, pp, vv) = bali_shield::get_attributes(shield);
        assert_eq!(rr, r);
        assert_eq!(pp, p);
        assert_eq!(vv, v);
    }

    // 1) Create shields with a dummy TxContext (single transaction)
    #[test]
    fun test_create_basic_attrs() {
        let mut ctx = sui::tx_context::dummy();
        let shield = bali_shield::create_basic_shield(&mut ctx);
        // basic: (100 + 20, 50, 10)
        expect_attrs(&shield, 120, 50, 10);
        // Avoid leaks in tests: transfer to some address
        sui::transfer::public_transfer(shield, @0x1);
    }

    #[test]
    fun test_create_advanced_attrs() {
        let mut ctx = sui::tx_context::dummy();
        let shield = bali_shield::create_advanced_shield(&mut ctx);
        // advanced: (150, 100 + 30, 50)
        expect_attrs(&shield, 150, 130, 50);
        sui::transfer::public_transfer(shield, @0x1);
    }

    #[test]
    fun test_create_epic_attrs() {
        let mut ctx = sui::tx_context::dummy();
        let shield = bali_shield::create_epic_shield(&mut ctx);
        // epic: (200 + 50, 150 + 50, 100 + 50)
        expect_attrs(&shield, 250, 200, 150);
        sui::transfer::public_transfer(shield, @0x1);
    }

    // 2) Upgrade path: Basic -> Advanced -> Epic
    #[test]
    fun test_upgrade_flow() {
        let mut ctx = sui::tx_context::dummy();
        let mut shield = bali_shield::create_basic_shield(&mut ctx);
        // after create: 120, 50, 10
        expect_attrs(&shield, 120, 50, 10);

        bali_shield::upgrade_shield(&mut shield);
        // Advanced (+30 power): 120, 80, 10
        expect_attrs(&shield, 120, 80, 10);

        bali_shield::upgrade_shield(&mut shield);
        // Epic (+50 resistance, +50 power, +50 value): 170, 130, 60
        expect_attrs(&shield, 170, 130, 60);

        sui::transfer::public_transfer(shield, @0x1);
    }

    // 3) Transfer with test_scenario (multi-tx, different users)
    #[test]
    fun test_transfer_ownership_with_scenario() {
        let admin = @0xA;
        let recipient = @0xB;

        // TX1: admin creates and transfers to recipient
        let mut sc = test_scenario::begin(admin);
        {
            let ctx = test_scenario::ctx(&mut sc); // &mut TxContext
            let shield = bali_shield::create_basic_shield(ctx); // pass ctx directly
            sui::transfer::public_transfer(shield, recipient);
        };

        // TX2: recipient inspects the received Shield
        test_scenario::next_tx(&mut sc, recipient);
        {
            let shield = test_scenario::take_from_sender<bali_shield::Shield>(&sc);
            expect_attrs(&shield, 120, 50, 10);
            test_scenario::return_to_sender(&sc, shield);
        };

        // IMPORTANT: consume the Scenario (it has no drop)
        test_scenario::end(sc);
    }

    // 4) Test the entry that creates and transfers to the sender
    #[test]
    fun test_entry_create_and_transfer_basic_shield() {
        let who = @0xC;

        // TX1: who calls the entry function
        let mut sc = test_scenario::begin(who);
        {
            let ctx = test_scenario::ctx(&mut sc); // &mut TxContext
            bali_shield::create_and_transfer_basic_shield(ctx); // pass ctx directly
        };

        // TX2: who should own the resulting Shield
        test_scenario::next_tx(&mut sc, who);
        {
            let shield = test_scenario::take_from_sender<bali_shield::Shield>(&sc);
            expect_attrs(&shield, 120, 50, 10);
            test_scenario::return_to_sender(&sc, shield);
        };

        // Consume Scenario
        test_scenario::end(sc);
    }
}
