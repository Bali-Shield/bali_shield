# 🛡️ Bali Shield – Sui Move Smart Contract

Este proyecto implementa un contrato en **Sui Move** que modela escudos con diferentes niveles de poder y rareza.  
Incluye funciones para **crear, mejorar y transferir** escudos, así como un conjunto de **tests automáticos**.

---

## ✨ Funcionalidad

El contrato define un `struct Shield` con los campos:

- `resistance`: vida o durabilidad
- `power`: daño o fuerza
- `value`: precio o rareza en el juego
- `stype`: tipo de escudo (`Basic`, `Advanced`, `Epic`)

### Tipos de escudos
- **Basic**: baja resistencia y costo bajo.  
- **Advanced**: más poder, valor medio.  
- **Epic**: alto valor, resistencia y poder.

### Funciones principales
- `create_basic_shield` → Crea un escudo básico (uso interno o desde tests).  
- `create_advanced_shield` → Crea un escudo avanzado (uso interno/tests).  
- `create_epic_shield` → Crea un escudo épico (uso interno/tests).  
- `upgrade_shield` → Mejora un escudo (Basic → Advanced → Epic).  
- `transfer_shield` → Transfiere un escudo a otro address.  
- `create_and_transfer_basic_shield` → **Entry point** para crear y recibir un escudo básico en una transacción.

> ⚠️ Importante: en Sui, **solo las funciones `entry`** se pueden llamar desde la consola o un frontend.  
> Las demás (`public fun`) sirven como lógica interna, para tests o para que otros módulos las reutilicen.

---

## 🧪 Tests

El proyecto incluye un módulo `bali_shield_tests` con pruebas unitarias:

- `test_create_basic_attrs` → Verifica atributos de un escudo básico.  
- `test_create_advanced_attrs` → Verifica atributos de un escudo avanzado.  
- `test_create_epic_attrs` → Verifica atributos de un escudo épico.  
- `test_upgrade_flow` → Verifica el flujo de mejora (Basic → Advanced → Epic).  
- `test_transfer_ownership_with_scenario` → Simula transferencia de un escudo entre usuarios.  
- `test_entry_create_and_transfer_basic_shield` → Verifica la creación + transferencia vía entry.

Ejecutar:

```bash
sui move test
