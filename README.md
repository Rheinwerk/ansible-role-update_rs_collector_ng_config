# rs-collector-ng

## Usage

```yaml
- hosts: servers
  var:
    RSCOLLECTORNG:
      ...
  roles:
    - { role: update_rs_collector_ng_config, tags: [ 'rscollectorng' ], _rs_collector_ng: "{{ RSCOLLECTORNG }}" }
```

### Collectors

The default template will enable the collectors `postfix` and `rscollector`. Additional collectors can be configured using the `_rs_collector_ng` variable.

#### JVM 

```yaml
_rs_collector_ng:
  jvm: # array of JVM collectors
    - command: tomcat # gets matched against `jps` output
      tags: # additional bosun tags, only for this jvm
        jvm_name: tomcat # add `jvm_name` tag to keep old rs-collector's behavior
```

#### Mongo

```yaml
_rs_collector_ng:
  mongo: # array of MONGO collectors
    # c.f. https://www.mongodb.com/docs/v3.6/reference/connection-string/
    # NOTE: Intended to be used with a direct connection e.g. specify only one host
    - connection_string: "mongodb://user:password@hostname:27015/?tls=true&tlsCAFile=/etc/ssl/certs/ca-certificates.crt"
```

#### Galera

```yaml
_rs_collector_ng:
  galera: # array of GALERA collectors
    - user: username
      password: password
      # specify socket...
      socket: /var/path/to/socket
      # ...or host & port...
      host: localhost
      port: 1337
      # ...but not both
      use_ssl: true
      ca_cert: /etc/path/to/ca.crt
```

#### Disable default collectors

```yaml
_rs_collector_ng:
    # Here's how postfix is enabled by the default value
    # >>> postfix: [{}]
    # so to disable just set it to an empty list
    postfix: []
    # also works for rscollector
    rscollector: []
```

The default template will enable the `bosun` emitter using `_scollector` values.

```yaml
_scollector:
  auth:
    user: USERNAME
    password: PASSWORD
  server:
    ip: IP_OR_HOST
    port: PORT_NUMBER
```

### Emitter

Bosun is configured on the key `_rs_collector_ng.bosun`. If omitted the default behavior is used: Values are taken from the configuration for [scollector](https://github.com/Rheinwerk/ansible-role-update_scollector_config) which have to be provided via the `_scollector` key.

```yaml
- { role: update_rs_collector_ng_config, tags: [ 'rscollectorng' ], _scollector: "{{ SCOLLECTOR }}" }
```

If the key `_rs_collector_ng.bosun` or any children are provided then the default is not used. Instead one has to provide desired values like so:

```yaml
_rs_collector_ng:
  # Bosun emitter
  bosun:
    host: "https://user:password@hostname.example.com:8070/"
    tags: # tags are optional and can be omitted
      key: value
```
