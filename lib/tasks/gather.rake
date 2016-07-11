require 'json'
require 'httparty'

task gather: :environment do

  def use_queued_item(queued_item)
    begin
      result = queued_item.item.use!(queued_item.target)
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

    # add gold ring to the queue if its not currently in effect, and if its not in the queue already
    name = 'Gold Ring'
    unless JSON.parse(result)['Effects'].include?(name) || QueuedItem.unused.map(&:item).map(&:name).include?(name)
        item_to_queue = Item.unused.where(name: name).first
        QueuedItem.create(item: item_to_queue, location: 0) if item_to_queue
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

        # next if ensure_effect_present('Gold Ring')

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
