## set Tomcat webroot via server.xml Service/Engine/Host/Context#docBase
CATALINA_OPTS="${CATALINA_OPTS} -Dserver.webroot=${SERVER_WEBROOT}"

## the lucee-server directory will be created inside lucee.server.dir 
CATALINA_OPTS="${CATALINA_OPTS} -Dlucee.server.dir=/srv/www"

CATALINA_OPTS="${CATALINA_OPTS} -XshowSettings:vm"

CATALINA_OPTS="${CATALINA_OPTS} -Djava.security.egd=file:/dev/./urandom"
CATALINA_OPTS="${CATALINA_OPTS} -Dorg.apache.catalina.startup.ContextConfig.jarsToSkip=*"
CATALINA_OPTS="${CATALINA_OPTS} -Dorg.apache.catalina.startup.TldConfig.jarsToSkip=*"
CATALINA_OPTS="${CATALINA_OPTS} -Dtomcat.util.scan.StandardJarScanFilter.jarsToSkip=*"

CATALINA_OPTS="${CATALINA_OPTS} -javaagent:${CATALINA_BASE}/lib/lucee-external-agent.jar"

CATALINA_OPTS="${CATALINA_OPTS} -Dlucee.preserve.case=true"


# if file /srv/www/catalina-base/bin/addenv.sh exists then include it
ENV_INCLUDE_FILE=/srv/www/catalina-base/bin/addenv.sh
if [ -f $ENV_INCLUDE_FILE ]; then
    # set default to export variables
    set -a

    echo "Including file $ENV_INCLUDE_FILE"
    . $ENV_INCLUDE_FILE

    # unset default to export variables
    set +a
fi
