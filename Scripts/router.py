#!/bin/python3

import sys

import requests
import urllib3
from bs4 import BeautifulSoup

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

proxies = {"http": "http://127.0.0.1:8080", "https": "http://127.0.0.1:8080"}

headers = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:135.0) Gecko/20100101 Firefox/135.0"
}


def login(s: requests.Session, url: str):
    try:
        # Getting a Valid Token
        randCountEndpoint = "/asp/GetRandCount.asp"
        res = s.post(
            url=f"{url}{randCountEndpoint}",
            verify=False,
            headers=headers,
        )
        token = res.text[1:]

        # Login
        loginEndPoint = "/login.cgi"
        data = {
            "UserName": "admin",
            "PassWord": "NTIwNkM5MDc=",
            "Language": "english",
            "x.X_HW_Token": token,
        }
        res = s.post(
            url=f"{url}{loginEndPoint}",
            data=data,
            verify=False,
            headers=headers,
        )
        print("[+] -> Logged In Successfully.") if len(res.text) == 596 else None

    except:
        print("[-] Faild To Login.")
        sys.exit(-1)


def reboot(s: requests.Session, url: str):

    # Login To Router Page
    login(s, url)

    token = ""

    # Getting A Second Token To Do Reboot
    try:
        res = s.get(
            url=f"{url}/index.asp", headers=headers, verify=False, proxies=proxies
        )
        soup = BeautifulSoup(res.text, "html.parser")
        token = soup.find("input", {"name": "onttoken"}).get("value")
    except AttributeError:
        print("[-] Faild To Get The Second Token.")
        sys.exit(-1)

    rebootEndPoint = "/html/ssmp/common/StartFileLoad.asp"
    res = s.get(url=f"{url}{rebootEndPoint}", verify=False, headers=headers)

    # Confirm Reboot Action
    try:
        confirmRebootEndPoint = "/html/ssmp/devicemanagement/set.cgi?x=InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard&RequestFile=html/ssmp/devicemanagement/devicemanagement.asp"

        s.post(
            url=f"{url}{confirmRebootEndPoint}",
            data={"x.X_HW_Token": token},
            verify=False,
            headers=headers,
            timeout=0.1,
        )
    except requests.exceptions.ReadTimeout:
        print("[+] -> Router Rebooted Successfully.")


def main():
    if len(sys.argv) != 1:
        print(f"[+] Usage: {sys.argv[0]}")
        print(f"[+] Example: {sys.argv[0]}")
        sys.exit()

    s = requests.Session()
    url = "https://wifi.hs.lan"
    reboot(s, url)


if __name__ == "__main__":
    main()
