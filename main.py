from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.by import By
from time import sleep
from json import loads
from pprint import pprint
from subprocess import check_call

capabilities = DesiredCapabilities.CHROME
capabilities["goog:loggingPrefs"] = {"performance": "ALL"}  # chromedriver 75+
chrome_options = Options()
chrome_options.add_argument('--hide-scrollbars')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument("--log-level=3")

books = ["MAT", "MRK", "LUK", "JHN", "ACT", "ROM", "1CO", "2CO", "GAL", "EPH", "PHP", "COL", "1TH", "2TH", "1TI", "2TI", "TIT", "PHM", "HEB", "JAS", "1PE", "2PE", "1JN", "2JN", "3JN", "JUD", "REV"]
chapters = [28, 16, 24, 21, 28, 16, 16, 13, 6, 6, 4, 4, 5, 3, 6, 4, 3, 1, 13, 5, 5, 3, 5, 1, 1, 1, 22]

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



def get(book, chapter):
    page = f"https://www2.bible.com/bible/194/{book}.{chapter}.WA2017?show_audio=1"
    driver.get(page)
    sleep(2)

    driver.find_element(By.XPATH, "//div[@class='circle-button play']").click()
    sleep(2)

def main():
    for book in books:
        for chapter in range(1, chapters[books.index(book)] + 1):
            global driver
            driver = webdriver.Chrome(chrome_options=chrome_options, desired_capabilities=capabilities)
            get(book, chapter)
            print(f"Retrieved {book} {chapter}")
            global logs
            logs = driver.get_log("performance")
            processLogs()
            driver.quit()



if __name__ == "__main__":
    main()

