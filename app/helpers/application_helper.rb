module ApplicationHelper
    def active_class(link_path)
        current_page?(link_path) ? "active" : ""
    end

    # def flash_class(level)
    #     case level
    #         when 'notice' then "alert alert-info"
    #         when 'success' then "alert alert-success"
    #         when 'error' then "alert alert-danger"
    #         when 'alert' then "alert alert-warning"
    #     end
    # end
end
