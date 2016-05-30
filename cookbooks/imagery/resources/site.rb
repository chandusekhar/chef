#
# Cookbook Name:: imagery
# Resource:: imagery_site
#
# Copyright 2016, OpenStreetMap Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default_action :create

property :name, String
property :aliases, [String, Array], :default => []
property :git_repository, String, :default => ["https://github.com/Firefishy/osm-imagery-default.git"]

action :create do
  git "/srv/#{name}" do
    action :sync
    repository "#{git_repository}"
    revision "master"
    enable_submodules true
    retries 3
    user "root"
    group "root"
  end

  nginx_site name do
    template "nginx_imagery.conf.erb"
    directory "/srv/imagery/#{name}"
    restart_nginx false
    variables new_resource.to_hash
  end
end

def after_created
  notifies :restart, "service[nginx]"
end
