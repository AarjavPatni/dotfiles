function resume-update {
  cp -f ~/Documents/Coop/Resume/Aarjav_Patni_resume.pdf ~/Documents/Programming/aarjav.xyz/public/Aarjav_Patni_resume.pdf
  cd ~/Documents/Programming/aarjavpatni.me/
  git add public/Aarjav_Patni_resume.pdf
  git commit -m "Update resume"
  git push
}

alias ghar-ssh="ssh ghar@ghar-server"
alias ghar-mosh="mosh ghar@ghar-server"
alias uw-ssh="ssh -Y a3patni@linux.student.cs.uwaterloo.ca"

export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

jrnl() {
  if [[ "$1" == "list" ]]; then
    shift
    command jrnl --format short "$@"
  elif [[ "$1" == "edit" ]]; then
    shift
    command jrnl --edit -contains "$@"
  elif [[ "$1" == "export" ]]; then
    mkdir -p ~/Documents/jrnl
    shift
    command jrnl --format markdown --file ~/Documents/jrnl/ "$@"
  elif [[ "$1" == "view" ]]; then
    shift
    command jrnl --format md -contains "$@" | mdless
  else
    command jrnl "$@"
  fi
}

life-mistakes() {
  jrnl --edit -contains 'Life Mistakes Log'
  jrnl --format markdown --file ~/Documents/ -contains 'Life Mistakes'
  mv -f ~/Documents/2025-05-03_life-mistakes-log.md ~/Documents/Life-Mistakes.md
}

