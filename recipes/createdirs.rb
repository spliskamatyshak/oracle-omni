#
# Cookbook Name:: oracle-omni
# Recipe:: createdirs
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

unless node.attribute?('dirs_created')

  rusr = node['oracle-omni']['rdbms']['user']
  rgrp = node['oracle-omni']['rdbms']['groups'].keys.first
  gusr = node['oracle-omni']['grid']['user']
  ggrp = node['oracle-omni']['grid']['groups'].keys.first
  mnt = node['oracle-omni']['oracle']['home_mount']

  [
    node['oracle-omni']['rdbms']['oracle_base'],
    node['oracle-omni']['grid']['oracle_home'],
    node['oracle-omni']['oracle']['oracle_inventory'],
    node['oracle-omni']['rdbms']['oracle_home']
  ].each do |dirs|
    directory dirs do
      owner gusr
      group ggrp
      mode '0775'
      recursive true
    end
  end

  directory node['oracle-omni']['oracle']['install_dir'] do
    owner gusr
    group ggrp
    mode '0775'
    recursive true
    not_if { node['oracle-omni']['oracle']['files_url'].nil? }
  end

  directory node['oracle-omni']['oracle']['patch_dir'] do
    owner gusr
    group ggrp
    mode '0775'
    recursive true
    not_if { node['oracle-omni']['oracle']['patch_dir'].empty? }
  end

  execute 'set_grid_owner' do
    command "chown -R #{gusr}:#{ggrp} #{mnt}"
  end

  execute 'set_home_mount_mode' do
    command "chmod -R 775 #{mnt}/"
  end

  execute 'oracle_ownership' do
    command "chown -R #{rusr}:#{rgrp} #{node['oracle-omni']['rdbms']['oracle_base']}"
  end

  node.normal['dirs_created'] = true
  node.save

end
