#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# This Modularity Testing Framework helps you to write tests for modules
# Copyright (C) 2017 Red Hat, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# he Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Authors: Rado Pitonak <rpitonak@redhat.com>
#

from avocado import main
from avocado.core import exceptions
from moduleframework import module_framework
import time


class SanityCheck2(module_framework.AvocadoTest):
    """
    :avocado: enable
    """

    def test1Port80(self):
        """
        Request to localhost inside the container to make sure that server running on port 8080
        """

        self.start()
        time.sleep(2)
        self.run("curl 127.0.0.1:8080")


    def test2WebContent(self):
        """
        Check if httpd display correct content
        """
        content = "<html><body><h1>Httpd is running in container!</h1></body></html>"
        root = "/var/www/"

        self.start()

        # create simple static  website inside the container
        self.run("touch {}/html/index.html".format(root))
        self.run("echo '{}' >> {}/html/index.html".format(content, root))

        # compare content returned by request from host with original content
        self.assertIn('{}\n'.format(content), self.runHost("curl 127.0.0.1:8080").stdout)


if __name__ == '__main__':
    main()
