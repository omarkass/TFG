'''
from flask import Flask
app = Flask(__name__)


@app.route("/")
def home():
    exec(open("./primernumb.py").read())
    return "Hello, this is a sample Python Web App running on Flask Framework new version"
'''

from flask import Flask , request ,render_template
from functions import primeNum ,sumNum
app = Flask(__name__)


@app.route('/exponential')
def exponential():
    return render_template('exponential.html')


@app.route('/squad')
def squad():
    return render_template('squad.html')


@app.route('/')
def home():
    return render_template('home.html')