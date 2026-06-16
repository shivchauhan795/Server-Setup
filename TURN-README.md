1. apt update && apt upgrade -y
2. apt install coturn -y
3. nano /etc/default/coturn
4. Uncomment: TURNSERVER_ENABLED=1
5. Go to: nano /etc/turnserver.conf
6. A solid production starter config:

```
listening-port=3478
tls-listening-port=5349

fingerprint
use-auth-secret
static-auth-secret=YOUR_SECRET_KEY

realm=yourdomain.com

total-quota=100
bps-capacity=0

stale-nonce
no-multicast-peers

# Public IP
external-ip=YOUR_SERVER_PUBLIC_IP

# Certificates (optional but recommended)
cert=/etc/letsencrypt/live/yourdomain.com/fullchain.pem
pkey=/etc/letsencrypt/live/yourdomain.com/privkey.pem

# Logging
simple-log
log-file=/var/log/turnserver.log
```

Replace:

YOUR_SECRET_KEY
YOUR_SERVER_PUBLIC_IP
yourdomain.com

6.1 Production starter if above don't work

```
listening-port=3478
tls-listening-port=5349

fingerprint
lt-cred-mech

use-auth-secret
static-auth-secret=YOUR_SECRET_KEY

realm=yourdomain.com

# Public IP
external-ip=YOUR_SERVER_PUBLIC_IP

no-multicast-peers
no-loopback-peers
stale-nonce
simple-log
```

7. Open Firewall Ports:

```
| Purpose         | Port        |
| --------------- | ----------- |
| STUN/TURN UDP   | 3478        |
| STUN/TURN TCP   | 3478        |
| TURN TLS        | 5349        |
| Relay UDP range | 49152–65535 |

```
using ufw:
```
ufw allow 3478/tcp
ufw allow 3478/udp
ufw allow 5349/tcp
ufw allow 49152:65535/udp
```
then
```
ufw enable
```

8. Start the server:

```
systemctl restart coturn
systemctl status coturn
```

9. Enable auto start:

```
systemctl enable coturn
```

## How to use on frontend

```
const pc = new RTCPeerConnection({
  iceServers: [
    {
      urls: [
        "stun:yourdomain.com:3478"
      ]
    },
    {
      urls: [
        "turn:yourdomain.com:3478?transport=udp",
        "turn:yourdomain.com:3478?transport=tcp",
        "turns:yourdomain.com:5349"
      ],
      username: "user",
      credential: "password"
    }
  ]
});
```



### Get certificate
```
certbot certonly --standalone -d yourdomain.com
```
