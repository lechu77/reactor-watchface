#!/usr/bin/env bash

# REACTOR Theme Switcher
# Cambia el tema, borra la caché del simulador, recompila y relanza.
# Uso: ./scripts/set_theme.sh [0-5]

THEME=$1

if [[ -z "$THEME" ]]; then
    echo ""
    echo "  ╔══════════════════════════════════════════╗"
    echo "  ║        REACTOR · Theme Switcher          ║"
    echo "  ╠══════════════════════════════════════════╣"
    echo "  ║  Uso: ./scripts/set_theme.sh <número>    ║"
    echo "  ╠══════════════════════════════════════════╣"
    echo "  ║  0 = Nixie (Cyan)           ██ bitmap   ║"
    echo "  ║  1 = Sólido (Cyan)          ██ segment  ║"
    echo "  ║  2 = Sólido (Fósforo Verde) ██ segment  ║"
    echo "  ║  3 = Sólido (Ámbar)         ██ segment  ║"
    echo "  ║  4 = Sólido (Blanco)        ██ segment  ║"
    echo "  ║  5 = Sólido (Azul Siemens)  ██ segment  ║"
    echo "  ║ 10 = Nixie (Ámbar)          ██ bitmap   ║"
    echo "  ╚══════════════════════════════════════════╝"
    echo ""
    exit 0
fi

if [[ "$THEME" -lt 0 || "$THEME" -gt 10 ]]; then
    echo "Error: el tema debe ser un número entre 0 y 10."
    exit 1
fi

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROPERTIES_FILE="$PROJECT_ROOT/resources/settings/properties.xml"

# 1. Cambiar el valor por defecto en properties.xml
sed -i '' -E 's/<property id="themeStyle" type="number">[0-9]+<\/property>/<property id="themeStyle" type="number">'"$THEME"'<\/property>/' "$PROPERTIES_FILE"
echo "✓ properties.xml → themeStyle = $THEME"

# 2. Borrar la caché de settings del simulador para que use el nuevo default
SIM_SETTINGS=$(find "$TMPDIR" -name "REACTOR.SET" 2>/dev/null)
if [[ -n "$SIM_SETTINGS" ]]; then
    rm -f "$SIM_SETTINGS"
    echo "✓ Caché del simulador eliminada (REACTOR.SET)"
else
    echo "· No se encontró caché del simulador"
fi

# 3. Borrar bin y gen para evitar errores de compilación por caché sucia
rm -rf "$PROJECT_ROOT/bin" "$PROJECT_ROOT/gen"

# 4. Recompilar y relanzar
echo "⟳ Recompilando..."
"$PROJECT_ROOT/scripts/build.sh"
echo "⟳ Lanzando simulador..."
"$PROJECT_ROOT/scripts/sim.sh"
