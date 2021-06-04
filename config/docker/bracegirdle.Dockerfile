FROM ruby:3.0.1
RUN apt-get update -qq &&\
  apt-get install -y curl build-essential libpq-dev &&\
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  curl -fsSL https://deb.nodesource.com/setup_16.x | bash - &&\
  apt-get install -y nodejs yarn

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/bracegirdle
RUN mkdir -p $RAILS_ROOT 

# Set working directory
WORKDIR $RAILS_ROOT

# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production'

# Adding gems
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install --jobs 20 --retry 5 --without development test

# Install JS assets
COPY package.json .
COPY yarn.lock .

# Adding project files
COPY . .

# Configure the main process to run when running the image
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

# Precompile assets
#RUN RAILS_ENV=production bundle exec rake assets:precompile