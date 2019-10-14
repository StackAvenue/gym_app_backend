class UserDetail < ApplicationRecord
    belongs_to :user

    def user_detail_info
     self.slice('id', 'age', 'height', 'weight').merge('created_at': created_date) 
    end

    private

    def created_date
        created_at.strftime('%d %B, %Y %I:%M %p')
    end
end
