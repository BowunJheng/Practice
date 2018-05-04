#!/bin/sh
WORKPATH="/home/admin/CVSProjects"
TMPDIR="MibTmpDir"
WWWPATH="/var/www/html/Mibs"
HTMLFILE="$WWWPATH/index.html"
YYMMDD=`/bin/date '+%Y%m%d'`
MIBTREE_CMD="/home/admin/MibTree"
PREHTML='<HTML>
<HEAD><TITLE>Mibs Collector</TITLE></HEAD>
<BODY>
<CENTER>
<TABLE BORDER="1">
';
TAILHTML='</TABLE>
<BR />P.S. Because the MibTree is large, you must wait for a while to load data
</CENTER>
</BODY>
</HTML>';

rm -rf $WWWPATH
mkdir $WWWPATH
tar xfj ./dtree.tar.bz2 -C $WWWPATH
echo $PREHTML > $HTMLFILE
for project in Bobcat Bobcat_39215 Penguin Starfish
do
	cd "$WORKPATH/$project"
	cvs -q update -P -d
	rm -rf "$WORKPATH/$TMPDIR"
	mkdir "$WORKPATH/$TMPDIR"
	find . -iname "*.mib" -exec cp '{}' "$WORKPATH/$TMPDIR" \;
	tar cfj $WWWPATH/$project\_$YYMMDD.tar.bz2 "../$TMPDIR"
	`$MIBTREE_CMD "$WORKPATH/$TMPDIR" "$WWWPATH/$project.html"`
	rm -rf "$WORKPATH/$TMPDIR"
	echo "<TR><TD>$project</TD><TD><A HREF=\"./"$project\_$YYMMDD.tar.bz2"\">"$project\_$YYMMDD.tar.bz2"</A></TD><TD>`stat --printf=%s $WWWPATH/$project\_$YYMMDD.tar.bz2` bytes</TD><TD>Update: `date`</TD><TD><A HREF=\"./$project.html\" TARGET=\"_blank\">MibTree</A></TD></TR>" >> $HTMLFILE
done
echo $TAILHTML >> $HTMLFILE
