.PHONY: setup git-clone setup-win git-clone-win up down reset logs api workers infra db

# =========================================================
# 🧠 SETUP (Mac / Linux)
# =========================================================

setup:
	@echo "⚙️ Running setup (Mac/Linux)..."
	@bash scripts/setup.sh

git-clone:
	@echo "📦 Cloning repositories (Mac/Linux)..."
	@bash scripts/git-clone.sh

# =========================================================
# 🪟 SETUP (Windows)
# =========================================================

setup-win:
	@echo "⚙️ Running setup (Windows)..."
	@powershell -ExecutionPolicy Bypass -File scripts/setup.ps1

git-clone-win:
	@echo "📦 Cloning repositories (Windows)..."
	@powershell -ExecutionPolicy Bypass -File scripts/git-clone.ps1

# =========================================================
# 🚀 FULL ENVIRONMENT
# =========================================================

up:
	@echo "🚀 Starting full environment..."
	@docker compose up -d --build
	@echo ""
	@echo "✅ Services running:"
	@echo "👉 API:    http://localhost:8080"
	@echo "👉 MinIO:  http://localhost:9001"
	@echo "👉 DB:     localhost:5432"
	@echo ""

down:
	@echo "🛑 Stopping environment..."
	@docker compose down

reset:
	@echo "💣 Resetting environment (removing volumes)..."
	@docker compose down -v

logs:
	@echo "📜 Tailing logs..."
	@docker compose logs -f

# =========================================================
# 🧱 INFRASTRUCTURE ONLY (rápido)
# =========================================================

infra:
	@echo "🧱 Starting infrastructure..."
	@docker compose up -d pubsub-emulator minio db

# =========================================================
# 🚀 SERVICES (DESACOPLADOS)
# =========================================================

front:
	@echo "🎨 Starting frontend..."
	@docker compose up -d --build front

api:
	@echo "🚀 Starting API..."
	@docker compose up -d --build api

workers:
	@echo "⚙️ Starting workers..."
	@docker compose up -d --build worker-example

# =========================================================
# 🗄️ DATABASE
# =========================================================

db:
	@echo "🗄️ Starting database..."
	@docker compose up -d db