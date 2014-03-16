class Alert < ActiveRecord::Base
  has_paper_trail

  belongs_to :question
  belongs_to :user
end
