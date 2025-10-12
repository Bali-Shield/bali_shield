#!/bin/bash
# ===================================================================
# make_executables.sh
# Da permiso de ejecución a todos los scripts .sh en el proyecto
# ===================================================================

# Salir si ocurre un error
set -e

echo "🔍 Buscando archivos .sh en el proyecto..."

# Buscar todos los archivos .sh y aplicar chmod +x
find . -type f -name "*.sh" ! -path "./node_modules/*" ! -path "./.git/*" -print -exec chmod +x {} \;

echo ""
echo "✅ Todos los scripts .sh tienen permisos de ejecución ahora."
