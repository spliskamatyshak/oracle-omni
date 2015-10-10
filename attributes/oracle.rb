#
# Cookbook Name:: oracle-omni
# Attributes:: oracle
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

default['oracle-omni']['oracle']['files_url'] = nil

default['oracle-omni']['oracle']['patch_files'] =
case node['oracle-omni']['rdbms']['version']
when '11.2.0.4'
  %w(
    p20760982_112040_Linux-x86-64.zip
    p21068539_112040_Linux-x86-64.zip
  )
when '12.1.0.1'
  %w(p21150817_121010_Linux-x86-64.zip)
when '12.1.0.2'
  %w(p21150782_121020_Linux-x86-64.zip)
end
