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
op_loc = node['oracle-omni']['oracle']['opatch_loc']
oh = node['oracle-omni']['rdbms']['oracle_home']
usr = node['oracle-omni']['rdbms']['user']
grp = node['oracle-omni']['rdbms']['groups'].keys.first
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

if url.nil?
  execute 'copy_patch' do
    command "cp #{op_loc}/#{node['oracle-omni']['oracle']['patch_file']} #{pdir}"
    user usr
    group grp
    not_if { op_loc.nil? }
    not_if { File.exist?("#{pdir}/#{pch}") }
  end
else
  remote_file "#{pdir}/#{pch}" do
    source "#{url}/#{node['oracle-omni']['oracle']['patch_file']}"
    owner usr
    group grp
    mode '0644'
    action :create_if_missing
  end
end

execute 'unzip_patch' do
  command "unzip -n #{pch}"
  user usr
  group grp
  cwd pdir
  not_if { File.directory?("#{pdir}/#{pnm}") }
end

execute 'patch_homes' do
  command "#{pch_cmd} #{pdir}/#{pnm} -oh #{oh} -ocmrf #{pdir}/ocm.rsp"
  environment(
    'PATH' => "#{ENV['PATH']}:#{oh}/OPatch"
  )
  user 'root'
  group 'root'
  only_if { File.directory?("#{pdir}/#{pnm}") }
end
