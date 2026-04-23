# 🌍 GCP Local Workspace Template (Event-Driven Architecture)

Este repositorio define un **workspace local** para desarrollar sistemas basados en eventos (event-driven) inspirados en GCP, utilizando emuladores y servicios locales.

La idea principal es tener un **template limpio, desacoplado y extensible** que permita iniciar nuevos proyectos sin fricción, simulando una arquitectura productiva desde el día 1.

---

## 🧠 Concepto

Este workspace sigue una arquitectura basada en eventos:

- Los servicios **no se comunican directamente**
- Se comunican mediante **mensajes (Pub/Sub)**
- Los **workers consumen eventos** y ejecutan lógica de negocio

Esto permite:

- Escalabilidad
- Desacoplamiento
- Tolerancia a fallos
- Procesamiento asíncrono

---

## 🧱 Estructura del Workspace

```bash
.
├── backend/         # API (FastAPI)
├── frontend/         # Frontend ssr (Remix(react+vite))
├── workers/         # Workers desacoplados (event-driven)
├── docker-compose.yml
├── env.example
```

### 🔹 Backend

Encargado de:

- Exponer endpoints (REST/WebSocket)
- Publicar eventos en Pub/Sub
- Orquestar lógica de entrada

> ⚠️ Su documentación vive en su propio README

---

### 🔹 Workers

Encargados de:

- Escuchar eventos desde Pub/Sub
- Procesar tareas específicas
- Ejecutar jobs desacoplados

Cada worker debe ser:

- Independiente
- Escalable
- Reemplazable

---

## 🚀 Infraestructura Local

El workspace levanta los siguientes servicios:

### 🐇 Pub/Sub Emulator

- Simula Google Pub/Sub localmente
- Puerto: `8085`

### 🪣 MinIO (S3 local)

- Storage compatible con S3
- API: `http://localhost:9000`
- Console: `http://localhost:9001`

Credenciales por defecto:

```
user: admin
password: password123
```

---

### 🗄️ PostgreSQL

- Base de datos principal
- Puerto: `5432`

Credenciales:

```
user: admin
password: password
db: app_db
```

---

### 🚀 Backend API

- FastAPI
- Puerto: `8080`

---

### ⚙️ Workers

- Consumidores de eventos
- Ejemplo incluido: `worker-example`

---

## ⚙️ Configuración Inicial

### 1. Clonar el repositorio

```bash
git clone https://github.com/hector4like6gorillaz/workspace-event-driven-architecture-gpc
cd workspace-event-driven-architecture-gpc
```

---

### 2. Crear archivo de entorno

```bash
cp env.example .env.localdev
```

> ⚠️ Completa las variables según tu necesidad

---

### 3. Levantar todo el workspace

## 🛠️ Makefile Commands Guide

Este proyecto incluye un `Makefile` para facilitar la configuración y ejecución del entorno.

---

## 🧠 Setup (Mac / Linux)

    make setup

Ejecuta el script de configuración inicial para Mac/Linux.

    make git-clone

Clona los repositorios necesarios en Mac/Linux.

---

## 🪟 Setup (Windows)

    make setup-win

Ejecuta el script de configuración en Windows usando PowerShell.

    make git-clone-win

Clona los repositorios necesarios en Windows.

---

## 🚀 Full Environment

    make up

Levanta todo el entorno completo con Docker:

- API: http://localhost:8080
- MinIO: http://localhost:9001
- DB: localhost:5432

  make down

Detiene todos los servicios.

    make reset

Reinicia el entorno eliminando contenedores y volúmenes (⚠️ borra datos).

    make logs

Muestra los logs en tiempo real.

---

## 🧱 Infrastructure Only (rápido)

    make infra

Levanta solo la infraestructura básica:

- Pub/Sub Emulator
- MinIO
- Base de datos

---

## 🚀 Servicios desacoplados

    make api

Levanta únicamente la API.

    make workers

Levanta los workers.

---

## 🗄️ Base de Datos

    make db

Levanta únicamente la base de datos.

---

## 🔥 Servicios Disponibles

| Servicio      | URL / Puerto          |
| ------------- | --------------------- |
| Backend API   | http://localhost:8080 |
| MinIO API     | http://localhost:9000 |
| MinIO Console | http://localhost:9001 |
| Pub/Sub       | http://localhost:8085 |
| PostgreSQL    | localhost:5432        |

---

## 🧪 Flujo de Trabajo (Ejemplo)

1. Backend recibe request
2. Backend publica evento en Pub/Sub
3. Worker consume evento
4. Worker procesa job
5. (Opcional) guarda resultado en DB o Storage

---

## ⚙️ Workers (Concepto)

Los workers viven en:

```bash
workers/src/worker_system/workers/
```

Ejemplo:

```bash
workers/example/
├── job.py
└── main.py
```

### Cada worker debe:

- Escuchar una **subscription**
- Procesar el mensaje
- Hacer `ack` solo si fue exitoso
- Ser tolerante a fallos

---

## ➕ Agregar un Nuevo Worker

### 1. Crear estructura

```bash
workers/src/worker_system/workers/<nombre>/
```

Ejemplo:

```bash
workers/src/worker_system/workers/extractor/
```

---

### 2. Crear archivos base

```bash
main.py
job.py
```

---

### 3. Registrar en docker-compose

```yaml
worker-extractor:
  build:
    context: ./workers
  container_name: worker-extractor
  volumes:
    - ./workers:/app
  depends_on:
    - pubsub-emulator
    - db
    - minio
  env_file:
    - .env.localdev
  environment:
    PYTHONPATH: /app
  command: ["python", "src/worker_system/workers/extractor/main.py"]
```

---

### 4. Naming convention

```
worker-<dominio>
```

Ejemplos:

- worker-extractor
- worker-ai
- worker-image-processor

---

## 🧩 Agregar Nuevos Servicios

Puedes extender el workspace agregando:

- Frontend (React, Next.js, etc.)
- Nuevos workers
- Nuevas APIs
- Servicios externos

---

## 🧪 Testing Local

Puedes probar el flujo:

1. Crear topic/subscription desde backend
2. Publicar mensaje
3. Ver logs del worker

---

## 📦 Persistencia

Los datos persisten en:

- PostgreSQL → `db_data`
- MinIO → `minio_data`

---

## 🧼 Resetear entorno

```bash
docker compose down -v
```

---

## 🧭 Filosofía del Template

Este workspace está diseñado para:

- Ser **mínimo pero escalable**
- Favorecer **desacoplamiento**
- Simular arquitectura real de GCP
- Permitir iteración rápida en local

---

## 🚧 Próximas mejoras

- Health checks
- Observabilidad (logs centralizados)
- Métricas

---

## 💡 Nota Final

Este template **no está acoplado a ningún dominio específico**.

Es una base para construir sistemas donde:

> "Los eventos son la fuente de verdad, y los workers ejecutan la lógica."

---

## 👨‍💻 Autor

HB <3
Template diseñado para acelerar desarrollo backend basado en eventos.
