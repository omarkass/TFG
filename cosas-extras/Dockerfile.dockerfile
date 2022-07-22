# parent image
FROM python:3.9

# install FreeTDS and dependencies
RUN apt-get update \
 && apt-get install unixodbc -y \
 && apt-get install unixodbc-dev -y \
 && apt-get install freetds-dev -y \
 && apt-get install freetds-bin -y \
 && apt-get install tdsodbc -y \
 && apt-get install --reinstall build-essential -y \
 && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
 && apt-get update \
 && ACCEPT_EULA=Y apt-get install -y msodbcsql17
# && ACCEPT_EULA=Y apt-get install -y mssql-tools \
# && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
# && source ~/.bashrc \
# && apt-get install -y unixodbc-dev \
# && apt-get install -y libgssapi-krb5-2

# populate "ocbcinst.ini"
RUN echo "[FreeTDS]\n\
Description = FreeTDS unixODBC Driver\n\
Driver = /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so\n\
Setup = /usr/lib/x86_64-linux-gnu/odbc/libtdsS.so" >> /etc/odbcinst.ini

# install pyodbc (and, optionally, sqlalchemy)
RUN pip install --trusted-host pypi.python.org pyodbc==4.0.26 sqlalchemy==1.3.5 Flask-SQLAlchemy==2.5.1

COPY ./app /app
# switch working directory
WORKDIR /app

# install the dependencies and packages in the requirements file
RUN pip install -r requirements.txt
# run app.py upon container launch
CMD ["python", "app.py"]
