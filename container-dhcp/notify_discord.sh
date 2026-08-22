#!/bin/sh

# DHCP から渡される引数
IP_ADDR=$1
MAC_ADDR=$2
HOST_NAME=$3

# Discord の Webhook URL に差し替えてください
WEBHOOK_URL="${DISCORD_WEBHOOK_URL}"

# 送信用 JSON ペイロード
PAYLOAD=$(cat <<EOF
{
  "embeds": [{
    "title": "🔔 DHCP IP割り当て通知",
    "color": 3447003,
    "fields": [
      { "name": "IP Address", "value": "${IP_ADDR}", "inline": true },
      { "name": "MAC Address", "value": "${MAC_ADDR}", "inline": true },
      { "name": "Hostname", "value": "${HOST_NAME:-N/A}", "inline": true }
    ]
  }]
}
EOF
)

# curl で送信
curl -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "$WEBHOOK_URL"
