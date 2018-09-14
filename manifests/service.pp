# @summary
#   This class handles the filebeat service.
#
# @api private
#
class filebeat::service {
  service{ $filebeat::service_name:
    ensure => $filebeat::service_ensure,
    enable => $filebeat::service_enable,
  }
}
