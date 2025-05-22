
#!/bin/bash

# Exit on any error
set -e

echo "==============================="
echo "⚙️  Frontend Setup - Snake Game"
echo "==============================="

# 1. Update system
echo "🔄 Updating packages..."
sudo apt update -y

# 2. Install NGINX
echo "🌐 Installing NGINX..."
sudo apt install nginx -y

# 3. Enable and start NGINX
echo "🚀 Enabling and starting NGINX..."
sudo systemctl enable nginx
sudo systemctl start nginx

echo "✅ NGINX is up and running. You can now manually copy your frontend files."
