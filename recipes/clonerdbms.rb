#
# Cookbook Name:: oracle-omni
# Recipe:: clonerdbms
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

dir = node['oracle-omni']['oracle']['install_dir']
url = node['oracle-omni']['oracle']['clone_url']
file = node['oracle-omni']['rdbms']['clone_file']
oh = node['oracle-omni']['rdbms']['oracle_home']
ob = node['oracle-omni']['rdbms']['oracle_base']
inv = node['oracle-omni']['oracle']['oracle_inventory']
usr = node['oracle-omni']['rdbms']['user']
grp = node['oracle-omni']['rdbms']['groups'].keys.first

# Download RDBMS tarball
remote_file "#{dir}/#{file}" do
  owner usr
  group grp
  mode '0644'
  source "#{url}/#{file}"
  not_if { File.exist?("#{oh}/bin") }
end

# Unpack tarball
execute 'untar_rdbms' do
  command "tar -zxf #{dir}/#{file}"
  cwd oh
  not_if { File.exist?("#{oh}/bin") }
end

# Remove tarball
file "#{dir}/#{file}" do
  action :delete
  owner usr
  group grp
  only_if { File.exist?("#{dir}/#{file}") }
  only_if { File.exist?("#{oh}/bin") }
end

execute 'clean_home' do
  command 'rm -rf network/admin/*.ora ccr/state/*.ll*'
  cwd oh
  not_if "grep -q \"#{oh}\" #{inv}/ContentsXML/inventory.xml"
end

execute 'clone_home' do
  command "#{oh}/perl/bin/perl #{oh}/clone/bin/clone.pl -silent \
  ORACLE_BASE=#{ob} ORACLE_HOME=#{oh} \
  ORACLE_HOME_NAME=OraDBHome OSDBA_GROUP=dba OSOPER_GROUP=oper \
  OSBACKUPDBA_GROUP=backupdba OSDGDBA_GROUP=dgdba OSKMDBA_GROUP=kmdba"
  user usr
  group grp
  not_if "grep -q \"#{oh}\" #{inv}/ContentsXML/inventory.xml"
end

execute 'run_root' do
  command "#{oh}/root.sh"
  user 'root'
  group 'root'
end
