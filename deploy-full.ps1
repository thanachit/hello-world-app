$AppName = "hello-world-app"
$Branch = "main"
$Region = "ap-southeast-1"
$Profile = "tg-dev"
$Tags = "file://tags.json"

# Step 1: Create Amplify app
Write-Host "1/5 Creating Amplify app..."
$App = aws amplify create-app `
  --name $AppName `
  --tags $Tags `
  --region $Region `
  --profile $Profile `
  --no-cli-pager | ConvertFrom-Json

$AppId = $App.app.appId
Write-Host "App ID: $AppId"

# Step 2: Create branch
Write-Host "2/5 Creating branch..."
aws amplify create-branch `
  --app-id $AppId `
  --branch-name $Branch `
  --tags $Tags `
  --region $Region `
  --profile $Profile `
  --no-cli-pager

# Step 3: Create deployment
Write-Host "3/5 Creating deployment..."
$Deployment = aws amplify create-deployment `
  --app-id $AppId `
  --branch-name $Branch `
  --region $Region `
  --profile $Profile `
  --no-cli-pager | ConvertFrom-Json

$JobId = $Deployment.jobId
$UploadUrl = $Deployment.zipUploadUrl

# Step 4: Upload zip
Write-Host "4/5 Uploading site.zip..."
Invoke-RestMethod -Uri $UploadUrl -Method PUT -InFile (Resolve-Path "site.zip") -ContentType "application/zip"
Write-Host "Upload complete."

# Step 5: Start deployment
Write-Host "5/5 Starting deployment..."
aws amplify start-deployment `
  --app-id $AppId `
  --branch-name $Branch `
  --job-id $JobId `
  --region $Region `
  --profile $Profile `
  --no-cli-pager

Write-Host ""
Write-Host "Done! https://$Branch.$AppId.amplifyapp.com"
