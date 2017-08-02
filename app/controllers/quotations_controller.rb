class QuotationsController < ApplicationController

   # skip_before_action :verify_authenticity_token
   skip_before_filter :verify_authenticity_token
    include ShopifyApp::AppProxyVerification
    include AppProxyAuth
    require 'json'

  def index
    @user_id = login_to_shopify('verify_logged_in_user')
    #@user_id = 4281588171
    @quotations = Quotation.where(customer_id: @user_id)
    render layout: true, content_type: 'application/liquid'
  end

  def show
    #@quotation = Quotation.find( params[:id])
    @quotation = Quotation.where(:token =>params[:id]).select('*').first
    @quotation.inspect
    if @quotation.nil?
         created_token = false
    else
        created = @quotation.created_at.strftime('%Y-%m-%d %H:%M:%S')
        c_id = @quotation.customer_id.to_s
        token_key = created+c_id
        created_token = hash_method(token_key)

    end

  if(params[:id] == created_token)
       login_to_shopify()
       #variantIds = eval(@quotation.product_variant_ids)
       #= variantIds[:collects]
       @customer = ShopifyAPI::Customer.find(@quotation.customer_id)
       render layout: 'guest', content_type: 'application/liquid'
  else
      @error_msg ="Please don't try to override the url"
      render '404/index.html', layout: true, content_type: 'application/liquid'
  end



  end

  def new

    @quotation = Quotation.new
    @customer = Customer.new
    if !params[:hash].present?
       @guest = true
    end

    render layout: 'guest', content_type: 'application/liquid'
  end

  def create
    @quotation = Quotation.new(quotation_params)

    if is_customer
      unless @quotation.valid?
        render_new_quotation
        return
      end
      customer_id = get_logged_in_customer_id
    else
      @guest = true
      @customer = Customer.new(customer_params)
      unless @customer.valid? && @quotation.valid?
        render_new_quotation
        return
      end
      customer_id = get_customer_id_from_shopify
    end

    tf= Time.now
    time = Time.at(tf).utc.strftime('%Y-%m-%d %H:%M:%S')
    msec = tf.usec
    float_fraction_of_time = "."+ msec.to_s
    puts time + float_fraction_of_time
    created_at = time + float_fraction_of_time

    access_token_key = time + customer_id
    puts created_at
    puts "access token"
    puts access_token_key
    token = hash_method( access_token_key)
    puts   token
    quotation_data = quotation_params.merge(customer_id: customer_id, token: token, created_at: created_at)
    login_to_shopify()
    @customer = ShopifyAPI::Customer.find(customer_id)
    @shop = ShopifyAPI::Shop.current
    shop_meta =     @shop.metafields

    @quotation = Quotation.new(quotation_data)

    if @quotation.save
        #customer mail
        @shop = ShopifyAPI::Shop.current
        mailer =  QuotationMailer.send_quotation_received_for_customer(@customer, @shop, @quotation, shop_meta)
        mailer_response = mailer.deliver_now
        mailgun_message_id = mailer_response.message_id
        #admin mail
        admin_mailer =  QuotationMailer.quotation_receive_for_admin(@customer, @shop, @quotation, shop_meta)
        admin_mailer_response = admin_mailer.deliver_now
        admin_mailgun_message_id = admin_mailer_response.message_id

        redirect_to quotation_path(token, success: "Thank you! Your request has been received. We'll look at it and get back to you with your quotation soon.")
    else
      render_new_quotation
    end

  end

  def edit
    @quotation = Quotation.find(params[:token])
    #puts(@quotation)
  end

   def update
    @quotation = Quotation.find(params[:id])
    #puts @quotation .inspect
    respond_to :html, :json
    if  @quotation.update_attributes(quotation_update_params)
      # Handle a successful update.
        render :json => {
          file_content:  @quotation.message,
          file_error:  @quotation.errors,
          redirect: 'cart'
        }
    else
       render :json => {
          file_content: @quotation.errors,
          status: :unprocessable_entity
       }
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

    def quotation_update_params
        params.require(:quotation).permit(:message, :quantity,  :resize_image, :image_width, :image_height,:set_margin)
    end

  private
    def customer_params
      params.require(:customer).permit(:first_name, :last_name, :email)
    end

  private
    def is_customer
      params[:customer_id].present? && !params[:customer_id].blank? ? true : false
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

    def time_formatted time_in_ms
      regex = /^(0*:?)*0*/
      Time.at(time_in_ms.to_f/1000).utc.strftime("%Y | %m | %d| %H:%M:%S.%1N").sub!(regex, '')
    end

end
