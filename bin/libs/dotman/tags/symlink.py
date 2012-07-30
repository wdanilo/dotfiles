import os
import logging
import shutil
from dotman.utils import getch
logger = logging.getLogger(__name__)

def symlink(env):
    path = os.path.dirname(env.dst)
    basepath = path
    while True:
        if os.path.exists(basepath):
            break
        basepath = os.path.dirname(basepath)
        
    if not os.access(basepath, os.R_OK | os.W_OK | os.X_OK):
        logger.error("Path '%s' is not accessible, you need to run this script as super user." % basepath)
        return
    
    if not os.path.exists(path):
        os.makedirs(path)
        
    if os.path.lexists(env.dst):
        skip = False
        backup = False
        override = False
        if env.duplicate.SKIP_ALL:
            skip = True
        elif env.duplicate.BACKUP_ALL:
            backup = True
        elif env.duplicate.OVERRIDE_ALL:
            override = True
        
        if not skip and not backup and not override:
            options = '[s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all'
            print 'File already exists: %s, what do you want to do? %s'% (env.dst, options)
            while True:
                char = getch()
                if char == 's':
                    skip = True
                elif char == 'S':
                    env.duplicate.SKIP_ALL.select()
                    skip = True
                elif char == 'o':
                    override = True
                elif char == 'O':
                    env.duplicate.OVERRIDE_ALL.select()
                    override = True
                elif char == 'b':
                    backup = True
                elif char == 'B':
                    env.duplicate.BACKUP_ALL.select()
                    backup = True
                else:
                    print "Sorry, response '%s' not understood. %s" % (char, options)
                    continue
                break
        if skip:
            logger.debug('skipping: %s' % env.src)
            return
        elif backup:
            logger.debug('backup: %s -> %s' % (env.dst, env.dst+'.backup'))
            shutil.move(env.dst, env.dst+'.backup')
        elif override:
            logger.debug('removing: %s' % env.dst)
            os.remove(env.dst)
    
    logger.debug('symlink: %s -> %s'%(env.src, env.dst))
    os.symlink(env.src, env.dst)

def parse(env):
    env.method = symlink
    
def setup(dotman):
    dotman.set_default_method(symlink)