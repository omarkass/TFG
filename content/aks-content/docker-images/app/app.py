from flask import Flask, render_template,request
import pypyodbc
import os
import sys


app = Flask(__name__)


@app.route('/')
def expo():
        database = 'sqldb'
        username = 'omar1'
        server = 'tcp:'+os.environ['sql_url']
        print ("hellow", file=sys.stderr)
        print( server, file=sys.stderr)
        password = 'Kassar@14689'
        num = request.args.get('num', default = 1, type = int)
        cnxn = pypyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
        cursor = cnxn.cursor()
        query = "select result from exponentiation where num=" + str(num)
        cursor.execute(query)
        row = cursor.fetchone()
        result = 0
        if cursor.rowcount == 0:
         result = num ** 2
         query = """INSERT INTO exponentiation VALUES (?, ?)"""
         cursor.execute(query,(num,result))
         cnxn.commit()
         cursor.close()
         cnxn.close()
        else:
         print(row)
         result= row
        result = str(result)
        result = result.replace(",)" , "")
        result = result.replace("(" , "")
        return str(result)


if __name__ == "__main__":
    port = int(os.environ.get('PORT', 30000))
    app.run(debug=True, host='0.0.0.0', port=port)