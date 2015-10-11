#
# Cookbook Name:: oracle-omni
# Recipe:: installgi
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

node['oracle-omni']['grid']['install_files'].each do |zip_file|
  remote_file "#{node['oracle-omni']['oracle']['install_dir']}/#{zip_file}" do
    source "#{node['oracle-omni']['oracle']['files_url']}/#{zip_file}"
    user node['oracle-omni']['grid']['user']
    group node['oracle-omni']['grid']['groups'].keys.first
    not_if { File.exist?("#{node['oracle-omni']['oracle']['install_dir']}/#{zip_file}") }
    not_if { File.exist?("#{node['oracle-omni']['grid']['install_dir']}/install/.oui") }
  end
  execute "unzip_media_#{zip_file}" do
    command "unzip -n #{File.basename(zip_file)}"
    user node['oracle-omni']['grid']['user']
    group node['oracle-omni']['grid']['groups'].keys.first
    cwd node['oracle-omni']['oracle']['install_dir']
    not_if { File.exist?("#{node['oracle-omni']['grid']['install_dir']}/install/.oui") }
  end
  file "#{node['oracle-omni']['oracle']['install_dir']}/#{zip_file}" do
    owner node['oracle-omni']['grid']['user']
    group node['oracle-omni']['grid']['groups'].keys.first
    action :delete
    only_if { File.exist?("#{node['oracle-omni']['oracle']['install_dir']}/#{zip_file}") }
  end
end

template '/etc/oraInst.loc' do
  source 'oraInst.loc.erb'
  mode '0644'
end

template "#{node['oracle-omni']['grid']['install_dir']}/response/grid_install.rsp" do
  source "#{node['oracle-omni']['rdbms']['version']}/grid_install.rsp.erb"
  user node['oracle-omni']['grid']['user']
  group node['oracle-omni']['grid']['groups'].keys.first
  mode '0644'
end

yum_package 'cvuqdisk' do
  source "#{node['oracle-omni']['grid']['install_dir']}/rpm/#{node['oracle-omni']['grid']['cvuqdisk_rpm']}"
end

execute 'gi_install' do
  command "su -c '#{node['oracle-omni']['grid']['install_dir']}/runInstaller -silent -waitforcompletion -ignoreSysPrereqs -ignorePrereq -responseFile #{node['oracle-omni']['grid']['install_dir']}/response/grid_install.rsp' - #{node['oracle-omni']['grid']['user']}"
  environment(
    'TMP' => '/tmp',
    'TMPDIR' => '/tmp',
    'DISPLAY' => "#{node['hostname']}:0.0"
  )
  returns [0, 6]
  not_if { File.directory?("#{node['oracle-omni']['grid']['oracle_home']}/bin") }
end

execute 'run_orainstRoot' do
  command "#{node['oracle-omni']['oracle']['ora_inventory']}/orainstRoot.sh"
  not_if "grep -q \"#{node['oracle-omni']['grid']['oracle_home']}\" #{node['oracle-omni']['oracle']['oracle_inventory']}/ContextXML/inventory.xml"
  only_if { File.exist?("#{node['oracle-omni']['oracle']['ora_inventory']}/orainstRoot.sh") }
end

execute 'run_root' do
  command "#{node['oracle-omni']['grid']['oracle_home']}/root.sh"
  not_if { File.directory?('/opt/ORCLfmap') }
end
