#
# Cookbook Name:: oracle-omni
# Recipe:: createdb
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

oh = node['oracle-omni']['rdbms']['oracle_home']
usr = node['oracle-omni']['rdbms']['user']
grp = node['oracle-omni']['rdbms']['groups'].keys.first
sid = node['oracle-omni']['rdbms']['sid']

arg =
case node['oracle-omni']['rdbms']['version'].to_i
when 11
  'd'
when 12
  'db'
end

template "#{oh}/assistants/dbca/dbca.rsp" do
  source "#{node['oracle-omni']['rdbms']['version']}/dbca.rsp.erb"
  owner usr
  group grp
  mode '0775'
end

directory "#{node['oracle-omni']['rdbms']['oracle_base']}/cfgtoollogs" do
  owner usr
  group grp
  mode '0775'
end

execute 'create_db' do
  command "./dbca -silent -responseFile #{oh}/assistants/dbca/dbca.rsp \
    -continueOnNonFatalErrors true"
  environment(
    'ORACLE_HOME' => oh
  )
  user usr
  group grp
  cwd "#{oh}/bin"
  umask '0022'
  not_if "export ORACLE_HOME=#{oh}; \
    #{oh}/bin/srvctl status database -#{arg} #{sid}"
end
