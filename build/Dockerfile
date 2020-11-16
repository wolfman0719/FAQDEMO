FROM store/intersystems/iris-community:2020.3.0.221.0 

ARG COMMIT_ID="faqdemo"

USER irisowner

ENV ISC_TEMP_DIR=/intersystems/iris/global
COPY FAQ/ $ISC_TEMP_DIR/
COPY TopicD.xml $ISC_TEMP_DIR

RUN  iris start $ISC_PACKAGE_INSTANCENAME \ 
&& printf 'Do ##class(Config.NLS.Locales).Install("jpuw") \
 set user = ##class(Security.Users).%%OpenId("_system") \
 set user.PasswordExternal = "demosystem" \
 set status = user.%%Save() \
 h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \ 
&& printf 'Do $system.OBJ.Load("'$ISC_TEMP_DIR'/FAQ/Installer.cls","ck") \
 Do $system.OBJ.Load("'$ISC_TEMP_DIR'/KB/Setup.cls","ck") \
 Do $system.OBJ.Load("'$ISC_TEMP_DIR'/KB/Config.cls","ck") \
 Do $system.OBJ.Load("'$ISC_TEMP_DIR'/KB/Utility.cls","ck") \
 do ##class(FAQ.Installer).runInstaller("global") \
 h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U USER\
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly

RUN rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/*

RUN echo $COMMIT_ID > $HOME/commit.txt