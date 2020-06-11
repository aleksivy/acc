#/usr/local/bin/tcsh


setenv ARG_I plaintext.txt
setenv ARG_O .
setenv ARG_C cer\OPTIMCLICTEST.pfx

setenv CP lib\CALYON_Crypto_Java.jar:lib\bcmail-jdk14-143.jar:lib\bcprov-jdk14-143.jar:lib\log4j-1.2.11.jar
setenv CMD "java -cp ${CP} CreateSMime -i ${ARG_I} -o ${ARG_O} -c ${ARG_C}"

echo ${CMD}
${CMD}


