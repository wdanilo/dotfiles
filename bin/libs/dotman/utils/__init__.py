from collections import OrderedDict

class _Getch:
    """Gets a single character from standard input.  Does not echo to the
screen."""
    def __init__(self):
        try:
            self.impl = _GetchWindows()
        except ImportError:
            self.impl = _GetchUnix()

    def __call__(self): return self.impl()


class _GetchUnix:
    def __init__(self):
        import tty, sys

    def __call__(self):
        import sys, tty, termios
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            ch = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        if ord(ch) == 3:
            sys.exit()
        return ch


class _GetchWindows:
    def __init__(self):
        import msvcrt

    def __call__(self):
        import msvcrt
        return msvcrt.getch()


getch = _Getch()


class enum(object):
    def __init__(self, *sequential, **named):
        self.__enums = OrderedDict(zip(sequential, range(len(sequential))), **named)
        for key, val in self.__enums.items():
            setattr(self, key, val)
    
    def __getitem__(self, key):
        return self.__enums[key]
    
    def items(self):
        return self.__enums.items()
    
    def keys(self):
        return self.__enums.keys()
    
    def values(self):
        return self.__enums.values()
    
    def __iter__(self):
        return self.__enums.__iter__()
    
    
class Options(object):
    class Element(object):
        def __init__(self, options):
            self.selected = False
            self.__options = options
        def select(self):
            self.__options.select(self)
        def __nonzero__(self):
            return self.selected
        
    def __init__(self, *sequential) :
        self.__selected = None
        for el in sequential:
            setattr(self, el, Options.Element(self))
    
    def select(self, element):
        if self.__selected:
            self.__selected.selected = False
        element.selected = True
        self.__selected = element
    
