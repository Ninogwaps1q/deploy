Automated Heroku Deployment

This repository includes `deploy_heroku.ps1`, a PowerShell script that automates deployment to Heroku.

Prerequisites
- Windows PowerShell
- Git
- Heroku CLI (https://devcenter.heroku.com/articles/heroku-cli) and logged in (`heroku login`)
- (Optional) GitHub CLI `gh` if you want automatic GitHub repo creation

Quick run
1. Open PowerShell in the project root:

```powershell
# Provide your Heroku app name (if omitted an auto-generated app will be created)
.\deploy_heroku.ps1 -HerokuAppName your-app-name -GitHubRepo your-username/your-repo
```

2. The script will:
- Initialize git and commit if needed
- Optionally create and push to a GitHub repo (if `gh` is installed and `-GitHubRepo` provided)
- Create a Heroku app (or use the provided name)
- Push `main` to Heroku
- Set Heroku config vars from `.env` or `.env.example`
- Run `flask_app/run.py` on Heroku to initialize DB and create admin user

Notes & Caveats
- You must be authenticated with Heroku (run `heroku login`) before running the script.
- The script reads `.env` or `.env.example` and will set environment variables on Heroku. Do not store secrets in these files in public repos.
- SQLite is NOT recommended for production on Heroku; consider attaching Postgres via `heroku addons:create heroku-postgresql:hobby-dev -a your-app-name` and updating `DATABASE_URL` accordingly.

If you want, I can try running the script here (requires interactive Heroku login). Alternatively, tell me your Heroku app name and confirm you are logged in and I'll run the necessary commands from the terminal.