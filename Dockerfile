FROM postgres:15

COPY database_setup.sql /docker-entrypoint-initdb.d