require 'json'
require 'net/http'
require 'open-uri'
require 'pp'
require 'pusher-client'

module Ruboty
  module Adapters
    class Idobata < Base
      include Mem

      env :IDOBATA_URL,        "Idobata url",              optional: true
      env :IDOBATA_PUSHER_KEY, "Idobata's pusher key",     optional: true
      env :IDOBATA_API_TOKEN,  "Idobata bots api token"

      def run
        on_connection_established do
          join_channel
          log_message
          listen
        end
        connect
      end

      def say(message)
        pp message
        req = Net::HTTP::Post.new(idobata_messages_url.path, headers)
        req.form_data = { 'message[room_id]' => message[:original][:room_id], 'message[source]' => message[:body] }
        https = Net::HTTP.new(idobata_messages_url.host, idobata_messages_url.port)
        https.use_ssl = true
        https.start {|https| https.request(req) }
      end

      def on_connection_established(&block)
        socket.bind('pusher:connection_established', &block)
      end

      memoize\
      def idobata_url
        URI.parse(ENV["IDOBATA_URL"] || "https://idobata.io/")
      end

      memoize\
      def idobata_pusher_key
        ENV["IDOBATA_PUSHER_KEY"] || "44ffe67af1c7035be764"
      end

      memoize\
      def idobata_api_token
        ENV["IDOBATA_API_TOKEN"]
      end

      memoize\
      def idobata_seed_url
        URI.join(idobata_url, '/api/seed')
      end

      memoize\
      def idobata_pusher_auth_url
        URI.join(idobata_url, '/pusher/auth')
      end

      memoize\
      def idobata_messages_url
        URI.join(idobata_url, '/api/messages')
      end

      memoize\
      def headers
        {
          'X-API-Token' => idobata_api_token,
          'User-Agent'  => "ruboty-idobata / v#{Ruboty::Idobata::VERSION}"
        }
      end

      memoize\
      def seed_json
        idobata_seed_url.read(headers)
      end

      memoize\
      def seed
        JSON.parse(seed_json)
      end

      memoize\
      def records
        seed["records"]
      end

      memoize\
      def bot
        records["bot"]
      end

      memoize\
      def channel_name
        bot["channel_name"]
      end

      memoize\
      def auth_payload
        {
          socket_id:    socket_id,
          channel_name: channel_name
        }
      end

      memoize\
      def authorize
        req = Net::HTTP::Post.new(idobata_pusher_auth_url.path, headers)
        req.form_data = auth_payload
        https = Net::HTTP.new(idobata_pusher_auth_url.host, idobata_pusher_auth_url.port)
        https.use_ssl = true
        https.start {|https| https.request(req) }
      end

      memoize\
      def pusher_auth_json
        authorize.body
      end

      memoize\
      def pusher_auth
        JSON.parse pusher_auth_json
      end

      memoize\
      def socket
        PusherClient::Socket.new(idobata_pusher_key, encrypted: true)
      end

      memoize\
      def connect
        socket.connect
      end

      memoize\
      def connected?
        socket.connected
      end

      memoize\
      def socket_id
        socket.socket_id
      end

      memoize\
      def channel
        socket.channels.add(channel_name)
      end

      memoize\
      def join_channel
        socket.authorize_callback(channel, pusher_auth["auth"], pusher_auth["channel_data"])
      end

      memoize\
      def listen
        channel.bind('message:created') do |message_json|
          message = JSON.parse(message_json)['message']
          robot.receive(
            body: message['body_plain'],
            from: message['sender_id'],
            from_name: message['sender_name'],
            room_id: message['room_id'],
            room_name: message['room_name']
          )
        end
      end

      memoize\
      def log_message
        channel.bind('message:created') do |message_json|
          pp JSON.parse message_json
        end
      end
    end
  end
end
