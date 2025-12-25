#!/bin/bash

echo "--- Starting Idempotent Server Setup Script ---"

# --- 1. Install Node.js (LTS version) and npm ---
echo "Checking for Node.js installation..."
if ! command -v node &> /dev/null
then
    echo "Node.js not found. Installing Node.js and npm..."
    # Download and execute the NodeSource setup script for the LTS version
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    # Install Node.js
    sudo apt update
    sudo apt install -y nodejs
    echo "Node.js and npm installation complete."
else
    echo "Node.js is already installed. Skipping."
fi

# --- 2. PM2 Installation (Process Manager) ---
echo "Checking for PM2 installation..."
if ! command -v pm2 &> /dev/null
then
    echo "PM2 not found. Installing PM2 globally..."
    # Install PM2 globally using npm
    # We assume npm is installed if Node.js check passed
    sudo npm install -g pm2
    
    # Enable PM2 Auto-start on Reboot (Safe to run multiple times, but we keep it here)
    echo "Configuring PM2 startup script..."
    pm2 startup
    echo "PM2 installation and startup configuration complete."
else
    echo "PM2 is already installed. Skipping PM2 installation."
fi

# --- 3. Install Nginx (Web Server) ---
echo "Checking for Nginx installation..."
if ! command -v nginx &> /dev/null
then
    echo "Nginx not found. Installing Nginx..."
    # Install Nginx
    sudo apt install -y nginx
    echo "Nginx installation complete."
else
    echo "Nginx is already installed. Skipping."
fi


# --- 4. Setting Up Firewall (UFW) ---
echo "Configuring Uncomplicated Firewall (UFW)..."

# Note: UFW rules can generally be run multiple times without issues, 
# as duplicate rules are ignored, but we wrap the enable to prevent 
# unnecessary output/prompts.

# Allow necessary ports
echo "Allowing SSH, HTTP (80), and HTTPS (443) ports..."
sudo ufw allow OpenSSH > /dev/null 2>&1
sudo ufw allow 443 > /dev/null 2>&1
sudo ufw allow 80 > /dev/null 2>&1

# Enable the firewall only if it's currently disabled
if sudo ufw status | grep -q "inactive"
then
    echo "Enabling UFW."
    sudo ufw --force enable
else
    echo "UFW is already active. Skipping enable step."
fi

sudo ufw status verbose

echo "--- Idempotent Setup Complete! ---"
