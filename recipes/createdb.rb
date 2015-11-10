#
# Cookbook Name:: oracle-omni
# Recipe:: createdb
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

ob = node['oracle-omni']['rdbms']['oracle_base']
oh = node['oracle-omni']['rdbms']['oracle_home']
usr = node['oracle-omni']['rdbms']['user']
grp = node['oracle-omni']['rdbms']['groups'].keys.first
sid = node['oracle-omni']['rdbms']['sid']

template "#{oh}/assistants/dbca/dbca.rsp" do
  source "#{node['oracle-omni']['rdbms']['version']}/dbca.rsp.erb"
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
  command "su -c 'export ORACLE_BASE=#{ob}; \
    export TNS_ADMIN=#{oh}/network/admin; #{oh}/bin/dbca -silent \
    -responseFile #{oh}/assistants/dbca/dbca.rsp' - #{usr}"
  not_if "#{oh}/bin/srvctl status database -d #{sid}", environment: {
    'ORACLE_HOME' => oh
  }
end
