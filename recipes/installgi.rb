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
op_loc = node['oracle-omni']['oracle']['opatch_loc']
rsp_dir = Chef::Config['file_cache_path']

pwd_content = Chef::EncryptedDataBagItem.load(
  node['oracle-omni']['oracle']['data_bag'],
  usr
)
asm_pwd = pwd_content['password']

unless url.nil?
  node['oracle-omni']['grid']['install_files'].each do |zip_file|
    remote_file "#{dir}/#{File.basename(zip_file)}" do
      source "#{url}/#{zip_file}"
      user usr
      group grp
      not_if { File.exist?("#{dir}/#{File.basename(zip_file)}") }
      not_if { File.exist?("#{gdir}/install/.oui") }
      not_if { File.directory?("#{oh}/bin") }
    end
    execute "unzip_media_#{zip_file}" do
      command "unzip -n #{File.basename(zip_file)}"
      user usr
      group grp
      cwd dir
      only_if { File.exist?("#{dir}/#{File.basename(zip_file)}") }
    end
    file "#{dir}/#{zip_file}" do
      owner usr
      group grp
      action :delete
      only_if { File.exist?("#{dir}/#{File.basename(zip_file)}") }
    end
  end
end

template '/etc/oraInst.loc' do
  source 'oraInst.loc.erb'
  mode '0644'
end

template "#{rsp_dir}/grid_install.rsp" do
  source "#{node['oracle-omni']['rdbms']['version']}/grid_install.rsp.erb"
  variables(
    asm_pasword: asm_pwd,
    disc_string: "#{node['oracle-omni']['grid']['discovery_string']}*"
  )
  user usr
  group grp
  mode '0644'
  sensitive true
end

yum_package 'cvuqdisk' do
  source "#{gdir}/rpm/#{node['oracle-omni']['grid']['cvuqdisk_rpm']}"
  only_if { File.exist?("#{gdir}/rpm/#{node['oracle-omni']['grid']['cvuqdisk_rpm']}") }
end

execute 'gi_install' do
  command "su -c '#{gdir}/runInstaller -silent -waitforcompletion \
  -ignoreSysPrereqs -ignorePrereq \
  -responseFile #{rsp_dir}/grid_install.rsp' - #{usr}"
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
  not_if { File.directory?('/opt/ORCLfmap') }
end

directory oh do
  owner usr
  group grp
  mode '0775'
end

if url.nil?
  execute 'copy_opatch' do
    command "cp #{op_loc}/#{op} #{oh}"
    not_if { op_loc.nil? }
    not_if { File.exist?("#{oh}/#{File.basename(op)}") }
  end
else
  remote_file "#{oh}/#{File.basename(op)}" do
    source "#{url}/#{op}"
    user usr
    group grp
    not_if { File.exist?("#{oh}/#{File.basename(op)}") }
  end
end

execute 'backup_opatch' do
  command 'mv OPatch OPatch.orig'
  user usr
  group grp
  cwd oh
  not_if { File.directory?("#{oh}/OPatch.orig") }
  only_if { File.exist?("#{oh}/#{File.basename(op)}") }
end

execute "unzip_#{File.basename(op)}" do
  command "unzip -n #{File.basename(op)}"
  user usr
  group grp
  cwd oh
  not_if { File.directory?("#{oh}/OPatch") }
end

directory gdir do
  action :delete
  recursive true
  user usr
  group grp
  only_if { File.directory?(gdir) }
  not_if { url.nil? }
end
