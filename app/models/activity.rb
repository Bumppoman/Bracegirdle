class Activity < ApplicationRecord  
  after_find do
    raw_configuration = YAML.load_file(Rails.root.join('config', 'activities.yml'))['activities'][object_type.downcase]
    @color = raw_configuration['color']
    @configuration = OpenStruct.new(raw_configuration[activity_performed])
  end

  attr_reader :color, :configuration

  belongs_to :object, polymorphic: true
  belongs_to :user

  delegate :icon, :text, :title, to: :configuration
end
