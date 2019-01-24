require 'test_helper'

class ComplaintTest < ActiveSupport::TestCase

  def setup
    @complaint = Complaint.new(
        complainant_name: "Herman Munster")
  end

  test "all blank complaint will not save" do
    assert_not @complaint.save
  end

  test "saving without name results in validation error" do
    @complaint.complainant_name = nil
    assert_not @complaint.valid?
    assert_includes @complaint.errors.keys, :complainant_name
  end

  test "any name will be valid" do
    @complaint.complainant_name = "Fred Gwynne"
    assert_not_includes @complaint.errors.keys, :complainant_name
  end
end
