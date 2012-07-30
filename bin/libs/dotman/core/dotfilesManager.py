import os
import re
from collections import OrderedDict
from graph import Graph
from copy import copy, deepcopy
from dotman.utils import Options

class Env(object):
    def __init__(self, base_path, default_method=None):
        self.src       = ''
        self.lex_path  = base_path
        self.dst       = ''
        self.meta_path = ''
        self.method    = default_method
        self.duplicate = Options('SKIP_ALL', 'OVERRIDE_ALL', 'BACKUP_ALL')

class DotfilesManager(object):
    def __init__(self):
        self.graph = Graph()
        self.pattern = None
        self.plugins = []
        self.default_method = None
        
        from dotman import plugins
        for name in plugins.__all__:
            plugin = getattr(plugins, name)
            prevlist = getattr(plugin, 'prev', [])
            nextlist = getattr(plugin, 'next', [])
            self.register_plugin(name, plugin, prevlist, nextlist)
        self.compile()
    
    def set_default_method(self, method):
        self.default_method = method

    def register_plugin(self, name, plugin, prevlist=[], nextlist=[]):
        node = self.graph.add_node(name, plugin)
        node.prevlist = prevlist
        node.nextlist = nextlist
        setup = getattr(plugin, 'setup', None)
        if setup:
            setup(self)
        
    def compile(self):
        for plugin in self.graph:
            for prevname in plugin.prevlist:
                prevplug = self.graph.node(prevname)
                if prevplug:
                    prevplug.connect_to(plugin)
            for nextname in plugin.nextlist:
                nextplug = self.graph.node(nextname)
                if nextplug:
                    nextplug.connect_from(plugin)
        nodequeue = self.graph.sort()
        self.plugins = [node.data for node in nodequeue]
        regex = '(?:%s)'%('|'.join(['(%s)'%plugin.regex for plugin in self.plugins]))
        self.pattern = re.compile(regex)


    def scan(self, base_path):
        env = Env(base_path, self.default_method)
        self.__scan(env, base_path)
        
    def __scan(self, env, top, cdir='', onerror=None, followlinks=False):
        islink, join, isdir = os.path.islink, os.path.join, os.path.isdir
        try:
            names = os.listdir(top)
        except os.error, err:
            if onerror is not None:
                onerror(err)
            return
    
        dirs, nondirs = [], []
        for name in names:
            if isdir(join(top, name)):
                dirs.append(name)
            else:
                nondirs.append(name)
    
        self.parse_env(env, cdir)
        env.lex_path += os.path.sep
        env.meta_path += os.path.sep
        for filename in nondirs:
            self.parse_env(copy(env), filename)
        
        for name in dirs:
            new_path = join(top, name)
            if followlinks or not islink(new_path):
                self.__scan(copy(env), new_path, name, onerror, followlinks)
        
        
    def parse_env(self, env, path):
        scan = self.pattern.scanner(path)
        while True:
            m = scan.match()
            if not m:
                break
            tokenid = m.lastindex-1
            token = m.group(m.lastindex)
            env.lex_path += token
            self.plugins[tokenid].parse(env, token)
