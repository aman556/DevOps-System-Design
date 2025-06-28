# Shell Scripting Basics

This guide introduces the fundamentals of shell scripting, common commands, and how shell scripts are used for automation in real-world industry scenarios.

---

## What is Shell Scripting?

**Shell scripting** is writing a series of commands for the shell (command line interpreter) to automate tasks. The most common shell is **Bash** (Bourne Again SHell), available in most Linux and Unix environments.

---

## Why Use Shell Scripts?

- **Automation:** Automate repetitive tasks (backups, deployments, monitoring).
- **Consistency:** Ensure tasks are done the same way every time.
- **Efficiency:** Save time on manual work.
- **Integration:** Connect different tools and systems.

---

## Basic Structure of a Shell Script

A shell script is a plain text file with a list of commands. It usually starts with a shebang (`#!`) to specify the interpreter.

**Example:**
```bash
#!/bin/bash
echo "Hello, World!"
```

---

## Making a Script Executable

1. Save the script (e.g., `myscript.sh`).
2. Make it executable:
   ```bash
   chmod +x myscript.sh
   ```
3. Run the script:
   ```bash
   ./myscript.sh
   ```

---

## Common Shell Scripting Concepts

### 1. Variables

```bash
name="Alice"
echo "Hello, $name"
```

### 2. Taking Input

```bash
read -p "Enter your name: " username
echo "Welcome, $username"
```

### 3. Conditionals (if/else)

```bash
if [ $age -ge 18 ]; then
  echo "Adult"
else
  echo "Minor"
fi
```

### 4. Loops

#### For Loop
```bash
for i in 1 2 3; do
  echo "Number $i"
done
```

#### While Loop
```bash
count=1
while [ $count -le 5 ]; do
  echo "Count is $count"
  ((count++))
done
```

### 5. Functions

```bash
greet() {
  echo "Hello, $1"
}
greet "Bob"
```

---

## Useful Shell Commands

- `ls` – List files and directories
- `cd` – Change directory
- `pwd` – Print working directory
- `cp` – Copy files
- `mv` – Move/rename files
- `rm` – Remove files
- `cat` – View file content
- `grep` – Search text
- `awk`, `sed` – Advanced text processing
- `chmod` – Change permissions

---

## Shell Script Example: Find Deployment Version in Main Branch

In real-world deployments, it's common to automatically find the version of the application to be deployed from the `main` branch—often from a `VERSION` file, a tag, or a value in `package.json` (for Node.js apps).

**Example Script:**
```bash
#!/bin/bash
# Find the version for deployment from the main branch

# Fetch the latest main branch
git fetch origin main

# Checkout main branch (optional if already on main)
git checkout main

# Get version from VERSION file
if [ -f VERSION ]; then
  version=$(cat VERSION)
  echo "Deploying version: $version"
else
  echo "VERSION file not found!"
  exit 1
fi
```

**Alternative: Find version from package.json (Node.js):**
```bash
#!/bin/bash
git fetch origin main
git checkout main

if [ -f package.json ]; then
  version=$(grep '"version":' package.json | head -1 | awk -F '"' '{print $4}')
  echo "Deploying version: $version"
else
  echo "package.json not found!"
  exit 1
fi
```

---

## Real Industry Automation with Shell Scripting

### How Shell Scripts Are Used in Automation:

- **System Administration:** Automate user creation, software installation, system updates, log rotation.
- **DevOps & CI/CD:** Automate code builds, testing, deployment pipelines (run via Jenkins, GitHub Actions, GitLab CI, etc.).
- **Monitoring & Alerts:** Check disk space, monitor services, and send notifications if issues are detected.
- **Data Processing:** Automate ETL (Extract, Transform, Load) tasks, parsing logs, or batch renaming files.
- **Cloud Operations:** Automate cloud resource management (launching EC2 instances, backups, scaling using AWS CLI, Azure CLI, etc.).

### Real-World Example: Automated Deployment Script with Version Detection

```bash
#!/bin/bash
# Automated deploy script with version detection

git fetch origin main
git checkout main

if [ -f VERSION ]; then
  version=$(cat VERSION)
elif [ -f package.json ]; then
  version=$(grep '"version":' package.json | head -1 | awk -F '"' '{print $4}')
else
  echo "No version information found!"
  exit 1
fi

echo "Deploying application version: $version"

# Example deployment steps follow...
# docker build -t myapp:$version .
# docker push myrepo/myapp:$version
# kubectl set image deployment/myapp myapp=myrepo/myapp:$version

echo "Deployment for version $version complete."
```

**Explanation:**  
This script fetches the main branch, finds the deployment version from a `VERSION` file or `package.json`, and uses that version for tagging and deploying the application—an industry-standard practice for reliable, traceable releases.

---

## Best Practices

- Always add comments to explain complex logic.
- Use `set -e` to stop the script if a command fails.
- Validate user input and check exit codes.
- Use logging for critical automation tasks.
- Keep scripts readable and modular (use functions).

---

## References

- [GNU Bash Manual](https://www.gnu.org/software/bash/manual/)
- [Shell Scripting Tutorial - GeeksforGeeks](https://www.geeksforgeeks.org/introduction-to-shell-scripting/)
- [Shell scripting at DigitalOcean](https://www.digitalocean.com/community/tutorial_series/how-to-write-shell-scripts)
- [LinuxCommand.org](https://linuxcommand.org/)

---
