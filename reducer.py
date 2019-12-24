#!/usr/bin/python
from operator import itemgetter
import sys

dict_player_zone = {}
num_player = {}
cluster=['C1','C2','C3','C4']

for line in sys.stdin:
    line = line.strip()
    player, SHOT_DIST, CLOSE_DEF_DIST, SHOT_CLOCK = line.split('\t')
    num_player[player] = num_player.get(player,0) + 1
    if num_player[player]<5:
        print('%s\t%s\t%s\t%s\t%s'%(player, cluster[num_player[player]-1], SHOT_DIST, CLOSE_DEF_DIST, SHOT_CLOCK))
