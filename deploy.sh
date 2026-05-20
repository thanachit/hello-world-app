#!/bin/bash
set -e
# Usage:
#   ./deploy.sh <APP_ID>                # defaults to site.zip
#   ./deploy.sh <APP_ID> mybuild.zip    # override

if [ -z "$1" ]; then
  echo "Usage: ./deploy.sh <APP_ID> [ZIP_FILE] [PROFILE]"
  echo ""
  echo "Examples:"
  echo "  ./deploy.sh d2yu5xoiv8r40k                       # uses env creds, site.zip"
  echo "  ./deploy.sh d2yu5xoiv8r40k mybuild.zip            # custom zip file"
  echo "  ./deploy.sh d2yu5xoiv8r40k site.zip tg-dev        # named profile"
  exit 1
fi
APP_ID="$1"
ZIP_FILE="${2:-site.zip}"

BRANCH="main"
REGION="ap-southeast-1"
PROFILE="${3:-}"

# Build profile flag only if set
PROFILE_FLAG=""
[ -n "$PROFILE" ] && PROFILE_FLAG="--profile $PROFILE"

# Step 1: Create deployment
echo "1/3 Creating deployment..."
DEPLOYMENT=$(aws amplify create-deployment \
  --app-id "$APP_ID" \
  --branch-name "$BRANCH" \
  --region "$REGION" \
  $PROFILE_FLAG \
  --no-cli-pager --output json)

JOB_ID=$(echo "$DEPLOYMENT" | jq -r '.jobId')
UPLOAD_URL=$(echo "$DEPLOYMENT" | jq -r '.zipUploadUrl')

# Step 2: Upload zip
echo "2/3 Uploading $ZIP_FILE..."
curl -s -X PUT -H "Content-Type: application/zip" -T "$ZIP_FILE" "$UPLOAD_URL"
echo "Upload complete."

# Step 3: Start deployment
echo "3/3 Starting deployment..."
aws amplify start-deployment \
  --app-id "$APP_ID" \
  --branch-name "$BRANCH" \
  --job-id "$JOB_ID" \
  --region "$REGION" \
  $PROFILE_FLAG \
  --no-cli-pager

echo ""
echo "Done! https://$BRANCH.$APP_ID.amplifyapp.com"
