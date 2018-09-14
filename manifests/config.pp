# @summary
#   This class handles the configuration file.
#
# @api private
#
class filebeat::config {
  file { '/etc/filebeat':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  ->file { ['/etc/filebeat/inputs.d', '/etc/filebeat/modules.d']:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
    ignore  => ['*.yml.disabled'],
  }
  ->file { '/etc/filebeat/filebeat.yml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/etc/filebeat/filebeat.yml.epp", {
      'config' => delete(to_yaml($filebeat::config), "---\n"),
    }),
  }

  file { $filebeat::environment_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/environment_file.epp"),
  }

  $filebeat::inputs.each |String $filename, Array $input_config| {
    filebeat::input{ $filename:
      config => $input_config,
    }
  }
  $filebeat::modules.each |String $filename, Array $module_config| {
    filebeat::module{ $filename:
      config => $module_config,
    }
  }
}
