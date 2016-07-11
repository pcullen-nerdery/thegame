require 'json'
require 'httparty'

task gather: :environment do

  def ensure_effect_present
    another_item_to_try = Item.unused.where(name: effect_name).first
    if another_item_to_try
      another_item_to_try.use!
      return true
    end
    return false
  end

  def use_queued_item(queued_item)
    begin
      queued_item.item.use!(queued_item.target)
      queued_item.update(status: 'Used')
    rescue Exceptions::NoSuchItem => e
      queued_item.update(status: 'Used')
      raise e
    end

    sleep 1.2
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

        next if ensure_effect_present('Gold Ring')

        # use queued items
        queued_item = QueuedItem.unused.order('location asc').first
        if queued_item
          use_queued_item(queued_item)
        else
          gather_points
        end
      end

    rescue Net::ReadTimeout, Errno::ETIMEDOUT, Net::OpenTimeout, JSON::ParserError, Exceptions::NoSuchItem => e
      puts "rescued `#{e.class.name}`, retrying"
      sleep 2
      retry
    end
  end  

end
