import os

def parse(env):
    env.src = env.lex_path
    env.dst = os.path.join(os.path.expanduser('~'), os.path.basename(env.meta_path))
    env.method(env)