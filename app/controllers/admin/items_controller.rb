module Admin
  class ItemsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    def index
      super
      @resources = Item.where(status: nil)
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
