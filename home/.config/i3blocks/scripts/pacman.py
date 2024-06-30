#!/usr/bin/env python3

import logging
import tools
import fontawesome as fa
import subprocess as proc
import sys
import os
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

PACMAN_LOCKFILE_PATH = '/var/lib/pacman/db.lck'

def update():
    logging.info('update')
    pkgs = proc.check_output(['checkupdates']).decode('utf-8')
    count = len(pkgs.split('\n')) - 1

    if count > 0:
        icon = tools.icon(fa.icons['gift'])
        print("%s %d" % (icon, count))
    else:
        print()
    sys.stdout.flush()


# call update() whenever pacman lock file is created or deleted, which happens
# every time pacman stops running. This lets us update immediately when packages
# are installed
class Handler(FileSystemEventHandler):

    def on_any_event(self, event):
        if event.src_path == PACMAN_LOCKFILE_PATH:
            update()

def main():
    observer = Observer()
    observer.schedule(Handler(), os.path.dirname(PACMAN_LOCKFILE_PATH))
    observer.start()

    # update on an interval
    while True:
        update()
        # check every half hour
        time.sleep(30 * 60)

    # TODO: call these to exit gracefully on signals
    observer.stop()
    observer.join()

if __name__ == '__main__':
    main()
