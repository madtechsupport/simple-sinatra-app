#!/bin/bash

set -e

>/var/log/audit/audit.log
cd /tmp
setenforce 0
service httpd restart
curl localhost >/dev/null 2>&1
grep httpd /var/log/audit/audit.log | audit2allow -M passenger
semodule -i passenger.pp
setenforce 1
service httpd restart
