# OpenSSL

Keep in mind manual pages have comprehensive and clear description of commands below. man openssl-x509, man openssl-req, man openssl-genrsa

## Self signed certificate

Create a certificate for a localhost domain

* Create a root RSA key
```bash
openssl genrsa -des3 -out rootCA.key 2048
```
* Create a root certificate. It creates pem instead of CSR (certificate signing request) due to -x509
```bash
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1825 -out rootCA.pem
```
* create a server RSA key
```bash
openssl genrsa -out server.key 2048
```
* create the server certificate request file
```bash
openssl req -new -sha256 -key server.key -out server.csr
```
* create certificate extensions
```bash
cat > server.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
EOF
```
* create a certificate extensions file
```bash
openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.pem -days 1825 -sha256 -extfile server.ext
```

Done. A server provides a `server.pem` and uses `server.key` (keeping it in secret) to decrypt data from client which is ecrypted with the key `server.pem` consists. A client uses `rootCA`.pem to verify `server.pem`.

## NGINX

Insert this in a `server` section

```nginx
ssl_certificate     server.pem; // you can see crt extension instead of pem. It could make no sense because PEM is encoding format (basically base64) but crt means an SSL certificate is inside the file. A ceritificate can be stored in PEM or DER
ssl_certificate_key server.key;
```

## Other

Certifincate structure is shown by `openssl x509 -text -in server.pem`

## Handshake algorithm

- client sends his tech data: the highest TLS version, supported ciphers, supported compression method, a random number;
- server sends chosen TLS version, cipher, compression method and a random number;
- server sends his public key within his certificate;
- client verifies it asking a certificater authrority. (in order to trust to self signed certificate provide rootCA.pem to the client);
- client creates pre-master key and sends ie to server encrypted with public key from the public certificate of the server;
- client and server generates shared secret on top of the random numbers;
- client sends an encrypted message with the shared secret;
- server verifies that it's able to decrypt it the encrypted message with the shared secret;
- message are sent with the shared secret;

TODO: see [tls client authentication](https://github.com/hyperium/tonic/blob/master/examples/src/tls_client_auth/)

Complete [example](./tls-auth) tls client authentication that it's done with NGINX as a server.
