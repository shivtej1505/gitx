# README

### Dependencies

* Ruby version: 2.6.6

### Setup

* `git clone https://github.com/shivtej1505/gitx.git`
* `cd gitx`
* `bundle install`
* Run tests: `bundle exec rspec`
* Start server: `bin/rails s`
* Make a curl request
  
```
curl -i \
  -X GET \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token <your-token-here>" \
  http://localhost:3000/api/user/repos
```
