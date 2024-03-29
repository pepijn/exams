class Order < ActiveRecord::Base
  def credits_enum
    [-500, -100, -50, -10, 10, 25, 50, 75, 100]
  end

  has_paper_trail

  belongs_to :user

  validates_presence_of :credits, :user
  serialize :payment

  scope :paid, -> { where paid: true }

  rails_admin do
    create do
      field :user
      field :credits
      field :paid
    end

    update do
      exclude_fields :user, :credits
    end
  end
end

