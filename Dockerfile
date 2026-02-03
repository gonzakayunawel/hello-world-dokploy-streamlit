# Usa una imagen de Python ligera y estable
FROM python:3.11-slim

# Evita que Python genere archivos .pyc y permite ver logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Instala dependencias del sistema necesarias (gcc es común para librerías de DS)
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

# Establece el directorio de trabajo
WORKDIR /app

# Copia e instala dependencias primero (aprovecha la caché de Docker)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto del código de la aplicación
COPY . .

# Expone el puerto por defecto de Streamlit
EXPOSE 8501

# Comando para ejecutar la aplicación
# Usamos 0.0.0.0 para que sea accesible desde fuera del contenedor
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
