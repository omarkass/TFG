import logging
import azure.functions as func
import pypyodbc 
import math
import os

def main(req: func.HttpRequest) -> func.HttpResponse:
        server =  'tcp:'+os.environ['sql_url']
        database = 'sqldb'
        username = 'omar1'
        password = 'Kassar@14689'
        num = int(req.params.get("num"))
        cnxn = pypyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
        cursor = cnxn.cursor()
        query = "select result from squad where num=" + str(num)
        cursor.execute(query)
        row = cursor.fetchone()
        result = 0
        if cursor.rowcount == 0:
         result = math.sqrt(num)
        # print(result)
         query = """INSERT INTO squad VALUES (?, ?)"""
         cursor.execute(query,(num,result))
         cnxn.commit()
         cursor.close()
         cnxn.close()
        else:
         #print(row)
         result= row
        result = str(result)
        result = result.replace(",)" , "")
        result = result.replace("(" , "")
       # print(result)
        return func.HttpResponse(result)
