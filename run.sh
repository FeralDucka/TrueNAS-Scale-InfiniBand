#!/bin/bash


REPO="https://raw.githubusercontent.com/FeralDucka/truenas-scale-infiniband/main/"
version=$(cat /etc/version | sed 's/#//')

# -----------------------------------------------------------------------------#

# Enable APT and DPKG
$(echo "mount -o remount,rw boot-pool/ROOT/$version/usr")
export PATH=/usr/bin:/usr/sbin
chmod +x /bin/apt*
chmod +x /usr/bin/dpkg

# -----------------------------------------------------------------------------#

# Install necessary software
apt update
apt install -y mstflint opensm infiniband-diags

# -----------------------------------------------------------------------------#

# Add necessary modules to the system
wget -qO- $REPO/infiniband.conf >> /etc/modules

# -----------------------------------------------------------------------------#

# Enable and load all modules without rebooting the machine
MODULE_FILE="/etc/modules"
if [[ ! -f "$MODULE_FILE" ]]; then
    echo "Module file $MODULE_FILE not found!"
    exit 1
fi
while IFS= read -r module; do
    if [[ -z "$module" || "$module" =~ ^# ]]; then
        continue
    fi
    echo "Loading module: $module"
    modprobe "$module"
    if lsmod | grep -q "^$module"; then
        echo "$module loaded successfully"
    else
        echo "Failed to load $module"
    fi
done < "$MODULE_FILE"
echo "All modules processed."

# -----------------------------------------------------------------------------#

# Start OpenSM on the interfaces (OpenSM will open automatically once rebooted)
opensm &
OPENSM_PID=$!
sleep 10
kill -SIGTERM $OPENSM_PID
