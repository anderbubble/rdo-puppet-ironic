# == Define: ironic::generic_service
#
# This defined type implements basic ironic services.
# It is introduced to attempt to consolidate
# common code.
#
# It also allows users to specify ad-hoc services
# as needed
#
# This define creates a service resource with title ironic-${name} and
# conditionally creates a package resource with title ironic-${name}
#
define ironic::generic_service(
  $package_name,
  $service_name,
  $enabled        = false,
  $manage_service = true,
  $ensure_package = 'present'
) {

  include ironic::params

  $ironic_title = "ironic-${name}"
  # ensure that the service is only started after
  # all ironic config entries have been set
  Exec['post-ironic_config'] ~> Service<| title == $ironic_title |>
  # ensure that the service has only been started
  # after the initial db sync
  Exec<| title == 'ironic-db-sync' |> ~> Service<| title == $ironic_title |>


  # I need to mark that ths package should be
  # installed before ironic_config
  if ($package_name) {
    if !defined(Package[$package_name]) {
      package { $ironic_title:
        ensure => $ensure_package,
        name   => $package_name,
        notify => Service[$ironic_title],
      }
    }
  }

  if $service_name {
    if $manage_service {
      if $enabled {
        $service_ensure = 'running'
      } else {
        $service_ensure = 'stopped'
      }
    }

    service { $ironic_title:
      ensure    => $service_ensure,
      name      => $service_name,
      enable    => $enabled,
      hasstatus => true,
      require   => [Package['ironic-common'], Package[$package_name]],
    }
  }
}
