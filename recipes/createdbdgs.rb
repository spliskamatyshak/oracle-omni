#
# Cookbook Name:: oracle-omni
# Recipe:: createdbdgs
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
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
  disk = 'ORCL:DATA_' + File.basename(disk) + suffix
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
  disk = 'ORCL:LOG_' + File.basename(disk) + suffix
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
