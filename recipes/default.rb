#
# Cookbook Name:: oracle-omni
# Recipe:: default
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'oracle-omni::prephost'

if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'
  if node['oracle-omni']['oracle']['clone_homes']
    include_recipe 'oracle-omni::clonegi'
  else
    include_recipe 'oracle-omni::installgi'
    include_recipe 'oracle-omni::configureasm'
  end
end

if node['oracle-omni']['oracle']['clone_homes']
  include_recipe 'oracle-omni::clonerdbms'
else
  include_recipe 'oracle-omni::installrdbms'
end

if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'
  include_recipe 'oracle-omni::createdbdgs'
else
  include_recipe 'oracle-omni::createmtpts'
end

include_recipe 'oracle-omni::createdb'
