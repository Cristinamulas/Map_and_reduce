#!/usr/bin/python
# --*-- coding:utf-8 --*--
import re
import sys


for line in sys.stdin:
    line = line.strip()
    line = line.split(',')
    if len(line[12])>0 and len(line[-5])>0 and len(line[9])>0 and (line[-2]=='james harden' or line[-2] == 'chris paul' or line[-2] =='stephen curry' or line[-2] == 'lebron james'):
        print('%s\t%s\t%s\t%s'%(line[-2],line[12],line[-5],line[9]))


