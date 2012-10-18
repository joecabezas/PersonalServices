#!/bin/sh

#SET SERVICE NAME
SERVICE_NAME="entel"

#READ PERSONAL DATA
. "./$SERVICE_NAME.data"

#DEFINE cURL BINARY
CURL_BIN=curl

COOKIE_FILE=$SERVICE_NAME.cookie

#LOGIN
$CURL_BIN \
	--cookie-jar $COOKIE_FILE \
	--data "buic_rutdv=$RUTDV&Movil=$MOVIL&Rut=$RUT&PIN=$PIN" \
	--location "http://www.entelpcs.cl/login/valida_ws.iws?origen=home" \
	> /dev/null 2>&1

#ALGUNAS OTRAS URL IMPORTANTES
#http://mi.entel.cl/personas/portlet/facturacion/resumenFacturacionJson.faces
#http://mi.entel.cl/personas/portlet/trafico/traficoEnLineaJson.faces

#FETCHING
$CURL_BIN \
	--silent \
	--cookie $COOKIE_FILE \
	--location "http://mi.entel.cl/personas/portlet/plan/resumenPlanJson.faces" \
	> $SERVICE_NAME.output

#DELETE COOKIE
rm $COOKIE_FILE

jsonval()
{
	temp=`\
	cat $SERVICE_NAME.output |\
	sed 's/\\\\\//\//g' |\
	sed 's/[{}]//g' |\
	awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' |\
	sed 's/,"/\n/g' |\
	sed 's/":"*/|/g' |\
	sed 's/^"//g' |\
	grep "$1|"\
	`

	echo ${temp##*|}
}

#mas variables con informacion
# estado
# detalle
# nombrePlan
# fechaExpiracion
# fechaExpiracionFormated
# saldo
# saldoFormated
# mercadoCuentaControlada

#OUTPUT
jsonval saldo