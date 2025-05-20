FROM tomcat:9-jre9

# Optional: MAINTAINER is deprecated, consider using LABEL instead
LABEL maintainer="madhandeva249@gmail.com"
COPY ./maxxy.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8081