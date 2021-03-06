#
# Cookbook Name:: oracle-omni
# Recipe:: configureasm
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

oh = node['oracle-omni']['grid']['oracle_home']
usr = node['oracle-omni']['grid']['user']
grp = node['oracle-omni']['grid']['groups'].keys.first

pwd_content = Chef::EncryptedDataBagItem.load(
  node['oracle-omni']['oracle']['data_bag'],
  usr
)
pwd = pwd_content['password']

execute 'start_cssd' do
  command "#{oh}/bin/crs_start ora.cssd"
  user usr
  group grp
  not_if "#{oh}/bin/crsctl check css", user: usr
end

suffix = node['oracle-omni']['grid']['ocr_disk']['md'] ? '' : '1'
disk = node['oracle-omni']['grid']['discovery_string'] + 'OCR_' + File.basename(node['oracle-omni']['grid']['ocr_disk']).upcase + suffix

execute 'configure_asm' do
  command "#{oh}/bin/asmca -silent -configureASM -sysASMPassword #{pwd} \
    -asmsnmpPassword #{pwd} -diskGroupName SYSTEM_DG -diskList #{disk} \
    -redundancy EXTERNAL"
  user usr
  group grp
  sensitive true
  not_if "#{oh}/bin/srvctl config asm", user: usr
end

execute 'configure_listener' do
  command "#{oh}/bin/netca -silent \
    -responseFile #{oh}/assistants/netca/netca.rsp"
  user usr
  group grp
  not_if "#{oh}/bin/srvctl config listener", user: usr
end
