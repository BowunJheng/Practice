#!/bin/sh
case $1 in
    "kissnet" | 308 | "001" )
        echo "KISSRadio網路音樂台"
        CHNNEL=308
    ;;
    "hitfmP" | 87 | "002" )
        echo "Hit FM聯播網-台北"
        CHNNEL=87
    ;;
    "iradio" | 206 | "003" )
        echo "i radio中廣音樂網"
        CHNNEL=206
    ;;
    "icrt" | 177 | "004" )
        echo "ICRT"
        CHNNEL=177
    ;;
    "family" | 156 | "005" )
        echo "大眾廣播電台"
        CHNNEL=156
    ;;
    "ufo" | 232 | "006" )
        echo "飛碟電台"
        CHNNEL=232
    ;;
    "bccfashion" | 205 | "007" )
        echo "中廣流行網"
        CHNNEL=205
    ;;
    "classical" | 228 | "008" )
        echo "台北愛樂"
        CHNNEL=228
    ;;
    "vot" | 222 | "009" )
        echo "台北之音"
        CHNNEL=222
    ;;
    "bccnews" | 207 | "010" )
        echo "中廣新聞網"
        CHNNEL=207
    ;;
    "news98" | 187 | "011" )
        echo "News98"
        CHNNEL=187
    ;;
    "hintfmC" | 88 | "012" )
        echo "Hit FM聯播網-台中"
        CHNNEL=88
    ;;
    "bestK" | 213 | "013" )
        echo "BestRadio高雄港都983"
        CHNNEL=213
    ;;
    "apple" | 248 | "014" )
        echo "蘋果線上"
        CHNNEL=248
    ;;
    "bestP" | 212 | "015" )
        echo "BestRadio台北好事989"
        CHNNEL=212
    ;;
    "bccclassical" | 162 | "016" )
        echo "中廣古典網"
        CHNNEL=162
    ;;
    "kissN"| 255 | "017" )
        echo "KISS RADIO台南知音廣播電台"
        CHNNEL=255
    ;;
    "bestC" | 211 | "018" )
        echo "BestRadio台中好事903"
        CHNNEL=211
    ;;
    "asiafm" | 295 | "019" )
        echo "亞太電台"
        CHNNEL=295
    ;;
    "asia" | 210 | "020" )
        echo "亞洲電台"
        CHNNEL=210
    ;;
    "goodnews" | 206 | "021" )
        echo "佳音電台-聖樂網"
        CHNNEL=206
    ;;
    "superfm" | 109 | "022" )
        echo "大千電台"
        CHNNEL=109
    ;;
    "023" )
        echo "正聲FM"
        CHNNEL=198;
    ;;
    "024" )
        echo "全國廣播"
        CHNNEL=202;
    ;;
    "025" )
        echo "綠色和平電台"
        CHNNEL=327;
    ;;
    "026" )
        echo "寶島新聲"
        CHNNEL=259;
    ;;
    "027" )
        echo "ASIAFM衛星音樂台"
        CHNNEL=321;
    ;;
    "028" )
        echo "Hit FM聯播網-高雄"
        CHNNEL=90;
    ;;
    "029" )
        echo "KISS RADIO南投廣播電台"
        CHNNEL=258;
    ;;
    "030" )
        echo "警廣全國交通網"
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
