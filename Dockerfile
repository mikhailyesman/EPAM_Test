FROM tomcat:alpine
ARG vers
ENV d=http://100.64.0.111:8081/content/repositories/releases/task7/${vers}/task7.war
RUN wget -P /usr/local/tomcat/webapps/ $d
