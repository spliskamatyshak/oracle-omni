#
# Cookbook Name:: oracle-omni
# Recipe:: createusers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Groups for GI owner

node['oracle-omni']['grid']['groups'].each_key do |grp|
  group grp do
    gid node['oracle-omni']['grid']['groups'][grp]
    action :create
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
    action :create
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
