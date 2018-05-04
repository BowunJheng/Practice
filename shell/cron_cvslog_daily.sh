#!/bin/sh
PATH="/usr/local/cvs_checkout"
RM_CMD="/bin/rm"
YYMMDD=`/bin/date '+%Y%m%d'`
TAGFILE="tags/opentags.$YYMMDD"
TAGLAST="tags/opentags-lastest.txt"
$RM_CMD -rf /tmp/cvschangelogbuilder*
for module in Bobcat Butterfly PKE3349 PKE3368 PKE37X
do
	cd $PATH/$module
	./html.sh $module
	/bin/sleep 60
done
cd $PATH
/bin/rm -f $TAGLAST
echo "# $YYMMDD" > $TAGFILE
for modulename in "Butterfly" "PKE3349" "PKE3368" "PKE36X" "PKE37X" "Seagull" "Strybneyville" "TCW690" "cm_v2" "dcm325" "v3_tmm" "vxAskey" "Beetles" "v3"
do
	echo "$modulename:" >> $TAGFILE
	./lsCvsTags.pl -l $modulename >> $TAGFILE
	/bin/cp $TAGFILE $TAGLAST
	/bin/sleep 60
done
