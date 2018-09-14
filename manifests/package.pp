# @summary
#   This class handles filebeat package.
#
# @api private
#
class filebeat::package {
  package { $filebeat::package_name:
    ensure   => $filebeat::package_ensure,
    provider => $filebeat::package_provider,
    source   => $filebeat::package_source,
  }
}
