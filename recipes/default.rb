#
# Cookbook Name:: oracle-omni
# Recipe:: default
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'oracle-omni::prephost'
include_recipe 'oracle-omni::installgi' if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'
include_recipe 'oracle-omni::installrdbms'
include_recipe 'oracle-omni::configureasm' if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'
if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'
  include_recipe 'oracle-omni::createdbdgs'
else
  include_recipe 'oracle-omni::createmtpts'
end
include_recipe 'oracle-omni::createdb'
