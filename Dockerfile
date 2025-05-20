FROM tomcat:9-jre9

LABEL MAINTAINER ="madhandeva249@gmail.com"
COPY ./target/maxxy.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8081