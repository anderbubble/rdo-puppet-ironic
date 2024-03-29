# http://docs.openstack.org/developer/ironic/deploy/install-guide.html

class { 'ironic::keystone::auth':
  password         => 'ironic',
  public_address   => '128.138.138.152',
  admin_address    => '128.138.138.152',
  internal_address => '128.138.138.152',
}

class { 'ironic::db::mysql':
  password      => 'ironic',
  host          => '%',
  allowed_hosts => '%',
  charset       => 'utf8',
}

class { 'ironic::api':
  enabled        => true,
  auth_host      => '128.138.138.152',
  admin_password => 'ironic',
}
class { 'ironic::conductor':
  enabled => true,
}
class { 'ironic':
  database_connection => 'mysql://ironic:ironic@128.138.138.152/ironic?charset=utf8',
  rabbit_host         => '128.138.138.152'
}

package { 'python-ironicclient': }
