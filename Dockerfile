FROM openjdk:8

# Link download allowed ending with .zip
ENV PENTAHO_SERVER_DOWNLOAD https://sourceforge.net/projects/pentaho/files/Pentaho-9.3/server/pentaho-server-ce-9.3.0.0-428.zip

# https://sourceforge.net/projects/pentaho/files/
# Documentation https://help.hitachivantara.com/Documentation/Pentaho/9.3
ENV PENTAHO_SERVER_VERSION 9.3.0.0-428

ENV PENTAHO_HOME /opt/pentaho

RUN apt-get update

# Install tools
RUN apt-get install -y unzip nano wget

# Create folder pentaho and add permissions user pentaho
RUN mkdir ${PENTAHO_HOME}; useradd -s /bin/bash -d ${PENTAHO_HOME} pentaho; chown -R pentaho:pentaho ${PENTAHO_HOME};

# Download file pentaho-server and create filename to unzip + Permissions start-pentaho.sh
RUN wget $PENTAHO_SERVER_DOWNLOAD --progress=dot:giga -O /tmp/pentaho-server-ce-${PENTAHO_SERVER_VERSION}.zip; \
unzip -q /tmp/pentaho-server-ce-${PENTAHO_SERVER_VERSION}.zip -d $PENTAHO_HOME; \
sed -i -e 's/\(exec ".*"\) start/\1 run/' $PENTAHO_HOME/pentaho-server/tomcat/bin/startup.sh; \
chmod +x $PENTAHO_HOME/pentaho-server/start-pentaho.sh; \
rm /tmp/pentaho-server-ce-${PENTAHO_SERVER_VERSION}.zip;

USER pentaho

WORKDIR /opt/pentaho

EXPOSE 8080

CMD ["sh", "/opt/pentaho/pentaho-server/start-pentaho.sh"]