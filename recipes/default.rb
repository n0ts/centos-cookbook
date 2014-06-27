#
# Cookbook Name:: centos
# Recipe:: default
#
# Copyright 2012, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

#
# /etc/hosts
#
template '/etc/hosts' do
  source 'hosts.erb'
  action :nothing
  only_if { node['centos']['replace_hosts'] }
end.run_action(:create) if node['centos']['replace_hosts']


#
# Directory
#
directory '/usr/local/script' do
  mode 0755
  action :create
end


#
# Packages
#
%w{
  bash
  bash-completion
  cpufreq-utils
  expect
  ethtool
  dstat
  git
  iotop
  keychain
  mlocate
  mosh
  pigz
  the_silver_searcher
  traceroute
  tree
  screen
  vim-enhanced
  sshpass
  tmux
  wget
  zsh
}.each do |pkg, ver|
  package pkg do
    action :install
    version ver if ver && ver.length > 0
  end
end

%w{
  lm_sensors
  smartmontools
}.each do |pkg, ver|
  package pkg do
    action :install
    version ver if ver && ver.length > 0
    only_if { node.virtualization[:role] == 'host' }
  end
end


#
# rc.local
#
template '/etc/rc.d/rc.local' do
  source 'rc.local.erb'
  owner 'root'
  group 'root'
  mode 0755
  action :create
  notifies :run, 'execute[rc-local]'
end

execute 'rc-local' do
  command 'sh /etc/rc.local'
  user 'root'
  action :nothing
  not_if { node[:centos][:rc_local_params].empty? }
end


#
# sysstat
#
package 'sysstat' do
  action :install
end

template '/etc/cron.d/sysstat' do
  source 'sysstat-cron.erb'
  mode 0600
  action :create
  notifies :reload, 'service[sysstat]', :delayed
end

service 'sysstat' do
  action [:enable, :start]
end


#
# Yum
#
node.override['yum']['main']['gpgcheck'] = false
node.override['yum']['main']['exclude'] = '*.i386 *.i686'
include_recipe 'yum'
