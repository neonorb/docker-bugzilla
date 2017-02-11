FROM ubuntu:trusty
MAINTAINER Neon Orb <neonorb@neonorb.com>

# update and install modules for bugzilla, Apache2
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y git nano apache2 mysql-server libappconfig-perl libdate-calc-perl libtemplate-perl libmime-perl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y build-essential libdatetime-timezone-perl libdatetime-perl libemail-sender-perl libemail-mime-perl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y libemail-mime-modifier-perl libdbi-perl libdbd-mysql-perl libcgi-pm-perl libmath-random-isaac-perl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y libmath-random-isaac-xs-perl apache2-mpm-prefork libapache2-mod-perl2 libapache2-mod-perl2-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y libchart-perl libxml-perl libxml-twig-perl perlmagick libgd-graph-perl libtemplate-plugin-gd-perl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y libsoap-lite-perl libhtml-scrubber-perl libjson-rpc-perl libdaemon-generic-perl libtheschwartz-perl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y libtest-taint-perl libauthen-radius-perl libfile-slurp-perl libencode-detect-perl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y libmodule-build-perl libnet-ldap-perl libauthen-sasl-perl libtemplate-perl-doc libfile-mimeinfo-perl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y libhtml-formattext-withlinks-perl libgd-dev libmysqlclient-dev lynx-cur graphviz python-sphinx

# set working directory
WORKDIR /var/www/

# install bugzilla
ADD bugzilla.conf /etc/apache2/sites-available/000-default.conf
RUN rm -rf html/
RUN a=a git clone --branch release-5.0-stable https://github.com/neonorb/bugzilla html/
WORKDIR /var/www/html/
RUN /usr/bin/perl install-module.pl --all
RUN /usr/bin/perl install-module.pl Net::SMTP::SSL
RUN /usr/bin/perl install-module.pl Email::Sender::Transport::SMTP::TLS
RUN /usr/bin/perl checksetup.pl --check-modules
RUN a2enmod cgi headers expires
RUN service apache2 restart

# Add the start script
ADD start /opt/

# Run start script
CMD ["/opt/start"]

# Expose web server port
EXPOSE 80
