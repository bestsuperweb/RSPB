class Admin::QuotationsController < ShopifyApp::AuthenticatedController
  layout 'admin'

  def index
    sleep 2
    @quotations = Quotation.all.order(updated_at: :desc).page(params[:page]).per(1)
  end

  def new
    @path = "sumon"
  end

  def samples
    @folder_path = "quotation/"+params[:service]+"/"+params[:option]
    @images = Dir.glob("app/assets/images/"+@folder_path+"/*.jpg").sort
    render layout: false
  end
  
  def search_filter
    @quotations = Quotation.search(params[:filter], params[:search_box], params[:daterange_box]).order(updated_at: :desc).page(params[:page]).per(1)
    render :template => 'admin/quotations/index' 
  end

end
