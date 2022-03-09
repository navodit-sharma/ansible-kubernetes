apt-key adv --list-public-keys --with-fingerprint --with-colons | grep 9DC858229FC7DD38854AE2D88D81803C0EBFCD88
STATUS=`echo $?`

if [ "$STATUS" -eq 0 ]; then
    exit 0
else
    exit 1
fi
