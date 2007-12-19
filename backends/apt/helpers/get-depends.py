#!/usr/bin/python
#
# Copyright (C) 2007 Richard Hughes <richard@hughsie.com>
#
# Licensed under the GNU General Public License Version 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

import sys

from aptBackend import PackageKitAptBackend
package=sys.argv[1]
recursive = sys.argv[2]
backend = PackageKitAptBackend(sys.argv[1:])
backend.get_depends(package, recursive)
sys.exit(0)
