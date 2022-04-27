import logging
import azure.functions as func
import pypyodbc 


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    name = req.params.get('name')
    server = 'tcp:proj-dev-sql.database.windows.net' 
    database = 'proj-dev-sqldb' 
    username = 'omar1' 
    password = 'Kassar@14689' 
    cnxn = pypyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
    cursor = cnxn.cursor()
    cursor.execute('SELECT * FROM Tarifa')
    row = cursor.fetchone()
    while row is not None:
        print(row)
        row = cursor.fetchone()
    return func.HttpResponse(f"this is the lis.")
