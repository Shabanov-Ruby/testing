class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :user, class_name: 'User'
end
