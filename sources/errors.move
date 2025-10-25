module bali_shield::errors {
    const E_WRONG_TIER: u64       = 1;
    const E_INSUFFICIENT_FEE: u64 = 2;
    const E_NOT_OWNER: u64        = 3;
    const E_INVALID_UPGRADE: u64  = 4;
    const E_UNAUTHORIZED: u64 = 1001;

    public fun wrong_tier(): u64 { E_WRONG_TIER }
    public fun insufficient_fee(): u64 { E_INSUFFICIENT_FEE }
    public fun not_owner(): u64 { E_NOT_OWNER }
    public fun invalid_upgrade(): u64 { E_INVALID_UPGRADE }
    public fun unauthorized(): u64 { E_UNAUTHORIZED }
}
