#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------
# mint_shieldcoin.sh
# Mintea SHIELD_COIN y lo envía a la cuenta indicada.
#
# Uso:
#   ./mint_shieldcoin.sh <AMOUNT_SHLD> <RECIPIENT_ADDRESS> [PACKAGE_ID] [TREASURY_CAP_ID]
# Ejemplo:
#   ./mint_shieldcoin.sh 5 0x18ace72f...958818
# ------------------------------------------------------------------

DEFAULT_PACKAGE_ID="0x699d99065a4b52ef79058ee2ef777b7976050a99f149c18f7a0084487381009b"
DEFAULT_TREASURY_CAP_ID="0x75b13f5b4319aa3ecbfed0dab6e4d061a69432258f0270cdf3e1cadd1470c176"
DECIMALS=9
GAS_BUDGET=100000000

usage() {
  echo "Uso: $0 <AMOUNT_SHLD> <RECIPIENT_ADDRESS> [PACKAGE_ID] [TREASURY_CAP_ID]"
  exit 1
}

if [ "$#" -lt 2 ]; then
  usage
fi

AMOUNT_HUMAN="$1"
RECIPIENT="$2"
PACKAGE_ID="${3:-$DEFAULT_PACKAGE_ID}"
TREASURY_CAP="${4:-$DEFAULT_TREASURY_CAP_ID}"

# ------------------------------------------------------------------
# 🔢 Conversión: unidades humanas → atómicas (10^decimales)
# Ej: 5.25 SHLD con 9 decimales = 5250000000
# ------------------------------------------------------------------

AMOUNT_ATOMIC=$(echo "scale=0; $AMOUNT_HUMAN * (10 ^ $DECIMALS)" | bc | cut -d'.' -f1)

echo "─────────────────────────────────────────────"
echo "🪙 Minting SHIELD_COIN"
echo "  Package ID:    $PACKAGE_ID"
echo "  TreasuryCap:   $TREASURY_CAP"
echo "  Recipient:     $RECIPIENT"
echo "  Amount human:  $AMOUNT_HUMAN"
echo "  Amount atomic: $AMOUNT_ATOMIC"
echo "─────────────────────────────────────────────"

# ------------------------------------------------------------------
# 🧩 Ejecutar mint
# ------------------------------------------------------------------

sui client call \
  --package "$PACKAGE_ID" \
  --module shield_coin \
  --function mint \
  --args "$TREASURY_CAP" "$AMOUNT_ATOMIC" "$RECIPIENT" \
  --gas-budget "$GAS_BUDGET"

echo "✅ Mint completado."
