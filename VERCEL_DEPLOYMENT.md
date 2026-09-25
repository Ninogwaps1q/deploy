# Deploying to Vercel

This repository is configured to run the Flask app as a Vercel Python Function.

1. Import the repository into Vercel and keep the project root set to the repository root.
2. Add the environment variables below in **Project Settings → Environment Variables**.
3. Deploy. The Flask application entry point is `api/index.py`.

## Required environment variables

- `SECRET_KEY`: a long, random value used to sign sessions and password reset tokens.
- `DATABASE_URL`: a hosted PostgreSQL connection URL. Vercel function filesystems are ephemeral, so the local SQLite default is only suitable for a temporary preview and must not hold production data.

The app accepts PostgreSQL URLs beginning with either `postgres://` or `postgresql://`.

## Optional integrations

Set these when the matching features are used:

- `PAYMONGO_SECRET_KEY` and `PAYMONGO_PUBLIC_KEY`
- `MAIL_SERVER`, `MAIL_PORT`, `MAIL_USERNAME`, `MAIL_PASSWORD`, `MAIL_DEFAULT_SENDER`
- `GOOGLE_API_KEY`

Uploads written by the app also need persistent object storage on Vercel. The function filesystem is temporary; uploaded files can disappear between invocations. Configure an external storage service before relying on user-uploaded images in production.

The existing `init_db()` helper initializes tables and sample records, but Vercel does not run it as a deployment migration. Initialize the hosted database separately before using the site. The import-time schema bootstrap creates missing tables.
