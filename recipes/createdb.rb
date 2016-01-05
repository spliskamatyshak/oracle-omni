#
# Cookbook Name:: oracle-omni
# Recipe:: createdb
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

ob = node['oracle-omni']['rdbms']['oracle_base']
oh = node['oracle-omni']['rdbms']['oracle_home']
usr = node['oracle-omni']['rdbms']['user']
grp = node['oracle-omni']['rdbms']['groups'].keys.first
sid = node['oracle-omni']['rdbms']['sid']

pwd_content = Chef::EncryptedDataBagItem.load(
  node['oracle-omni']['oracle']['data_bag'],
  usr
)
rdbms_pwd = pwd_content['password']

pwd_content = Chef::EncryptedDataBagItem.load(
  node['oracle-omni']['oracle']['data_bag'],
  node['oracle-omni']['grid']['user']
)
asm_pwd = pwd_content['password']

template "#{oh}/assistants/dbca/dbca.rsp" do
  source "#{node['oracle-omni']['rdbms']['version']}/dbca.rsp.erb"
  variables(
    rdbms_password: rdbms_pwd,
    asm_password: asm_pwd
  )
  sensitive true
  owner usr
  group grp
  mode '0775'
end

directory "#{ob}/cfgtoollogs" do
  mode '0775'
end

directory "#{ob}/admin" do
  mode '0770'
end

%w(listener sqlnet).each do |file|
  link "#{oh}/network/admin/#{file}.ora" do
    to "#{node['oracle-omni']['grid']['oracle_home']}/network/admin/#{file}.ora"
  end
end

execute 'create_db' do
  command "setenforce 0; su -c 'export ORACLE_BASE=#{ob}; \
    export TNS_ADMIN=#{oh}/network/admin; #{oh}/bin/dbca -silent \
    -responseFile #{oh}/assistants/dbca/dbca.rsp' - #{usr}; \
    setenforce 1"
  not_if "#{oh}/bin/srvctl status database -d #{sid}", environment: {
    'ORACLE_HOME' => oh
  }
end
