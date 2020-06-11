set JAVA_HOME="c:\program files\java\j2re1.4.2_05"

set ARG_I=plaintext.txt
set ARG_O=.

set CP=lib\CALYON_Crypto_Java.jar;lib\bcmail-jdk14-143.jar;lib\bcprov-jdk14-143.jar;lib\log4j-1.2.11.jar

%JAVA_HOME%\bin\java -cp %CP% Trigger %ARG_I% %ARG_O%
pause
