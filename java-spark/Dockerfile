FROM java:8 

# Install maven
RUN apt-get update
RUN apt-get install -y maven

WORKDIR /spark
Add . /spark

RUN mvn package
EXPOSE 8080
CMD ["/usr/lib/jvm/java-8-openjdk-amd64/bin/java", "-jar", "target/hello-world-jar-with-dependencies.jar"]

