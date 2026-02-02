# Example usage of paw_ansible_role_varnish

# Simple include with default parameters
include paw_ansible_role_varnish

# Or with custom parameters:
# class { 'paw_ansible_role_varnish':
#   varnish_default_backend_host => '127.0.0.1',
#   varnish_default_backend_port => '8080',
#   backend => undef,
#   vhost => undef,
#   varnish_secret => '14bac2e6-1e34-4770-8078-974373b76c90',
#   varnish_limit_nofile => 131072,
#   varnish_pidfile => '/run/varnishd.pid',
#   varnish_config_path => '/etc/varnish',
#   varnish_listen_address => undef,
#   varnish_listen_port => '80',
#   varnish_admin_listen_host => '127.0.0.1',
#   varnish_admin_listen_port => '6082',
#   varnish_storage => 'file,/var/lib/varnish/varnish_storage.bin,256M',
#   varnishd_extra_options => undef,
#   varnish_package_name => 'varnish',
#   varnish_modules_package_name => undef,
#   varnish_version => '6.6',
#   varnish_use_default_vcl => true,
#   varnish_default_vcl_template_path => 'default.vcl.j2',
#   varnish_enabled_services => ['varnish'],
#   varnish_apt_use_packagecloud => true,
#   varnish_packagecloud_repo_yum_repository_priority => '1',
#   varnish_yum_repo_baseurl => 'https://packagecloud.io/varnishcache/{{ varnish_packagecloud_repo }}/el/{{ ansible_facts.distribution_major_version|int }}/$basearch',
#   varnish_apt_repo => 'deb https://packagecloud.io/varnishcache/{{ varnish_packagecloud_repo }}/{{ ansible_facts.distribution | lower }}/ {{ ansible_facts.distribution_release }} main',
# }
