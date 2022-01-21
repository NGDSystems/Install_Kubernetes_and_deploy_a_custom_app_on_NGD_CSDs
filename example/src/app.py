from subprocess import PIPE, Popen
from flask import Flask
import getpass
import psutil
import shlex
import os


# Identify the architecture of this machine / container
cmd = shlex.split("uname -m")
process = Popen(cmd, stdout=PIPE)
process.wait()
arch = process.stdout.readline().decode('utf-8').strip()


# Get the username we are running from
uid = str(os.getuid())
user_name = getpass.getuser()
node_name = os.getenv("NODE_NAME", "Unknown")
pod_ip = os.getenv("POD_IP", "Unknown")
pod_name = os.getenv("POD_NAME", "Unknown")
pod_namespace = os.getenv("POD_NAME", "Unknown")
home = os.path.expanduser('~')
cpu_count = str(psutil.cpu_count())
swap_memory = str(psutil.swap_memory().percent)
virtual_memory = str(psutil.virtual_memory())


# Cache the response
cached_response = ("Hello World!" 
    + "\n  UID: " + uid
    + "\n  Home: " + home
    + "\n  Username: " + user_name
    + "\n  NodeName: " + node_name
    + "\n  Arch: " + arch
    + "\n  PodNamespace: " + pod_namespace
    + "\n  PodName: " + pod_name
    + "\n  PodIP: " + pod_ip
    + "\n  #CPUs: " + cpu_count
    + "\n  swap_memory: " + swap_memory + "%"
    + "\n  virtual_memory: " + virtual_memory + "%"
    + "\n")


# Create the http server
app = Flask(__name__)

@app.route("/")
def hello():
    return cached_response
