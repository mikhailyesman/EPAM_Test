FROM tomcat:alpine
ARG Nomer=${vers}
RUN wget -P /usr/local/tomcat/webapps/ http://100.64.0.111:8081/nexus/content/repositories/releases/task7/$Nomer/task7.war
