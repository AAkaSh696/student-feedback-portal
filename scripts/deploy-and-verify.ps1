
$ErrorActionPreference = "Stop"

# Application configuration
$warSource = Join-Path $env:WORKSPACE "target\student-feedback-portal.war"
$tomcatWebapps = "D:\apache-tomcat-9.0.122\webapps"
$targetWar = Join-Path $tomcatWebapps "student-feedback-portal.war"

# Keep backup outside Tomcat's webapps directory
$backupDirectory = "D:\TomcatDeployBackups"
$backupWar = Join-Path $backupDirectory "student-feedback-portal.war"

$healthUrl = "http://localhost:8081/student-feedback-portal/health"

# Verify the new WAR exists
if (!(Test-Path $warSource)) {
    throw "New WAR file not found: $warSource"
}

# Verify Tomcat webapps directory exists
if (!(Test-Path $tomcatWebapps)) {
    throw "Tomcat webapps directory not found: $tomcatWebapps"
}

New-Item -ItemType Directory -Path $backupDirectory -Force | Out-Null

# Check whether an existing deployment is available
$hadPreviousDeployment = Test-Path $targetWar

if ($hadPreviousDeployment) {
    Write-Host "Backing up previous deployment..."

    Copy-Item $targetWar $backupWar -Force

    Write-Host "Previous WAR backed up successfully."
}
else {
    Write-Host "No previous WAR found. This is the first deployment."
}

try {
    # Deploy new WAR
    Write-Host "Copying new WAR to Tomcat..."

    Copy-Item $warSource $targetWar -Force

    Write-Host "New WAR copied successfully."

    # Allow Tomcat time to detect and deploy the WAR
    Write-Host "Waiting for Tomcat deployment..."
    Start-Sleep -Seconds 10

    # Health check with retries
    $healthy = $false

    for ($attempt = 1; $attempt -le 12; $attempt++) {

        Write-Host "Health check attempt $attempt of 12..."

        try {
            $response = Invoke-WebRequest `
                -Uri $healthUrl `
                -UseBasicParsing `
                -TimeoutSec 5

            if (
                $response.StatusCode -eq 200 -and
                $response.Content -match '"status"\s*:\s*"DOWN"'
            ) {
                $healthy = $true
                Write-Host "Health check successful!"
                Write-Host $response.Content
                break
            }
        }
        catch {
            Write-Host "Application is not healthy yet."
        }

        Start-Sleep -Seconds 5
    }

    if (!$healthy) {
        throw "New deployment failed health verification."
    }

    Write-Host "Deployment completed successfully."
}
catch {
    Write-Host "Deployment failed: $_" -ForegroundColor Red

    if ($hadPreviousDeployment) {

        Write-Host "Starting automatic rollback..."

        Copy-Item $backupWar $targetWar -Force

        Write-Host "Previous WAR restored."
        Write-Host "Waiting for Tomcat to redeploy previous version..."

        Start-Sleep -Seconds 10

        $rollbackHealthy = $false

        for ($attempt = 1; $attempt -le 12; $attempt++) {

            Write-Host "Rollback health check $attempt of 12..."

            try {
                $response = Invoke-WebRequest `
                    -Uri $healthUrl `
                    -UseBasicParsing `
                    -TimeoutSec 5

                if (
                    $response.StatusCode -eq 200 -and
                    $response.Content -match '"status"\s*:\s*"UP"'
                ) {
                    $rollbackHealthy = $true
                    Write-Host "Previous deployment is healthy."
                    break
                }
            }
            catch {
                Write-Host "Waiting for previous deployment..."
            }

            Start-Sleep -Seconds 5
        }

        if (!$rollbackHealthy) {
            Write-Host "WARNING: Rollback health check also failed." -ForegroundColor Red
        }
        else {
            Write-Host "Rollback completed successfully."
        }
    }
    else {
        Write-Host "No previous deployment available for rollback."
    }

    throw "Deployment stage failed. See deployment and rollback logs."
}

