#
# Cookbook Name:: oracle-omni
# Attributes:: grid
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

default['oracle-omni']['grid']['install_files'] =
case node['oracle-omni']['rdbms']['version']
when '11.2.0.4'
  %w(p13390677_112040_Linux-x86-64_3of7.zip)
when '12.1.0.1'
  %w(
    linuxamd64_12c_grid_1of2.zip
    linuxamd64_12c_grid_2of2.zip
  )
when '12.1.0.2'
  %w(
    linuxamd64_12102_grid_1of2.zip
    linuxamd64_12102_grid_2of2.zip
  )
end
