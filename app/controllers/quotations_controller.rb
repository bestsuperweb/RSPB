class QuotationsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  include ShopifyApp::AppProxyVerification
  include AppProxyAuth
  require 'json'
  require 'securerandom'

  def index

    unless is_user_logged_in
      redirect_to login_url and return
    end

    @quotations = Quotation.where(customer_id: logged_in_user_id).order(created_at: :desc)
    render layout: true, content_type: 'application/liquid'
  end

  def show
    @quotation = Quotation.where(:token =>params[:id]).select('*').first
    if @quotation.blank?
      not_found
    else
      connect_to_shopify
      @customer = ShopifyAPI::Customer.find(@quotation.customer_id)
      render layout: 'guest', content_type: 'application/liquid'
    end
  end

  def new
    @quotation = Quotation.new
    @customer = Customer.new
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
    created_at = time + float_fraction_of_time

    token = Digest::MD5.hexdigest(created_at)
    quotation_data = quotation_params.merge(customer_id: customer_id, token: token)
    connect_to_shopify
    @customer = ShopifyAPI::Customer.find(customer_id)
    @shop = ShopifyAPI::Shop.current
    shop_meta = @shop.metafields

    @quotation = Quotation.new(quotation_data)

    if @quotation.save
        #customer mail
        mailer =  QuotationMailer.send_quotation_received_for_customer(@customer, @shop, @quotation, shop_meta)
        mailer_response = mailer.deliver_now
        mailgun_message_id = mailer_response.message_id

        #admin mail
        admin_mailer =  QuotationMailer.quotation_receive_for_admin(@customer, @shop, @quotation, shop_meta)
        admin_mailer_response = admin_mailer.deliver_now
        admin_mailgun_message_id = admin_mailer_response.message_id

        redirect_to quotation_path(token)
    else
      render_new_quotation
    end

  end

  def edit
    @quotation = Quotation.find(params[:token])
  end

  def update
    @quotation = Quotation.find(params[:id])
    respond_to :html, :json
    if  @quotation.update_attributes(quotation_update_params)
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

  private
    def quotation_update_params
      params.require(:quotation).permit(:quantity, :return_file_format, :set_margin, :resize_image, :image_width, :image_height, :additional_comment)
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

end
