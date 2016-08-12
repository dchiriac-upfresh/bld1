#!/usr/bin/env bash

# Bootstrap dependencies for Centos
RPMS=(
  'git-core' 
  'zlib' 
  'zlib-devel' 
  'gcc-c++' 
  'patch' 
  'readline' 
  'readline-devel' 
  'libyaml-devel' 
  'libffi-devel' 
  'openssl-devel' 
  'make' 
  'bzip2' 
  'autoconf' 
  'automake' 
  'libtool' 
  'bison' 
  'curl' 
  'sqlite-devel'
)

sudo yum install -y $( IFS=$' '; echo "${RPMS[*]}" )

# Verify Git is installed:
if [ ! $(which git) ]; then
  echo "Git is not installed, can't continue."
  exit 1
fi

if [ -z "${RBENV_ROOT}" ]; then
  RBENV_ROOT="$HOME/.rbenv"
fi

# Install rbenv:
if [ ! -d "$RBENV_ROOT" ] ; then
  git clone https://github.com/sstephenson/rbenv.git $RBENV_ROOT
else
  cd $RBENV_ROOT
  if [ ! -d '.git' ]; then
    git init
    git remote add origin https://github.com/sstephenson/rbenv.git
  fi
  git pull origin master
fi

# Install plugins:
PLUGINS=(
  sstephenson/rbenv-vars
  sstephenson/ruby-build
  sstephenson/rbenv-gem-rehash
)

for plugin in ${PLUGINS[@]} ; do
  KEY=${plugin%%/*}
  VALUE=${plugin#*/}
  RBENV_PLUGIN_ROOT="${RBENV_ROOT}/plugins/$VALUE"
  if [ ! -d "$RBENV_PLUGIN_ROOT" ] ; then
    git clone https://github.com/$KEY/$VALUE.git $RBENV_PLUGIN_ROOT
  else
    cd $RBENV_PLUGIN_ROOT
    echo "Pulling $VALUE updates."
    git pull
  fi
done

# Fix the .bashrc

cat << 'EOF' > $HOME/.bashrc
# .bashrc

# setup rbenv
export RBENV_ROOT="${HOME}/.rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
eval "$(rbenv init -)"

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific aliases and functions"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

EOF

