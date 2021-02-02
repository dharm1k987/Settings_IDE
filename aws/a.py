from time import sleep
import subprocess as sp
from requests import get
import re
import sys
import os

if len(sys.argv) != 3:
        print("USAGE: python3 a.py [folder] [course_only]")
        exit(0)
folder = sys.argv[1]


#COURSE_ONLY = "kubernetes-for-the-absolute-beginners-handson"
COURSE_ONLY=sys.argv[2]
COURSE = f"https://www.learningcrux.com/course/{COURSE_ONLY}"
URL = f"https://www.learningcrux.com/play/{COURSE_ONLY}"

response = get(COURSE).text
response = response.replace("\n","")

regex = r"(Section \d+:.*?)<\/h2"
regex2 = r"Saving to: '.*uc\?id=(.*)&"
sections = re.findall(regex, response)

print(f"Here are sections: {sections}")

ans = input("Continue ... (y/n)?")
if ans != "y":
    exit(0)

cookie = False
cookie_file = "cookie.txt"
save_cookies = f"--save-cookies {cookie_file} --keep-session-cookies"
load_cookies = f"--load-cookies {cookie_file} --keep-session-cookies"
other_flags = "--no-parent --no-check-certificate --content-disposition"
out_flags = "> /tmp/wget_stdout 2> /tmp/wget_stderr"

sections = sections[:]
section_count = 0
for section in sections:
    video_count = 0
    while True:
        print(f"Section {section_count}: {URL}/{section_count}/{video_count}/720")
        if not cookie:
            cookie = True
            p = sp.Popen(f"wget -P '{folder}/{section}' {save_cookies} {other_flags} {URL}/{section_count}/{video_count}/720 {out_flags}", stdout=sp.PIPE,shell=True)
        else:
            p = sp.Popen(f"wget -P '{folder}/{section}' {load_cookies} {other_flags} {URL}/{section_count}/{video_count}/720 {out_flags}", stdout=sp.PIPE,shell=True) 
        p.communicate()
        p.wait()
        print("Finished downloading")
        if p.returncode != 0:
            print("failed")
            break

        stderr = open("/tmp/wget_stderr").read()
        stderr = stderr.replace("‘","'")
        ids = re.findall(regex2, stderr)
        if ids:
            print("Google drive")
            p = sp.Popen(f"gdrive.sh {ids[0]} '{os.getcwd()}/{folder}/{section}'", shell=True)
            p.wait()

        print("Sleeping 5 seconds\n")
        sleep(5)
        video_count += 1
    print("----------------------")
    section_count += 1
