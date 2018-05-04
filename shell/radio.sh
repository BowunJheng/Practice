#!/bin/sh
case $1 in
    "kissnet" | 308 | "001" )
        echo "KISSRadio�������֥x"
        CHNNEL=308
    ;;
    "hitfmP" | 87 | "002" )
        echo "Hit FM�p����-�x�_"
        CHNNEL=87
    ;;
    "iradio" | 206 | "003" )
        echo "i radio���s���ֺ�"
        CHNNEL=206
    ;;
    "icrt" | 177 | "004" )
        echo "ICRT"
        CHNNEL=177
    ;;
    "family" | 156 | "005" )
        echo "�j���s���q�x"
        CHNNEL=156
    ;;
    "ufo" | 232 | "006" )
        echo "���йq�x"
        CHNNEL=232
    ;;
    "bccfashion" | 205 | "007" )
        echo "���s�y���"
        CHNNEL=205
    ;;
    "classical" | 228 | "008" )
        echo "�x�_�R��"
        CHNNEL=228
    ;;
    "vot" | 222 | "009" )
        echo "�x�_����"
        CHNNEL=222
    ;;
    "bccnews" | 207 | "010" )
        echo "���s�s�D��"
        CHNNEL=207
    ;;
    "news98" | 187 | "011" )
        echo "News98"
        CHNNEL=187
    ;;
    "hintfmC" | 88 | "012" )
        echo "Hit FM�p����-�x��"
        CHNNEL=88
    ;;
    "bestK" | 213 | "013" )
        echo "BestRadio�����䳣983"
        CHNNEL=213
    ;;
    "apple" | 248 | "014" )
        echo "ī�G�u�W"
        CHNNEL=248
    ;;
    "bestP" | 212 | "015" )
        echo "BestRadio�x�_�n��989"
        CHNNEL=212
    ;;
    "bccclassical" | 162 | "016" )
        echo "���s�j���"
        CHNNEL=162
    ;;
    "kissN"| 255 | "017" )
        echo "KISS RADIO�x�n�����s���q�x"
        CHNNEL=255
    ;;
    "bestC" | 211 | "018" )
        echo "BestRadio�x���n��903"
        CHNNEL=211
    ;;
    "asiafm" | 295 | "019" )
        echo "�Ȥӹq�x"
        CHNNEL=295
    ;;
    "asia" | 210 | "020" )
        echo "�Ȭw�q�x"
        CHNNEL=210
    ;;
    "goodnews" | 206 | "021" )
        echo "�έ��q�x-�t�ֺ�"
        CHNNEL=206
    ;;
    "superfm" | 109 | "022" )
        echo "�j�d�q�x"
        CHNNEL=109
    ;;
    "023" )
        echo "���nFM"
        CHNNEL=198;
    ;;
    "024" )
        echo "����s��"
        CHNNEL=202;
    ;;
    "025" )
        echo "���M���q�x"
        CHNNEL=327;
    ;;
    "026" )
        echo "�_�q�s�n"
        CHNNEL=259;
    ;;
    "027" )
        echo "ASIAFM�ìP���֥x"
        CHNNEL=321;
    ;;
    "028" )
        echo "Hit FM�p����-����"
        CHNNEL=90;
    ;;
    "029" )
        echo "KISS RADIO�n��s���q�x"
        CHNNEL=258;
    ;;
    "030" )
        echo "ĵ�s�����q��"
        CHNNEL=269;
    ;;
    "rtsp" | "mms" )
        echo "RTSP downloading......"
        CHNNEL=-1;
    ;;
    *)
        echo "ICRT"
        CHNNEL=177;
    ;;
esac

oldRADIO="http://hichannel.hinet.net/api/streamFreeRadio.jsp?id=$CHNNEL"
RADIO="http://hichannel.hinet.net/player/radio/index.jsp?radio_id=$CHNNEL"
WGET="/usr/bin/wget"
MPLAYER="/usr/bin/mplayer"

if [ $CHNNEL -eq -1 ];then
    extension_name=`expr match "$2" '.*/\(.*\)'`
    $MPLAYER -noframedrop -dumpfile $extension_name -dumpstream $2
    exit;
fi

wmp_get()
{
    $WGET -q --user-agent 'Windows Media Player' --referer=http://hichannel.hinet.net -O - $*
}

#URL=$(wmp_get $(wmp_get $RADIO | grep mms | cut -d '"' -f 2) | grep 203 | cut -d '"' -f 2)
URL=$(wmp_get $RADIO | grep mms | cut -d '"' -f 2)

$MPLAYER $URL
