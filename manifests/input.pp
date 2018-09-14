# @summary
#   This defined type creates a new filebeat input.
#
# @param config
#   An array with input configurations.
define filebeat::input(
  Array $config,
) {
  file { "/etc/filebeat/inputs.d/${name}.yml":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => to_yaml($config),
  }
}
