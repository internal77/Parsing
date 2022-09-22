#!/bin/bash
#apt-get install youtube-dl
#apt-get install python3
#apt install install jq
#pip install google-api-python-client
cd Видео
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
# Наложение logo
ffmpeg -i final.mp4 -i logo.png -filter_complex 'overlay=5:main_h-overlay_h' -strict -2 output.mp4
# https://stackoverflow.com/questions/10918907/how-to-add-transparent-watermark-in-center-of-a-video-with-ffmpeg
# https://evogeek.ru/questions/60462627/
#ffmpeg -i final.mp4 -vhook '/path/to_vhook/imlib2.so -i /path/to_img/watermark.png -x 5 -y 5' outputfile.avi
rm -rf blur
rm file_list.txt
rm final.mp4
#Прямая трансляция файла на канал Ютуб
#ffmpeg -i final.mp4 -f flv rtmp://a.rtmp.youtube.com/live2/us5w-28w9-zrqs-pvuu-es3a
#перенос в другой каталог и переименование
mv output.mp4 /mnt/6654bb9a-77c8-4e55-bc82-bb3d7edff7d6/Final
cd /mnt/6654bb9a-77c8-4e55-bc82-bb3d7edff7d6/Final
mv output.mp4 final-$(date +%d%m%y_%H%M%S).mp4

#python2 $HOME/bw/.local/bin/upload.py --file="final.mp4" --title="Funny TikTok Compilation" --description="Buy my merchandise - spamlink.ly" --keywords="tiktok,cringe" --category="22" --privacyStatus="public"
