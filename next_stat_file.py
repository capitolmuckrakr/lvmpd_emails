# coding: utf-8
from __future__ import print_function
from glob import glob
import sys, os

def next_file(input):
    data_dir = '/Users/acohen/data/LVMPD/COM_CENTER_STATS/'
    os.chdir(data_dir)
    last_id = get_ipython().getoutput(u"tail -1 $input | cut -d '|' -f 1 | cut -d '_' -f 1")
    next_id=int(last_id[0]) + 1
    try:
        next_file=data_dir + glob('*'+str(next_id)+'*')[0]
    except:
        next_file=''
    return next_file

if __name__ == '__main__':
    input = sys.argv[1]
    print(next_file(input))