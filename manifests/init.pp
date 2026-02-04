# paw_ansible_role_varnish
# @summary Manage paw_ansible_role_varnish configuration
#
# @param varnish_default_backend_host
# @param varnish_default_backend_port
# @param backend
# @param vhost
# @param varnish_secret
# @param varnish_limit_nofile
# @param varnish_pidfile
# @param varnish_config_path
# @param varnish_listen_address
# @param varnish_listen_port
# @param varnish_admin_listen_host
# @param varnish_admin_listen_port
# @param varnish_storage
# @param varnishd_extra_options
# @param varnish_package_name
# @param varnish_modules_package_name
# @param varnish_version
# @param varnish_use_default_vcl
# @param varnish_default_vcl_template_path
# @param varnish_enabled_services
# @param varnish_apt_use_packagecloud Use Packagecloud repo instead of distribution default
# @param varnish_packagecloud_repo_yum_repository_priority Make sure Packagecloud repo is used on RHEL/CentOS.
# @param varnish_yum_repo_baseurl Only used on RedHat / CentOS.
# @param varnish_apt_repo Only used on Debian / Ubuntu.
# @param par_vardir Base directory for Puppet agent cache (uses lookup('paw::par_vardir') for common config)
# @param par_tags An array of Ansible tags to execute (optional)
# @param par_skip_tags An array of Ansible tags to skip (optional)
# @param par_start_at_task The name of the task to start execution at (optional)
# @param par_limit Limit playbook execution to specific hosts (optional)
# @param par_verbose Enable verbose output from Ansible (optional)
# @param par_check_mode Run Ansible in check mode (dry-run) (optional)
# @param par_timeout Timeout in seconds for playbook execution (optional)
# @param par_user Remote user to use for Ansible connections (optional)
# @param par_env_vars Additional environment variables for ansible-playbook execution (optional)
# @param par_logoutput Control whether playbook output is displayed in Puppet logs (optional)
# @param par_exclusive Serialize playbook execution using a lock file (optional)
class paw_ansible_role_varnish (
  String $varnish_default_backend_host = '127.0.0.1',
  String $varnish_default_backend_port = '8080',
  Optional[String] $backend = undef,
  Optional[String] $vhost = undef,
  String $varnish_secret = '14bac2e6-1e34-4770-8078-974373b76c90',
  Integer $varnish_limit_nofile = 131072,
  String $varnish_pidfile = '/run/varnishd.pid',
  String $varnish_config_path = '/etc/varnish',
  Optional[String] $varnish_listen_address = undef,
  String $varnish_listen_port = '80',
  String $varnish_admin_listen_host = '127.0.0.1',
  String $varnish_admin_listen_port = '6082',
  String $varnish_storage = 'file,/var/lib/varnish/varnish_storage.bin,256M',
  Optional[String] $varnishd_extra_options = undef,
  String $varnish_package_name = 'varnish',
  Optional[String] $varnish_modules_package_name = undef,
  String $varnish_version = '6.6',
  Boolean $varnish_use_default_vcl = true,
  String $varnish_default_vcl_template_path = 'default.vcl.j2',
  Array $varnish_enabled_services = ['varnish'],
  Boolean $varnish_apt_use_packagecloud = true,
  String $varnish_packagecloud_repo_yum_repository_priority = '1',
  String $varnish_yum_repo_baseurl = 'https://packagecloud.io/varnishcache/{{ varnish_packagecloud_repo }}/el/{{ ansible_facts.distribution_major_version|int }}/$basearch',
  String $varnish_apt_repo = 'deb https://packagecloud.io/varnishcache/{{ varnish_packagecloud_repo }}/{{ ansible_facts.distribution | lower }}/ {{ ansible_facts.distribution_release }} main',
  Optional[Stdlib::Absolutepath] $par_vardir = undef,
  Optional[Array[String]] $par_tags = undef,
  Optional[Array[String]] $par_skip_tags = undef,
  Optional[String] $par_start_at_task = undef,
  Optional[String] $par_limit = undef,
  Optional[Boolean] $par_verbose = undef,
  Optional[Boolean] $par_check_mode = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[String] $par_user = undef,
  Optional[Hash] $par_env_vars = undef,
  Optional[Boolean] $par_logoutput = undef,
  Optional[Boolean] $par_exclusive = undef
) {
# Execute the Ansible role using PAR (Puppet Ansible Runner)
# Playbook synced via pluginsync to agent's cache directory
# Check for common paw::par_vardir setting, then module-specific, then default
$_par_vardir = $par_vardir ? {
  undef   => lookup('paw::par_vardir', Stdlib::Absolutepath, 'first', '/opt/puppetlabs/puppet/cache'),
  default => $par_vardir,
}
$playbook_path = "${_par_vardir}/lib/puppet_x/ansible_modules/ansible_role_varnish/playbook.yml"

par { 'paw_ansible_role_varnish-main':
  ensure        => present,
  playbook      => $playbook_path,
  playbook_vars => {
        'varnish_default_backend_host' => $varnish_default_backend_host,
        'varnish_default_backend_port' => $varnish_default_backend_port,
        'backend' => $backend,
        'vhost' => $vhost,
        'varnish_secret' => $varnish_secret,
        'varnish_limit_nofile' => $varnish_limit_nofile,
        'varnish_pidfile' => $varnish_pidfile,
        'varnish_config_path' => $varnish_config_path,
        'varnish_listen_address' => $varnish_listen_address,
        'varnish_listen_port' => $varnish_listen_port,
        'varnish_admin_listen_host' => $varnish_admin_listen_host,
        'varnish_admin_listen_port' => $varnish_admin_listen_port,
        'varnish_storage' => $varnish_storage,
        'varnishd_extra_options' => $varnishd_extra_options,
        'varnish_package_name' => $varnish_package_name,
        'varnish_modules_package_name' => $varnish_modules_package_name,
        'varnish_version' => $varnish_version,
        'varnish_use_default_vcl' => $varnish_use_default_vcl,
        'varnish_default_vcl_template_path' => $varnish_default_vcl_template_path,
        'varnish_enabled_services' => $varnish_enabled_services,
        'varnish_apt_use_packagecloud' => $varnish_apt_use_packagecloud,
        'varnish_packagecloud_repo_yum_repository_priority' => $varnish_packagecloud_repo_yum_repository_priority,
        'varnish_yum_repo_baseurl' => $varnish_yum_repo_baseurl,
        'varnish_apt_repo' => $varnish_apt_repo
              },
  tags          => $par_tags,
  skip_tags     => $par_skip_tags,
  start_at_task => $par_start_at_task,
  limit         => $par_limit,
  verbose       => $par_verbose,
  check_mode    => $par_check_mode,
  timeout       => $par_timeout,
  user          => $par_user,
  env_vars      => $par_env_vars,
  logoutput     => $par_logoutput,
  exclusive     => $par_exclusive,
}
}
