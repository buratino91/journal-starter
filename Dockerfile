FROM postgres:15    

COPY .env . 

COPY database_setup.sql /docker-entrypoint-initdb.d

VOLUME [ "postgres_data:/var/lib/postgresql/data" ]

EXPOSE 5432

HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD [ "CMD-SHELL", "pg_isready -U ${POSTGRES_USER}" ]

