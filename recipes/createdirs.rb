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

[
  node['oracle-omni']['rdbms']['oracle_base'],
  node['oracle-omni']['rdbms']['oracle_home'],
  node['oracle-omni']['grid']['oracle_home']
].each do |dirs|
  directory dirs do
    owner rusr
    group rgrp
    mode '0775'
    recursive true
  end
end

execute 'set_rdbms_owner' do
  command "chown -R #{rusr}:#{rgrp} #{node['oracle-omni']['oracle']['home_mount']}/"
end

gusr = node['oracle-omni']['grid']['user']
ggrp = node['oracle-omni']['grid']['groups'].keys.first

directory node['oracle-omni']['grid']['oracle_home'] do
  owner gusr
  group ggrp
  mode '0775'
  recursive true
end

execute 'set_gi_owner' do
  command "chown -R #{gusr}:#{ggrp} #{node['oracle-omni']['grid']['oracle_home']}"
end

execute 'set_home_mount_mode' do
  command "chmod -R 775 #{node['oracle-omni']['oracle']['home_mount']}/"
end

# Create other directories necessary for installs

directory node['oracle-omni']['oracle']['oracle_inventory'] do
  owner gusr
  group ggrp
  mode '0775'
end

directory node['oracle-omni']['oracle']['install_dir'] do
  owner gusr
  group ggrp
  mode '0770'
end
