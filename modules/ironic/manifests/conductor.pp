# == Class: ironic::conductor
#
# Manages ironic conductor package and service
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to enable the ironic-conductor service
#   Defaults to false
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*ensure_package*]
#   (optional) The state of the ironic conductor package
#   Defaults to 'present'
#
# [*workers*]
#   (optional) Number of workers for OpenStack Conductor service
#   Defaults to undef (i.e. parameter will not be present)
#
class ironic::conductor(
  $enabled        = false,
  $manage_service = true,
  $ensure_package = 'present',
  $workers        = undef,
) {

  include ironic::params

  ironic::generic_service { 'conductor':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_name   => $::ironic::params::conductor_package_name,
    service_name   => $::ironic::params::conductor_service_name,
    ensure_package => $ensure_package,
  }

  if $workers {
    ironic_config {
      'conductor/workers': value => $workers;
    }
  }
}
