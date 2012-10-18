#!/bin/sh

#SET SERVICE NAME
SERVICE_NAME="santander"

#READ PERSONAL DATA
. "./$SERVICE_NAME.data"

#DEFINE cURL BINARY
CURL_BIN=curl

COOKIE_FILE=$SERVICE_NAME.cookie
OUTPUT_FILE=$SERVICE_NAME.html

#LOGIN
$CURL_BIN \
	--insecure \
	--cookie-jar $COOKIE_FILE \
	--data "rut=$RUT&pin=$PIN" \
	--location "https://www.santander.cl/transa/cruce.asp" \
	> /dev/null 2>&1

#FETCHING
$CURL_BIN \
	--insecure \
	--silent \
	--cookie $COOKIE_FILE \
	--location "https://www.santander.cl/transa/productos/cm/Ccartola.asp?cta=$CTA" \
	> $OUTPUT_FILE

#DELETE COOKIE
rm $COOKIE_FILE

#OUTPUT
cat $OUTPUT_FILE |\
	awk '/<td valign="MIDDLE" colspan= "2" class=.td_f.>/,/<\/td>/' |\
	awk '{ for(i=1; i<=NF; i++) if($i ~/^[0-9]+/) {print $i} }'