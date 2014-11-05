# http://docs.openstack.org/developer/ironic/deploy/install-guide.html

class { 'ironic::keystone::auth':
  password         => 'IRONIC_PASSWORD',
  public_address   => '128.138.138.152',
  admin_address    => '128.138.138.152',
  internal_address => '128.138.138.152',
}

class { 'ironic::db::mysql':
  password => 'IRONIC_DBPASSWORD',
}

class { 'ironic::api': }
class { 'ironic::conductor': }
class { 'ironic':
  database_connection => 'mysql://ironic:IRONIC_DBPASSWORD@DB_IP/ironic?charset=utf8',
}

package { 'python-ironicclient': }
