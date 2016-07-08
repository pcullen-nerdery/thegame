require 'json'
require 'httparty'

task gather: :environment do
  # wait 1 second to start up (for deployments, so we don't send off too quickly)
  sleep 1

  # puts "Starting thread for gathering points"
  while true do
    begin

      recently_used_text = Item.item_recently_used?
      if recently_used_text
        Rails.logger.info recently_used_text
      end

      result = Game.post('/points', {'verbose': true}).body

      item = JSON.parse(result)['Item']
      if item
        unless Item.create(name: item['Fields'][0]['Name'],
          guid: item['Fields'][0]['Id'],
          rarity: item['Fields'][0]['Rarity'],
          description: item['Fields'][0]['Description'])

          Rails.logger.info "Item not created #{item}"
        end
      end

      Rails.logger.info result
      sleep 1.2
    rescue Net::ReadTimeout, Errno::ETIMEDOUT, Net::OpenTimeout, JSON::ParserError => e
      puts "rescued `#{e.class.name}`, retrying"
      sleep 2
      retry
    end
  end  
end
