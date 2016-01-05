#
# Cookbook Name:: oracle-omni
# Recipe:: installrpms
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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

include_recipe 'parted'
