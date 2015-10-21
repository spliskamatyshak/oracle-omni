#
# Cookbook Name:: oracle-omni
# Recipe:: clonegi
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

if 'ohai etc | grep vagrant'
  file '/etc/profile.d/no_proxy.sh' do
    content 'export no_proxy=localhost,127.0.0.1,10.,3.'
    owner 'root'
    group 'root'
    mode '0644'
  end
end
