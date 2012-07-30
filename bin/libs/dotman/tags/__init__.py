import os, glob
dirname = os.path.dirname(__file__)
__all__ = [ os.path.basename(f)[:-3] for f in glob.glob(dirname+"/*.py")]
try:    __all__.remove('__init__')
except: pass
__import__(os.path.basename(dirname), globals(), locals(), ('*',), 2)
