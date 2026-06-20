FROM amazoncorretto:17-alpine-jdk

EXPOSE 8080
#COPY ./target/java-maven-app-1.0-SNAPSHOT.jar /usr/app/
# the * matches any version
COPY ./target/java-maven-app-*.jar /usr/app/
WORKDIR /usr/app

#ENTRYPOINT ["java", "-jar", "java-maven-app-1.0-SNAPSHOT.jar"]
#Substitues the above command for CMD in order to be able to use * for dynamic image name
CMD java -jar java-maven-app-*.jar

