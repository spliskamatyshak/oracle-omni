#
# Cookbook Name:: oracle-omni
# Recipe:: createusers
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

# Groups for GI owner

node['oracle-omni']['grid']['groups'].each_key do |grp|
  group grp do
    gid node['oracle-omni']['grid']['groups'][grp]
  end
end

# GI owner

user node['oracle-omni']['grid']['user'] do
  uid node['oracle-omni']['grid']['uid']
  gid node['oracle-omni']['grid']['groups'].keys.first
  comment 'Oracle GI Administrator'
  supports manage_home: true
  shell '/bin/ksh'
end

# Assign groups to GI owner

node['oracle-omni']['grid']['groups'].each_key do |grp|
  group grp do
    members node['oracle-omni']['grid']['user']
    action :modify
    append true
  end
end

# Groups for RDBMS owner

node['oracle-omni']['rdbms']['groups'].each_key do |grp|
  group grp do
    gid node['oracle-omni']['rdbms']['groups'][grp]
  end
end

# RDBMS owner

user node['oracle-omni']['rdbms']['user'] do
  uid node['oracle-omni']['rdbms']['uid']
  gid node['oracle-omni']['rdbms']['groups'].keys.first
  comment 'Oracle RDBMS Administrator'
  supports manage_home: true
  shell '/bin/ksh'
end

# Assign groups to RDBMS owner

node['oracle-omni']['rdbms']['groups'].each_key do |grp|
  group grp do
    members node['oracle-omni']['rdbms']['user']
    action :modify
    append true
  end
end
