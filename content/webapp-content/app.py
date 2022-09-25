
from flask import Flask , request ,render_template
import requests
import os
app = Flask(__name__)


@app.route('/squad')
def squad():
    func_url =  os.environ['func_url']
    func_code =  os.environ['func_code']
    return render_template('squad.html', funcUrl=func_url, funcCode=func_code )


@app.route('/exponential')
def exponential():
    return render_template('exponential.html')



@app.route('/aks')
def sending_to_aks():
    aks_url =  os.environ['aks_url']
    aks_ip =  os.environ['aks_ip']
    num = request.args.get('num')
    calledIp = 'http://' + aks_ip
    res = requests.get(calledIp , headers={'host':aks_url},params={'num': num})
    return res.text


@app.route('/')
def home():
    return render_template('home.html')