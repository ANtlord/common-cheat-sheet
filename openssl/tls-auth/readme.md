# TLS Auth

Example of mutual TLS communication. It means that a client must have a valid SSL certificate to
get access to a site. Technically a user get a bundle of his private key, his certificate in p12
file. The file must be installed in an operation system or be used by a http client.

Note: keep in mind that the example uses self-signed certificate to provide SSL connection.

## Certification generation

Note: before do anything install [Easy RSA](https://github.com/OpenVPN/easy-rsa)

Run `make` in `certs` directory to generate all of certificates. It asks you to type passwords and
other date for certificates. Type the data carefully. Then run `docker-compose up` and check the
connection. Run the next commands staying in the root of the project.

```bash
curl --cacert ./certs/pki/ca.crt https://localhost:8090/  # access denied
cp ./certs/pki/private/client3.p12 .
curl --cert-type p12 \
    --cert client1.p12:<password which type when exports the client certificate> \
    --cacert ./certs/pki/ca.crt \
    https://localhost:8090/
```

## Certificate revoke

Run `make revoke` to revoke client1 certificate from `certs` folder then run
`docker-compose exec nginx nginx -s reload` from the root of the project. Try again

```bash
curl --cert-type p12 \
    --cert client1.p12:<password which is typed when p12 is exported the client certificate> \
    --cacert ./certs/pki/ca.crt \
    https://localhost:8090/
```

and get 400 response. That means that you are unable to get URL with the certificate.
