class Notification < ApplicationRecord
  after_find do
    raw_configuration = YAML.load_file(Rails.root.join('config', 'notifications.yml'))['notifications'][object_type.downcase]
    @configuration = OpenStruct.new(raw_configuration[message])
  end

  attr_reader :configuration

  belongs_to :object, polymorphic: true
  belongs_to :receiver, class_name: 'User'
  belongs_to :sender, class_name: 'User'

  delegate :text, to: :configuration

  scope :for_user, -> (user) { where(receiver: user) }
  scope :unread, -> { where(read: false) }
end
