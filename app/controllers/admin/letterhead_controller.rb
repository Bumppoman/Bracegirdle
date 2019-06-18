class Admin::LetterheadController < Admin::BaseController
  def edit
    @letterhead = letterhead
  end

  def update
    File.open(Rails.root.join('config', 'letterhead.yml'), 'w') do |file|
      file.write({ 'letterhead' => letterhead_params.to_h }.to_yaml)
    end

    redirect_to root_path
  end

  private

  def letterhead
    @_letterhead ||= OpenStruct.new(YAML.load(File.read(Rails.root.join('config', 'letterhead.yml')))['letterhead'])
  end

  def letterhead_params
    params.require(:letterhead).permit(
      :governor, :secretary_of_state, :attorney_general,
      :commissioner_of_health, :director
    )
  end
end