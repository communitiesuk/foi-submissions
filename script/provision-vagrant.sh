export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get -qq install -y autoconf bison build-essential libssl-dev \
  libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev \
  libgdbm3 libgdbm-dev git-core postgresql-9.6 postgresql-server-dev-9.6 \
  postgresql-client-9.6 curl redis-server

if [ ! -d "$HOME/.rbenv" ]; then
  echo 'Installing rbenv and ruby-build'
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git \
    ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
fi

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

if [ ! -d "$HOME/.nvm" ]; then
  echo 'Installing nvm'
  curl -o- -sL "https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh" | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export RUBY_VERSION='2.5.1'
if [ ! -d "$HOME/.rbenv/versions/$RUBY_VERSION" ]; then
  echo 'Installing ruby and bundler'
  rbenv install $RUBY_VERSION
  rbenv global $RUBY_VERSION
  gem update --system
  bundle config path "$HOME/.bundle"
fi

export NODE_VERSION='8.10.0'
if [ ! -d "$HOME/.nvm/versions/node/v$NODE_VERSION" ]; then
  echo 'Installing node and yarn'
  nvm install $NODE_VERSION
  nvm use $NODE_VERSION
  curl -o- -sL https://yarnpkg.com/install.sh | bash
fi

export PATH="$HOME/.yarn/bin:$PATH"

if [ ! -d "$HOME/.gemrc" ]; then
  echo 'gem: --no-ri --no-rdoc' >> ~/.gemrc
fi

if ! grep -qe "^cd \\$HOME/app$" "./.bashrc"; then
  echo "cd \\$HOME/app" >> ./.bashrc
fi
cd "$HOME/app"

echo 'Create PostgreSQL user'
sudo -u postgres createuser --superuser $USER 2>/dev/null

echo 'Copy config/database.yml-example'
sed -r \
  -e "s,^( *username: *).*,\\1${USER}," \
  -e "s,^( *password: *).*,\\1null," \
  -e "s,^( *host: *).*,\\1/var/run/postgresql," \
  config/database.yml-example > config/database.yml

echo 'Run Rails setup'
./bin/setup
