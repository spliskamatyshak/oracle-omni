#
# Cookbook Name:: oracle-omni
# Recipe:: partitiondisks
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

node['oracle-omni']['grid']['data_disks'].each do |disk|
  parted_disk disk do
    action :mkpart
    not_if { disk.include? 'md' }
  end
end

node['oracle-omni']['grid']['log_disks'].each do |disk|
  parted_disk disk do
    action :mkpart
    not_if { disk.include? 'md' }
  end
end
