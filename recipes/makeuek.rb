#
# Cookbook Name:: oracle-omni
# Recipe:: clonegi
#
# Copyright 2015, Stephen Pliska-Matyshak
#
# All rights reserved - Do Not Redistribute
#

file_loc = Chef::Config['file_cache_path']

case node['platform_version'].to_i
when 5, 6
  unless node['os_version'].include? 'uek'
    unless node['platform'] == 'oracle'

      remote_file "#{file_loc}/centos2ol.sh" do
        owner 'root'
        group 'root'
        mode '0644'
        source 'https://linux.oracle.com/switch/centos2ol.sh'
      end

      execute 'centos2olkernel' do
        command 'sh centos2ol.sh'
        cwd file_loc
      end

      reboot 'centos2olkernel_reboot' do
        action :reboot_now
      end

    end

    unless node['plaform'] == 'centos'
      %w(
        kernel-uek.x86_64 kernel-uek-devel.x86_64 kernel-uek-firmware.noarch
      ).each do |uek|
        yum_package uek
      end

      ruby_block 'grubconfselectuek' do
        block do
          file = Chef::Util::FileEdit.new('/etc/grub.conf')
          file.search_file_replace(/default=\d/, 'default=0')
          file.write_file
        end
      end

      reboot 'olkernel2uek_reboot' do
        action :reboot_now
      end

    end
  end
else
  Chef::Log.warn("Version #{node['platform_version']} of #{node['platform']} does not convert to UEK.")
end
