class Comment < ActiveRecord::Base
	belongs_to :article
	belongs_to :user

	has_many :parents, class_name: "Comment",
                          foreign_key: "parent_id"
  	belongs_to :parent, class_name: "Comment"
end
