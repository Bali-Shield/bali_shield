#!/bin/bash
set -e

# ============================================
# Script de upgrade de Shields en bali_shield
# Uso:
#   ./scripts/upgrade_shield.sh <upgrade_type> <shield_id> <fee_coin_id> [gas_coin_id]
# Ejemplo:
#   ./scripts/upgrade_shield.sh basic_to_advanced 0xSHIELD 0xCOIN 0xSUI_GAS
# ============================================

UPGRADE_TYPE=$1
SHIELD_ID=$2
FEE_COIN_ID=$3
GAS_COIN_ID=${4:-""} # opcional

# ID del paquete de tu contrato (reemplazá con el tuyo)
PACKAGE_ID="0x699d99065a4b52ef79058ee2ef777b7976050a99f149c18f7a0084487381009b"
GAS_BUDGET=100000000

echo "─────────────────────────────────────────────"
echo "🛡️ Upgrade de Shield"
echo "  Tipo de upgrade: $UPGRADE_TYPE"
echo "  Package ID:      $PACKAGE_ID"
echo "  Shield ID:       $SHIELD_ID"
echo "  Fee Coin ID:     $FEE_COIN_ID"
if [ -n "$GAS_COIN_ID" ]; then
  echo "  Gas Coin ID:     $GAS_COIN_ID"
fi
echo "─────────────────────────────────────────────"

# Comando base
CMD=(
  sui client call
  --package "$PACKAGE_ID"
  --module entries
  --function "upgrade_${UPGRADE_TYPE}"
  --args "$SHIELD_ID" "$FEE_COIN_ID"
  --gas-budget "$GAS_BUDGET"
)

# Si pasaste un gas coin, se añade
if [ -n "$GAS_COIN_ID" ]; then
  CMD+=(--gas "$GAS_COIN_ID")
fi

# Ejecuta
"${CMD[@]}"
