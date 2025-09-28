module bali_shield::errors {
    // Error codes
    const E_WRONG_TIER: u64       = 1;
    const E_INSUFFICIENT_FEE: u64 = 2;

    /// Returns the error code for invalid upgrade tier
    public fun wrong_tier(): u64 { E_WRONG_TIER }

    /// Returns the error code for insufficient fee
    public fun insufficient_fee(): u64 { E_INSUFFICIENT_FEE }
}
