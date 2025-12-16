<html>
    <head>
        <title>Lucee Lab Test App</title>
    </head>
    <body>

<cfoutput>
    <h1>Lucee #Server.lucee.version# !!!</h1>
    <h2>Server time: #now()#</h2>
    <h2>Webroot is mounted from host: #Server.system.environment.HOST_APP_WEBROOT#
    
    <h2>Lucee Admin*: <a href="/lucee/admin/server.cfm" target="lucee_admin">/lucee/admin/server.cfm</a></h2>
    <cfif (CGI.SERVER_PORT != Server.system.environment.HOST_PORT_LUCEE)>
        <p>* The Lucee Admin is only accessible on the Lucee port (#Server.system.environment.HOST_PORT_LUCEE#)
    </cfif>
    
    <p>Password is: #Server.system.environment.LUCEE_ADMIN_PASSWORD#
    <p>
    <cfset arrPaths = [ "lucee-web", "lucee-server", "lucee-config", "web-root-directory", "temp-directory", "home-directory", "system-directory", "web-context-hash", "web-context-label" ]>
    <cfloop array="#arrPaths#" item="path">
        {#path#}: #expandPath('{#path#}')#<br>
    </cfloop>
</cfoutput>

<cfflush interval="1">

<p>
<cftry>
    <cfquery name="q" datasource="postgres" timeout="2">
        SELECT  version() AS db_version,
                current_timestamp;
    </cfquery>

    <cfdump var="#q#" label="Postgres Version">

    <cfcatch>
        <cfdump var="#cfcatch.message#" label="Postgres Version">
    </cfcatch>
</cftry>

<p>
<cftry>
    <cfquery name="q" datasource="mysql" timeout="2">
        SELECT  version() AS db_version,
                current_timestamp;
    </cfquery>

    <cfdump var="#q#" label="MySQL Version">

    <cfcatch>
        <cfdump var="#cfcatch.message#" label="MySQL Version">
    </cfcatch>
</cftry>
    
<p>
<cftry>

    <!--- <cfset red = redisCommand(arguments: ["KEYS", "*"], cache: "redis")> --->
    <cfset red = redisCommand(arguments: ["INFO"], cache: "redis")>

    <cfdump var="#red#" label="Redis INFO">

    <cfcatch>
        <cfdump var="#cfcatch.message#" label="Redis INFO">
    </cfcatch>
</cftry>

<p>
<cfdump eval="Server.system.environment">

<p>
<cfdump eval="Server.system.properties">

<p>
<cfdump eval="CGI">

    </body>
</html>