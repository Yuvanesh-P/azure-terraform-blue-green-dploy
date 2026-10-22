import os
import socket
import time
from datetime import datetime, timezone
from pathlib import Path

from fastapi import FastAPI
from fastapi.responses import FileResponse

APP_COLOR = os.getenv("APP_COLOR", "blue").lower()
APP_VERSION = os.getenv("APP_VERSION", "v1.0.0")
STARTED_AT = time.time()
HOSTNAME = socket.gethostname()
STATIC_DIR = Path(__file__).parent / "static"

app = FastAPI(
    title="PulseOps API",
    version=APP_VERSION,
    description="Blue-Green deployment reliability demo",
)

@app.get("/", include_in_schema=False)
def dashboard():
    return FileResponse(STATIC_DIR / "index.html")

@app.get("/health")
def health():
    return {"status": "healthy", "color": APP_COLOR, "version": APP_VERSION}

@app.get("/ready")
def ready():
    return {"ready": True, "checked_at": datetime.now(timezone.utc).isoformat()}

@app.get("/api/status")
def status():
    return {
        "service": "pulseops-api",
        "status": "healthy",
        "color": APP_COLOR,
        "version": APP_VERSION,
        "hostname": HOSTNAME,
        "uptime_seconds": int(time.time() - STARTED_AT),
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }

@app.get("/api/metrics")
def metrics():
    # These are illustrative demo metrics, not Azure Monitor telemetry.
    uptime = int(time.time() - STARTED_AT)
    return {
        "requests_total": 1284 + uptime,
        "error_rate_percent": 0.2,
        "p95_latency_ms": 84,
        "uptime_percent": 99.95,
        "sampled_at": datetime.now(timezone.utc).isoformat(),
        "source": "demo",
    }

@app.get("/api/incidents")
def incidents():
    return [
        {"id": "INC-1042", "title": "Green release health verification", "severity": "medium", "status": "monitoring", "time": "Just now"},
        {"id": "INC-1038", "title": "API latency spike resolved", "severity": "low", "status": "resolved", "time": "18 min ago"},
        {"id": "INC-1029", "title": "Deployment probe timeout", "severity": "high", "status": "resolved", "time": "Yesterday"},
    ]

@app.get("/api/version")
def version():
    return {"color": APP_COLOR, "version": APP_VERSION}
