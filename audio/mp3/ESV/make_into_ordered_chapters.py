#!/usr/bin/python3
import os
from shutil import copyfile
books = ["MAT", "MRK", "LUK", "JHN", "ACT", "ROM", "1CO", "2CO", "GAL", "EPH", "PHP", "COL", "1TH", "2TH", "1TI", "2TI", "TIT", "PHM", "HEB", "JAS", "1PE", "2PE", "1JN", "2JN", "3JN", "JUD", "REV"]

counter = 0
for book in books:
    chapters = sorted(os.listdir(f"books/{book}"))
    for chapter in chapters:
        copyfile(f"books/{book}/{chapter}", f"chapters/{counter:03}.mp3")
        counter += 1
