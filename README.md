# Ruboty::Idobata

Idobata adapter for [Ruboty](https://github.com/r7kamura/ruboty).

## Usage
Get your idobata bots api token

- from organization setting page: https://idobata.io/#/organization/YOUR_ORGANIZATION/bots
- or room setting page: https://idobata.io/#/organization/YOUR_ORGANIZATION/room/YOUR_ROOM/settings

``` ruby
# Gemfile
gem 'ruboty-idobata'
```

## ENV

```
    IDOBATA_URL                    - Idobata url
    IDOBATA_PUSHER_KEY             - Idobata's pusher key
    IDOBATA_API_TOKEN              - Idobata bots api token
```

## Screenshot

![](https://raw.githubusercontent.com/yasslab/ruboty-idobata/master/images/screenshot.png)

Notice: _The default robot name is `ruboty`, so if you want to use another name(e.x. `ellen`), you must be set `ROBOT_NAME` environment variable._

## Contributing

1. Fork it ( http://github.com/yasslab/ruboty-idobata/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
