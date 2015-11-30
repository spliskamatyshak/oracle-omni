#
# Cookbook Name:: oracle-omni
# Recipe:: setlimits
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

[
  node['oracle-omni']['grid']['user'],
  node['oracle-omni']['rdbms']['user']
].each do |usr|
  template "/etc/security/limits.d/99-#{usr}.conf" do
    source 'limits.conf.erb'
    variables(
      usr: usr
    )
    owner 'root'
    group 'root'
    mode '0644'
  end
end

execute 'set_kernel_panic' do
  command 'sysctl -w kernel.panic=1'
end

execute 'set_swappiness' do
  command 'sysctl -w vm.swappiness=100'
end

include_recipe 'iptables'

iptables_rule 'lsnr_port' do
  action :enable
end
