#
# Cookbook Name:: oracle-omni
# Recipe:: createdirs
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

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
  not_if "ls -ld #{mnt} | grep #{gusr} | grep -q #{ggrp}"
end

execute 'set_home_mount_mode' do
  command "chmod -R 775 #{mnt}/"
  not_if "ls -ld #{mnt} | grep -q drwxrwxr-x"
end

# Create rdbms home

execute 'oracle_ownership' do
  command "chown -R #{rusr}:#{rgrp} \
  #{node['oracle-omni']['rdbms']['oracle_base']}"
  not_if "ls -ld #{node['oracle-omni']['rdbms']['oracle_base']} | grep -q #{rusr}"
end
