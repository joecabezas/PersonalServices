#!/bin/sh

#LEER DATOS PERSONALES
. datos

COOKIE_FILE=entel.cookie

curl \
	--cookie-jar $COOKIE_FILE \
	--data "funcion=ingreso&ext=%2526Sistema%253D1011%2526Portal%253DON%2526desdelogin%253D%2526miEPCS%253DNEW%2526MENU%253DSI&Sistema=1011&Portal=ON&desdelogin=SI&buic_rutdv=$RUTDV&miEPCS=NEW&buic=yes&Movil=$MOVIL&Rut=$RUT&PIN=$PIN" \
	--location "http://www.entelpcs.cl/login/valida_ws.iws?origen=home" \
	> /dev/null 2>&1

#ALGUNAS OTRAS URL IMPORTANTES
#http://mi.entel.cl/personas/portlet/facturacion/resumenFacturacionJson.faces
#http://mi.entel.cl/personas/portlet/trafico/traficoEnLineaJson.faces

curl \
	--silent \
	--cookie $COOKIE_FILE \
	--location "http://mi.entel.cl/personas/portlet/plan/resumenPlanJson.faces" \
	> output.json

jsonval() {
	temp=`cat output.json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | sed 's/",/\n/g' | sed 's/,"/\n/g' | sed 's/":"*/|/g' | sed 's/^"//g' | grep "$1|"`
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

jsonval saldo