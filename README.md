# hello-world-app

## Step 1 — Configure AWS Credentials (SSO) - can be skipped if already complete this step. 

Run the SSO configuration:
```
aws configure sso
```

Follow the prompts as shown below:
```
SSO session name (Recommended): user1-playground
SSO start URL [None]: <starturl>
SSO region [None]: ap-southeast-1
SSO registration scopes [sso:account:access]:
```

A browser window will open for you to authorize. After approval, continue:
```
The only AWS account available to you is: 
Using the account ID 
The only role available to you is: DeveloperAccess
Using the role name "DeveloperAccess"
Default client Region [ap-southeast-1]:
CLI default output format (json if not specified) [None]:
Profile name [DeveloperAccess-<accountid>]: tg-dev 
```

> **Tip:** Name the profile `default` so you don't need `--profile` on every command. Otherwise, use a custom name `dev` and pass `--profile dev` to all commands.

Verify your configuration:
```
aws sts get-caller-identity
```

**Login before each session:**
```
aws sso login
# or with named profile
aws sso login --profile tg-dev
```

---

## Step 2 — Clone frontend template from Github

```
git clone https://github.com/thanachit/hello-world-app hello-world-app
cd hello-world-app
```

## Step 3 — Create Amplify App using SAM IaC

```
sam build 
sam deploy --guided
```

## Step 4 — Deploy application to Amplify branch. 

```
.\deploy.ps1 -AppID d19nymd88ls66x -ZipFile site.zip
```


