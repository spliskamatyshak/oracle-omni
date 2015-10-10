#
# Cookbook Name:: oracle-omni
# Attributes:: default
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

###############################################################################
# oracle attributes
###############################################################################

default['oracle-omni']['oracle']['preinstall_rpm'] =
case node['oracle-omni']['rdbms']['version'].to_i
when 11
  'oracle-rdbms-server-11gR2-preinstall'
when 12
  'oracle-rdbms-server-12cR1-preinstall'
end

default['oracle-omni']['oracle']['asm_rpms'] =
  %w(oracleasm-support oracleasmlib)

default['oracle-omni']['oracle']['files_url'] = nil

default['oracle-omni']['oracle']['patch_files'] =
case node['oracle-omni']['rdbms']['version']
when '11.2.0.4'
  %w(
    p20760982_112040_Linux-x86-64.zip
    p21068539_112040_Linux-x86-64.zip
  )
when '12.1.0.1'
  %w(p21150817_121010_Linux-x86-64.zip)
when '12.1.0.2'
  %w(p21150782_121020_Linux-x86-64.zip)
end

###############################################################################
# grid attributes
###############################################################################

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

###############################################################################
# rdbms attributes
###############################################################################

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

default['oracle-omni']['rdbms']['storage_type'] = 'FS'

###############################################################################
# client attributes
###############################################################################

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

###############################################################################
# agent attributes
###############################################################################

default['oracle-omni']['agent']['version'] = '12.1.0.4'
default['oracle-omni']['agent']['oms_url'] = nil
default['oracle-omni']['agent']['oms_port'] = 1_159
