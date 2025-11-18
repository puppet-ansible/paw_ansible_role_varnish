# Puppet task for executing Ansible role: ansible_role_varnish
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_varnish"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_varnish"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_varnish\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_varnish"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_varnish"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_varnish_default_backend_host) {
  $ExtraVars['varnish_default_backend_host'] = $env:PT_varnish_default_backend_host
}
if ($env:PT_varnish_default_backend_port) {
  $ExtraVars['varnish_default_backend_port'] = $env:PT_varnish_default_backend_port
}
if ($env:PT_backend) {
  $ExtraVars['backend'] = $env:PT_backend
}
if ($env:PT_vhost) {
  $ExtraVars['vhost'] = $env:PT_vhost
}
if ($env:PT_varnish_secret) {
  $ExtraVars['varnish_secret'] = $env:PT_varnish_secret
}
if ($env:PT_varnish_limit_nofile) {
  $ExtraVars['varnish_limit_nofile'] = $env:PT_varnish_limit_nofile
}
if ($env:PT_varnish_pidfile) {
  $ExtraVars['varnish_pidfile'] = $env:PT_varnish_pidfile
}
if ($env:PT_varnish_config_path) {
  $ExtraVars['varnish_config_path'] = $env:PT_varnish_config_path
}
if ($env:PT_varnish_listen_address) {
  $ExtraVars['varnish_listen_address'] = $env:PT_varnish_listen_address
}
if ($env:PT_varnish_listen_port) {
  $ExtraVars['varnish_listen_port'] = $env:PT_varnish_listen_port
}
if ($env:PT_varnish_admin_listen_host) {
  $ExtraVars['varnish_admin_listen_host'] = $env:PT_varnish_admin_listen_host
}
if ($env:PT_varnish_admin_listen_port) {
  $ExtraVars['varnish_admin_listen_port'] = $env:PT_varnish_admin_listen_port
}
if ($env:PT_varnish_storage) {
  $ExtraVars['varnish_storage'] = $env:PT_varnish_storage
}
if ($env:PT_varnishd_extra_options) {
  $ExtraVars['varnishd_extra_options'] = $env:PT_varnishd_extra_options
}
if ($env:PT_varnish_package_name) {
  $ExtraVars['varnish_package_name'] = $env:PT_varnish_package_name
}
if ($env:PT_varnish_modules_package_name) {
  $ExtraVars['varnish_modules_package_name'] = $env:PT_varnish_modules_package_name
}
if ($env:PT_varnish_version) {
  $ExtraVars['varnish_version'] = $env:PT_varnish_version
}
if ($env:PT_varnish_use_default_vcl) {
  $ExtraVars['varnish_use_default_vcl'] = $env:PT_varnish_use_default_vcl
}
if ($env:PT_varnish_default_vcl_template_path) {
  $ExtraVars['varnish_default_vcl_template_path'] = $env:PT_varnish_default_vcl_template_path
}
if ($env:PT_varnish_enabled_services) {
  $ExtraVars['varnish_enabled_services'] = $env:PT_varnish_enabled_services
}
if ($env:PT_varnish_apt_use_packagecloud) {
  $ExtraVars['varnish_apt_use_packagecloud'] = $env:PT_varnish_apt_use_packagecloud
}
if ($env:PT_varnish_packagecloud_repo_yum_repository_priority) {
  $ExtraVars['varnish_packagecloud_repo_yum_repository_priority'] = $env:PT_varnish_packagecloud_repo_yum_repository_priority
}
if ($env:PT_varnish_yum_repo_baseurl) {
  $ExtraVars['varnish_yum_repo_baseurl'] = $env:PT_varnish_yum_repo_baseurl
}
if ($env:PT_varnish_apt_repo) {
  $ExtraVars['varnish_apt_repo'] = $env:PT_varnish_apt_repo
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_varnish"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_varnish"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}
