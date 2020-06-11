set JAVA_HOME="C:\Program Files\Java\jre1.8.0_151"

set ARG_I=.
set ARG_O=.
set ARG_C=cer\ClicClient.cer.

set CP=lib\CALYON_Crypto_Java.jar;lib\bcmail-jdk14-143.jar;lib\bcprov-jdk14-143.jar;lib\log4j-1.2.11.jar

%JAVA_HOME%\bin\java -cp %CP% CreateSMime -i %ARG_I% -o %ARG_O% -c %ARG_C%
pause
