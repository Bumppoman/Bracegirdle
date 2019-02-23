class Activity < ApplicationRecord
  after_find do
    raw_configuration = YAML.load_file(Rails.root.join('config', 'activities.yml'))['activities'][model_type.downcase]
    @color = raw_configuration['color']
    @configuration = OpenStruct.new(raw_configuration[activity_performed])
    @object = model_type.constantize.find(model_id)
  end

  attr_reader :color, :configuration, :object

  belongs_to :user

  delegate :icon, :text, :title, to: :configuration
end
