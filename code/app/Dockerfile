FROM public.ecr.aws/docker/library/amazoncorretto:11-alpine
#https://docs.aws.amazon.com/codeguru/latest/profiler-ug/enabling-the-agent-with-command-line.html
RUN mkdir -p /opt/target
RUN apk add libcrypto3 libssl3
EXPOSE 8080 5005
COPY target/aws-proserve-java-greeting.war /opt/target/
WORKDIR /opt/target
USER nobody
ENV _JAVA_OPTIONS '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005'
CMD ["sh", "-c", "java -jar aws-proserve-java-greeting.war --debug"]
HEALTHCHECK CMD curl --fail http://localhost:8080/hello || exit 1
