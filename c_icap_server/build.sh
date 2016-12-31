set -e -x

mkdir /build
cd /build

apk add -t devenv alpine-sdk ca-certificates clamav-dev pcre-dev zlib-dev db-c++

[ -n $C_ICAP_VERSION ] 
[ -n $SQUIDCLAMAV_VERSION ]

icap_modules=c_icap_modules-$C_ICAP_VERSION
icap_daemon=c_icap-$C_ICAP_VERSION
squidclamav=squidclamav-$SQUIDCLAMAV_VERSION


v_short=${C_ICAP_VERSION%.*}.x
wget http://downloads.sourceforge.net/project/c-icap/c-icap/$v_short/$icap_daemon.tar.gz
wget http://downloads.sourceforge.net/project/c-icap/c-icap-modules/$v_short/$icap_modules.tar.gz
wget http://downloads.sourceforge.net/project/squidclamav/squidclamav/$SQUIDCLAMAV_VERSION/$squidclamav.tar.gz

tar -xvzf $icap_daemon.tar.gz
tar -xvzf $icap_modules.tar.gz
tar -xvzf $squidclamav.tar.gz

cfg_opt="--prefix=/usr --sysconfdir=/etc/c-icap --localstatedir=/var --disable-dependency-tracking"

cd $icap_daemon


./configure $cfg_opt
make
make install

cd /build/$icap_modules
./configure $cfg_opt
make
make install

cd /build/$squidclamav
./configure $cfg_opt
make
make install

cd /

apk del devenv
rm -rf /build

