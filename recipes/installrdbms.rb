#
# Cookbook Name:: oracle-omni
# Recipe:: installrdbms
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

usr = node['oracle-omni']['rdbms']['user']
grp = node['oracle-omni']['rdbms']['groups'].keys.first
dir = node['oracle-omni']['oracle']['install_dir']
rdir = node['oracle-omni']['rdbms']['install_dir']
oh = node['oracle-omni']['rdbms']['oracle_home']
inv = node['oracle-omni']['oracle']['oracle_inventory']
url = node['oracle-omni']['oracle']['files_url']
op = node['oracle-omni']['oracle']['opatch']

node['oracle-omni']['rdbms']['install_files'].each do |zip_file|
  remote_file "#{dir}/#{File.basename(zip_file)}" do
    source "#{url}/#{zip_file}"
    user usr
    group grp
    not_if { File.exist?("#{dir}/#{File.basename(zip_file)}") }
    not_if { File.directory?("#{rdir}/stage/Components/oracle.rdbms") }
    not_if { File.directory?("#{oh}/bin") }
  end
  execute "unzip_media_#{zip_file}" do
    command "unzip -n #{File.basename(zip_file)}"
    user usr
    group grp
    cwd dir
    only_if { File.exist?("#{dir}/#{File.basename(zip_file)}") }
  end
  file "#{dir}/#{File.basename(zip_file)}" do
    owner usr
    group grp
    action :delete
    only_if { File.exist?("#{dir}/#{File.basename(zip_file)}") }
  end
end

template '/etc/oraInst.loc' do
  source 'oraInst.loc.erb'
  mode '0644'
  not_if { File.exist?('/etc/oraInst.loc') }
end

template "#{rdir}/response/db_install.rsp" do
  source "#{node['oracle-omni']['rdbms']['version']}/db_install.rsp.erb"
  user usr
  group grp
  mode '0644'
  only_if { File.directory?(rdir) }
end

execute 'rdbms_install' do
  command "su -c '#{rdir}/runInstaller -silent -waitforcompletion \
  -ignoreSysPrereqs -ignorePrereq \
  -responseFile #{rdir}/response/db_install.rsp' - #{usr}"
  environment(
    'TMP' => '/tmp',
    'TMPDIR' => '/tmp',
    'DISPLAY' => "#{node['hostname']}:0.0"
  )
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
end

remote_file "#{oh}/#{op}" do
  source "#{url}/#{op}"
  user usr
  group grp
  not_if { File.exist?("#{oh}/#{op}") }
end

execute 'backup_opatch' do
  command 'mv OPatch OPatch.orig'
  user usr
  group grp
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

execute 'clean_rdbms_media' do
  command "rm -rf #{rdir}"
  user usr
  group grp
  only_if { File.directory?(rdir) }
end
