class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Instrument all activerecord actions for tracing

  around_save do |activity, block|
    with_span("ActiveRecord#save #{activity.class.name}") do
      block.call
    end
  end

  around_destroy do |activity, block|
    with_span("ActiveRecord#destroy #{activity.class.name}") do
      block.call
    end
  end
end
