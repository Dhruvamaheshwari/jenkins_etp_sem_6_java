FROM openjdk:23

WORKDIR /app

COPY target/*.jar app.jar
RUN mvn clean install
COPY . .

EXPOSE 8080

ENTRYPOINT ["java" , "-jar" , "app.jar"]
