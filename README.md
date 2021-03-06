Instructions
============

This script has been tested with [Centos 6.5 (i386) minimal iso](http://mirror.aarnet.edu.au/pub/centos/6.5/isos/i386/CentOS-6.5-i386-minimal.iso) and [Debian 7.5 (i386) netinst iso](http://cdimage.debian.org/debian-cd/7.5.0/i386/iso-cd/debian-7.5.0-i386-netinst.iso).

Centos 6.5 (i386) minimal iso
-----------------------------
(These steps should also work for RHEL 6).

1. Log in as `root`
2. Install git, `yum install git -y`
3. Change directory to the location where you want to clone this repository.
4. Clone the repository: `git clone https://github.com/madtechsupport/simple-sinatra-app.git`
5. There should now be a new `simple-sinatra-app` directory, change to that directory.
6. Run `setup.sh` to install and run the application using the location `/var/www/simple-sinatra-app`, or run `setup.sh` followed by the full path of
an desired location e.g. `setup.sh /var/ruby/simple-sinatra-app`.
7. Wait for the script to complete and then test by pointing your browser to port 80 of the external ip address of the host.

Debian 7.5 (i386) netinst iso
-----------------------------

1. Log in as `root`
2. Install git, `apt-get install git -y`
3. Change directory to the location where you want to clone this repository.
4. Clone the repository: `git clone https://github.com/madtechsupport/simple-sinatra-app.git`
5. There should now be a new `simple-sinatra-app` directory, change to that directory.
6. Run `setup.sh` to install and run the application using the location `/var/www/simple-sinatra-app`, or run `setup.sh` followed by the full path of
an desired location e.g. `setup.sh /var/ruby/simple-sinatra-app`.
7. Wait for the script to complete and then test by pointing your browser to port 80 of the external ip address of the host.
