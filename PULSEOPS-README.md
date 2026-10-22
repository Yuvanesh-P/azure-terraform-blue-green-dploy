# PulseOps Fast-Track

## Local test (PowerShell)
From the project root:
```powershell
cd app
py -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
$env:APP_COLOR="blue"
$env:APP_VERSION="v1.0.0"
uvicorn main:app --reload --port 8000
```
Open http://127.0.0.1:8000 and API docs at http://127.0.0.1:8000/docs.

## Terraform integration before the first apply
Inspect `terraform/virtual-machines.tf`. The Blue VM custom_data should reference:
`filebase64("${path.module}/../app/blue/cloud-init.yaml")`
and Green should reference:
`filebase64("${path.module}/../app/green/cloud-init.yaml")`.
If the existing code uses `base64encode(file(...))`, that is also acceptable. Do not change Terraform blindly; review the exact expressions and run `terraform -chdir=terraform plan` afterwards. Updating custom_data after VM creation can force replacement.

## GitHub Actions
Ensure repository variables exist: AZURE_CLIENT_ID, AZURE_TENANT_ID, AZURE_SUBSCRIPTION_ID.
Verify the actual FQDN using:
`terraform -chdir=terraform output -raw load_balancer_fqdn`
If it differs from `deploy-bg-lab.southindia.cloudapp.azure.com`, update PUBLIC_HOST in `.github/workflows/pulseops-release.yml`.
Run Actions -> PulseOps Blue-Green Release -> Run workflow.

Metrics for latency, uptime, requests, and error rate are labelled illustrative demo metrics, not Azure Monitor telemetry. The workflow checks the candidate VM via Azure Run Command, switches the Load Balancer pool, then verifies the public endpoint and attempts rollback on post-switch verification failure.

This is a learning lab. Azure CLI traffic switching can cause Terraform configuration/state drift if `active_color` in Terraform still says blue. After workflow tests, reconcile the Terraform config/state before another apply. Use HTTPS and narrower Azure permissions for production.
