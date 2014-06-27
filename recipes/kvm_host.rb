#
# Cookbook Name:: centos
# Recipe:: kvm_host
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

%w{
  kvm
  kmod-kvm
  kvm-qemu-img
  libvirt
  python-virtinst
}.each do |pkg|
  package pkg do
    action :install
    notifies :execute, "execute[virt-configuration]"
  end
end

service "qemu-kvm" do
  action [:enable, :start]
end

service "libvirt-bin" do
  action [:enable, :start]
end

execute "virt-configuration" do
  command "modprobe kvm; modprobe kvm_intel; virsh net-destroy default"
  action :nothing
  notifies :restart, "service[libvirt-bin]"
end
