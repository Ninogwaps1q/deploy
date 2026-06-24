cd d:\project\pythponTeckitHub-2
git init
git add .
git commit -m "Prepare for Heroku deployment"
git remote add origin https://github.com/YOUR_USERNAME/your-repo-name
git push -u origin maincd d:\project\pythponTeckitHub-2
git init
git add .
git commit -m "Prepare for Heroku deployment"
git remote add origin https://github.com/YOUR_USERNAME/your-repo-name
git push -u origin maincd d:\project\pythponTeckitHub-2
git init
git add .
git commit -m "Prepare for Heroku deployment"
git remote add origin https://github.com/YOUR_USERNAME/your-repo-name
git push -u origin main# Deployment Guide - Python Teckit Hub (Heroku)

This guide walks you through deploying your Flask ticketing application to Heroku.

## Prerequisites

1. **GitHub Account** - For storing and deploying your code
2. **Heroku Account** - Create one at https://www.heroku.com
3. **Heroku CLI** - Download from https://devcenter.heroku.com/articles/heroku-cli
4. **Git** - Version control system

## Step 1: Prepare Your Project

✅ Already done:
- Added `gunicorn` to requirements.txt (production WSGI server)
- Created `Procfile` (tells Heroku how to run your app)
- Created `runtime.txt` (specifies Python version 3.13.14)
- Created `.env.example` (template for environment variables)
- Updated `.gitignore` (excludes sensitive files)

## Step 2: Initialize Git Repository

If you haven't already:

```bash
cd d:\project\pythponTeckitHub-2
git init
git add .
git commit -m "Initial commit: Prepare for Heroku deployment"
```

## Step 3: Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository (e.g., `pythonTeckitHub`)
3. Follow GitHub's instructions to push your local code:

```bash
git remote add origin https://github.com/YOUR_USERNAME/pythonTeckitHub.git
git branch -M main
git push -u origin main
```

## Step 4: Set Up Heroku

### Option A: Deploy from GitHub (Recommended)

1. **Login to Heroku CLI:**
   ```bash
   heroku login
   ```

2. **Create a Heroku App:**
   ```bash
   heroku create your-app-name
   ```
   Replace `your-app-name` with a unique name (e.g., `pythonteckit-hub`)

3. **Connect GitHub Repository:**
   - Go to https://dashboard.heroku.com/apps
   - Select your app → "Deploy" tab
   - Click "Connect to GitHub"
   - Search and select your repository
   - Enable "Automatic deploys" (optional)

4. **Set Environment Variables:**
   ```bash
   heroku config:set -a your-app-name SECRET_KEY="$(openssl rand -hex 32)"
   heroku config:set -a your-app-name PAYMONGO_SECRET_KEY="your-key"
   heroku config:set -a your-app-name PAYMONGO_PUBLIC_KEY="your-key"
   heroku config:set -a your-app-name MAIL_USERNAME="your-email@gmail.com"
   heroku config:set -a your-app-name MAIL_PASSWORD="your-app-password"
   heroku config:set -a your-app-name GOOGLE_API_KEY="your-key"
   heroku config:set -a your-app-name FLASK_ENV=production
   ```

### Option B: Deploy Using Heroku CLI

```bash
heroku create your-app-name
git push heroku main
```

## Step 5: Initialize Database

Run migrations and create admin user on Heroku:

```bash
heroku run -a your-app-name python flask_app/run.py
```

## Step 6: View Your App

```bash
heroku open -a your-app-name
```

Or visit: `https://your-app-name.herokuapp.com`

## Step 7: Monitor Logs

```bash
heroku logs -a your-app-name --tail
```

## Important Configuration

### Environment Variables You MUST Set

Create a `.env` file locally (copy from `.env.example`) with your actual values:

- `SECRET_KEY` - Use a strong random key
- `PAYMONGO_SECRET_KEY` - Your PayMongo secret
- `PAYMONGO_PUBLIC_KEY` - Your PayMongo public key
- `MAIL_USERNAME` / `MAIL_PASSWORD` - Gmail credentials
- `GOOGLE_API_KEY` - For AI chatbot features

### Database Note (SQLite on Heroku)

⚠️ **Warning**: SQLite on Heroku has limitations because the filesystem is ephemeral (resets every 24 hours).

For production, consider upgrading to PostgreSQL:

```bash
heroku addons:create heroku-postgresql:hobby-dev -a your-app-name
```

Update your app to use PostgreSQL automatically:
```bash
# Heroku will set DATABASE_URL automatically
```

## Troubleshooting

### App crashes with "No module named 'flask_app'"
- Check that `Procfile` path is correct
- Verify project structure matches the Procfile

### "Application error" when visiting app
```bash
heroku logs -a your-app-name --tail
```
- Check logs for specific error messages

### PayMongo integration not working
- Verify API keys are set correctly: `heroku config -a your-app-name`
- Check that keys are in production format (not test keys)

## Next Steps

1. **Add Domain Name**
   - Go to Heroku app settings → "Domains"
   - Add your custom domain
   - Follow DNS configuration instructions

2. **Enable SSL/HTTPS**
   - Automatic with `.herokuapp.com` domain
   - For custom domains: Upgrade to paid Heroku plan for automatic SSL

3. **Optimize Performance**
   - Monitor dyno resources
   - Scale dynos as needed: `heroku dyno:scale web=2`

4. **Set Up CI/CD**
   - Enable automatic deploys from GitHub
   - Add automated tests with GitHub Actions

## Helpful Commands

```bash
# View all environment variables
heroku config -a your-app-name

# Scale dynos (web processes)
heroku dyno:scale web=2 -a your-app-name

# Run one-off task
heroku run "python flask_app/init_db.py" -a your-app-name

# Restart app
heroku restart -a your-app-name

# View current dyno status
heroku ps -a your-app-name
```

## Support

For Heroku documentation: https://devcenter.heroku.com/
For Flask deployment: https://flask.palletsprojects.com/en/latest/deployment/

Good luck with your deployment! 🚀
