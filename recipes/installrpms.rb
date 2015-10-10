#
# Cookbook Name:: oracle-omni
# Recipe:: installrpms
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

yum_package node['oracle-omni']['oracle']['preinstall_rpm']

yum_package node['oracle-omni']['oracle']['asm_support_rpm'] if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'

file_loc = Chef::Config['file_cache_path']
url = node['oracle-omni']['oracle']['asmlib_rpm_url']
rpm = node['oracle-omni']['oracle']['asmlib_rpm']

yum_package 'asmlib' do
  source "#{file_loc}/#{rpm}"
  action :nothing
  not_if { File.exist?('/opt/oracle/extapi/64/asm/orcl/1/libasm.so') }
end

remote_file "#{file_loc}/#{rpm}" do
  source "#{url}/#{rpm}"
  action :create_if_missing
  notifies :install, 'yum_package[asmlib]', :immediately
  only_if { node['oracle-omni']['rdbms']['storage_type'] == 'ASM' }
end
