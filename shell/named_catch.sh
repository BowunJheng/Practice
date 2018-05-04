  #!/bin/sh
  #
  # Update the nameserver cache information file once per month.
  # This is run automatically by a cron entry.
  #
  (
   echo "To: hostmaster <hostmaster>"
   echo "From: system <root>"
   echo "Subject: Automatic update of the named.boot file"
   export PATH=/sbin:/usr/sbin:/bin:/usr/bin:
   cd /var/named

   echo "The named.boot file has been updated to contain the following
  information:"
   echo
   chown root.root named.cache.new
   chmod 444 named.cache.new
   rm -f named.cache.old
   mv named.cache named.cache.old
   mv named.cache.new named.cache
   ndc restart
   echo
   echo "The nameserver has been restarted to ensure that the update
is complete.
  "
   echo "The previous named.cache file is now called
  /var/named/named.cache.old."
  ) 2>&1 | /usr/lib/sendmail -t
  exit 0

