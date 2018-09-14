# @summary
#   This defined type creates a new filebeat module.
#
# @param config
#   An array with module configurations.
define filebeat::module(
  Array $config,
) {
  file { "/etc/filebeat/modules.d/${name}.yml":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => to_yaml($config),
  }
}
