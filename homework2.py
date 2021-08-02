import socket
from datetime import date, datetime, timezone

today = date.today()
now = datetime.now()
time_zone = datetime.now(timezone.utc).astimezone().tzname()
hostname = socket.gethostname()
local_ip = socket. gethostbyname(hostname)
# dd/mm/YY
d1 = today.strftime("%d/%m/%Y")
current_time = now.strftime("%H:%M:%S")
print("Current date:", d1)
print("Current Time =", current_time)
print("Time Zone: ",time_zone)
print("hostname: ", hostname)
print("IP address: ", local_ip)

