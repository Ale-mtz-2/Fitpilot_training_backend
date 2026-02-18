# Mock Users - FitPilot API

Este documento contiene las credenciales de los usuarios mock para desarrollo y testing.

## 🔐 Contraseña por Defecto

**Todos los usuarios usan la misma contraseña:**
```
password123
```

## 👥 Usuarios Disponibles

### Admin

| Email | Nombre | Role | Estado |
|-------|--------|------|--------|
| `admin@fitpilot.com` | Admin User | ADMIN | ✅ Verificado, Activo |

**Permisos:** Acceso completo a todas las funcionalidades del sistema.

### Trainers

| Email | Nombre | Role | Estado |
|-------|--------|------|--------|
| `trainer1@fitpilot.com` | Carlos Rodriguez | TRAINER | ✅ Verificado, Activo |
| `trainer2@fitpilot.com` | Maria Garcia | TRAINER | ✅ Verificado, Activo |

**Permisos:** Pueden crear, editar y eliminar ejercicios. Pueden crear y gestionar rutinas.

### Clients

| Email | Nombre | Role | Estado |
|-------|--------|------|--------|
| `client1@fitpilot.com` | Juan Perez | CLIENT | ✅ Verificado, Activo |
| `client2@fitpilot.com` | Ana Martinez | CLIENT | ✅ Verificado, Activo |
| `client3@fitpilot.com` | Luis Sanchez | CLIENT | ⚠️ No verificado, Activo |

**Permisos:** Pueden ver ejercicios, crear y ver sus propias rutinas. No pueden modificar ejercicios.

## 📝 Ejemplos de Uso

### Login

```bash
# Login como Admin
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@fitpilot.com", "password": "password123"}'

# Login como Trainer
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "trainer1@fitpilot.com", "password": "password123"}'

# Login como Client
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "client1@fitpilot.com", "password": "password123"}'
```

### Usar Token de Autenticación

```bash
# Guardar el token
TOKEN="tu_token_jwt_aqui"

# Usar el token en requests
curl -X GET http://localhost:8000/api/exercises \
  -H "Authorization: Bearer $TOKEN"
```

## 🔄 Resetear Usuarios Mock

Para resetear y volver a crear todos los usuarios mock:

```bash
docker exec -it fitpilot_backend python scripts/seed_users.py
# Cuando pregunte, responde "yes" para confirmar
```

O con confirmación automática:

```bash
docker exec -i fitpilot_backend python scripts/seed_users.py <<< "yes"
```

## 🗂️ Estructura de Roles

```
ADMIN
  └─ Acceso completo al sistema
     ├─ Gestión de usuarios
     ├─ Gestión de ejercicios (CRUD)
     ├─ Gestión de rutinas (CRUD)
     └─ Acceso a todas las funcionalidades

TRAINER
  └─ Gestión de contenido
     ├─ Gestión de ejercicios (CRUD)
     ├─ Gestión de rutinas (CRUD)
     └─ Ver todos los ejercicios

CLIENT
  └─ Usuario estándar
     ├─ Ver ejercicios (solo lectura)
     ├─ Crear sus propias rutinas
     └─ Ver sus propias rutinas
```

## 📋 Notas

- El usuario `client3@fitpilot.com` está **no verificado** para probar flujos de verificación de email.
- Todos los usuarios están **activos** por defecto.
- Las contraseñas están hasheadas usando **Argon2** en la base de datos.
- Los tokens JWT expiran según la configuración en `core/config.py`.
