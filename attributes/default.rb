#
# Cookbook Name:: centos
# Attribute:: default
#

default[:centos] = {
  :replace_hosts => false,
  :rc_local_params => [],
}
