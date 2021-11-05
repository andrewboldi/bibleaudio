from wget import download
from subprocess import Popen
import os.path

lines = open("list.txt", "r").readlines()
for number, line in enumerate(lines):
#    download(line, line[line.index("32k/")+4:-15])
    Popen(['wget', line, '-O', os.path.join(line[line.index("32k/") + 4:line.index("32k/") + 7], line[line.index("32k/") + 8:line.index(".mp3") + 4])])
