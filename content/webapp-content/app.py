'''
from flask import Flask
app = Flask(__name__)


@app.route("/")
def home():
    exec(open("./primernumb.py").read())
    return "Hello, this is a sample Python Web App running on Flask Framework new version"
'''

from flask import Flask , requests ,render_template
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
    return render_template('squad.html', funcUrl=func_url, funcCode=func_code  )


@app.route('/aks')
def sending_to_aks():
    num = requests.form.get('num')
    data= {'num',num}
    res = requests.get('http://20.249.26.151/', headers={'host':'app.lcoal'}, json=data)
    return res.text

    #return render_template('squad.html', funcUrl=func_url, funcCode=func_code  )


@app.route('/')
def home():
    return render_template('home.html')