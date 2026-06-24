web: gunicorn --workers 4 --worker-class sync --bind 0.0.0.0:$PORT flask_app.app:app
worker: python flask_app/run.py
