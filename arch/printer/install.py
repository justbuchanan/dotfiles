from install.utils import *

# Usage:
# Start cupsd:
#   sudo systemctl start org.cups.cupsd
#
# Run system-config-printer to add a printer. Add it by its url found with:
#   lpoptions
#
# See printer stats:
#   lpstat -p <printer-name>
syspkg({'arch': ['cups', 'system-config-printer', 'cups-pdf']})
# syspkg({'arch': ['dymo-cups-drivers']})
