# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin
    before_action :display_item_recently_used_warning

    def authenticate_admin
      # TODO Add authentication logic here.
    end

    def display_item_recently_used_warning
      return unless File.file?("#{Rails.root}/tmp/last_used_time")
      last_used = File.read("#{Rails.root}/tmp/last_used_time") 

      if DateTime.parse(last_used) > 1.minute.ago
        flash.now[:error] = []
        flash.now[:error] << "You used an item at #{last_used}. Wait #{DateTime.parse(last_used).to_i - 1.minute.ago.to_i} seconds"
      end
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
