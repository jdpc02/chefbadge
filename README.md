# All things Chef


Useful cookbooks as reference under Sample.
- disktest is a custom resource about disks
- lazytest utilized lazy for picking up updated attributes
- resourcetest is a custom resource to setup web servers
- mycookbook calls the custom resources


Utilized the following as a basis for my code.
* [Script to move IIS](https://gallery.technet.microsoft.com/scriptcenter/Script-to-move-the-IIS-f1fb62a5)
* [Self Signed Cert Creation](https://stackoverflow.com/questions/10175812/how-to-create-a-self-signed-certificate-with-openssl)


When adding disks for vagrant/virtualbox in .kitchen.yml, you can list the existing disk from a virtualbox VM via:
```
VBoxManage.exe list runningvms
VBoxManage.exe showvminfo <UUID/VM Name>
```
Check the Storage Controller Name as that is needed for creating a new disk.


The different system bus and controller chipsets are as follows:
> [--add ide|sata|scsi|floppy|sas|usb|pcie]
> [--controller LSILogic|LSILogicSAS|BusLogic|
>    IntelAhci|PIIX3|PIIX4|ICH6|I82078|USB|NVMe]


The main thing about generating self signed certs in Linux is getting the -subj parameter just right. Here is an example:
```
[vagrant@localhost ~]$ openssl req -x509 -newkey rsa:4096 -keyout test.pem -out cert.csr -days 365 -subj '/C=US/ST=NY/L=New York/O=Insert Company Name/OU=IT Group/CN=localhost' -nodes
```

You can also create a configuration file and specifying that for your self signed cert. Here are the contents of the config file sample.conf:
```
[ req ]
default_bits        = 4096
default_keyfile     = test.pem
default_days        = 365
default_crl_days    = 30
distinguished_name  = subject
req_extensions      = req_ext
x509_extensions     = x509_ext # or v3_ca for windows PKI
#req_extensions      = v3_req
string_mask         = utf8only

# The Subject DN can be formed using X501 or RFC 4514 (see RFC 4519 for a description).
#   Its sort of a mashup. For example, RFC 4514 does not provide emailAddress.
[ subject ]
countryName         = Country Name (2 letter code)
countryName_default     = US

stateOrProvinceName     = State or Province Name (full name)
stateOrProvinceName_default = NY

localityName            = Locality Name (eg, city)
localityName_default        = New York

organizationName         = Organization Name (eg, company)
organizationName_default    = Insert Company Name

organizationalUnitName   = Group Name
organizationalUnitName_default   = IT Group

# Use a friendly name here because it's presented to the user. The server's DNS
#   names are placed in Subject Alternate Names. Plus, DNS names here is deprecated
#   by both IETF and CA/Browser Forums. If you place a DNS name here, then you
#   must include the DNS name in the SAN too (otherwise, Chrome and others that
#   strictly follow the CA/Browser Baseline Requirements will fail).
commonName          = Common Name (e.g. server FQDN or YOUR name)
commonName_default      = Example Company

emailAddress            = Email Address
emailAddress_default        = test@example.com

# Section x509_ext is used when generating a self-signed certificate. I.e., openssl req -x509 ...
[ x509_ext ]

subjectKeyIdentifier        = hash
authorityKeyIdentifier    = keyid,issuer

# You only need digitalSignature below. *If* you don't allow
#   RSA Key transport (i.e., you use ephemeral cipher suites), then
#   omit keyEncipherment because that's key transport.
basicConstraints        = CA:FALSE
keyUsage            = digitalSignature, keyEncipherment
subjectAltName          = @alternate_names
nsComment           = "OpenSSL Generated Certificate"

# RFC 5280, Section 4.2.1.12 makes EKU optional
#   CA/Browser Baseline Requirements, Appendix (B)(3)(G) makes me confused
#   In either case, you probably only need serverAuth.
# extendedKeyUsage    = serverAuth, clientAuth

# Section req_ext is used when generating a certificate signing request. I.e., openssl req ...
[ req_ext ]

subjectKeyIdentifier        = hash

basicConstraints        = CA:FALSE
keyUsage            = digitalSignature, keyEncipherment
subjectAltName          = @alternate_names
nsComment           = "OpenSSL Generated Certificate"

#[v3_req]
#basicConstraints        = CA:FALSE
#keyUsage            = nonRepudiation, digitalSignature, keyEncipherment
#subjectAltName          = @alternate_names
#
#[v3_ca]
#subjectKeyIdentifier   = hash
#authorityKeyIdentifier = keyid:always,issuer

# RFC 5280, Section 4.2.1.12 makes EKU optional
#   CA/Browser Baseline Requirements, Appendix (B)(3)(G) makes me confused
#   In either case, you probably only need serverAuth.
# extendedKeyUsage    = serverAuth, clientAuth

[ alternate_names ]

DNS.1       = example.com
DNS.2       = www.example.com
DNS.3       = mail.example.com
DNS.4       = ftp.example.com

# Add these if you need them. But usually you don't want them or
#   need them in production. You may need them for development.
# DNS.5       = localhost
# DNS.6       = localhost.localdomain
# DNS.7       = 127.0.0.1

# IPv6 localhost
# DNS.8     = ::1
```

Here is the command:
```
openssl req -config sample.conf -new -x509 -sha256 -newkey rsa:4096 -nodes \
    -keyout test.pem -days 365 -out cert.csr
```
