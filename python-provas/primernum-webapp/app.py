from flask import Flask , request
from functions import primeNum ,sumNum
app = Flask(__name__)

#http://127.0.0.1:5000/prime?num=30
@app.route('/prime')
def prime():
    num = request.args['num']
   # return 'The value is: ' + num
    msg = primeNum(int(num))
    return  num + ' ' +msg

       
#http://127.0.0.1:5000/sum?num1=30&num2=4
@app.route('/sum')
def sum():
    num1 = request.args['num1']
    num2 = request.args['num2']
   # return 'The value is: ' + num
    num = sumNum(int(num1), int(num2))
    return  'The result is ' + str(num) 