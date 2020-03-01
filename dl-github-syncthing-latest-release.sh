#!/bin/bash
#########################################################
#
#   Maintained by Gregor Santner, 2020-
#   https://gsantner.net/
#
#########################################################
# vim: sw=4 ts=4 ft=sh noexpandtab:

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTFILE=$(readlink -f $0)
SCRIPTDIR_REAL=$(dirname $SCRIPTFILE)
SCRIPTDIR_PARENT="$(dirname "$SCRIPTDIR")"
WORKINGDIR="$(pwd)"
argc=$#; argv=$@; RCol='\e[0m'; Gra='\e[0;90m'; Gre='\e[0;32m'; Red='\e[0;31m'; Yel='\e[0;33m'; Pur='\e[0;35m';

#########################################################

cd "$SCRIPTDIR"
ARCH="linux-arm"

echo "Download syncthing"
for url in $(curl -s "https://api.github.com/repos/syncthing/syncthing/releases/latest" | grep "$ARCH" | grep '^\s*"browser_download_url.*tar.gz' | cut -d'"' -f4) ; do
	arch=`echo -n "$url"    | sed 's@.*syncthing-@@'       | sed 's@-v.*@@'`
	version=`echo -n "$url" | sed 's@.*syncthing-@@' | rev | sed 's@v-.*@@' | rev | sed 's@.tar.gz@@'`
	rm -Rf dl && mkdir dl
	echo "...v${version} for ${arch}"
	curl -s -L "$url" | tar -C dl -xzv > /dev/null
	mv "dl/syncthing-"*"/syncthing" "syncthing-$arch"
done
rm -Rf dl
sed -i "s@version\": .*@version\": \"${version}-1\",@" "manifest.json"
