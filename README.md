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
  http://localhost:3000/github/api/user/repos
```

### Project Doc & Other details

https://www.notion.so/shivangnagaria/GitX-Project-Doc-0c9df395a68e4dc3a547f7cce658ab96
