FROM openjdk:8
COPY target/*.jar /usr/local/*.jar
EXPOSE 8091
CMD ["java", "-jar", "/usr/local/*.jar"]
