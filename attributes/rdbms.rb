#
# Cookbook Name:: oracle-omni
# Attributes:: rdbms
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

default['oracle-omni']['rdbms']['version'] = '12.1.0.2'
default['oracle-omni']['rdbms']['edition'] = 'EE' # EE, SE, SO

default['oracle-omni']['rdbms']['install_files'] =
case node['oracle-omni']['rdbms']['version']
when '11.2.0.4'
  %w(
    p13390677_112040_Linux-x86-64_1of7.zip
    p13390677_112040_Linux-x86-64_2of7.zip
  )
when '12.1.0.1'
  %w(
    linuxamd64_12c_database_1of2.zip
    linuxamd64_12c_database_2of2.zip
  )
when '12.1.0.2'
  if node['oracle-omni']['rdbms']['edition'] == 'SE'
    %w(
      linuxamd64_12102_database_se2_1of2.zip
      linuxamd64_12102_database_se2_2of2.zip
    )
  else
    %w(
      linuxamd64_12102_database_1of2.zip
      linuxamd64_12102_database_2of2.zip
    )
  end
end
