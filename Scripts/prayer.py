#!/bin/python3
from datetime import datetime, timedelta
import requests
import urllib3
import sys
import os


# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Headers only (no proxy)
headers = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:135.0) Gecko/20100101 Firefox/135.0"
}

# Get current date
current_date = datetime.today().strftime('%d-%m-%Y')

# API URL
url = f"https://api.aladhan.com/v1/timingsByCity/{current_date}?city=Tanta&country=Egypt"

try:
    res = requests.get(url=url, headers=headers, verify=False, timeout=5)
    res.raise_for_status()
except requests.exceptions.RequestException as e:
    print(f"[Error] Failed to fetch prayer times: {e}")
    sys.exit(1)

# Parse the response
data = res.json()
if data['code'] != 200 or 'data' not in data or 'timings' not in data['data']:
    print("[Error] Unexpected response format.")
    sys.exit(1)

timings = data['data']['timings']
now = datetime.now()

# List of key prayers
prayer_names = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']
time_diffs = {}

for prayer in prayer_names:
    prayer_time_str = timings.get(prayer)
    if not prayer_time_str:
        continue

    # Try parsing 24-hour or 12-hour time format
    try:
        try:
            prayer_time = datetime.strptime(f"{now.date()} {prayer_time_str}", "%Y-%m-%d %H:%M")
        except ValueError:
            prayer_time = datetime.strptime(f"{now.date()} {prayer_time_str}", "%Y-%m-%d %I:%M %p")
    except Exception as e:
        print(f"[Error] Failed to parse time for {prayer}: {e}")
        continue

    if prayer_time < now:
        prayer_time += timedelta(days=1)

    time_diffs[prayer] = prayer_time - now

# Find the next prayer
if not time_diffs:
    print("[Error] Could not determine next prayer.")
    sys.exit(1)

next_prayer = min(time_diffs, key=time_diffs.get)
next_time = time_diffs[next_prayer]
next_hours, next_remainder = divmod(next_time.seconds, 3600)
next_minutes, _ = divmod(next_remainder, 60)

text= f"{next_prayer} in {next_hours}h {next_minutes}m"

print(text)

if "0h 5m" in text:
    os.system(f'notify-send \"{next_prayer}\" \"Time To Pray\" -i ~/Photos/Icons/pray.png -u critical')
    os.system('paplay /usr/share/sounds/freedesktop/stereo/bell.oga')
