FROM tomcat:alpine
ARG blabla=$vers
ENV d=http://100.64.0.111:8081/nexus/content/repositories/releases/task7/${blabla}/task7.war
RUN echo $vers
RUN echo ${d}
RUN echo blabla
