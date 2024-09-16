#!/bin/bash
#
# Telegram Login Monitor Log Agent
#
# @Author       @Bimosaurus - bimosaurus@gmail.com
# @ModifiedBy   @DyanGalih - dyan.galih@gmail.com
# @version		  0.0.2
# @date			    2018-12-11
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

#endpoint telegram api
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

CONVERT_TIMEZONE=$(TZ="$TZ" date)

if [ -n "$SSH_CLIENT" ]; then
  IP=$(echo "$SSH_CLIENT" | awk '{print $1}')
  PORT=$(echo "$SSH_CLIENT" | awk '{print $3}')
  HOSTNAME=$(hostname -f)
  IPADDR=$(hostname -I | awk '{print $2}')

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
