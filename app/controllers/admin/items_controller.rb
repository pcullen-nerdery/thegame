module Admin
  class ItemsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(resource_resolver, search_term).run
      resources = order.apply(resources)
        .unused
        # .current_game

      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
      }
    end
    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Item.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
    
    def use
      item = Item.find_by!(id: params[:id])
      result = item.use!
      flash[:notice] = "#{Time.now} - #{result}"
      redirect_to admin_items_path
    end


  end
end
