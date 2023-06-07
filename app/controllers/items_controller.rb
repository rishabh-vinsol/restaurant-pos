class ItemsController < ApplicationController
  skip_before_action :authorize, only: :menu
end
