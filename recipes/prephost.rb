#
# Cookbook Name:: oracle-omni
# Recipe:: prephost
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'oracle-omni::installrpms'
include_recipe 'oracle-omni::createusers'
include_recipe 'oracle-omni::createdirs'
include_recipe 'oracle-omni::setupasm' if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'
