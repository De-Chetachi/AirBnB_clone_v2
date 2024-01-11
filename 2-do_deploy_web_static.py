#!/usr/bin/python3
from fabric.api import local, run, put, env
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


env.user = 'ubuntu'
env.hosts = ['54.197.77.69', '18.233.67.26']


def do_deploy(archive_path):
    '''distributes an archive to your web servers'''
    try:
        arch = archive_path.split("/")[-1]
        archive_ = arch.split(".")[0]
        put(archive_path, "/tmp/{}".format(arch))
        upload_path = "/data/web_static/releases/{}".format(archive_)
        run("mkdir -p {}".format(upload_path))
        run("tar -xvzf /tmp/{} -C {}".format(arch, upload_path))
        run("rm /tmp/{}".format(arch))
        run("mv {}/web_static/* {}".format(upload_path, upload_path))
        run("rm -rf {}/web_static".format(upload_path))
        run("rm -rf /data/web_static/current")
        run("ln -sf {} /data/web_static/current".format(upload_path))
        return True

    except Exception as e:
        return False
