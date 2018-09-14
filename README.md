# puppet-filebeat

#### Table of Contents


1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with filebeat](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)


## Module description

The filebeat module installs, configures and manages the Elastic filebeat service for shipping logs to Logstash, Kafka or Elasticsearch.

## Setup

### Filebeat packages

This modules currently does not manage the package repository for the elastic. The main reason for this is that the module is primarily written for enterprise environments, without an direct access to the public internet. Furthermore, as you also might want to install Logstash, Elasticsearch and Kibana in your in environment (and there is only a "all-in-one" package repository for elastic), there would be a high chance of a duplicate resource definition of the package repository.
 
If you don't have a central repository management in your environment (like Pulp or RedHat Satellite) prepare the package repository on your nodes with a different module (e.g. [elastic_stack](https://forge.puppet.com/elastic/elastic_stack)), or use the module parameters to switch to an "url based" installation method. 

```yaml
filebeat::package_provider: 'rpm'
filebeat::package_source: 'https://artifacts.elastic.co/packages/6.x/yum/6.4.0/filebeat-6.4.0-x86_64.rpm'
```

### Configure a output

Filebeat requires at least one configured output. See below for example configurations.

## Usage

All parameters for the filebeat module are contained within the main `filebeat` class, so for any function of the module, set the options you want. See the common usages below for examples.

### Install and enable filebeat

```puppet
include filebeat
```

### Define a filebeat input

Each hash entry represents a own configuration file inside of `/etc/filebeat/inputs.d`.

```yaml
filebeat::inputs:
  syslog:
    - type: log
      enabled: true
      paths:
        - /var/log/messages
        - /var/log/syslog
```

Optional additional fields can be added.

```yaml
filebeat::inputs:
  syslog:
    - type: log
      enabled: true
      paths:
        - /var/log/messages
        - /var/log/syslog
      fields:
        type: syslog
```

### Configure a filebeat module

Each hash entry represents a own configuration file inside of `/etc/filebeat/modules.d`.

```yaml
filebeat::modules:
  'system':
    - module: system
      syslog:
        enabled: true
      auth:
        enabled: true
```

### Configure Logstash output

```yaml
filebeat::config:
  output:
    logstash:
      hosts:
        - 'logstash1.example.com:5044'
        - 'logstash2.example.com:5044'
```

### Configure Apache Kafka output

```yaml
filebeat::config:
  output:
    kafka:
      hosts:
        - 'kafka1.example.com:9092'
        - 'kafka2.example.com:9092'
      topic: 'logs'
```

### Configure Apache Kafka with output to different topics

```yaml
filebeat::inputs:
  syslog:
    - type: log
      enabled: true
      paths:
        - /var/log/messages
        - /var/log/syslog
      fields:
        kafka_topic: syslog
  apache:
    - type: log
      enabled: true
      paths:
        - /var/log/httpd/access_log
        - /var/log/apache2/access_log
      fields:
        kafka_topic: apache

filebeat::config:
  output:
    kafka:
      hosts:
        - 'kafka1.example.com:9092'
        - 'kafka2.example.com:9092'
      topic: "%{literal('%')}{[fields.kafka_topic]}"
```

### Configure Elasticsearch output

```yaml
filebeat::config:
  output:
    elasticsearch:
      hosts: ["localhost:9200"]
      protocol: "https"
      username: "elastic"
      password: "changeme"
```

### Full example configuration

A complete example configuration using the Logstash output with authentication via the Puppet SSL certificates TLS hardening.

```yaml
filebeat::env:
  'APPLICATION': 'puppetserver'

filebeat::config:
  name: '%{facts.fqdn}'
  tags:
    - '%{facts.osfamily}'
  fields:
    environment: '%{environment}'
    application: '${APPLICATION:none}'
  logging.level: 'error'
  logging.selectors: ["*"]
  output:
    logstash:
      hosts: ["logstash.example.com:5044"]
      ssl.certificate_authorities: ["/etc/puppetlabs/puppet/ssl/certs/ca.pem"]
      ssl.certificate: "/etc/puppetlabs/puppet/ssl/certs/%{trusted.certname}.pem"
      ssl.key: "/etc/puppetlabs/puppet/ssl/private_keys/%{trusted.certname}.pem"
      ssl.supported_protocols: [TLSv1.2]
      ssl.cipher_suites: [ECDHE-ECDSA-AES-256-GCM-SHA384, ECDHE-RSA-AES-256-GCM-SHA384, ECDHE-ECDSA-AES-128-GCM-SHA256, ECDHE-RSA-AES-128-GCM-SHA256]
      ssl.curve_types: [P-256, P-384, P-521]
      ssl.renegotiation: never

filebeat::modules:
  system:
    - module: system
      syslog:
        enabled: true
      auth:
        enabled: true

filebeat::inputs:
  apache:
    - type: log
      enabled: true
      paths:
        - /var/log/httpd/*_access.log
        - /var/log/httpd/*_access_ssl.log
      fields:
        type: apache_access
```

## Reference

See [REFERENCE.md](REFERENCE.md)

## Limitations

For an extensive list of supported operating systems, see [metadata.json](https://github.com/slauger/puppet-filebeat/blob/master/metadata.json)

## Development

Puppet modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. Feature requests and pull requests are appreciated.

### Contributors

To see who's already involved, see the [list of contributors.](https://github.com/slauger/puppet-filebeat/graphs/contributors)
