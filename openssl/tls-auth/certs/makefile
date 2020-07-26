client := client1

all:
	easyrsa init-pki
	easyrsa build-ca
	easyrsa gen-req localhost nopass
	easyrsa sign-req server localhost
	easyrsa gen-req $(client) nopass
	easyrsa sign-req client $(client)
	easyrsa export-p12 $(client)
	easyrsa gen-crl

client_cert:
	easyrsa gen-req $(client) nopass
	easyrsa sign-req client $(client)
	easyrsa export-p12 $(client)

revoke_client:
	easyrsa revoke $(client)
	easyrsa gen-crl
