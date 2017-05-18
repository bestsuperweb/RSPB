class QuotationsController < ApplicationController

    skip_before_filter :verify_authenticity_token
    include ShopifyApp::AppProxyVerification
    include AppProxyAuth

  def index
    @user_id = login_to_shopify('verify_logged_in_user')
    #@user_id = 4281588171
    @quotations = Quotation.where(customer_id: @user_id)
    render layout: true, content_type: 'application/liquid'
  end

  def show
     flash[:success] = "Thank you! Your request has been received. We'll look at it and get back to you with a quote soon."
     @quotation = Quotation.find(params[:id])
    render layout: 'guest', content_type: 'application/liquid'
  end

  def new
    @quotation = Quotation.new
    @customer = Customer.new
    render layout: 'guest', content_type: 'application/liquid'
  end

  def create
    @customer = Customer.new(customer_params)
    @quotation = Quotation.new(quotation_params)

    #flash[:notice] = "Thank you! Your request has been received. We'll look at it and get back to you with a quote soon."
    redirect_to '/a/portal-dev/quotations/22', notice: "Thank you! Your request has been received. We'll look at it and get back to you with a quote soon."
    return

    if is_customer === true
      unless @quotation.valid?
        render_new_quotation
        return
      end
    else
      unless @customer.valid? && @quotation.valid?
        render_new_quotation
        return
      end
    end

    if is_customer === true
      customer_id = get_logged_in_customer_id
    else
      customer_id = get_customer_id_from_shopify
    end

    quotation_data = quotation_params.merge(customer_id: customer_id)

    @quotation = Quotation.new(quotation_data)

    if @quotation.save
      flash[:success] = "Thank you! Your request has been received. We'll look at it and get back to you with a quote soon."
      redirect_to @quotation
    else
      render_new_quotation
    end

  end

  private
    def get_customer_id_from_shopify
      connect_to_shopify
      customer = ShopifyAPI::Customer.search(query: 'email:'+params[:customer][:email])
      if customer.count >= 1
        return customer[0].id
      else
        return create_customer_at_shopify
      end
    end

  private
    def create_customer_at_shopify
      connect_to_shopify
      @customer = ShopifyAPI::Customer.new(customer_params.to_h)
      if @customer.save
        return @customer.id
      else
          render_new_quotation
          return
      end
    end

  private
    def quotation_params
        params.require(:quotation).permit(:message, :quantity, :yearly_quantity_id, :resize_image, :image_width, :image_height)
    end

  private
    def customer_params
      params.require(:customer).permit(:first_name, :last_name, :email)
    end

  private
    def is_customer
      #params[:customer_id].present? && !params[:customer_id].blank? ? true : false
      return true
    end

  private
    def get_logged_in_customer_id
      return params[:customer_id]
    end

  private
    def render_new_quotation
      render layout: 'guest', action: 'new', content_type: 'application/liquid'
    end

  private
    def connect_to_shopify
      shop = params[:shop]
      token = Shop.find_by(shopify_domain: shop).shopify_token
      session = ShopifyAPI::Session.new(shop, token)
      ShopifyAPI::Base.activate_session(session)
    end

end
