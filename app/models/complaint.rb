GROUPED_COMPLAINT_TYPES = [
    ['Investigatory', [
        ["Board member issue", 1],
        ["Burial issues", 2],
        ["Burial rights", 3],
        ["Burial records", 4],
        ["Burial society issues", 5],
        ["Cemetery maintenance issues", 6],
        ["Cremation process", 7],
        ["Damaged monument", 8],
        ["Dangerous conditions", 9],
        ["Lot owner issues", 10],
        ["Monument issues", 11],
        ["Operating illegal cemetery", 12],
        ["Perpetual care issues", 13],
        ["Pet burial issues", 14],
        ["Rules and regulations issues", 15],
        ["Tree removal", 16],
        ["Winter burial", 17]
      ]
    ],
    ['Accounting', [
        ["Embezzlement/Fraud", 18],
        ["Financial issues", 19],
        ["Financial records issues", 20],
        ["Service fee issues", 21],
        ["Sales contract issues", 22]
    ]
  ]
]

RAW_COMPLAINT_TYPES = {
    1 => "Board member issue",
    2 => "Burial issues",
    3 => "Burial rights",
    4 => "Burial records",
    5 => "Burial society issues",
    6 => "Cemetery maintenance issues",
    7 => "Cremation process",
    8 => "Damaged monument",
    9 => "Dangerous conditions",
    10 => "Lot owner issues",
    11 => "Monument issues",
    12 => "Operating illegal cemetery",
    13 => "Perpetual care issues",
    14 => "Pet burial issues",
    15 => "Rules and regulations issues",
    16 => "Tree removal",
    17 => "Winter burial",
    18 => "Embezzlement/Fraud",
    19 => "Financial issues",
    20 => "Financial records issues",
    21 => "Service fee issues",
    22 => "Sales contract issues"
}

STATUSES = {
    1 => "Investigation Pending",
    2 => "Investigation Complete",
    3 => "Pending Review",
    4 => "Closed"
}

class Complaint < ApplicationRecord
  belongs_to :cemetery, optional: true
  belongs_to :receiver, class_name: :User, foreign_key: :receiver_id, optional: true
  belongs_to :investigator, class_name: :User, foreign_key: :investigator_id, optional: true

  validates_presence_of :complainant_name, message: "You must provide the complainant's name."
  validates_presence_of :cemetery_county, message: "You must select the cemetery's county."
  validates_presence_of :complaint_type, message: "You must specify at least one type of complaint."
  validates_presence_of :summary, message: "You must provide a summary of the complaint."
  validates_presence_of :receiver, message: "You must specify who received the complaint."
  validates_presence_of :date_acknowledged, message: "You must enter the date you acknowledged this complaint."
  validates_presence_of :form_of_relief, message: "You must enter the desired form of relief."
  validates_presence_of :date_of_event, message: "You must enter the date the event occurred."
  validate :cemetery_is_completed
  validate :investigation_data

  def self.grouped_complaint_types
    GROUPED_COMPLAINT_TYPES
  end

  def self.raw_complaint_types
    RAW_COMPLAINT_TYPES
  end

  def complaint_type
    self[:complaint_type].split(', ') if self[:complaint_type].respond_to? :split
  end

  def last_action
    case status
    when 1
      "Investigation Pending"
    when 2
      "Investigation Complete"
    when 3
      "Pending Review"
    when 4
      "Closed"
    end
  end

  private
    def cemetery_is_completed
      if cemetery_regulated?
        errors.add(:cemetery, :blank, message: "You must choose a cemetery.") unless cemetery
      else
        errors.add(:cemetery_alternate_name, :blank, message: "You must specify the name of the cemetery.") unless cemetery_alternate_name
      end
    end

    def investigation_data
      if investigation_required?
        validates_presence_of :investigation_begin_date, message: "You must specify the beginning date for the investigation."
        errors.add(:investigator, :blank, message: "You must assign the complaint to an investigator.") unless investigator
      end
    end
end
