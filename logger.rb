# frozen_string_literal: true

require 'rubygems'
require 'mqtt'
require 'json'
require 'CSV'
require 'yaml'

config  = YAML.load_file('config.yaml')

# MQTT Server configuration
SERVER = '192.168.178.48'

# Sensor configuration
sensors_config = config['sensors']

# Connect to the MQTT broker
MQTT::Client.connect(config['mqtt_server']) do |client|
  # For each sensor
  sensors_config.each_key do |sensor_topic|
    sensor = sensors_config[sensor_topic]
    # Subscribe its topic
    client.get(sensor_topic.to_s) do |topic, message|
      # Log the output
      puts "#{sensor["name"]}: #{message}"

      payload = JSON.parse(message)

      # Log payload in a csv file
      CSV.open('data.csv', 'wb+') do |csv|
        csv << [Time.now,
                sensor["name"],
                topic,
                payload['humidity'],
                payload['temperature'],
                payload['pressure'],
                payload['battery'],
                payload['voltage'],
                payload['linkquality']]
      end
    end
  end
end
