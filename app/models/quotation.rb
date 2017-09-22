class Quotation < ApplicationRecord
    belongs_to :yearly_quantity
    has_many :templates, dependent: :destroy
    validates :message, :quantity, :yearly_quantity_id,  presence: true
    validates_inclusion_of :resize_image, :in => [true, false]
    validates :quantity, numericality: { only_integer: true }
    validate :any_present?
    #validates_presence_of :image_width, :message => " Or Image height is required",  :if => :error_required_image_width?

    scope   :by_status, ->  (status) { where status: status }
    scope   :by_query, ->   (query)                 { where("id = ? OR customer_name LIKE ? OR customer_email LIKE ?", "%"+query+"%", "%"+query+"%", "%"+query+"%") }
    scope   :by_date, ->    (start_date, end_date)  { where("created_at >= ? AND created_at <= ?", start_date, end_date) }

    STATUS =['Status','new','ready','completed']


    def any_present?
        if resize_image == false || resize_image.nil?
            false
        else
          if %w(image_height image_width).all?{|attr| self[attr].blank?}
            errors.add :base, "You should input at-least one field of resizing \"Height\" or \"Width\" "
          end
        end
    end


    # def error_required_image_width?

    #   image_height_new = image_height.to_i == 0 ? 0 : image_height.to_i
    #   if resize_image == false || resize_image.nil?
    #         false
    #     else
    #         if resize_image == true && image_height_new > 0
    #             false
    #         else
    #             puts "height less than 0"
    #             return true
    #         end
    #     end
    # end

    def self.daterange_filter(start_date, end_date)
      where( "created_at >= ? AND created_at <= ?", start_date, end_date )
    end

    def self.query_filter(query)
      where("id = ? OR customer_name LIKE ? OR customer_email LIKE ?", "%"+query+"%", "%"+query+"%", "%"+query+"%")
    end

    def self.search_quotation(status, query, start_date, end_date)
      if start_date == nil
          self.where(status: status).query_filter(query)
      elsif query == nil
          self.where(status: status).daterange_filter(start_date, end_date)
      elsif status == nil
          self.where("id = ? OR customer_name LIKE ? OR customer_email LIKE ?", "%"+query+"%", "%"+query+"%", "%"+query+"%").daterange_filter(start_date, end_date)
      else
          self.where(status: status).query_filter(query).daterange_filter(start_date, end_date)
      end
    end

    def self.search(status, query, daterange)
        results = []

        if(daterange != "")
           start_date = Date.strptime(daterange.at(0..9), '%m/%d/%Y')
           end_date =  Date.strptime(daterange.at(13..22), '%m/%d/%Y')
        end

        case
          when (status != "Status" && query != "" && daterange != "") then
            results = search_quotation(status, query, start_date, end_date)

          when (status != "Status" && query == "" && daterange == "") then
            results = self.by_status(status)

          when (status == "Status" && query != "" && daterange == "") then
            results = self.by_query(query)

          when (status == "Status" && query == "" && daterange != "") then
            results = self.by_date(start_date, end_date)

          when (status != "Status" && query != "" && daterange == "") then
            results = search_quotation(status, query, nil, nil)

          when (status != "Status" && query == "" && daterange != "") then
            results = search_quotation(status, nil, start_date, end_date)

          when (status == "Status" && query != "" && daterange != "") then
            results = search_quotation(nil, query, start_date, end_date)

          when (status == "Status" && query == "" && daterange == "") then
            results = self.all
        end
        results

    end

end
