'''
from flask import Flask
app = Flask(__name__)


@app.route("/")
def home():
    exec(open("./primernumb.py").read())
    return "Hello, this is a sample Python Web App running on Flask Framework new version"
'''
from requests_toolbelt.utils import dump
from flask import Flask , request ,render_template
import requests
from functions import primeNum ,sumNum
import os
app = Flask(__name__)


@app.route('/exponential')
def exponential():
    func_url =  os.environ['func_url']
    func_code =  os.environ['func_code']
    return render_template('exponential.html', funcUrl=func_url, funcCode=func_code )


@app.route('/squad')
def squad():
    return render_template('squad.html')

'''
@app.route('/aks')
def sending_to_aks():
    #aks_url =  os.environ['aks_url']
    #aks_ip =  os.environ['aks_ip']
    num = request.args.get('num')
    print (num)
    res = requests.get('http://20.200.227.179', headers={'host':'app.local'},params={'num': num})
    return res.text
'''



@app.route('/aks')
def sending_to_aks():
    aks_url =  os.environ['aks_url']
    aks_ip =  os.environ['aks_ip']
    num = request.args.get('num')
    res = requests.get(aks_ip , headers={'host':aks_url},params={'num': num})
    return res.text


@app.route('/')
def home():
    return render_template('home.html')