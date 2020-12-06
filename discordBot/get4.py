import time
import os

token = "NzE1MTA3NzM0MTE4MjAzNDIz.Xs42XQ.RIvhHTHK3G-JMxxCg7_-Iv5GY-Q"
lenght = 0
os.system("cd AnarchyBot")
while True:
    time.sleep(5)
    os.system("cd AnarchyBot && git pull > /dev/null")
    newlenght =  os.popen('cd AnarchyBot && git rev-list --all --count').read()
    if (int(newlenght) > lenght):
        os.system("echo 'Logs (webpage does not automatically reload)\n\n' > html/out.out")
        lenght = int(newlenght)
        os.system("screen -X -S anarchyscreen quit")
        isHere =  os.popen('cd AnarchyBot && git rev-list --all --count').read()
        os.system("screen -dmS anarchyscreen && screen -S anarchyscreen -X stuff \"cd AnarchyBot && ((echo '#\n# pip:\n#\n' && python3 -m pip install . && export PYTHONUNBUFFERED=1 && echo '\n\n#\n# Anarchybot:\n#\n' && python3 -m anarchybot " + token + ") >> ../html/out.out 2>&1) \n\"")

