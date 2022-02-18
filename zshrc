alias ll='CLICOLOR_FORCE=1 ls -la -G '
alias h='history'
alias gs='git status'
alias gl='git log --oneline'

alias h='history'
alias ll='ls -la -G'
alias fixusb='sudo killall -STOP -c usbd'


alias gs="git status"
alias gc="git commit"
alias gr="git checkout"
alias ga="git add"
alias gl="git lola"
alias glog="git lola"

##############################
### Caffeinate
##############################

caff() {
  if [ -z "$(pgrep 'caffeinate')" ];then caffeinate -dimus &; echo "caffeinate ligado."; else echo "caffeinate já está rodando."; fi
}

kcaff() {
  if [ -z "$(pgrep 'caffeinate')" ];then echo "caffeinate já está desligado."; else killall -9 'caffeinate'; echo "caffeinate desligado."; fi
}


# cat command with syntax highlight
# must have pygments installed
# http://pygments.org
alias ccat='pygmentize -g'
# with line numbers
alias ccatl='pygmentize -g -O style=colorful,linenos=1'
# same but forcing to ruby (Gemfile, Podfile, Fastfile, etc)
alias rcat='pygmentize -g -l ruby'
# with line numbers
alias rcatl='pygmentize -g -l ruby -O style=colorful,linenos=1'

alias -s txt=code
alias -g gp="grep"

# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

##############################
### DEEPLINK ON SIMULATOR
##############################
dlink() {
  xcrun simctl openurl booted "$1"
}


##############################
### IMAGE TOOLS - using magick
##############################

concat-img2() {
  filename1source=$(basename "$1")
  filename2source=$(basename "$2")
  extension=$filename1source:t:e
  filename1=$filename1source:t:r
  filename2=$filename2source:t:r
  finalFilename="${filename1}+${filename2}.${extension}"
  magick montage \
  -label "Antes" ${filename1source} \
  -label "Depois" ${filename2source} \
  -background gray -geometry +8+8  \
  -fill white \
  -pointsize 32  -gravity center \
  "$filename1+$filename2.$extension" 
}


##############################
### iOS simulator Helpers
##############################

appsnap() {
  sourcefile=$(basename "$1")
  filename="${sourcefile%.*}"
  xcrun simctl io booted screenshot "${filename}".png
}

apprec() {
  sourcefile=$(basename "$1")
  filename="${sourcefile%.*}"
  xcrun simctl io booted recordVideo --codec=h264 "${filename}".mp4
}

##############################
### VIDEO TOOLS - using ffmpeg
##############################

# Compress video files while keep their quality
# Usage: compress video_file
compress() {
  sourcefile=$(basename "$1")
  filename="${sourcefile%.*}"
  ffmpeg -i ${sourcefile} -c:v libx264 -crf 24 -b:v 1M -c:a aac -strict -2 "${filename}"_compressed.mp4
}


# Convert video to gif file.
# Usage: video2gif video_file (scale) (fps)
video2gif() {
  sourcefile=$(basename "$1") 
  filename="${sourcefile%.*}"
  ffmpeg -y -i "${1}" -vf fps=${3:-10},scale=${2:-320}:-1:flags=lanczos,palettegen "${filename}.png"
  ffmpeg -i "${1}" -i "${filename}.png" -filter_complex "fps=${3:-10},scale=${2:-320}:-1:flags=lanczos[x];[x][1:v]paletteuse" "${filename}".gif
  rm "${filename}.png"
}

# Rescale video to file.
# Usage: rescale video_file desired_width
# example, will rescale a video to width = 640 keeping aspect ratio: 
# rescale video_file 640
rescale() {
  sourcefile=$(basename "$1")
  filename="${sourcefile%.*}"
  ffmpeg -i ${sourcefile} -vf scale=${2:-320}:-1 "${filename}_scaled.mp4"
}

# Speed up video to file.
# Usage: speedup video_file
# tip: could be used to optimize file size too
speedup() {
  sourcefile=$(basename "$1")
  filename="${sourcefile%.*}"
  ffmpeg -i ${sourcefile} -r 16 -filter:v "setpts=0.5*PTS" "${filename}"_faster.mp4
}

# Speed down video to file.
# Usage: speedup video_file
# tip: could be used to optimize file size too
speeddn() {
  sourcefile=$(basename "$1")
  filename="${sourcefile%.*}"
  ffmpeg -i ${sourcefile} -r 16 -filter:v "setpts=2*PTS" "${filename}"_slower.mp4
}

# Remove audio from video
# Usage: noaudio video_file
noaudio() {
  if [ ! -f "$1" ]; then
    echo "\n:: Especifique um arquivo de video válido.\n";
    return
  elif [ -f "$1" ]; then
    filename1source=$(basename "$1")
    filename1=$filename1source:t:r
    extension=$filename1source:t:e
    finalFilename="${filename1}-na.${extension}"
    # echo $finalFilename
    ffmpeg -i $filename1source -c copy -an $finalFilename
    return;
  fi
}

cov() {
  if [ ! -f "$1" ]; then
    echo "\n:: Parametros invalidos.\n";
    return
  elif [ -f "$1" ]; then
    filename1source=$(basename "$1")
    filename1=$filename1source:t:r
    extension=$filename1source:t:e
    finalFilename="${filename1}-na.${extension}"
    rsync -avzh --progress daniel.bonates@192.168.0.25:~/work/app-ios app-ios/
  fi
  
}

###########################
### CUSTOM PROMPT
###########################


Color_Off="\033[0m"

Green="\033[38;5;10m" 
IRed='\033[91;5;10m'
Yellow='\033[33m'
BYellow="\033[93;5;10m"




Time12h="%D{%H:%M:%S}"
PathShort="%2~"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

setopt PROMPT_SUBST
autoload -U colors && colors
export PROMPT='%B%F{8}$Time12h%f%b %~ $(git branch &>/dev/null;\
  if [ $? -eq 0 ]; then \
  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
  if [ "$?" -eq "0" ]; then \
    echo "'$Green'"▪; \
  else \
    echo "'$IRed'"▪; \
  fi) '$BYellow'"$(parse_git_branch)" '$Color_Off'%B%F{8}\$%f%b "; \
else \
  echo " '$Yellow''$Color_Off'%B%F{8}\$%f%b "; \
fi) '


