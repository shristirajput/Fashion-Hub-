Set-Location 'C:\FashionHub'
& 'C:\FashionHub\apache-maven-3.9.6\bin\mvn.cmd' clean package
Copy-Item -Path 'C:\FashionHub\target\FashionHub-1.0-SNAPSHOT.war' -Destination 'C:\FashionHub\apache-tomcat-9.0.87\webapps\FashionHub.war' -Force
$env:CATALINA_HOME = 'C:\FashionHub\apache-tomcat-9.0.87'
& 'C:\FashionHub\apache-tomcat-9.0.87\bin\startup.bat'
