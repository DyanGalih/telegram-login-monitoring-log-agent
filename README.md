Here’s the updated `README.md` with notes about storing the script in a GitHub repository:

---

# Telegram Login Monitoring Log Agent

## Overview

The **Telegram Login Monitoring Log Agent** is a Bash script designed to send a notification to a specified Telegram chat when a user logs in via SSH. The notification includes details such as login time, user information, and client IP address.

## Features

- Sends login notifications to a Telegram chat.
- Includes detailed information such as the client IP address, server IP address, hostname, organization, city, region, and country.
- Customizable time zone for the timestamp.

## Requirements

- `curl`: For making HTTP requests.
- `jq`: For parsing JSON data.
- A Telegram bot token and chat ID.

## Installation

1. **Install Required Packages**

   Ensure `curl` and `jq` are installed on your system. You can install them using the following commands:

   ```bash
   sudo apt-get update
   sudo apt-get install curl jq
   ```

   For other distributions, use the appropriate package manager.

2. **Clone the Repository**

   Clone the repository to your local system:

   ```bash
   git clone git@github.com:DyanGalih/telegram-login-monitoring-log-agent.git.git
   ```

   Replace `git@github.com:DyanGalih/telegram-login-monitoring-log-agent.git.git` with the actual URL of your GitHub repository.

3. **Copy the Script**

   Navigate to the repository directory and copy the script to `/etc/profile.d/`:

   ```bash
   cd telegram-login-monitoring-log-agent
   sudo cp login.sh /etc/profile.d/
   ```

4. **No Need to Set the Script as Executable**

   The script will be sourced automatically for each user login because files in `/etc/profile.d/` are sourced by login shells. There’s no need to make the script executable explicitly.

## Configuration

Edit the `login.sh` script to configure the following variables:

- **`CHAT_ID`**: Your Telegram chat ID where notifications will be sent.
- **`TOKEN`**: The token for your Telegram bot.
- **`TZ`**: The time zone for the timestamp (e.g., `America/New_York`).

Example configuration within `login.sh`:

```bash
CHAT_ID="123456789"
TOKEN="your-telegram-bot-token"
TZ="America/New_York"
```

## Troubleshooting

- **Incorrect IP Address**: If `IPADDR` displays the wrong IP address, verify the correct index for `hostname -I`. The script uses `{print $2}`, but this may need adjustment based on your system’s output. Check the output of `hostname -I` and modify `{print $2}` to the appropriate index (e.g., `{print $1}`, `{print $3}`).

## Usage

The script will run automatically for each SSH login session. It sends a notification to the specified Telegram chat with details about the SSH login.

## License

The software is provided "as is", without warranty of any kind. See the [LICENSE](LICENSE) file for details.

## Author

- **@Bimosaurus** - bimosaurus@gmail.com
- **@DyanGalih** - dyan.galih@gmail.com

## Version

- **0.0.2** (2018-12-11)

## Repository

- GitHub Repository: [git@github.com:DyanGalih/telegram-login-monitoring-log-agent.git](git@github.com:DyanGalih/telegram-login-monitoring-log-agent.git)
