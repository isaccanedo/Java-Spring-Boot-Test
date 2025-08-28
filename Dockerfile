# Estágio 1: Construir a aplicação
FROM eclipse-temurin:21-jdk-jammy AS build

# Mudar para o diretório de trabalho
WORKDIR /app

# Copiar os arquivos de construção do Maven
COPY pom.xml .
COPY src ./src
COPY .mvn ./.mvn
COPY mvnw .

# Dar permissão de execução ao mvnw
RUN chmod +x ./mvnw

# Construir a aplicação
RUN ./mvnw clean package -DskipTests

# Estágio 2: Criar a imagem final
FROM eclipse-temurin:21-jre-jammy

# Copiar o JAR da aplicação do estágio de construção
COPY --from=build /app/target/*.jar app.jar

# Expor a porta que a sua aplicação Spring Boot utiliza (ex: 8080)
EXPOSE 8080

# Comando para executar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
