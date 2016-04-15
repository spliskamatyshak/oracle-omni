#
# Cookbook Name:: oracle-omni
# Recipe:: createdbdgs
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

arg =
  case node['oracle-omni']['rdbms']['version'].to_i
  when 11
    'g'
  when 12
    'diskgroup'
  end

cnt = 0
disklist = ''

node['oracle-omni']['grid']['data_disks'].each do |disk|
  cnt += 1
  suffix = disk['md'] ? '' : '1'
  disk = node['oracle-omni']['grid']['discovery_string'] + 'DATA_' + File.basename(disk).upcase + suffix
  disklist += disk
  disklist += ',' if cnt < node['oracle-omni']['grid']['data_disks'].count
end

execute 'create_data_dg' do
  command "#{oh}/bin/asmca -silent -createDiskGroup -diskGroupName DATA_DG \
    -diskList #{disklist} -redundancy EXTERNAL"
  user usr
  group grp
  not_if "#{oh}/bin/srvctl status diskgroup -#{arg} DATA_DG", user: usr
end

cnt = 0
disklist = ''

node['oracle-omni']['grid']['log_disks'].each do |disk|
  cnt += 1
  suffix = disk['md'] ? '' : '1'
  disk = node['oracle-omni']['grid']['discovery_string'] + 'LOG_' + File.basename(disk).upcase + suffix
  disklist += disk
  disklist += ',' if cnt < node['oracle-omni']['grid']['log_disks'].count
end

execute 'create_log_dg' do
  command "#{oh}/bin/asmca -silent -createDiskGroup -diskGroupName LOG_DG \
    -diskList #{disklist} -redundancy EXTERNAL"
  user usr
  group grp
  not_if "#{oh}/bin/srvctl status diskgroup -#{arg} LOG_DG", user: usr
end
