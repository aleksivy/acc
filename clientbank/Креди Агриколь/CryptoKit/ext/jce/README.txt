   Unlimited Strength Java(TM) Cryptography Extension Policy Files
        for the Java(TM) 2 SDK, Standard Edition, v 1.4.2

                               README

----------------------------------------------------------------------
CONTENTS
----------------------------------------------------------------------

     o Introduction
     o Copyright
     o Understanding The Export/Import Issues
     o Where To Find Documentation
     o Installation
     o Questions, Support, Reporting Bugs, and Feedback


----------------------------------------------------------------------
Introduction
----------------------------------------------------------------------

Thank you for downloading the Unlimited Strength Java(TM) Cryptography 
Extension (JCE) Policy Files for the Java(TM) 2 SDK, Standard Edition, 
v 1.4.2 (J2SDK).

Due to import control restrictions, the version of JCE policy files that 
are bundled in the J2SDK, v 1.4.2 environment allow "strong" but 
limited cryptography to be used. This download bundle (the one including 
this README file) provides "unlimited strength" policy files which 
contain no restrictions on cryptographic strengths.

Please note that this download file does NOT contain any encryption 
functionality since such functionality is supported in Sun's J2SDK, 
v 1.4.2. Thus, this installation applies only to Sun's J2SDK, v 1.4.2,
and assumes that the J2SDK, v 1.4.2 is already installed.


----------------------------------------------------------------------
Copyright
----------------------------------------------------------------------

The copyright notice governing this product's use can be found in
COPYRIGHT.html. This file is normally found in the same directory 
as this README.txt file.


----------------------------------------------------------------------
Understanding The Export/Import Issues
----------------------------------------------------------------------

JCE for J2SDK, v 1.4.2 has been through the U.S. export review
process. The JCE framework, along with the SunJCE provider that comes
standard with it, is exportable.

The JCE architecture allows flexible cryptographic strength
to be configured via jurisdiction policy files. Due to the
import restrictions of some countries, the jurisdiction policy files 
distributed with the J2SDK, v 1.4.2 software have built-in 
restrictions on available cryptographic strength. The jurisdiction 
policy files in this download bundle (the bundle including this 
README file) contain no restrictions on cryptographic strengths. 
This is appropriate for most countries. Framework vendors can 
create download bundles that include jurisdiction policy files 
that specify cryptographic restrictions appropriate for countries 
whose governments mandate restrictions. Users in those countries 
can download an appropriate bundle, and the JCE framework will 
enforce the specified restrictions.

Since JCE for J2SDK, v 1.4.2 has been granted "retail" status, 
a product which bundles JCE may be globally distributable.
You are advised to consult your export/import control counsel or 
attorney to determine the exact requirements.

For more information on U.S. encyption policies, refer to these web sites:

    U.S. Dept of Commerce               www.doc.gov
    Export Policy Resource Page         www.crypto.com
    Computer Systems Public Policy      www.cspp.org


----------------------------------------------------------------------
Where To Find Documentation
----------------------------------------------------------------------

The following documents will be of interest to you:

    o  The Java(TM) Cryptography Extension (JCE) Reference Guide at: 

            http://java.sun.com/products/jce/index-14.html

    o  The Java Security web site has more information about JCE,
       plus additional information about the Java 2 Security Model.
       Please see:

            http://java.sun.com/products/jce/
            http://java.sun.com/security/


----------------------------------------------------------------------
Installation
----------------------------------------------------------------------

Notes:

  o Win32 and Solaris use different pathname separators, so
    please use the appropriate one ("\", "/") for your
    environment. 

  o <java-home> refers to the directory where 
    the Java 2 Runtime Environment (JRE) was installed. 
    It is determined based on whether you are running JCE on 
    a JRE with or without the J2SDK installed. The J2SDK 
    contains the JRE, but at a different level in the file 
    hierarchy. For example, if the J2SDK is installed in 
    /home/user1/j2sdk1.4.2 on Solaris or in 
    C:\j2sdk1.4.2 on Win32, then <java-home> is

        /home/user1/j2sdk1.4.2/jre    (Solaris)
        C:\j2sdk1.4.2\jre             (Win32)

    If on the other hand the JRE is installed in /home/user1/j2re1.4.2
    on Solaris or in C:\j2re1.4.2 on Win32, and the J2SDK is not
    installed, then <java-home> is

        /home/user1/j2re1.4.2        (Solaris)
        C:\j2re1.4.2                 (Win32)

Here are the installation instruction:

1)  Download the unlimited strength JCE policy files.

2)  Uncompress and extract the downloaded file.

    This will create a subdirectory called jce.
    This directory contains the following files:

        README.txt            This file
        COPYRIGHT.html        Copyright information
        local_policy.jar      Unlimited strength local policy file
        US_export_policy.jar  Unlimited strength US export policy file

3)  Install the unlimited strength policy JAR files.

	To utilize the encryption/decryption functionalities of
	the JCE framework without any limitation, first make a copy of
	the original JCE policy files (US_export_policy.jar and
	local_policy.jar in the standard place for JCE
	jurisdiction policy JAR files) in case you later decide 
	to revert to these "strong" versions. Then replace the strong 
	policy files with the unlimited strength versions extracted in the 
	previous step.

    The standard place for JCE jurisdiction policy JAR files is: 

        <java-home>\lib\security         [Win32]
        <java-home>/lib/security         [Solaris]


-----------------------------------------------------------------------
Questions, Support, Reporting Bugs, and Feedback
-----------------------------------------------------------------------

Questions
---------

For miscellaneous questions about JCE usage and deployment, we
encourage you to read:

    o Information on the JCE web site

        http://java.sun.com/products/jce

    o The Java Security Q&A Archives

        http://archives.java.sun.com/archives/java-security.html

    o The Java Developer Connection(SM) forums. These discussion forums
      allow you to tap into the experience of other users, ask
      questions, or offer tips to others on a variety of Java-related
      topics including JCE. There is no fee to participate.

        http://forum.java.sun.com/

    o Although not supported by Sun, an alternative for technical
      expertise may be found at:

        http://www.hotdispatch.com/sun


Support
-------

For more extensive JCE questions or deployment issues, Sun currently
offers several levels of developer support for the Java 2 platform:

    o Per-Incident
    o Developer Access Direct(SM)
    o Developer Access Plus(SM)

For more information, please see

    http://www.sun.com/developer/support/

Please be aware that we may be barred from offering technical support
specifically regarding encryption implementations of the JCE APIs to
people outside the U.S. or Canada, according to U.S. regulations.


Reporting Bugs
--------------

To report bugs with sample code or request a feature, please see:

    http://java.sun.com/cgi-bin/bugreport.cgi

Bug reports with test cases are highly appreciated!


Feedback
--------

Please e-mail general comments about JCE to:

    java-security@sun.com

The above mailing list is not a subscription list or a support
mechanism.  It is simply a one-way channel that you can use to 
send comments to the Java 2 Standard Edition security team. 
Please include the keyword "JAVASEC" in the Subject of your 
email so it can be distinguished from spam.

Though we value your input, before sending your feedback please review
our pages of Frequently Asked Questions, available from the JCE web
site:

    http://java.sun.com/products/jce

and search the Java Security Q&A Archives:

    http://archives.java.sun.com/archives/java-security.html

Please note that due to the volume of messages we receive, we
may not be able to respond to every individual message.

For other comments/suggestions concerning the web sites please
use the feedback form at:

        http://java.sun.com/feedback/index.html

