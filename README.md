# Bali Shield

Contrato escrito en **Sui Move** que implementa un sistema de escudos (`Shield`) con distintos niveles de poder, tarifas de mejora y funciones de transferencia.

La arquitectura está dividida en módulos para mantener el código legible, seguro y fácil de extender.

---

## Arquitectura del contrato

### `types.move`
Define las estructuras y funciones principales:

- `ShieldType`: enum con variantes:
  - `Basic { bonus_resistance }`
  - `Advanced { bonus_power }`
  - `Epic { bonus_value }`

- `Shield`: struct con campos:
  - `id: UID`
  - `resistance: u64`
  - `power: u64`
  - `value: u64`
  - `stype: ShieldType`

- Funciones:
  - `new`: constructor genérico de shields.
  - `make_basic`: helper para crear un shield básico.
  - Getters y validadores (`is_basic`, `is_advanced`, `is_epic`).
  - Bonus extractors (`bonus_resistance_of`, `bonus_power_of`, `bonus_value_of`).
  - `upgrade`: mejora el tipo de escudo (Basic → Advanced → Epic).

---

### `logic.move`
Implementa la lógica de negocio:

- `create_shield`: combina valores base con bonus según el tipo.
- `upgrade_shield`: aplica las mejoras de nivel llamando a `types::upgrade`.

---

### `fees.move`
Gestión de tarifas en SUI:

- Constantes internas:
  - `BASIC_TO_ADVANCED_FEE = 0.1 SUI`
  - `ADVANCED_TO_EPIC_FEE = 0.2 SUI`
  - `TREASURY = @treasury`

- Funciones:
  - `basic_to_advanced_fee`, `advanced_to_epic_fee`, `treasury`: exponen las constantes.
  - `charge_fee`: cobra un monto de un `Coin<T>` y lo transfiere a la tesorería.

---

### `errors.move`
Centraliza los códigos de error:

- `wrong_tier`: error al intentar un upgrade inválido.
- `insufficient_fee`: error al no tener suficiente balance para la tarifa.

---

### `entries.move`
Capa de orquestación que combina validaciones, cobro de tarifas y lógica de negocio:

- `upgrade_basic_to_advanced`:
  - Verifica que el shield sea `Basic`.
  - Cobra la tarifa correspondiente.
  - Llama a `logic::upgrade_shield`.

- `create_basic_shield`:
  - Crea un shield básico con `types::make_basic`.

---

### `transfers.move`
Funciones de entrada pública (`entry fun`) que interactúan con los usuarios:

- `mint_basic_and_send_to`:
  - Crea un shield básico con `entries::create_basic_shield`.
  - Lo transfiere al address indicado.

---

## Flujo de uso

1. **Creación de un shield**  
   - Llamar `mint_basic_and_send_to` para recibir un shield básico.

2. **Mejora de tier**  
   - Llamar `upgrade_basic_to_advanced` con:
     - El shield en propiedad.
     - Una `Coin<SUI>` con suficiente balance.
     - El contexto de transacción.

3. **Próximos upgrades**  
   - Implementar `upgrade_advanced_to_epic` siguiendo la misma estructura.

---

## Próximos pasos

- Agregar `upgrade_advanced_to_epic` en `entries`.
- Emitir eventos (`MintedEvent`, `UpgradedEvent`, `FeeChargedEvent`) para trazabilidad.
- Reemplazar la tesorería fija por un objeto configurable.
- Crear pruebas unitarias (`#[test]`) para upgrades, cobro de tarifas y validaciones.
- Centralizar constantes en un módulo `constants.move`.
