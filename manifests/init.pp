# filebeat
#
# @summary
#  Main class, includes all other classes
#
# @param package_name
#   Name of the filebeat package. Dfault value: 'filebeat'.
#
# @param package_ensure
#   State of package (e.g. present oder latest). Default value: 'present'.
#
# @param package_provider
#   Optional package provider for the package. Default value: Undef.
#
# @param package_source
#   Optional package source for the package. Default value: Undef.
#
# @param service_name
#   Name of the filebeat service. Default value: 'filebeat'.
#
# @param service_ensure
#   Whether the filebeat service should be running. Default value: 'running'.
#
# @param service_enable
#   Whether the filebeat service should be enabled. Default value: true.
#
# @param environment_file
#   Path to the environment file for systemd. Default value: '/etc/sysconfig/filebeat'.
#
# @param inputs
#   An hash with enabled inputs for filebeat. Default value: {}.
#
# @param modules
#   An hash with enabled modules for filebeat. Default value: {}.
#
# @param config
#   An hash with the main and output configuration. Default value: {}.
#
# @param env
#   An array with environment variables, wich will be written to the environment_file. Default value: [].
class filebeat(
  String $package_name,
  String $package_ensure,
  Optional[String] $package_provider,
  Optional[String] $package_source,
  String $service_name,
  Optional[String] $service_ensure,
  Optional[Boolean] $service_enable,
  String $environment_file,
  Optional[Hash] $inputs,
  Optional[Hash] $modules,
  Optional[Hash] $config,
  Optional[Hash] $env,
) {
  contain 'filebeat::package'
  contain 'filebeat::config'
  contain 'filebeat::service'

  Class['filebeat::package']
  ->Class['filebeat::config']
  ~>Class['filebeat::service']
}
