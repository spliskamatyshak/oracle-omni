#
# Cookbook Name:: oracle-omni
# Recipe:: installrpms
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

yum_package node['oracle-omni']['oracle']['preinstall_rpm']

if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'
  node['oracle-omni']['oracle']['asm_rpms'].each do |rpm|
    yum_package rpm
  end
end
