class Admin::LetterheadController < Admin::BaseController
  def edit
    authorize [:admin, :letterhead], :edit?
    @letterhead = letterhead
  end

  def update
    authorize [:admin, :letterhead], :update? 
    File.open(Rails.root.join('config', 'letterhead.yml'), 'w') do |file|
      file.write({ 'letterhead' => letterhead_params.to_h }.to_yaml)
    end

    redirect_to root_path
  end

  private

  def letterhead
    @_letterhead ||= Admin::Letterhead.new(YAML.load(File.read(Rails.root.join('config', 'letterhead.yml')))['letterhead'])
  end

  def letterhead_params
    params.require(:admin_letterhead).permit(
      :governor, :secretary_of_state, :attorney_general,
      :commissioner_of_health, :director
    )
  end
end
