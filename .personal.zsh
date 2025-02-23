function resume-update {
  cp -f ~/Documents/Coop/Resume/Aarjav_Patni_resume.pdf ~/Documents/Programming/aarjavpatni.me/public/Aarjav_Patni_resume.pdf
  cd ~/Documents/Programming/aarjavpatni.me/
  git add public/Aarjav_Patni_resume.pdf
  git commit -m "Update resume"
  git push
}

alias ghar-ssh="ssh ghar@ghar-server"
alias uw-ssh="ssh -Y a3patni@linux.student.cs.uwaterloo.ca"

export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

