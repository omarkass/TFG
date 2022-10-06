
from flask import Flask , request ,render_template
import requests
import os
app = Flask(__name__)


#set the route for the squad.html template
@app.route('/squad')
def squad():
    func_url =  os.environ['func_url'] 
    return render_template('squad.html', funcUrl=func_url)

#set the route for the squad.html template
@app.route('/exponential')
def exponential():
    return render_template('exponential.html')


#Create the needed request for calling app project inside the Aks
@app.route('/aks')
def sending_to_aks():
    aks_url =  os.environ['aks_url']
    aks_ip =  os.environ['aks_ip']
    num = request.args.get('num')
    calledIp = 'http://' + aks_ip
    #Adding host = $aks_url to the header of the request that will be sent to the ingress controller 
    res = requests.get(calledIp , headers={'host':aks_url},params={'num': num})
    return res.text

#set the route for the squad.html template
@app.route('/')
def home():
    return render_template('home.html')