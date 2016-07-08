require 'json'
require 'httparty'

task gather: :environment do


  def use_queued_item(queued_item)
    queued_item.item.use!
    queued_item.update(status: 'Used')
    sleep 0.5
  end


  def gather_points
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
  end

  # wait 1 second to start up (for deployments, so we don't send off too quickly)
  sleep 1

  # puts "Starting thread for gathering points"
  while true do
    begin

      if Item.item_recently_used?
        gather_points
      else
        queued_item = QueuedItem.unused.order('location asc').first
        if queued_item
          use_queued_item(queued_item)
        else
          gather_points
        end
      end

    rescue Net::ReadTimeout, Errno::ETIMEDOUT, Net::OpenTimeout, JSON::ParserError => e
      puts "rescued `#{e.class.name}`, retrying"
      sleep 2
      retry
    end
  end  

end
