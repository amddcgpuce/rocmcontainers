#!/bin/bash
# Check the compatibility of ROCm-Kernel Version

/opt/rocm/bin/rocminfo 2>&1 | /bin/grep "HSA Error" > /dev/null
if [ $? -eq 0 ]
then
        echo ""
        echo "Error: Incompatible ROCm environment. The Docker container "
        echo "requires the latest kernel driver to operate correctly."
        echo ""
        echo "Upgrade the ROCm kernel to v4.1 or newer, or use a container "
        echo "tagged for v4.0.1 or older."
        echo ""
        echo "To inspect the version of the installed kernel driver, run either:"
        echo "    . dpkg --status rock-dkms [Debian-based]"
        echo "    . rpm -ql rock-dkms [RHEL, SUSE, and others]"
        echo ""
        echo "To install or update the driver, follow the installation instructions at:"
        echo "    https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html"
        echo ""
        exit 1
fi
exec "$@"

