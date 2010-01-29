require 'net/http'

set :ruby_enterprise_url do
  Net::HTTP.get('www.rubyenterpriseedition.com', '/download.html').scan(/http:.*\.tar\.gz/).first
end

set :ruby_enterprise_version do
  "#{ruby_enterprise_url[/(ruby-enterprise.*)(.tar.gz)/, 1]}"
end

set :passenger_version do
  capture("gem list passenger$ -r").gsub(/[\n|\s|passenger|(|)]/,"")
end

namespace :ruby do
  desc "Install Ruby Enterpise Edition"
  task :install_enterprise, :roles => :app do
    # install dependancies
    sudo "aptitude install -y libssl-dev"
    sudo "apt-get install -y libreadline5-dev"
    # check it's not ready installed
    run "test ! -d /opt/#{ruby_enterprise_version}"
    # download
    run "wget -q #{ruby_enterprise_url}"
    # unzip
    run "tar xzvf #{ruby_enterprise_version}.tar.gz"
    # remove the zip
    run "rm #{ruby_enterprise_version}.tar.gz"
    # run the install
    sudo "./#{ruby_enterprise_version}/installer --auto /opt/#{ruby_enterprise_version}"
    # remove the source files
    sudo "rm -rf #{ruby_enterprise_version}/"
    # link up our new binaries for eacy access
    sudo "ln -s /opt/#{ruby_enterprise_version}/bin/gem /usr/bin/gem"
    sudo "ln -s /opt/#{ruby_enterprise_version}/bin/ruby /usr/bin/ruby"
    sudo "ln -s /opt/#{ruby_enterprise_version}/bin/rake /usr/bin/rake"
    # make our gems writable
    sudo "chmod 660 -R /opt/#{ruby_enterprise_version}/lib/ruby/gems"
    sudo "chmod 665 -R /opt/#{ruby_enterprise_version}/bin"
  end

  desc "Install Phusion Passenger"
  task :install_passenger, :roles => :app do
    # build our nginx dependancies
    sudo "aptitude install libpcre3 libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev"
    # install passenger gem
    sudo "/opt/#{ruby_enterprise_version}/bin/ruby /opt/#{ruby_enterprise_version}/bin/gem install passenger rake --no-rdoc --no-ri"
    # run the installer
    sudo "PATH='/opt/#{ruby_enterprise_version}/bin/':\$PATH /opt/#{ruby_enterprise_version}/bin/ruby /opt/#{ruby_enterprise_version}/bin/passenger-install-nginx-module --auto --auto-download --prefix=/etc/nginx"
    # setup nginx defaults
    nginx_defaults
  end
  
  desc "Setup nginx defaults"
  task :nginx_defaults do
    # render and upload the init.d daemon
    put render("nginx_initd", binding), "nginx"
    # move it into place
    sudo "mv nginx /etc/init.d/nginx && chmod 665 /etc/init.d/nginx"
    # setup some blank dirs
    sudo "mkdir -p /etc/nginx/sites-enabled/"
    sudo "mkdir -p /etc/nginx/sites-available/"
    # add sites-enabled to our nginx config
    sudo "echo 'include /etc/nginx/sites-enabled/*;' >> /etc/nginx/conf/nginx.conf"
  end
end
