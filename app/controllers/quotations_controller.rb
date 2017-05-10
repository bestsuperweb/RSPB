class QuotationsController < ApplicationController
    skip_before_filter :verify_authenticity_token
    include ShopifyApp::AppProxyVerification
    #include AppProxyAuth
    layout "guest", only: [:new, :edit]

  def index
    #render layout: false, content_type: 'application/liquid'
    shop = params[:shop]
    token = Shop.find_by(shopify_domain: shop).shopify_token
    session = ShopifyAPI::Session.new(shop, token)
    ShopifyAPI::Base.activate_session(session)
    #@metafields = ShopifyAPI::Metafield.find(:all, params: { limit: 10 })

    @metafields = ShopifyAPI::Customer.find(4281588171).metafields

    render layout: true, content_type: 'application/liquid'
  end

  def new
    @quotation = Quotation.new
    @customer = Customer.new
    render layout: true, content_type: 'application/liquid'
  end

  def create
    @customer = Customer.new(customer_params)
    if !@customer.valid?
      flash.now
    end
    if params[:customer_id].present? && !params[:customer_id].blank?
      customer_id = params[:customer_id]
    else
      customer_id = get_customer_id_from_shopify
    end

    quotation_data = quotation_params.merge(customer_id: customer_id)

    @quotation = Quotation.new(quotation_data)


    if @quotation.save
        redirect_to quotations_path
    else
        render 'new'
    end

    #render inline: params[:quotation].inspect
    #data = quotation_params

    # metadata = {
    #   'namespace': 'quotation',
    #   'key': 123456,
    #   'value': 'Name: '+quotation_params[:full_name]+', E-mail: '+quotation_params[:email],
    #   'value_type': 'string'
    # }

    # shop = params[:shop]
    # token = Shop.find_by(shopify_domain: shop).shopify_token
    # session = ShopifyAPI::Session.new(shop, token)
    # ShopifyAPI::Base.activate_session(session)

    # customer = ShopifyAPI::Customer.find(4281588171)
    # customer.add_metafield(ShopifyAPI::Metafield.new(metadata))

    # if customer.metafields
    #   redirect_to quotations_path
    # else
    #   render 'new'
    # end

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
      # customer_data = {
      #   'first_name': params[:first_name],
      #   'last_name': params[:last_name],
      #   'email': params[:email],
      # }
      @customer = ShopifyAPI::Customer.new(customer_params.to_h)
      if @customer.save
        return @customer.id
      else
          render 'new'
      end
    end

  private
    def quotation_params
        params.require(:quotation).permit(:message, :quantity, :yearly_quantity_id, :resize_image, :image_width, :image_height)
        #.merge(customer_id: params[:customer_id])
    end

  private
    def customer_params
        params.require(:customer).permit(:first_name, :last_name, :email)
    end

  private
    def connect_to_shopify
      shop = params[:shop]
      token = Shop.find_by(shopify_domain: shop).shopify_token
      session = ShopifyAPI::Session.new(shop, token)
      ShopifyAPI::Base.activate_session(session)
    end

end
