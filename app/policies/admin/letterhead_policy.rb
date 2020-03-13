class Admin::LetterheadPolicy < Struct.new(:user, :letterhead)
  def edit?
    update?
  end

  def update?
    user.supervisor?
  end
end
