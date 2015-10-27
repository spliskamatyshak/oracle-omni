#
# Cookbook Name:: oracle-omni
# Recipe:: patchhomes
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

url = node['oracle-omni']['oracle']['files_url']
pdir = node['oracle-omni']['oracle']['patch_dir']
pch = File.basename(node['oracle-omni']['oracle']['patch_file'])
pnm = pch.slice(1, 8)
oh = node['oracle-omni']['grid']['oracle_home']
usr = node['oracle-omni']['grid']['user']
grp = node['oracle-omni']['grid']['groups'].keys.first
pch_cmd =
case node['oracle-omni']['rdbms']['version']
when '11.2.0.4'
  'opatch auto'
else
  'opatchauto apply'
end

cookbook_file "#{pdir}/ocm.rsp" do
  source 'ocm.rsp'
  owner usr
  group grp
  mode '0644'
  action :create_if_missing
end

remote_file "#{pdir}/#{pch}" do
  source "#{url}/#{node['oracle-omni']['oracle']['patch_file']}"
  owner usr
  group grp
  mode '0644'
  action :create_if_missing
end

execute 'unzip_patch' do
  command "unzip -n #{pch}"
  user usr
  group grp
  cwd pdir
  not_if { File.directory?("#{pdir}/#{pnm}") }
end

execute 'patch_homes' do
  command "#{pch_cmd} -ocmrf #{pdir}/ocm.rsp"
  environment(
    'PATH' => "$PATH:#{oh}/OPatch"
  )
  user 'root'
  cwd "#{pdir}/#{pnm}"
end
