# frozen_string_literal: true

require 'rubygems'
require 'mqtt'
require 'json'
require 'CSV'

# MQTT Server configuration
SERVER = '192.168.178.48'

# Sensor configuration
sensors = {
  'zigbee2mqtt/0x00158d00073a7ba8': {
    'name': 'Test Sensor',
    'min_humidity': 61,
    'max_humidity': 64
  }
}

# Connect to the MQTT broker
MQTT::Client.connect(SERVER) do |client|
  # For each sensor
  sensors.each_key do |sensor_topic|
    sensor = sensors[sensor_topic]
    # Subscribe its topic
    client.get(sensor_topic.to_s) do |topic, message|
      # Log the output
      puts "#{sensor[:name]}: #{message}"

      payload = JSON.parse(message)

      # Log payload in a csv file
      CSV.open('data.csv', 'wb') do |csv|
        csv << [Time.now,
                sensor[:name],
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
