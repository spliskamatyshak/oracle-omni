#
# Cookbook Name:: oracle-omni
# Recipe:: partitiondisks
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

parted_disk node['oracle-omni']['grid']['data_disk'] do
  action :mkpart
  not_if { node['oracle-omni']['grid']['data_disk'].include? 'md' }
end

parted_disk node['oracle-omni']['grid']['log_disk'] do
  action :mkpart
  not_if { node['oracle-omni']['grid']['log_disk'].include? 'md' }
end
