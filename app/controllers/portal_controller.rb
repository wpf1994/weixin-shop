class PortalController < ApplicationController
  include Front::HomesHelper
  layout false
  before_filter :authenticate_user!, only: [:get_addr, :save_addr]

  def index
    user, has_redirect = weixin_entry
    return if has_redirect
    sign_in user if user.present?
    return redirect_to '/' if user.nil?

    @adverts = Advert.all.order(created_at: :desc).take(5)
    @notices = Notice.all.where('public_at <= ?', Time.now).order(created_at: :desc).take(5)
  end

  def free_express

  end

  def get_addr
    @addr = current_user.owner.receiving_addresses.find_by_id(params[:id])
  end

  def save_addr
    ReceivingAddress.all.find_or_create_by customer_id: current_user.owner_id, name: params[:express][:name],
                                           phone: params[:express][:phone], address: params[:express][:address],
                                           shop_id: params[:express][:shop_id]

    if (eo = ExpressOrder.create(consignee: params[:express][:name], phone: params[:express][:phone], address: params[:express][:address], status: 0, shop_id: params[:express][:shop_id]))
      render nothing: true
    else
      render json: {message: eo.errors.full_messages.join(',')}, status: 400
    end
  end

  def notice
    @notice = Notice.all.find_by_id(params[:id])
  end
end
