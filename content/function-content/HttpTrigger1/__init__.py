import logging
import azure.functions as func
import pypyodbc 
import math
import os

def main(req: func.HttpRequest) -> func.HttpResponse:
        server =  'tcp:'+ os.environ['sql_url'] # Creating the whole database url
        database = os.environ['sql_name'] # Getting the database name
        username = os.environ['sql_username'] # Getting the username of the database
        password = os.environ['sql_password'] # Getting the password of the database
        num = int(req.params.get("num")) # Getting the num Parameter 
        cnxn = pypyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password) # Creating the connection with the database 
        cursor = cnxn.cursor() # Starting the connection
        query = "select result from squad where num=" + str(num) # Creating the query to consult the database
        cursor.execute(query) # Execute the query
        row = cursor.fetchone() # Getting the result
        result = 0
        if cursor.rowcount == 0:  # In case nothing is returned
         result = math.sqrt(num) + math.sqrt(num) 
         query = """INSERT INTO squad VALUES (?, ?)""" # Create the query to insert the new result
         cursor.execute(query,(num,result)) # Execute the query
         cnxn.commit() # Update the database
         cursor.close() # End the connection
         cnxn.close() # Close the connection
        else:
         result= row
        result = str(result)
        result = result.replace(",)" , "")
        result = result.replace("(" , "")
        return func.HttpResponse(result) # Returning the result
