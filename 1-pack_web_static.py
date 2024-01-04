#!/usr/bin/python3
from fabric.api import local
from datetime import datetime
import os
'''this module is a  Fabric script that generates a .tgz archive
from the contents of the web_static folder of this AirBnB Clone
repo, using the function do_pack'''


def do_pack():
    '''A function that generates an achieve from web_static'''
    local("mkdir -p versions")

    now = datetime.now()
    timestamp = now.strftime("%Y%m%d%H%M%S")
    archive_name = "web_static_{}.tgz".format(timestamp)
    archive_path = "versions/{}".format(archive_name)
    archive_source = "web_static"
    x = local("tar -cvzf {} {}".format(archive_path, archive_source))

    if x.failed:
        return None
    else:
        size = os.path.getsize(archive_path)
        print("web_static packed: {} -> {}Bytes".format(archive_path, size))
        return archive_path
