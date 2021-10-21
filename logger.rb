# frozen_string_literal: true

require 'rubygems'
require 'mqtt'
require 'json'
require 'csv'
require 'yaml'

config  = YAML.load_file('config.yaml')

# Sensor configuration
sensors_config = config['sensors']

# Connect to the MQTT broker
MQTT::Client.connect(config['mqtt_server']) do |client|
  # Subscribe topics
  client.get('zigbee2mqtt/#') do |topic, message|
    # Only observe configured sensors
    next unless sensors_config.keys.include?(topic)

    sensor = sensors_config[topic]

    # Log the output
    puts "#{sensor['name']}: #{message}"

    payload = JSON.parse(message)

    # Log payload in a csv file
    CSV.open('data.csv', 'ab') do |csv|
      csv << [Time.now,
              sensor['name'],
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
