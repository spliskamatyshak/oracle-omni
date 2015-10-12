#
# Cookbook Name:: oracle-omni
# Recipe:: installgi
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

usr = node['oracle-omni']['grid']['user']
grp = node['oracle-omni']['grid']['groups'].keys.first
dir = node['oracle-omni']['oracle']['install_dir']
gdir = node['oracle-omni']['grid']['install_dir']
oh = node['oracle-omni']['grid']['oracle_home']
inv = node['oracle-omni']['oracle']['oracle_inventory']
url = node['oracle-omni']['oracle']['files_url']
op = node['oracle-omni']['oracle']['opatch']
# pdir = node['oracle-omni']['oracle']['patch_dir']

node['oracle-omni']['grid']['install_files'].each do |zip_file|
  remote_file "#{dir}/#{zip_file}" do
    source "#{url}/#{zip_file}"
    user usr
    group grp
    not_if { File.exist?("#{dir}/#{zip_file}") }
    not_if { File.exist?("#{gdir}/install/.oui") }
  end
  execute "unzip_media_#{zip_file}" do
    command "unzip -n #{File.basename(zip_file)}"
    user usr
    group grp
    cwd dir
    not_if { File.exist?("#{gdir}/install/.oui") }
  end
  file "#{dir}/#{zip_file}" do
    owner usr
    group grp
    action :delete
    only_if { File.exist?("#{dir}/#{zip_file}") }
  end
end

template '/etc/oraInst.loc' do
  source 'oraInst.loc.erb'
  mode '0644'
end

template "#{gdir}/response/grid_install.rsp" do
  source "#{node['oracle-omni']['rdbms']['version']}/grid_install.rsp.erb"
  user usr
  group grp
  mode '0644'
end

yum_package 'cvuqdisk' do
  source "#{gdir}/rpm/#{node['oracle-omni']['grid']['cvuqdisk_rpm']}"
end

execute 'gi_install' do
  command "./runInstaller -silent -waitforcompletion \
  -ignoreSysPrereqs -ignorePrereq \
  -responseFile #{gdir}/response/grid_install.rsp"
  environment(
    'TMP' => '/tmp',
    'TMPDIR' => '/tmp',
    'DISPLAY' => "#{node['hostname']}:0.0"
  )
  user usr
  group grp
  cwd gdir
  returns [0, 6]
  not_if { File.directory?("#{oh}/bin") }
end

execute 'run_orainstRoot' do
  command "#{inv}/orainstRoot.sh"
  not_if "grep -q \"#{oh}\" #{inv}/ContextXML/inventory.xml"
  only_if { File.exist?("#{inv}/orainstRoot.sh") }
end

execute 'run_root' do
  command "#{oh}/root.sh"
  not_if { File.directory?('/opt/ORCLfmap') }
end

remote_file "#{oh}/#{op}" do
  source "#{url}/#{op}"
  user usr
  group grp
  not_if { File.exist?("#{oh}/#{op}") }
end

execute 'backup_opatch' do
  command 'mv OPatch OPatch.orig'
  cwd oh
  not_if { File.directory?("#{oh}/OPatch.orig") }
end

execute "unzip_#{op}" do
  command "unzip -n #{File.basename(op)}"
  user usr
  group grp
  cwd oh
  not_if { File.directory?("#{oh}/OPatch") }
end
