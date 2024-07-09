from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from time import sleep
from json import loads
from pprint import pprint
from subprocess import check_call
from wget import download
from subprocess import run
from sys import argv
from os import listdir, mkdir
import os.path

books = ["MAT", "MRK", "LUK", "JHN", "ACT", "ROM", "1CO", "2CO", "GAL", "EPH", "PHP", "COL", "1TH", "2TH", "1TI", "2TI", "TIT", "PHM", "HEB", "JAS", "1PE", "2PE", "1JN", "2JN", "3JN", "JUD", "REV"]
chapters = [28, 16, 24, 21, 28, 16, 16, 13, 6, 6, 4, 4, 5, 3, 6, 4, 3, 1, 13, 5, 5, 3, 5, 1, 1, 1, 22]
versionList = ["WA2017", "ESV"]
versionPrefix = {
        "WA2017": "194",
        "ESV": "59"
}

def process_browser_logs_for_network_events(logs_):
    for entry in logs_:
        log = loads(entry["message"])["message"]
        if (
            "Network.response" in log["method"]
            or "Network.request" in log["method"]
            or "Network.webSocket" in log["method"]
        ):
            yield log

def processLogs():
    lines = []
    with open("log_temp.txt", "w") as out:
        for event in process_browser_logs_for_network_events(logs):
            pprint(event, stream=out)

    with open("log_temp.txt", "r") as fp:
        lines = fp.readlines()
        for number, line in enumerate(lines):
            if r"'url': 'https://audio-bible-cdn.youversionapi.com" in line:
                open("list.txt", "a").write(line[32:-4]+ "\n")
                return

def get(book, chapter, version):
    page = f"https://www2.bible.com/bible/{versionPrefix[version]}/{book}.{chapter}.{version}?show_audio=1"
    driver.get(page)
    sleep(2)

    driver.find_element(By.XPATH, "//div[@class='circle-button play']").click()
    sleep(2)

def download(version):
    lines = open("list.txt", "r").readlines()
    if "mp3" not in listdir():
        mkdir("mp3")
    if version not in listdir("mp3"):
        mkdir(f"mp3/{version}")
    for book in books:
        if book not in listdir(f"mp3/{version}"):
            mkdir(f"mp3/{version}/{book}")
    for number, line in enumerate(lines):
        if f"version_id={versionPrefix[version]}" in line:
            run(['wget', line, '-O', f"mp3/{version}/{line[line.index('32k/') + 3:line.index('.mp3') + 4]}"])
            # Popen(['wget', line, '-O', os.path.join("mp3", line[line.index("32k/") + 4:line.index("32k/") + 7], line[line.index("32k/") + 8:line.index(".mp3") + 4])])

def main(versions, allVersions, downloadOnly):
    if allVersions:
        versions = versionList
    """
    else: # This is probably overkill since iterating over a tuple works the same way as a list
        tmp = versions
        versions = []
        for item in tmp:
            versions.extend(item)
            """

    for version in versions:
        for book in books:
            if not downloadOnly:
                for chapter in range(1, chapters[books.index(book)] + 1):
                        global driver
                        cService = webdriver.ChromeService(executable_path='/home/andrew/build/chromedriver/chromedriver')
                        driver = webdriver.Chrome(service = cService)
                        driver.set_window_position(1024, 1024, windowHandle='current')
                        get(book, chapter, version)
                        print(f"Retrieved {book} {chapter}")
                        global logs
                        logs = driver.get_log("performance")
                        processLogs()
                        driver.quit()
        download(version)

if __name__ == "__main__":
    if len(argv) >= 2:
        allVersions = False
        downloadOnly = False
        if "-a" in argv:
            allVersions = True
            argv.remove("-a")
        if "-d" in argv:
            downloadOnly = True
            argv.remove("-d")
        main(argv[1:], allVersions, downloadOnly)
    else:
        print("Specify versions to download")
