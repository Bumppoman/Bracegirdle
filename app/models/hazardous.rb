class Hazardous < Restoration
  def concern_link
    :board_applications_hazardous_path  
  end
  
  def to_sym
    :hazardous
  end
end