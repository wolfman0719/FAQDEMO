FROM store/intersystems/iris:2019.1.0.510.0-community 

ENV ISC_TEMP_DIR=/intersystems/iris/global
COPY FAQ/ $ISC_TEMP_DIR/
COPY TopicD.xml $ISC_TEMP_DIR

# Temporary folder
RUN cd $ISC_TEMP_DIR \
 && cd .. \
 && iris start iris EmergencyID=1,1 \ 
 && printf '1\n1\n \
 zn "USER" Do $system.OBJ.Load("/intersystems/iris/global/FAQ/Installer.cls","ck") \
 Do $system.OBJ.Load("/intersystems/iris/global/KB/Setup.cls","ck") \
 Do $system.OBJ.Load("/intersystems/iris/global/KB/Config.cls","ck") \
 Do $system.OBJ.Load("/intersystems/iris/global/KB/Utility.cls","ck") \
 do ##class(FAQ.Installer).runInstaller("global") \
 zn "%%SYS" Do INT^SHUTDOWN\n' | iris session iris | cat \
 && iris start iris nostu quietly \
 && printf "kill ^%%SYS(\"JOURNAL\") kill ^SYS(\"NODE\") Do INT^SHUTDOWN" | irissession IRIS -B | cat \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/* \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log \
 && rm -rf $ISC_TEMP_DIR

WORKDIR /

