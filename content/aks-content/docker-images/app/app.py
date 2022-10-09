from flask import Flask, render_template,request
import pypyodbc
import os
import sys


app = Flask(__name__)


@app.route('/')
def expo():
        database = os.environ['sql_name'] # Getting the database name
        username = os.environ['sql_username'] # Getting the username of the database
        password = os.environ['sql_password'] # Getting the password of the database
        server = 'tcp:'+os.environ['sql_url'] # Creating the whole database url
        print ("hellow", file=sys.stderr)
        print( server, file=sys.stderr)
        num = request.args.get('num', default = 1, type = int)  # Getting the num Parameter 
        cnxn = pypyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password) # Creating the connection with the database 
        cursor = cnxn.cursor() # Starting the connection
        query = "select result from exponentiation where num=" + str(num) # Creating the query to consult the database
        cursor.execute(query) # Execute the query
        row = cursor.fetchone() # Getting the result
        result = 0
        if row == None: # In case nothing is returned
         result = num * num
         query = """INSERT INTO exponentiation VALUES (?, ?)""" # Create the query to insert the new result
         cursor.execute(query,(num,result)) # Execute the query
         cnxn.commit() # Update the database
         cursor.close() # End the connection
         cnxn.close() # Close the connection
        else:
         result= row
        result = str(result)
        result = result.replace(",)" , "")
        result = result.replace("(" , "")
        return str(result) # Returning the result in string format


if __name__ == "__main__":
    port = int(os.environ.get('PORT', 30000))
    app.run(debug=True, host='0.0.0.0', port=port)
