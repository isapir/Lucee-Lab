<cfoutput>
    <h1>Lucee #Server.lucee.version#</h1>
    <h2>Server time: #now()#</h2>
    <h2>Webroot is mounted from host: #Server.system.environment.HOST_APP_WEBROOT#
    <h2>Lucee Admin*: <a href="/lucee/admin/server.cfm" target="lucee_admin">/lucee/admin/server.cfm</a></h2>
    <p>* The Lucee Admin is only accessible on the Lucee port, and is blocked via nginx. 
        Password is: #Server.system.environment.LUCEE_ADMIN_PASSWORD#
</cfoutput>

<p>
<cftry>
    <cfquery name="q" datasource="postgres">
        SELECT  version() AS db_version,
                current_timestamp;
    </cfquery>

    <cfdump var="#q#" label="Postgres Version">

    <cfcatch>
        <cfdump eval="cfcatch">
    </cfcatch>
</cftry>

<p>
<cftry>

    <!--- <cfset red = redisCommand(arguments: ["KEYS", "*"], cache: "redis")> --->
    <cfset red = redisCommand(arguments: ["INFO"], cache: "redis")>

    <cfdump var="#red#" label="Redis INFO">

    <cfcatch>
        <cfdump eval="cfcatch">
    </cfcatch>
</cftry>

<p>
<cfdump eval="Server.system.environment">

<p>
<cfdump eval="Server.system.properties">

<p>
<cfdump eval="CGI">
