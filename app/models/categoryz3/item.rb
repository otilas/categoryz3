module Categoryz3
  class Item < ActiveRecord::Base
    belongs_to :category, inverse_of: :direct_items
    belongs_to :categorizable, polymorphic: true
    has_many   :child_items, foreign_key: 'master_item_id', inverse_of: :master_item, dependent: :destroy

    after_create :create_child_items
    attr_accessible :categorizable

    private

    def create_child_item_for_category(category)
      category.child_items.create(categorizable: self.categorizable, master_item: self)
    end

    def create_child_items
      category.path.each do |category|
        create_child_item_for_category category
      end
    end

  end
end
