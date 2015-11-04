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
end

execute 'create_ASM_ocr' do
  command "/usr/sbin/oracleasm createdisk OCR \
  #{node['oracle-omni']['grid']['ocr_disk']}1"
  retries 3
  retry_delay 20
  not_if 'usr/sbin/oracleasm listdisks | grep -q OCR'
end

parted_disk node['oracle-omni']['grid']['data_disk'] do
  action :mkpart
end

execute 'create_ASM_data' do
  command "/usr/sbin/oracleasm createdisk DATA \
  #{node['oracle-omni']['grid']['data_disk']}1"
  retries 3
  retry_delay 20
  not_if 'usr/sbin/oracleasm listdisks | grep -q DATA'
end

parted_disk node['oracle-omni']['grid']['log_disk'] do
  action :mkpart
end

execute 'create_ASM_log' do
  command "/usr/sbin/oracleasm createdisk LOG \
  #{node['oracle-omni']['grid']['log_disk']}1"
  retries 3
  retry_delay 20
  not_if 'usr/sbin/oracleasm listdisks | grep -q LOG'
end
