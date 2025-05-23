FROM maven:3.8.6-openjdk-11
WORKDIR /app
COPY . /app
RUN mvn clean package -DskipTests
CMD ["java", "-jar", "target/ecommerce-1.0-SNAPSHOT.jar"]



