#!/bin/bash

# Exit on any error
set -e

echo "==============================="
echo "🔧 Backend Setup - Snake Game"
echo "==============================="

# 1. Update system
echo "🔄 Updating packages..."
sudo apt update -y

# 2. Install Apache2
echo "🌐 Installing Apache2..."
sudo apt install apache2 -y

# 3. Install PHP and MySQL PHP extension
echo "⚙️ Installing PHP and required modules..."
sudo apt install php libapache2-mod-php php-mysql -y

# 4. Install MySQL client (for RDS or local DB access)
echo "🛢️ Installing MySQL Client..."
sudo apt install mysql-client-8.0 -y

# 5. Enable and start Apache2
echo "🚀 Enabling and starting Apache2..."
sudo systemctl enable apache2
sudo systemctl start apache2

echo "✅ Backend environment ready!"
echo "➡️ Apache2 + PHP installed"
echo "➡️ mysql-client-8.0 installed (use: mysql -h <host> -u <user> -p)"

