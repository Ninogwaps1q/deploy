# Deploying to Vercel

This repository is configured to run the Flask app as a Vercel Python Function.

1. Import the repository into Vercel and keep the project root set to the repository root.
2. Add the environment variables below in **Project Settings → Environment Variables**.
3. Deploy. The Flask application entry point is the repository-root `app.py`.

## Required environment variables

- `SECRET_KEY`: a long, random value used to sign sessions and password reset tokens.
- `DATABASE_URL`: a hosted PostgreSQL connection URL. Vercel function filesystems are ephemeral, so the local SQLite default is only suitable for a temporary preview and must not hold production data.
- `ADMIN_EMAIL` and `ADMIN_PASSWORD`: credentials for the administrator account.
- `BUS_OPERATOR_EMAIL` and `BUS_OPERATOR_PASSWORD`: credentials for the bus operator account.
- `CINEMA_OPERATOR_EMAIL` and `CINEMA_OPERATOR_PASSWORD`: credentials for the cinema operator account.

Set each email/password pair before deploying. On startup, the app creates the configured accounts in `DATABASE_URL` if they do not already exist and grants the matching role. Optional `ADMIN_NAME`, `BUS_OPERATOR_NAME`, and `CINEMA_OPERATOR_NAME` variables set their display names. Use separate emails and strong passwords for each account.

The app accepts PostgreSQL URLs beginning with either `postgres://` or `postgresql://`.

## Optional integrations

Set these when the matching features are used:

- `PAYMONGO_SECRET_KEY` and `PAYMONGO_PUBLIC_KEY`
- `MAIL_SERVER`, `MAIL_PORT`, `MAIL_USERNAME`, `MAIL_PASSWORD`, `MAIL_DEFAULT_SENDER`
- `GOOGLE_API_KEY`

Uploads written by the app also need persistent object storage on Vercel. The function filesystem is temporary; uploaded files can disappear between invocations. Configure an external storage service before relying on user-uploaded images in production.

The import-time schema bootstrap creates missing tables and the configured role accounts. SQLite and uploads use temporary storage on Vercel, so a hosted database and external object storage are required for persistent production data and images. Admins must assign bus routes and cinemas to the respective operator accounts in the admin panel before those dashboards show assigned data.
