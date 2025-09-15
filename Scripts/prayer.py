#!/bin/python3
from datetime import datetime, timedelta
import requests
import urllib3
import json
import sys
import os

# === CONFIG ===
city = "Tanta"
country = "Egypt"
log_path = '/var/log/pray.json'  # JSON log file

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

headers = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:135.0) Gecko/20100101 Firefox/135.0"
}

# Get today's date
today = datetime.today().strftime('%d-%m-%Y')


# --- Step 1: Try to load cached prayer times from file ---
use_cached = False
timings = {}

if os.path.exists(log_path):
    try:
        with open(log_path, 'r') as file:
            saved_data = json.load(file)
            if saved_data.get("date") == today:
                timings = saved_data.get("timings", {})
                use_cached = True
    except Exception as e:
        print(f"[Warning] Failed to read cache: {e}")

# --- Step 2: Fetch from API if not cached ---
if not use_cached:
    url = f"https://api.aladhan.com/v1/timingsByCity/{today}?city={city}&country={country}"

    try:
        res = requests.get(url=url, headers=headers, verify=False, timeout=5)
        res.raise_for_status()
        data = res.json()
        if data['code'] != 200 or 'data' not in data or 'timings' not in data['data']:
            raise ValueError("Unexpected response format")
        timings = data['data']['timings']

        # Save to file
        try:
            with open(log_path, 'w') as file:
                json.dump({
                    "date": today,
                    "timings": timings
                }, file)
        except Exception as e:
            print(f"[Warning] Could not write to log file: {e}")

    except Exception as e:
        print(f"[Error] Failed to fetch prayer times from API: {e}")

        # --- MODIFIED: Try loading from file again as fallback ---
        if os.path.exists(log_path):
            try:
                with open(log_path, 'r') as file:
                    saved_data = json.load(file)
                    print("[Info] Using cached data as fallback.")
                    timings = saved_data.get("timings", {})
                    use_cached = True
            except Exception as e2:
                print(f"[Error] Could not read fallback cache: {e2}")
                sys.exit(1)
        else:
            print("[Error] No cached file found for fallback.")
            sys.exit(1)

#--- Step 3: Calculate next prayer time ---
now = datetime.now()
prayer_names = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']
time_diffs = {}

for prayer in prayer_names:
    prayer_time_str = timings.get(prayer)
    if not prayer_time_str:
        continue

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

if not time_diffs:
    print("[Error] Could not determine next prayer.")
    sys.exit(1)

next_prayer = min(time_diffs, key=time_diffs.get)
next_time = time_diffs[next_prayer]
next_hours, next_remainder = divmod(next_time.seconds, 3600)
next_minutes, _ = divmod(next_remainder, 60)

text = f"{next_prayer} in {next_hours}h {next_minutes}m"
print(text)

# --- Step 4: Notify if needed ---
if "0h 5m" in text:
    os.system(f'notify-send \"{next_prayer}\" \"Time To Pray\" -i ~/Photos/Icons/pray.png -u critical')
    os.system('paplay /usr/share/sounds/freedesktop/stereo/bell.oga')

