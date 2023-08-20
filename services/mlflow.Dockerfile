# Usar una imagen base con Python y MLflow
FROM python:3.9.17-slim-bullseye

# Establecer el directorio de trabajo en el contenedor
WORKDIR /mlflow

# Copiar requirements.txt y instalar las dependencias
COPY requeriments_mlflow.txt .
RUN pip install --no-cache-dir -r requeriments_mlflow.txt

# Crear la carpeta 'artifacts'
RUN mkdir --parents artifacts && \
    chmod 777 artifacts