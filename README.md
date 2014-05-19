Instructions
============

This script has been tested with Centos 6.5 (i386) minimal iso and Debian...

Centos 6.5 (i386) minimal iso
-----------------------------
(These steps should also work for RHEL 6).

1.  Log in as `root`
2.  Install git, `yum install git -y`
3. Change directory to the location where you want to clone the repository.
4. Clone the repository: 'git clone https://github.com/tnh/simple-sinatra-app.git`
5. There should now be a new `simple-sinatra-appr` directory, change to that directory.
6. Run `setup.sh` to install and run the application using `/var/www/simple-sinatra-app` as the "document root", or run `setup.sh` followed by the full path of
an alternative location e.g. `setup.sh /var/ruby/simple-sinatra-app`.
7. Wait for the script to complete and then test by pointing your browser to port 80 of the external ip address of the host.

### Header 3

> This is a blockquote.
> 
> This is the second paragraph in the blockquote.
>
> ## This is an H2 in a blockquote
