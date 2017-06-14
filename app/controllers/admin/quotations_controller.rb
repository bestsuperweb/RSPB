class Admin::QuotationsController < ShopifyApp::AuthenticatedController
  layout 'admin'

  def index
    @quotations = Quotation.all
  end

  def new
    @path = "sumon"
  end

  def samples
    @folder_path = "quotation/"+params[:service]+"/"+params[:option]
    @images = Dir.glob("app/assets/images/"+@folder_path+"/*.jpg").sort
    render layout: false
  end

end
