systemctl list-unit-files | grep enabled | awk '{ print  }' > enabled-services.txta
