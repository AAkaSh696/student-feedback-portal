# Student Feedback Portal – End-to-End CI/CD Pipeline

An end-to-end DevOps project that automates the build, testing, packaging, deployment, health verification, and rollback of a Java web application using Git, Maven, Jenkins, and Apache Tomcat.

## Project Overview

The Student Feedback Portal is a Java-based web application that allows students to submit feedback through a web form.

The main objective of this project is to implement an automated CI/CD pipeline that reduces manual deployment work and makes application delivery more reliable.

Whenever code is pushed to the `dev` branch of GitHub, Jenkins automatically retrieves the source code, builds the application, executes unit tests, generates a WAR file, archives the build artifact, and deploys the application to Apache Tomcat.

The pipeline also includes automated health checks and rollback functionality to recover the previous deployment if a new deployment fails.

## Technologies Used

| Technology | Purpose |
|---|---|
| Java | Application development |
| JSP and Servlets | Web application functionality |
| Maven | Build and dependency management |
| JUnit | Unit testing |
| Git | Version control |
| GitHub | Source code repository |
| Jenkins | CI/CD automation |
| Apache Tomcat 9 | Application server |
| Windows PowerShell | Deployment and rollback automation |

## Application Features

- Student feedback submission form.
- Input validation for name, email, and message.
- Feedback submission confirmation page.
- HTML output escaping to handle user-provided input safely.
- Health-check endpoint for application monitoring.
- In-memory feedback storage.

**Note:** Feedback is stored in memory and is not persisted in a database. Submitted feedback is lost when the application restarts.

## CI/CD Pipeline Architecture

```text
             Developer
                 |
                 v
           Git Repository
              GitHub
                 |
             dev branch
                 |
                 v
              Jenkins
                 |
                 v
          Source Checkout
                 |
                 v
           Maven Build
                 |
                 v
           JUnit Testing
                 |
                 v
          Generate WAR
                 |
                 v
        Archive Artifact
                 |
                 v
        Backup Previous WAR
                 |
                 v
        Deploy to Tomcat
                 |
                 v
          Health Check
                 |
           +-----+-----+
           |           |
         Success      Failure
           |           |
           v           v
       Deployment   Automatic
       Successful   Rollback
                       |
                       v
                 Verify Previous
                   Deployment
```

## Jenkins Pipeline Stages

The Jenkins pipeline is implemented using a Declarative Pipeline in the `Jenkinsfile`.

### 1. Checkout

Jenkins retrieves the application source code from the GitHub repository's `dev` branch.

### 2. Build

Maven compiles the Java source code and checks for compilation errors.

```bash
mvn clean compile
```

### 3. Test

JUnit executes unit tests for the feedback validation functionality.

```bash
mvn test
```

If the tests fail, the pipeline stops and deployment does not proceed.

### 4. Package

Maven packages the application into a deployable WAR file.

```bash
mvn package -DskipTests
```

Generated artifact:

```text
target/student-feedback-portal.war
```

### 5. Archive

Jenkins archives the generated WAR file and records its fingerprint so that the build artifact can be accessed from Jenkins.

### 6. Backup

Before deployment, the PowerShell deployment script checks for an existing WAR file and saves a backup.

Backup location:

```text
D:\TomcatDeployBackups\student-feedback-portal.war
```

### 7. Deploy

Jenkins executes the PowerShell deployment script, which copies the new WAR file into the Tomcat `webapps` directory.

### 8. Health Check

After deployment, the script checks the application health endpoint.

```text
http://localhost:8081/student-feedback-portal/health
```

The script retries the health check up to 12 times.

Expected response:

```json
{
  "status": "UP",
  "application": "Student Feedback Portal"
}
```

### 9. Automatic Rollback

If the newly deployed application fails the health check, the script restores the previous WAR file from the backup directory.

It then checks whether the restored application is healthy.

If rollback succeeds, the previous application is restored, but Jenkins marks the build as failed to indicate that the new deployment was unsuccessful.

## Project Structure

```text
student-feedback-portal/
│
├── Jenkinsfile
├── pom.xml
├── README.md
├── .gitignore
│
├── scripts/
│   └── deploy-and-verify.ps1
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/internship/
│   │   │       ├── FeedbackServlet.java
│   │   │       ├── FeedbackValidator.java
│   │   │       └── HealthServlet.java
│   │   │
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml
│   │       └── index.jsp
│   │
│   └── test/
│       └── java/
│           └── com/internship/
│               └── FeedbackValidatorTest.java
│
└── target/
    └── student-feedback-portal.war
```

## Running the Application Locally

### Prerequisites

Install the following:

- JDK 17 or later
- Apache Maven
- Apache Tomcat 9
- Git

### Step 1: Clone the Repository

```bash
git clone https://github.com/AAkaSh696/student-feedback-portal.git
```

Navigate to the project directory:

```bash
cd student-feedback-portal
```

### Step 2: Build and Test

```bash
mvn clean test
```

### Step 3: Generate WAR File

```bash
mvn package -DskipTests
```

The WAR file will be generated inside the `target` directory.

### Step 4: Deploy to Tomcat

Copy the WAR file into the Tomcat `webapps` directory.

```powershell
Copy-Item "target\student-feedback-portal.war" "D:\apache-tomcat-9.0.122\webapps\"
```

Start Tomcat using:

```powershell
D:\apache-tomcat-9.0.122\bin\startup.bat
```

### Step 5: Access the Application

Open the following URL in your browser:

```text
http://localhost:8081/student-feedback-portal/
```

Health endpoint:

```text
http://localhost:8081/student-feedback-portal/health
```

## Git Branching Strategy

The project uses the following branching strategy:

| Branch | Purpose |
|---|---|
| `main` | Stable project version |
| `dev` | Integration and CI/CD development |
| `feature/*` | Individual feature development |

Changes are developed and integrated through the `dev` branch before being considered for the stable `main` branch.

Commit messages follow conventions such as:

```text
feat: add feedback validation
fix: correct servlet configuration
ci: add Jenkins pipeline
test: add feedback validator unit tests
```

## Failure Handling and Rollback Demonstration

The pipeline was tested with an intentionally unsuccessful health-check condition.

The test demonstrated that:

1. Jenkins deployed the new WAR.
2. The health-check verification failed.
3. The deployment script detected the failure.
4. The previous WAR was restored from the backup.
5. The rollback health check verified the previous application.
6. Jenkins marked the deployment build as failed.

After the test, the original health-check condition was restored and a successful deployment was verified.

This demonstrates how automated rollback can help reduce application downtime during failed deployments.

## Verification

The application was verified using the following health-check command:

```powershell
Invoke-WebRequest -UseBasicParsing "http://localhost:8081/student-feedback-portal/health"
```

Expected HTTP status:

```text
200 OK
```

Expected response:

```json
{
  "status": "UP",
  "application": "Student Feedback Portal"
}
```

## Key DevOps Concepts Demonstrated

- Version control using Git and GitHub.
- Git branching and commit management.
- Continuous Integration using Jenkins.
- Automated build using Maven.
- Unit testing using JUnit.
- WAR artifact generation and archiving.
- Continuous Deployment to Apache Tomcat.
- PowerShell-based deployment automation.
- Automated application health checks.
- Backup and rollback strategy.
- Failure handling in a CI/CD pipeline.

## Future Improvements

- Deploy the application on AWS EC2.
- Configure HTTPS using a domain and SSL certificate.
- Introduce persistent database storage.
- Configure Jenkins credentials for secure deployments.
- Add application version information to health checks.
- Implement automated deployment to a dedicated Linux server.

## Repository

GitHub: https://github.com/AAkaSh696/student-feedback-portal

---

**Project:** Student Feedback Portal – End-to-End CI/CD Pipeline  
**Build Tool:** Maven  
**CI/CD Tool:** Jenkins  
**Application Server:** Apache Tomcat  
**Version Control:** Git and GitHub
