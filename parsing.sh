#!/bin/bash
#apt-get install youtube-dl
#apt-get install python3
#apt install install jq
#pip install google-api-python-client
mkdir blur
#скачивание указанное количество популярных на сегодня роликов Тик Ток
youtube-dl $(curl -s -H "User-agent: 'your bot 0.1'" https://www.reddit.com/r/TikTokCringe/hot.json\?limit\=10 | jq '.' | grep url_overridden_by_dest | grep -Eoh "https:\/\/v\.redd\.it\/\w{13}")
#конвертирование в размер кадра
for f in *.mp4;
do
  ffmpeg -i $f -lavfi '[0:v]scale=ih*16/9:-1,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[bg][0:v]overlay=(W-w)/2:(H-h)/2,crop=h=iw*9/16' -vb 800K blur/$f ;
done
#сборка в один мультимедиа файл
rm *.mp4
for f in blur/*.mp4; do echo "file $f" >> file_list.txt ; done
ffmpeg -f concat -i file_list.txt final.mp4
rm -rf blur
#Прямая трансляция файла на канал Ютуб
#ffmpeg -i final.mp4 -f flv rtmp://a.rtmp.youtube.com/live2/us5w-28w9-zrqs-pvuu-es3a
#перенос в другой каталог и переименование
mv final.mp4 /home/internal77/Видео/Final
cd /home/internal77/Видео/Final
mv final.mp4 final-$(date +%d%m%y_%H%M%S).mp4
#python2 $HOME/bw/.local/bin/upload.py --file="final.mp4" --title="Funny TikTok Compilation" --description="Buy my merchandise - spamlink.ly" --keywords="tiktok,cringe" --category="22" --privacyStatus="public"
