#!/bin/bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
#  Script: create_shield.sh
#  Crea un escudo básico en el contrato Bali Shield
#  y lo transfiere al address especificado.
#
#  Uso:
#    ./create_shield.sh [ACCOUNT_ADDRESS]
#
#  Si no se pasa address, usa el del deploy.
# ─────────────────────────────────────────────────────────────

# Variables fijas del contrato actual
PACKAGE_ID="0x699d99065a4b52ef79058ee2ef777b7976050a99f149c18f7a0084487381009b"
DEFAULT_ACCOUNT="0x18ace72faa4c4c3dbc7a342fa7a0b8d6524d9ad3cda06883b712674975958818"
GAS_BUDGET=100000000

# Address destino (por parámetro o default)
RECIPIENT="${1:-$DEFAULT_ACCOUNT}"

echo "─────────────────────────────────────────────"
echo "⚔️  Creando Shield básico (gratuito)"
echo "─────────────────────────────────────────────"
echo "📦 Package:     $PACKAGE_ID"
echo "👤 Recipient:   $RECIPIENT"
echo "⛽ Gas budget:  $GAS_BUDGET"
echo "─────────────────────────────────────────────"

# Ejecutar transacción
sui client call \
  --package "$PACKAGE_ID" \
  --module transfers \
  --function mint_basic_and_send_to \
  --args "$RECIPIENT" \
  --gas-budget "$GAS_BUDGET"

echo "✅ Escudo básico creado y transferido exitosamente."
