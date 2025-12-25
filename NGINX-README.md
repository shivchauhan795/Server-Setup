# Always create a copy of default nginx file
`mv nginx.conf nginx-backup.conf`

# Create new file and edit on the file
`nano nginx.conf`

# Location of nginx.conf file
`etc/nginx`

# Test nginx configuration
`sudo nginx -t`

# Reload nginx configuration
`sudo nginx -s reload`
