FROM ruby:3.3.0

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

ENV RAILS_ENV=production

EXPOSE 3000

#COPY entrypoint.sh /usr/bin/entrypoint.sh
#RUN chmod +x /usr/bin/entrypoint.sh

#ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["rails", "server", "-e", "production", "-b", "0.0.0.0"]


