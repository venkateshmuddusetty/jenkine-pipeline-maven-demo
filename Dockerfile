FROM openjdk:8
COPY target/*.jar /usr/local/demo.jar
EXPOSE 8091
CMD ["java", "-jar", "/usr/local/demo.jar"]
