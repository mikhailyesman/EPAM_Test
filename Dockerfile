FROM tomcat:alpine
ARG vers
RUN wget -P /usr/local/tomcat/webapps/ http://100.64.0.111:8081/repository/snapshot/task7/$NameFile/task7.war
