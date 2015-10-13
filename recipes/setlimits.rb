#
# Cookbook Name:: oracle-omni
# Recipe:: setlimits
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

cookbook_file '/etc/security/limits.d/99-grid.conf' do
  source '99-grid.conf'
  owner 'root'
  group 'root'
  mode '0644'
end
