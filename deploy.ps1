#Usage:
#.\deploy-only.ps1 -AppId <APP_ID>                        # defaults to site.zip
#.\deploy-only.ps1 -AppId <APP_ID> -ZipFile mybuild.zip   # override

param(
    [Parameter(Mandatory)][string]$AppId,
    [string]$ZipFile = "site.zip"
)

$Branch  = "main"
$Region  = "ap-southeast-1"
$Profile = "tg-dev"

# Step 1: Create deployment
Write-Host "1/3 Creating deployment..."
$Deployment = aws amplify create-deployment `
  --app-id $AppId `
  --branch-name $Branch `
  --region $Region `
  --profile $Profile `
  --no-cli-pager | ConvertFrom-Json

$JobId     = $Deployment.jobId
$UploadUrl = $Deployment.zipUploadUrl

# Step 2: Upload zip
Write-Host "2/3 Uploading $ZipFile..."
Invoke-RestMethod -Uri $UploadUrl -Method PUT -InFile (Resolve-Path $ZipFile) -ContentType "application/zip"
Write-Host "Upload complete."

# Step 3: Start deployment
Write-Host "3/3 Starting deployment..."
aws amplify start-deployment `
  --app-id $AppId `
  --branch-name $Branch `
  --job-id $JobId `
  --region $Region `
  --profile $Profile `
  --no-cli-pager

Write-Host ""
Write-Host "Done! https://$Branch.$AppId.amplifyapp.com"
