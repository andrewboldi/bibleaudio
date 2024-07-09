#!/usr/bin/python3
import os
books = ["MAT", "MRK", "LUK", "JHN", "ACT", "ROM", "1CO", "2CO", "GAL", "EPH", "PHP", "COL", "1TH", "2TH", "1TI", "2TI", "TIT", "PHM", "HEB", "JAS", "1PE", "2PE", "1JN", "2JN", "3JN", "JUD", "REV"]

for book in books:
    chapters = sorted(os.listdir(f"books/{book}"))
    for chapter in chapters:
        if len(chapter.split("-")[0]) == 1:
            os.rename(f"books/{book}/{chapter}", f"books/{book}/0{chapter}")
