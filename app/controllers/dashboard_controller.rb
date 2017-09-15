class DashboardController < ApplicationController
    include ShopifyApp::AppProxyVerification
    include AppProxyAuth

    def index

        unless is_user_logged_in
            redirect_to login_url and return
        end
        connect_to_shopify
        @waiting_draft_orders = []
        draft_orders = ShopifyAPI::DraftOrder.where( :customer => { :id => logged_in_user_id })
        draft_orders.sort! {|x,y| y.created_at <=> x.created_at }
        
        draft_orders.each do |draft_order|
            unless draft_order.tags.include?('Invoice')
                @waiting_draft_orders.push draft_order
            end
        end
        
        render layout: true, content_type: 'application/liquid'
    end
    
    def load_templates
        @templates = Template.where( { :customer_id => params[:id], :deleted => false }).order('last_used_at DESC, times_used DESC')
        render_data = ''
        if @templates.nil? or @templates.empty?
            render_data = '<tr>
		        	            <td cols="4">There is no templates.</td>
		        	        </tr>'
        else
            @templates.each do |template|
                times_used      = template.times_used ? template.times_used : 0
                last_used_at    = template.last_used_at ? template.last_used_at.strftime('%d %b %Y') : ''
                render_data += "<tr id='template-#{ template.id }'>
        		        			<td>
        		        			    <a href='javascript:;' class='template_name_link' data-template='#{template.to_json}' >
        		        			    #{ template.template_name }
        		        			    </a>
        		        			</td>
        		        			<td class='hidden-xs'>#{ last_used_at }</td>
        		        			<td>#{times_used}</td>
        		        			<td>
        		        				<a href='javascript:;' class='select-template' data-id= #{template.id}><div class='btn btn-blue btn-sm'></i> SELECT</div></a>
        			        			<div class='btn-group'>
        		            				<a href='javascript:;' data-toggle='dropdown' class='cdropdown-toggle'>
        		            					Options <span class='caret'></span>
        		            				</a>
        		            				<ul class='dropdown-menu dropdown-primary' role='menu'>
        		            					<li>
        		            					    <a href='javascript:;' class='rename-template'
    			            					                data-name='#{ template.template_name }'
    			            					                data-url='#{ update_template_path template.id }' >Rename</a>
        		            					</li>
        		            					<li class='divider'></li>
        		            					<li>
        		            					    <a href='#{delete_template_path(template)}' data-method='DELETE' data-remote='true' data-confirm = 'Are you sure you want to delete it?'>Delete</a>
        		            					</li>
        		            				</ul>
        	            				</div>
                    				</td>
        		        		</tr>"
            end
            render_data  += '<script>jQuery(".cdropdown-toggle").dropdown();</script>'
        end
        render json: { 'data': render_data }
    end
    
    def new_order
        @template = Template.find(params[:id])
        unless @template.nil?
            @variants = []
            JSON.parse(@template.product_variants).each do |v|
                product = ShopifyAPI::Product.find(JSON.parse(v)['product_id'])
                variants = product.variants
                variants.each do |vitem|
                  vitem.product_id = vitem.product_id
                end
                @variants.concat product.variants
            end
        end
        render layout:'guest', content_type: 'application/liquid'
    end
    
    def order
        @msg ||= params[:msg]
        render layout: true, content_type: 'application/liquid'
    end
    
    def draft_order_delete
        connect_to_shopify
        
        draft_order_id ||= params[:id]
        
        respond_to :html, :json
        if draft_order_id
            draft_order = ShopifyAPI::DraftOrder.find(draft_order_id)
            if draft_order.destroy
                render json:{
                    status: 'success',
                    result: 'Draft order was successfully deleted!'
                }
            else
                render json: {
                    status: 'error',
                    message: 'Internal Server Error!'
                }
            end
        else
            render json: {
                status: 'error',
                message: 'Draft Order Id is required!'
            }
        end
    end
    
end
