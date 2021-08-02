import socket
from datetime import date, datetime, timezone

from flask import  Flask

app = Flask(__name__)

@app.route('/')
def homework2():
    today = date.today()
    now = datetime.now()
    time_zone = datetime.now(timezone.utc).astimezone().tzname()
    hostname = socket.gethostname()
    local_ip = socket. gethostbyname(hostname)
    # dd/mm/YY
    d1 = today.strftime("%d/%m/%Y")
    current_time = now.strftime("%H:%M:%S")
    return "Current date: " + d1 + " - Current Time =" + current_time + " - Time Zone: " + time_zone + " - hostname: " + hostname + " - IP address: " + local_ip

if __name__ == '__main__':
    app.run(host='0.0.0.0')
