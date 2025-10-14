#!/bin/bash
set -euo pipefail

# ======================================
# Mint Shield Script for bali_shield
# ======================================
# Uso:
#   ./scripts/mint_shield.sh [basic|advanced|epic] [recipient?]
# Ejemplo:
#   ./scripts/mint_shield.sh basic
#   ./scripts/mint_shield.sh epic 0x1234abcd...
# ======================================

# ---------- CONFIGURACIÓN ----------
PACKAGE_ID="0xb7c439fce11c26e3dd9ff934d58908824085f53c726d2df33b40750b457ca7a0"
MODULE="entries"
FUNCTION="create_shield"
GAS_BUDGET="100000000"

# ---------- VALIDACIÓN ----------
if [ $# -lt 1 ]; then
  echo "❌ Uso: $0 [basic|advanced|epic] [recipient?]"
  exit 1
fi

TIER_NAME="$1"
RECIPIENT="${2:-none}"

# ---------- MAPEO ----------
case "$TIER_NAME" in
  basic) TIER_ID=0 ;;
  advanced) TIER_ID=1 ;;
  epic) TIER_ID=2 ;;
  *)
    echo "❌ Tier inválido: $TIER_NAME"
    echo "   Usa: basic | advanced | epic"
    exit 1
    ;;
esac

echo "⚔️  Minting Shield..."
echo "   Tier: $TIER_NAME ($TIER_ID)"
echo "   Recipient: $RECIPIENT"

# ---------- EJECUCIÓN ----------
if [ "$RECIPIENT" = "none" ]; then
  # 🟢 Mint para el caller → Option<address> vacío = []
  sui client call \
    --package $PACKAGE_ID \
    --module $MODULE \
    --function $FUNCTION \
    --args $TIER_ID "[]" \
    --gas-budget $GAS_BUDGET
else
  # 🟣 Mint para otra dirección → Option<address> con un valor = [<address>]
  sui client call \
    --package $PACKAGE_ID \
    --module $MODULE \
    --function $FUNCTION \
    --args $TIER_ID "[\"$RECIPIENT\"]" \
    --gas-budget $GAS_BUDGET
fi

echo "✅ Shield minted successfully!"
