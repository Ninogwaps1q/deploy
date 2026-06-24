<#
Automated Heroku deployment script (PowerShell)
Prerequisites:
 - Heroku CLI installed and logged in (`heroku login`)
 - Git installed
 - (Optional) GitHub CLI `gh` if you want repository creation automated
Usage:
 .\deploy_heroku.ps1 -HerokuAppName your-app-name -GitHubRepo your-user/your-repo
#>
param(
    [string]$HerokuAppName = "",
    [string]$GitHubRepo = ""
)

Write-Host "Starting automated Heroku deployment..."

# Check for git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git not found in PATH. Install Git and retry."
    exit 1
}

# Initialize git repo if missing
if (-not (Test-Path .git)) {
    Write-Host "Initializing git repository..."
    git init
    git add .
    git commit -m "Prepare for Heroku deployment" | Out-Null
}

# Optionally create GitHub repo using gh
if ($GitHubRepo -and (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "Ensuring GitHub repo exists (using gh)..."
    gh repo create $GitHubRepo --source=. --public --push --confirm
} elseif ($GitHubRepo) {
    Write-Host "GitHub CLI 'gh' not found; skipping GitHub repo creation."
}

# Create or use existing Heroku app
if (-not (Get-Command heroku -ErrorAction SilentlyContinue)) {
    Write-Error "Heroku CLI not found. Install it and run 'heroku login' before running this script."
    exit 1
}

if (-not $HerokuAppName) {
    Write-Host "Creating a new Heroku app (auto-generated name)..."
    $createOutput = heroku create
    # Extract app name from output like "Created app: app-name"
    $m = ($createOutput | Select-String -Pattern "Created app: (?<name>[^\s]+)")
    if ($m) { $HerokuAppName = $m.Matches[0].Groups['name'].Value }
} else {
    Write-Host "Creating or ensuring Heroku app: $HerokuAppName..."
    heroku create $HerokuAppName -s
}

if (-not $HerokuAppName) {
    Write-Error "Unable to determine Heroku app name. Provide -HerokuAppName explicitly."
    exit 1
}

Write-Host "Heroku app: $HerokuAppName"

# Add heroku git remote if missing
$remotes = git remote
if ($remotes -notmatch "heroku") {
    heroku git:remote -a $HerokuAppName
}

# Push to heroku
Write-Host "Pushing main branch to Heroku..."
git push heroku main

# Set environment variables from .env (if exists) or .env.example
$envFile = "./.env"
if (-not (Test-Path $envFile)) { $envFile = "./.env.example" }
if (Test-Path $envFile) {
    Write-Host "Setting config vars from $envFile..."
    Get-Content $envFile | Where-Object { $_ -match '=' -and -not ($_ -match '^#') } | ForEach-Object {
        $parts = $_ -split '=',2
        $k = $parts[0].Trim()
        $v = $parts[1].Trim().Trim('"')
        if ($k) {
            Write-Host "heroku config:set $k=*** -a $HerokuAppName"
            heroku config:set $k="$v" -a $HerokuAppName
        }
    }
} else {
    Write-Host "No .env or .env.example found to set config vars."
}

# Run DB init script if present
if (Test-Path "flask_app/run.py") {
    Write-Host "Running DB init/admin creation script on Heroku..."
    heroku run python flask_app/run.py -a $HerokuAppName
}

Write-Host "Deployment finished. Check logs with: heroku logs -a $HerokuAppName --tail"
