FROM ruby:3.3.0

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

ENV RAILS_ENV=production

EXPOSE 3000

CMD ["rails", "server", "-e", "production", "-b", "0.0.0.0"]


