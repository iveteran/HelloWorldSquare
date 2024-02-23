# Install: cp daily-running-script /etc/cron.daily/
# NOTE: Debian 12 depend on anacron: apt install anacron
#       the filename of daily-running-script can not has the postfix .sh
sudo run-parts -v --report /etc/cron.daily  # Debian
sudo run-parts /etc/cron.daily  # CentOS
