# == Class: ironic::params
#
# These parameters need to be accessed from several locations and
# should be considered to be constant
class ironic::params {

  case $::osfamily {
    'RedHat': {
      # package names
      $api_package_name             = 'openstack-ironic-api'
  #     $cells_package_name           = 'openstack-ironic-cells'
  #     $cert_package_name            = 'openstack-ironic-cert'
      $common_package_name          = 'openstack-ironic-common'
  #     $compute_package_name         = 'openstack-ironic-compute'
      $conductor_package_name       = 'openstack-ironic-conductor'
  #     $consoleauth_package_name     = 'openstack-ironic-console'
  #     $doc_package_name             = 'openstack-ironic-doc'
  #     $libvirt_package_name         = 'libvirt'
  #     $network_package_name         = 'openstack-ironic-network'
  #     $numpy_package_name           = 'numpy'
  #     $objectstore_package_name     = 'openstack-ironic-objectstore'
  #     $scheduler_package_name       = 'openstack-ironic-scheduler'
  #     $tgt_package_name             = 'scsi-target-utils'
  #     $vncproxy_package_name        = 'openstack-ironic-novncproxy'
  #     $spicehtml5proxy_package_name = 'openstack-ironic-console'
  #     # service names
      $api_service_name             = 'openstack-ironic-api'
  #     $cells_service_name           = 'openstack-ironic-cells'
  #     $cert_service_name            = 'openstack-ironic-cert'
  #     $compute_service_name         = 'openstack-ironic-compute'
      $conductor_service_name       = 'openstack-ironic-conductor'
  #     $consoleauth_service_name     = 'openstack-ironic-consoleauth'
  #     $libvirt_service_name         = 'libvirtd'
  #     $network_service_name         = 'openstack-ironic-network'
  #     $objectstore_service_name     = 'openstack-ironic-objectstore'
  #     $scheduler_service_name       = 'openstack-ironic-scheduler'
  #     $tgt_service_name             = 'tgtd'
  #     $vncproxy_service_name        = 'openstack-ironic-novncproxy'
  #     $spicehtml5proxy_service_name = 'openstack-ironic-spicehtml5proxy'
  #     # redhat specific config defaults
  #     $root_helper                  = 'sudo ironic-rootwrap'
  #     $lock_path                    = '/var/lib/ironic/tmp'
  #     case $::operatingsystem {
  #       'Fedora', 'RedHat': {
  #         $special_service_provider = undef
  #       }
  #       'RedHat', 'CentOS', 'Scientific': {
  #         if ($::operatingsystemmajrelease < 7) {
  #           $special_service_provider = 'init'
  #         } else {
  #           $special_service_provider = undef
  #         }
  #       }
  #       default: {
  #         $special_service_provider = 'init'
  #       }
  #     }
    }
    'Debian': {
  #     # package names
      $api_package_name             = 'ironic-api'
  #     $cells_package_name           = 'ironic-cells'
  #     $cert_package_name            = 'ironic-cert'
      $common_package_name          = 'ironic-common'
  #     $compute_package_name         = 'ironic-compute'
      $conductor_package_name       = 'ironic-conductor'
  #     $consoleauth_package_name     = 'ironic-consoleauth'
  #     $doc_package_name             = 'ironic-doc'
  #     $libvirt_package_name         = 'libvirt-bin'
  #     $network_package_name         = 'ironic-network'
  #     $numpy_package_name           = 'python-numpy'
  #     $objectstore_package_name     = 'ironic-objectstore'
  #     $scheduler_package_name       = 'ironic-scheduler'
  #     $tgt_package_name             = 'tgt'
  #     # service names
      $api_service_name             = 'ironic-api'
  #     $cells_service_name           = 'ironic-cells'
  #     $cert_service_name            = 'ironic-cert'
  #     $compute_service_name         = 'ironic-compute'
      $conductor_service_name       = 'ironic-conductor'
  #     $consoleauth_service_name     = 'ironic-consoleauth'
  #     $libvirt_service_name         = 'libvirt-bin'
  #     $network_service_name         = 'ironic-network'
  #     $objectstore_service_name     = 'ironic-objectstore'
  #     $scheduler_service_name       = 'ironic-scheduler'
  #     $spicehtml5proxy_service_name = 'ironic-spicehtml5proxy'
  #     $vncproxy_service_name        = 'ironic-novncproxy'
  #     $tgt_service_name             = 'tgt'
  #     # debian specific ironic config
  #     $root_helper                  = 'sudo ironic-rootwrap'
  #     $lock_path                    = '/var/lock/ironic'
  #     case $::operatingsystem {
  #       'Debian': {
  #         $spicehtml5proxy_package_name = 'ironic-consoleproxy'
  #         $vncproxy_package_name    = 'ironic-consoleproxy'
  #         # Use default provider on Debian
  #         $special_service_provider = undef
  #       }
  #       default: {
  #         $spicehtml5proxy_package_name = 'ironic-spiceproxy'
  #         $vncproxy_package_name    = 'ironic-novncproxy'
  #         # some of the services need to be started form the special upstart provider
  #         $special_service_provider = 'upstart'
  #       }
  #     }
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
