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

2. **Save the Script**

   Save the script to `/etc/profile.d/` to ensure it runs for each SSH login.

   ```bash
   sudo nano /etc/profile.d/telegram_monitor.sh
   ```

3. **Add the Script Content**

   Paste the following script into the file:

   ```bash
   #!/bin/bash
   #
   # Telegram Monitor Agent
   #
   # @Author       @Bimosaurus - bimosaurus@gmail.com
   # @ModifiedBy   @DyanGalih - dyan.galih@gmail.com
   # @version      0.0.2
   # @date         2018-12-11
   #
   # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   # FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
   # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   # THE SOFTWARE.

   # Chat Id
   CHAT_ID=[CHAT_ID]

   # Telegram token
   TOKEN=[TELEGRAM_BOT_TOKEN]

   # Default Timeout
   TIMEOUT="10"

   # Set Timezone
   TZ=[TZ]

   # Endpoint Telegram API
   URL="https://api.telegram.org/bot$TOKEN/sendMessage"

   CONVERT_TIMEZONE=$(TZ="$TZ" date)

   if [ -n "$SSH_CLIENT" ]; then
     IP=$(echo "$SSH_CLIENT" | awk '{print $1}')
     PORT=$(echo "$SSH_CLIENT" | awk '{print $3}')
     HOSTNAME=$(hostname -f)
     IPADDR=$(hostname -I | awk '{print $2}')

     # Check and adjust IPADDR if it displays incorrectly
     # Replace '{print $2}' with the correct index if necessary, e.g., '{print $1}', '{print $3}'
     IPADDR=$(hostname -I | awk '{print $1}')  # Adjust if needed

     # Fetch IP information and store in a variable
     IPINFO=$(curl -s "http://ipinfo.io/$IP")

     # Extract values from the JSON response
     CITY=$(echo "$IPINFO" | jq -r '.city')
     REGION=$(echo "$IPINFO" | jq -r '.region')
     COUNTRY=$(echo "$IPINFO" | jq -r '.country')
     ORG=$(echo "$IPINFO" | jq -r '.org')

     TEXT="Login Date: $CONVERT_TIMEZONE %0AUser: ${USER} %0AHostname: $HOSTNAME %0AServer IP: $IPADDR %0AClient IP: $IP %0AOrganization:  $ORG %0ACity: $CITY, $REGION, $COUNTRY %0APort: $PORT"

     curl -s --max-time $TIMEOUT -d "chat_id=$CHAT_ID&disable_web_page_preview=1&text=$TEXT" "$URL" > /dev/null
   fi
   ```

   Replace `[CHAT_ID]`, `[TELEGRAM_BOT_TOKEN]`, and `[TZ]` with your actual values.

4. **Save and Exit**

   Save the file and exit the editor (for `nano`, press `CTRL+X`, then `Y`, and `Enter`).

5. **No Need to Set the Script as Executable**

   The script will be sourced automatically for each user login because files in `/etc/profile.d/` are sourced by login shells. There’s no need to make the script executable explicitly.

## Troubleshooting

- **Incorrect IP Address**: If `IPADDR` displays the wrong IP address, verify the correct index for `hostname -I`. The default script uses `{print $2}`, but this may need adjustment based on your system’s output. Check the output of `hostname -I` and modify `{print $2}` to the appropriate index (e.g., `{print $1}`, `{print $3}`).

## Usage

The script will run automatically for each SSH login session. It sends a notification to the specified Telegram chat with details about the SSH login.

## License

The software is provided "as is", without warranty of any kind. See the [LICENSE](LICENSE) file for details.

## Author

- **@Bimosaurus** - bimosaurus@gmail.com
- **@DyanGalih** - dyan.galih@gmail.com

## Version

- **0.0.2** (2018-12-11)

---

Feel free to make further adjustments as needed!