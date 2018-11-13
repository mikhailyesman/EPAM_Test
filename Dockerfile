FROM tomcat:alpine
ARG vers
ENV s=${vers}
RUN wget -P /usr/local/tomcat/webapps/ http://100.64.0.111:8081/nexus/content/repositories/releases/task7/${s}/task7.war
