class Activity < ApplicationRecord
  after_find do
    raw_configuration = YAML.load_file(Rails.root.join('config', 'activities.yml'))['activities'][model_type.downcase]
    @color = raw_configuration['color']
    @configuration = OpenStruct.new(raw_configuration[activity_performed])
  end

  attr_reader :color, :configuration

  belongs_to :user

  delegate :icon, :title, to: :configuration

  def object
    @object ||= model_type.constantize.find(model_id)
  end

  def text
    "#{user.name} #{configuration['text'].gsub(/\{\{(.+)\}\}/) { $1.split('.').inject(object, :send) }}"
  end
end
