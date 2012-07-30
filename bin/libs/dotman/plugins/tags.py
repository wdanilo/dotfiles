regex = r'@[a-zA-Z_.]+'
next = ['default']

from .. import tags

def parse(env, token):
    token = token[1:]
    tag = getattr(tags, token, None)
    if not tag:
        raise
    tag.parse(env)

def setup(dotman):
    for name in tags.__all__:
        tag = getattr(tags, name)
        setup = getattr(tag, 'setup', None)
        if setup:
            setup(dotman)