#!/bin/sh
set -x -e
apk add alpine-sdk db-dev flex bison

mkdir /build
cd /build
curl http://www.squidguard.org/Downloads/squidGuard-${SQUIDGUARD_VERSION}.tar.gz | tar -xvzf -
cd squidGuard-${SQUIDGUARD_VERSION}
curl "https://bugs.squid-cache.org/attachment.cgi?id=2988" | patch -p1
cat <<EOF | patch -p1
diff -ruN squidGuard-1.4-vanilla/src/sgDb.c squidGuard-1.4/src/sgDb.c
--- squidGuard-1.4-vanilla/src/sgDb.c   2008-07-15 04:29:41.000000000 +1000
+++ squidGuard-1.4/src/sgDb.c   2013-01-21 12:47:41.049325756 +1100
@@ -114,7 +114,7 @@
     }
   }
 #endif
-#if DB_VERSION_MAJOR == 4
+#if DB_VERSION_MAJOR >= 4
   if(globalUpdate || createdb || (dbfile != NULL && stat(dbfile,&st))){
     flag = DB_CREATE;
     if(createdb)

EOF
echo "struct UserInfo * setuserinfo();" >>src/sg.h.in
./configure
make
make install

cd /
rm -rf /build

apk del alpine-sdk db-dev flex bison
