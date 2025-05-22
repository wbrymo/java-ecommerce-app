FROM openjdk:17
COPY backend/target/ecommerce-1.0-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
