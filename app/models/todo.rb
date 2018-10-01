class Todo < ApplicationRecord
  attribute :key

  def key
    self[:id]
  end
end
