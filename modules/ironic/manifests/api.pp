# == Class: ironic::api
#
# Setup and configure the Ironic API endpoint
#
# === Parameters
#
# [*admin_password*]
#   (required) The password to set for the ironic admin user in keystone
#
# [*enabled*]
#   (optional) Whether the ironic api service will be run
#   Defaults to false
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*ensure_package*]
#   (optional) Whether the ironic api package will be installed
#   Defaults to 'present'
#
# [*auth_host*]
#   (optional) The IP of the server running keystone
#   Defaults to '127.0.0.1'
#
# [*auth_port*]
#   (optional) The port to use when authenticating against Keystone
#   Defaults to 35357
#
# [*auth_protocol*]
#   (optional) The protocol to use when authenticating against Keystone
#   Defaults to 'http'
#
# [*auth_uri*]
#   (optional) The uri of a Keystone service to authenticate against
#   Defaults to false
#
# [*auth_admin_prefix*]
#   (optional) Prefix to prepend at the beginning of the keystone path
#   Defaults to false
#
# [*auth_version*]
#   (optional) API version of the admin Identity API endpoint
#   for example, use 'v3.0' for the keystone version 3.0 api
#   Defaults to false
#
# [*admin_tenant_name*]
#   (optional) The name of the tenant to create in keystone for use by the ironic services
#   Defaults to 'services'
#
# [*admin_user*]
#   (optional) The name of the user to create in keystone for use by the ironic services
#   Defaults to 'ironic'
#
# [*api_bind_address*]
#   (optional) IP address for ironic-api server to listen
#   Defaults to '0.0.0.0'
#
# [*metadata_listen*]
#   (optional) IP address  for metadata server to listen
#   Defaults to '0.0.0.0'
#
# [*enabled_apis*]
#   (optional) A comma separated list of apis to enable
#   Defaults to 'ec2,osapi_compute,metadata'
#
# [*keystone_ec2_url*]
#   (optional) The keystone url where ironic should send requests for ec2tokens
#   Defaults to false
#
# [*use_forwarded_for*]
#   (optional) Treat X-Forwarded-For as the canonical remote address. Only
#   enable this if you have a sanitizing proxy.
#   Defaults to false
#
# [*osapi_compute_workers*]
#   (optional) Number of workers for OpenStack API service
#   Defaults to $::processorcount
#
# [*ec2_workers*]
#   (optional) Number of workers for EC2 service
#   Defaults to $::processorcount
#
# [*metadata_workers*]
#   (optional) Number of workers for metadata service
#   Defaults to $::processorcount
#
# [*sync_db*]
#   (optional) Run ironic-manage db sync on api nodes after installing the package.
#   Defaults to true
#
# [*neutron_metadata_proxy_shared_secret*]
#   (optional) Shared secret to validate proxies Neutron metadata requests
#   Defaults to undef
#
# [*ratelimits*]
#   (optional) A string that is a semicolon-separated list of 5-tuples.
#   See http://docs.openstack.org/trunk/config-reference/content/configuring-compute-API.html
#   Example: '(POST, "*", .*, 10, MINUTE);(POST, "*/servers", ^/servers, 50, DAY);(PUT, "*", .*, 10, MINUTE)'
#   Defaults to undef
#
# [*ratelimits_factory*]
#   (optional) The rate limiting factory to use
#   Defaults to 'ironic.api.openstack.compute.limits:RateLimitingMiddleware.factory'
#
# [*osapi_v3*]
#   (optional) Enable or not Ironic API v3
#   Defaults to false
#
class ironic::api(
  $admin_password,
  $enabled               = false,
  $manage_service        = true,
  $ensure_package        = 'present',
  $auth_host             = '127.0.0.1',
  $auth_port             = 35357,
  $auth_protocol         = 'http',
  $auth_uri              = false,
  $auth_admin_prefix     = false,
  $auth_version          = false,
  $admin_tenant_name     = 'services',
  $admin_user            = 'ironic',
  # $api_bind_address      = '0.0.0.0',
  # $metadata_listen       = '0.0.0.0',
  # $enabled_apis          = 'ec2,osapi_compute,metadata',
  # $keystone_ec2_url      = false,
  # $use_forwarded_for     = false,
  # $osapi_compute_workers = $::processorcount,
  # $ec2_workers           = $::processorcount,
  # $metadata_workers      = $::processorcount,
  $sync_db               = true,
  # $neutron_metadata_proxy_shared_secret = undef,
  # $osapi_v3              = false,
  # $ratelimits            = undef,
  # $ratelimits_factory    =
  #   'ironic.api.openstack.compute.limits:RateLimitingMiddleware.factory',
) {

  include ironic::params
  require keystone::python

  Package<| title == 'ironic-api' |> -> Ironic_paste_api_ini<| |>

  Package<| title == 'ironic-common' |> -> Class['ironic::api']

  Ironic_paste_api_ini<| |> ~> Exec['post-ironic_config']

  Ironic_paste_api_ini<| |> ~> Service['ironic-api']

  ironic::generic_service { 'api':
    enabled        => $enabled,
    manage_service => $manage_service,
    ensure_package => $ensure_package,
    package_name   => $::ironic::params::api_package_name,
    service_name   => $::ironic::params::api_service_name,
  }

  # ironic_config {
  #   'DEFAULT/enabled_apis':          value => $enabled_apis;
  #   'DEFAULT/ec2_listen':            value => $api_bind_address;
  #   'DEFAULT/osapi_compute_listen':  value => $api_bind_address;
  #   'DEFAULT/metadata_listen':       value => $metadata_listen;
  #   'DEFAULT/osapi_volume_listen':   value => $api_bind_address;
  #   'DEFAULT/osapi_compute_workers': value => $osapi_compute_workers;
  #   'DEFAULT/ec2_workers':           value => $ec2_workers;
  #   'DEFAULT/metadata_workers':      value => $metadata_workers;
  #   'DEFAULT/use_forwarded_for':     value => $use_forwarded_for;
  #   'osapi_v3/enabled':              value => $osapi_v3;
  # }

  # if ($neutron_metadata_proxy_shared_secret){
  #   ironic_config {
  #     'DEFAULT/service_neutron_metadata_proxy': value => true;
  #     'DEFAULT/neutron_metadata_proxy_shared_secret':
  #       value => $neutron_metadata_proxy_shared_secret;
  #   }
  # } else {
  #   ironic_config {
  #     'DEFAULT/service_neutron_metadata_proxy':       value  => false;
  #     'DEFAULT/neutron_metadata_proxy_shared_secret': ensure => absent;
  #   }
  # }

  if $auth_uri {
    ironic_config { 'keystone_authtoken/auth_uri': value => $auth_uri; }
  } else {
    ironic_config { 'keystone_authtoken/auth_uri': value => "${auth_protocol}://${auth_host}:5000/"; }
  }

  if $auth_version {
    ironic_config { 'keystone_authtoken/auth_version': value => $auth_version; }
  } else {
    ironic_config { 'keystone_authtoken/auth_version': ensure => absent; }
  }

  ironic_config {
    'keystone_authtoken/auth_host':         value => $auth_host;
    'keystone_authtoken/auth_port':         value => $auth_port;
    'keystone_authtoken/auth_protocol':     value => $auth_protocol;
    'keystone_authtoken/admin_tenant_name': value => $admin_tenant_name;
    'keystone_authtoken/admin_user':        value => $admin_user;
    'keystone_authtoken/admin_password':    value => $admin_password, secret => true;
  }

  if $auth_admin_prefix {
    validate_re($auth_admin_prefix, '^(/.+[^/])?$')
    ironic_config {
      'keystone_authtoken/auth_admin_prefix': value => $auth_admin_prefix;
    }
  } else {
    ironic_config {
      'keystone_authtoken/auth_admin_prefix': ensure => absent;
    }
  }

  # if $keystone_ec2_url {
  #   ironic_config {
  #     'DEFAULT/keystone_ec2_url': value => $keystone_ec2_url;
  #   }
  # } else {
  #   ironic_config {
  #     'DEFAULT/keystone_ec2_url': ensure => absent;
  #   }
  # }

  # if 'occiapi' in $enabled_apis {
  #   if !defined(Package['python-pip']) {
  #     package { 'python-pip':
  #       ensure => latest,
  #     }
  #   }
  #   if !defined(Package['pyssf']) {
  #     package { 'pyssf':
  #       ensure   => latest,
  #       provider => pip,
  #       require  => Package['python-pip']
  #     }
  #   }
  #   package { 'openstackocci':
  #     ensure   => latest,
  #     provider => 'pip',
  #     require  => Package['python-pip'],
  #   }
  # }

  # if ($ratelimits != undef) {
  #   ironic_paste_api_ini {
  #     'filter:ratelimit/paste.filter_factory': value => $ratelimits_factory;
  #     'filter:ratelimit/limits':               value => $ratelimits;
  #   }
  # }

  # Added arg and if statement prevents this from being run
  # where db is not active i.e. the compute
  if $sync_db {
    Package<| title == 'ironic-api' |> -> Exec['ironic-db-sync']
    exec { 'ironic-db-sync':
      command     => '/usr/bin/ironic-dbsync --config-file /etc/ironic/ironic.conf upgrade',
      require     => Package['python-pbr'],
      refreshonly => true,
      subscribe   => Exec['post-ironic_config'],
    }
    package { 'python-pbr': ensure => latest, }
  }

  # Remove auth configuration from api-paste.ini
  ironic_paste_api_ini {
    'filter:authtoken/auth_uri':          ensure => absent;
    'filter:authtoken/auth_host':         ensure => absent;
    'filter:authtoken/auth_port':         ensure => absent;
    'filter:authtoken/auth_protocol':     ensure => absent;
    'filter:authtoken/admin_tenant_name': ensure => absent;
    'filter:authtoken/admin_user':        ensure => absent;
    'filter:authtoken/admin_password':    ensure => absent;
    'filter:authtoken/auth_admin_prefix': ensure => absent;
  }

}
