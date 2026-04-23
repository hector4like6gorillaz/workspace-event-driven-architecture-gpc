Write-Host "🚀 Setting up workspace..."

# =========================================================
# 🌱 ROOT ENV
# =========================================================

if (!(Test-Path ".env.localdev")) {
    Copy-Item "env.example" ".env.localdev"
    Write-Host "✅ .env.localdev created"
} else {
    Write-Host "ℹ️ .env.localdev already exists"
}

# =========================================================
# 📦 CLONE REPOS
# =========================================================

powershell -ExecutionPolicy Bypass -File scripts/git-clone.ps1

# =========================================================
# ⚙️ SETUP ENVS PER REPO
# =========================================================

Write-Host ""
Write-Host "⚙️ Configuring env files in services..."

$config = Get-Content "repos.json" | ConvertFrom-Json

foreach ($service in $config.services) {

    $name = $service.name
    $dir = $service.dir
    $envFile = $service.env
    $envPath = $service.env_path

    if (Test-Path $dir) {

        Write-Host "🔧 $name..."

        $example = Join-Path $dir "env.example"

        if ($envPath -eq ".") {
            $targetDir = $dir
        } else {
            $targetDir = Join-Path $dir $envPath
        }

        $target = Join-Path $targetDir $envFile

        if (Test-Path $example) {

            # Crear directorio si no existe
            if (!(Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir | Out-Null
            }

            if (!(Test-Path $target)) {
                Copy-Item $example $target
                Write-Host "✅ Created $target"
            } else {
                Write-Host "↩️ $target already exists"
            }

        } else {
            Write-Host "⚠️ No .env.example in $name"
        }

    } else {
        Write-Host "⚠️ Directory $dir not found"
    }
}

# =========================================================
# 🐳 DOCKER
# =========================================================

Write-Host ""
Write-Host "🐳 Pulling Docker images..."
docker compose pull

Write-Host ""
Write-Host "🔥 Setup complete!"