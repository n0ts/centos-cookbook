name             'centos'
maintainer       'Naoya Nakazawa'
maintainer_email 'me@n0ts.org'
license          'All rights reserved'
description      'Installs/Configures centos'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ yum }.each do |depend|
  depends depend
end
