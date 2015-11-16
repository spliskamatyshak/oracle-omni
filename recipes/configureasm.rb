#
# Cookbook Name:: oracle-omni
# Recipe:: configureasm
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

oh = node['oracle-omni']['grid']['oracle_home']
usr = node['oracle-omni']['grid']['user']
grp = node['oracle-omni']['grid']['groups'].keys.first

pwd_content = Chef::EncryptedDataBagItem.load(node['oracle-omni']['oracle']['data_bag'], usr)
pwd = pwd_content['password']

execute 'start_cssd' do
  command "#{oh}/bin/crs_start ora.cssd"
  user usr
  group grp
  not_if "#{oh}/bin/crsctl check css", user: usr
end

execute 'configure_asm' do
  command "#{oh}/bin/asmca -silent -configureASM -sysASMPassword #{pwd} \
    -asmsnmpPassword #{pwd} -diskGroupName SYSTEM_DG -diskList ORCL:OCR \
    -redundancy EXTERNAL"
  user usr
  group grp
  not_if "#{oh}/bin/srvctl config asm", user: usr
end

execute 'configure_listener' do
  command "#{oh}/bin/netca -silent \
    -responseFile #{oh}/assistants/netca/netca.rsp"
  user usr
  group grp
  not_if "#{oh}/bin/srvctl config listener", user: usr
end
