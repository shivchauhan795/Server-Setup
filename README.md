# Check Current Permissions
`ls -l setup.sh`

# Apply Permission To Execute
`chmod u+x setup.sh`

# Check Permission Again
- It should show `-rwx-r--r-- 1 root root 2048 Dec 25 10:00 setup.sh`
- x here shows that the file is only executable by root/owner user

# Run Setup File
`sudo ./setup.sh`
