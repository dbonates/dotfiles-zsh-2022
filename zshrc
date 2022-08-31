alias ll='CLICOLOR_FORCE=1 ls -alhg -G'
alias h='history'
alias gs='git status'
alias gl='git log --oneline'
alias sw='git switch'

alias h='history'
alias fixusb='sudo killall -STOP -c usbd'
alias fixhde='sudo pkill -f fsck'


# Deezer download
# arl: 487fd00bfb7ca50833458456387997ba239ba7ba683c36a412b6f84c98800ec00144df8cf9dbcbc8aee14664826e536ba9379c39ca6492032d4aefe3e55df1047a385c6bfbd67671873549be883552d941124d5c8547c4fe93f9cbd0382f8a20
alias dzdl='python3 -m deemix'

alias bkpwork='rsync -avzh --progress daniel.bonates@192.168.0.33:~/work work/'

alias gs="git status"
alias gc="git commit"
alias gr="git checkout"
alias ga="git add"
alias gl="git lola"
alias glog="git lola"

alias updtnextbkp="rsync -avzh --progress daniel.bonates@192.168.0.26:~/work ~/daniel/work/"

# Remove arquivo lixo do macos
frml () {
  find . -name ._.DS_Store | xargs rm -f
  find . -name .DS_Store | xargs rm -f
  find . -name ._*.* | xargs rm -f
  find . -name '._*' | xargs rm -f
}


compressall() {
  for file in *; do compress $file; done
}

##############################
### Caffeinate
##############################

caff() {
  if [ -z "$(pgrep 'caffeinate')" ];then caffeinate -dimus &; echo "caffeinate ligado."; else echo "caffeinate já está rodando."; fi
}

kcaff() {
  if [ -z "$(pgrep 'caffeinate')" ];then echo "caffeinate já está desligado."; else killall -9 'caffeinate'; echo "caffeinate desligado."; fi
}


##############################
### DEEPLINK ON SIMULATOR
##############################
dlink() {
  xcrun simctl openurl booted "$1"
}

mytools() {
  # All available via homebrew
  echo ""
  echo "****************************"
  echo "  htop - process viewer."
  echo "  ncdu - disk usage."
  echo "  tig  - git 'great' gui."
  echo "  mc   - visual file manager."
  echo "  "
  echo "****************************"
  echo "Skyscraper:"
  echo "gerar midia para uma determinada plataforma:"
  echo "Skyscraper -p megadrive -s screenscraper"
  echo "gerar a playlist depois de ter as midias geradas:"
  echo "Skyscraper -p megadrive"
  echo "*****************************"
  echo ""
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

# kill processes given a partial name

kany(){
  killall -9 $1
}

# kill processes given a partial name

klike(){
  killall -f $1
}

##############################
### PICO-8 shortcuts
##############################

kp8() {
  if [ -z "$(pgrep 'pico8')" ];then echo "pico8 já está desligado."; else killall -9 'pico8'; echo "pico8 desligado."; fi
}

# pico-8 run cart
p8() {
  if [ ! $1 ]; then
    echo "\n:: indique um cart valido.\n";
    return
  fi
  /Applications/PICO-8.app/Contents/MacOS/pico8 -windowed 1 -run $1 &
}

# pico-8 splore
p8s() {
  /Applications/PICO-8.app/Contents/MacOS/pico8 -windowed 1 -splore &
}

# pico-8 console
p8c() {
  /Applications/PICO-8.app/Contents/MacOS/pico8 -windowed 1 -splore &
}



##############################
### IMAGE TOOLS - using magick
##############################


scjpg() {
  if [ ! $1 ]; then
    echo "\n:: Especifique qual arquivo converter.\n";
    return
  fi
  mogrify -format jpg $1
}

conv() {
  if [ ! $1 ]; then
    echo "\n:: Especifique qual formato converter.\n";
    return
  elif [ ! $2 ]; then
    echo "\n:: Especifique o formato de destino.\n";
    return
  fi
  mogrify -format $2 *.$1
}

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


export PATH=$PATH:/Users/sabrinabonates/daniel/pico-8/alternativas/love.app/Contents/MacOS/

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

mounttip() {
  # mkdir /Volumes/Linux
  echo ""
  echo "***************************************************"
  echo "diskutil list"
  echo "sudo mount -t fuse-ext2 /dev/disk3s2 /Volumes/Linux"
  echo "***************************************************"
  echo ""
}

export PATH="/usr/local/opt/qt@5/bin:$PATH"
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH
export PATH=/usr/local/bin:$PATH
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
