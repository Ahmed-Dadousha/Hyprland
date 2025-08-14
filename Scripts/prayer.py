#!/bin/python3
from datetime import datetime, timedelta
import requests
import urllib3

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Optional: proxy and headers if needed
proxies = {"http": "http://127.0.0.1:8080", "https": "http://127.0.0.1:8080"}
headers = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:135.0) Gecko/20100101 Firefox/135.0"
}

# Get current date in DD-MM-YYYY format
current_date = datetime.today().strftime('%d-%m-%Y')

# Make the API request
url = f"https://api.aladhan.com/v1/timingsByCity/{current_date}?city=Cairo&country=Egypt"
res = requests.get(url=url, headers=headers ,verify=False)

# Parse the JSON response
data = res.json()
timings = data['data']['timings']

# Get current time
now = datetime.now()

# Define a list of main prayers
prayer_names = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']

# To store time differences
time_diffs = {}

# print("Time remaining until each prayer:")

for prayer in prayer_names:
    prayer_time_str = timings[prayer]
    
    # Combine today's date with the prayer time
    prayer_time = datetime.strptime(f"{now.date()} {prayer_time_str}", "%Y-%m-%d %H:%M")
    
    # If the prayer time already passed, consider it for the next day
    if prayer_time < now:
        prayer_time += timedelta(days=1)

    # Calculate time remaining
    time_remaining = prayer_time - now
    time_diffs[prayer] = time_remaining
    #
    # hours, remainder = divmod(time_remaining.seconds, 3600)
    # minutes, _ = divmod(remainder, 60)
    #
    # print(f"{prayer}: in {hours}h {minutes}m")

# Find the next upcoming prayer
next_prayer = min(time_diffs, key=time_diffs.get)
next_time = time_diffs[next_prayer]
next_hours, next_remainder = divmod(next_time.seconds, 3600)
next_minutes, next_seconds = divmod(next_remainder, 60)

print(f"{next_prayer} in {next_hours}h {next_minutes}m {next_seconds}s")
