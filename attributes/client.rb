#
# Cookbook Name:: oracle-omni
# Attributes:: agent
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

default['oracle-omni']['client']['version'] = '12.1.0.2'
default['oracle-omni']['client']['is_32bit'] = false

default['oracle-omni']['client']['install_file'] =
case node['oracle-omni']['client']['version']
when '11.2.0.4'
  if node['oracle-omni']['client']['is_32bit']
    'p13390677_112040_LINUX_4of7.zip'
  else
    'p13390677_112040_Linux-x86-64_4of7.zip'
  end
when '12.1.0.1'
  if node['oracle-omni']['client']['is_32bit']
    'linux_12c_client32.zip'
  else
    'linuxamd64_12c_client.zip'
  end
when '12.1.0.2'
  if node['oracle-omni']['client']['is_32bit']
    'linux_12102_client32.zip'
  else
    'linuxamd64_12102_client.zip'
  end
end
