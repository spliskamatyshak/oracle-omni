#
# Cookbook Name:: oracle-omni
# Recipe:: clonegi
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

file '/etc/profile.d/no_proxy.sh' do
  content 'export no_proxy=localhost,127.0.0.1,10.,3.,ge.com'
  owner 'root'
  group 'root'
  mode '0644'
  only_if 'ohai etc | grep vagrant'
end
