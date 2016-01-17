#
# Cookbook Name:: imagery
# Resource:: imagery_layer
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
property :site, String, :required => true
property :source, String, :required => true
property :text, String
property :copyright, String, :default => "Copyright"
property :projection, String, :default => "EPSG:3857"
property :palette, String
property :extent, String
property :background, String
property :resample, String, :default => "average"
property :imagemode, String
property :extension, String
property :max_zoom, Fixnum, :default => 23

action :create do
  template "/srv/imagery/mapserver/layer-#{name}.map" do
    cookbook "imagery"
    source "mapserver.map.erb"
    owner "root"
    group "root"
    mode 0644
    variables new_resource.to_hash
  end

  template "/etc/init/mapserv-fgi-layer-#{name}.conf" do
    cookbook "imagery"
    source "mapserv_fcgi.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables new_resource.to_hash
  end

  service "mapserv-fgi-layer-#{name}.conf" do
    provider Chef::Provider::Service::Upstart
    action [:enable, :start]
    supports :status => true, :restart => true, :reload => false
    subscribes :restart, "template[/srv/imagery/mapserver/layer-#{name}.map]"
    subscribes :restart, "template[/etc/init/mapserv-fgi-layer-#{name}.conf]"
  end
end
