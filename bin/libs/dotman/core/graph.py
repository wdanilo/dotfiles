from collections import deque, OrderedDict

class Node(object):
    def __init__(self, name, data):
        self.name = name
        self.data = data
        self.inputs = {}
        self.outputs = {}
        
    def connect_to(self, node):
        if not node in self.outputs:
            self.outputs[node] = True
            node.connect_from(self)
            
    def connect_from(self, node):
        if not node in self.inputs:
            self.inputs[node] = True
            node.connect_to(self)
            
    def __str__(self):
        return "Node '%s' (%s)"%(self.name, self.data)
            
            
class Graph(object):
    def __init__(self):
        self.nodes = {}
        
    def register_node(self, node):
        self.nodes[node.name] = node
        
    def add_node(self, name, data):
        node = Node(name, data)
        self.register_node(node)
        return node
    
    def get_roots(self):
        roots = deque()
        for node in self.nodes.itervalues():
            if not node.inputs:
                roots.append(node)
        return roots
    
    def sort(self):
        squeue = OrderedDict()
        nc = {}
        for node in self.nodes.itervalues():
            nc[node] = 0
        queue = self.get_roots()
        while queue:
            node = queue.popleft()
            if not node in squeue and nc[node] == len(node.inputs):
                squeue[node] = True
                for output in node.outputs:
                    nc[output] += 1
                    queue.append(output)
        return squeue
    
    def node(self, name):
        try:
            return self.nodes[name]
        except:
            return None
    
    def __iter__(self):
        return self.nodes.itervalues()
        
        
    

g = Graph()
a = g.add_node('a',1)
b = g.add_node('b',1)
c = g.add_node('c',1)
d = g.add_node('d',1)

a.connect_to(b)
b.connect_to(c)
d.connect_to(b)

g.sort()

# d->
# a->b->c

