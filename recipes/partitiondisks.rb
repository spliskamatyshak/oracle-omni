#
# Cookbook Name:: oracle-omni
# Recipe:: partitiondisks
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

node['oracle-omni']['grid']['data_disks'].each do |disk|
  next if disk.include? 'md'

  parted_disk disk do
    action :mklabel
  end

  parted_disk disk do
    action :mkpart
  end
end

node['oracle-omni']['grid']['log_disks'].each do |disk|
  next if disk.include? 'md'

  parted_disk disk do
    action :mklabel
  end

  parted_disk disk do
    action :mkpart
  end
end
