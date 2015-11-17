#
# Cookbook Name:: oracle-omni
# Recipe:: setupasm
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

prefix = ''

node['oracle-omni']['grid']['device_prefix'].each do |dev|
  prefix += "-o #{dev} "
end

execute 'configure_asm' do
  command "/usr/sbin/oracleasm configure -e \
  -u #{node['oracle-omni']['grid']['user']} \
  -g #{node['oracle-omni']['grid']['groups'].keys[3]} \
  -s y -e #{prefix}"
end

execute 'init_asm' do
  command '/usr/sbin/oracleasm init'
end

parted_disk node['oracle-omni']['grid']['ocr_disk'] do
  action :mkpart
  not_if { node['oracle-omni']['grid']['ocr_disk'].include? 'md' }
end

part_no = node['oracle-omni']['grid']['ocr_disk']['md'] ? '' : '1'

execute 'create_ASM_ocr' do
  command "/usr/sbin/oracleasm createdisk OCR \
  #{node['oracle-omni']['grid']['ocr_disk']}1"
  retries 3
  retry_delay 20
  not_if '/usr/sbin/oracleasm listdisks | grep -q OCR'
end

part_no = node['oracle-omni']['grid']['data_disk']['md'] ? '' : '1'

execute 'create_ASM_data' do
  command "/usr/sbin/oracleasm createdisk DATA \
  #{node['oracle-omni']['grid']['data_disk']}#{part_no}"
  retries 3
  retry_delay 20
  not_if '/usr/sbin/oracleasm listdisks | grep -q DATA'
end

part_no = node['oracle-omni']['grid']['log_disk']['md'] ? '' : '1'

execute 'create_ASM_log' do
  command "/usr/sbin/oracleasm createdisk LOG \
  #{node['oracle-omni']['grid']['log_disk']}#{part_no}"
  retries 3
  retry_delay 20
  not_if '/usr/sbin/oracleasm listdisks | grep -q LOG'
end
