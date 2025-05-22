FROM openjdk:11
WORKDIR /app
COPY . /app
RUN ./mvnw clean package -DskipTests
CMD ["java", "-jar", "target/ecommerce-1.0-SNAPSHOT.jar"]
