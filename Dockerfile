# Utiliza una imagen base que tenga Node.js y PostgreSQL
FROM node:16
# Configura variables de entorno para PostgreSQL

# Directorio de trabajo
WORKDIR /app

# Copia el código de la aplicación
COPY . .

# Instala dependencias de la aplicación
RUN npm install --force

# Instala PostgreSQL y restaura la base de datos desde el archivo SQL de respaldo

# Expone el puerto en el que se ejecutará la aplicación
EXPOSE 5051

# Comando para iniciar la aplicación Node.js y PostgreSQL
CMD [ "npm", "run", "start" ]

