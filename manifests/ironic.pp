# http://docs.openstack.org/developer/ironic/deploy/install-guide.html

class { 'ironic::keystone::auth':
  password         => 'IRONIC_PASSWORD',
  public_address   => '128.138.138.152',
  admin_address    => '128.138.138.152',
  internal_address => '128.138.138.152',
}

class { 'ironic::db::mysql': }

class { 'ironic::api': }
class { 'ironic::conductor': }
class { 'ironic': }

package { 'python-ironicclient': }
