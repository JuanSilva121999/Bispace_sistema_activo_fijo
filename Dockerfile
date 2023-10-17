# Usamos una imagen base de Node.js
FROM node:18

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos el archivo package.json y package-lock.json para instalar dependencias
COPY package*.json ./

# Instalamos las dependencias
RUN npm install

# Copiamos el resto de los archivos del backend al contenedor
COPY . .

# Exponemos el puerto en el que se ejecutará tu servidor Node.js (ajusta según tu configuración)
EXPOSE 5051

# Comando para iniciar el servidor Node.js
CMD ["npm", "start"]
