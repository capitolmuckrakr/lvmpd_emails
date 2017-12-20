# coding: utf-8
from __future__ import print_function
from glob import glob
import sys, os

def next_file(inputfile):
    HOME = os.environ['HOME']
    data_dir = HOME + '/data/LVMPD/COM_CENTER_STATS/'
    os.chdir(data_dir)
    last_id = get_ipython().getoutput(u"tail -n1 loaded/$inputfile | cut -d '|' -f 1 | cut -d '_' -f 1")
    next_id=int(last_id[0]) + 1
    try:
        next_filenum=data_dir + glob('*'+str(next_id)+'_rc*')[0]
    except:
        next_filenum=''
    return next_filenum

if __name__ == '__main__':
    input = sys.argv[1]
    print(next_file(input))