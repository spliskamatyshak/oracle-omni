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
    include_recipe 'oracle-omni::configureasm'
  else
    include_recipe 'oracle-omni::installgi'
    include_recipe 'oracle-omni::configureasm'
    include_recipe 'oracle-omni::patchgi'
  end
end

if node['oracle-omni']['oracle']['clone_homes']
  include_recipe 'oracle-omni::clonerdbms'
else
  include_recipe 'oracle-omni::installrdbms'
  include_recipe 'oracle-omni::patchrdbms'
end

if node['oracle-omni']['rdbms']['storage_type'] == 'ASM'
  include_recipe 'oracle-omni::createdbdgs'
else
  include_recipe 'oracle-omni::createmtpts'
end

include_recipe 'oracle-omni::createdb'
