#
# Cookbook Name:: oracle-omni
# Recipe:: setupasm
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

prefix = ''

node['oracle-omni']['grid']['device_prefixes'].each do |dev|
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

unless node['oracle-omni']['grid']['ocr_disk'].include? 'md'
  parted_disk node['oracle-omni']['grid']['ocr_disk'] do
    action :mklabel
  end

  parted_disk node['oracle-omni']['grid']['ocr_disk'] do
    action :mkpart
  end
end

part_no = node['oracle-omni']['grid']['ocr_disk']['md'] ? '' : '1'
dsk = File.basename(node['oracle-omni']['grid']['ocr_disk']) + part_no

execute "create_ASM_ocr_#{dsk}" do
  command "/usr/sbin/oracleasm createdisk OCR_#{dsk} \
  #{node['oracle-omni']['grid']['ocr_disk']}#{part_no}"
  retries 3
  retry_delay 20
  not_if "/usr/sbin/oracleasm listdisks | grep -qi OCR_#{dsk}"
end

node['oracle-omni']['grid']['data_disks'].each do |disk|
  part_no = disk['md'] ? '' : '1'
  dsk = File.basename(disk) + part_no

  execute "create_ASM_data_#{dsk}" do
    command "/usr/sbin/oracleasm createdisk DATA_#{dsk} #{disk}#{part_no}"
    retries 3
    retry_delay 20
    not_if "/usr/sbin/oracleasm listdisks | grep -qi DATA_#{dsk}"
  end
end

node['oracle-omni']['grid']['log_disks'].each do |disk|
  part_no = disk['md'] ? '' : '1'
  dsk = File.basename(disk) + part_no

  execute "create_ASM_log_#{dsk}" do
    command "/usr/sbin/oracleasm createdisk LOG_#{dsk} #{disk}#{part_no}"
    retries 3
    retry_delay 20
    not_if "/usr/sbin/oracleasm listdisks | grep -qi LOG_#{dsk}"
  end
end
