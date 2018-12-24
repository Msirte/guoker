RailsAdmin.config do |config|
  config.parent_controller = "::ApplicationController"


  # config.main_app_name = ["Cool app", "BackOffice"]
  # or something more dynamic
  config.main_app_name = Proc.new { |controller| ["CourseSelect", "控制面板"] }

  # config.authorize_with :cancan, AdminAbility

  config.included_models = ['User','Course','Grade']
  
  # == Authenticate ==
  config.authorize_with do
    redirect_to main_app.root_path, flash: {:danger => '请先以管理员身份登陆'} unless current_user.admin?
  end

  config.current_user_method(&:current_user)

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0
  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    # root actions
    dashboard                     # mandatory
    # collection actions
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
    # member actions
    show
    edit
    delete
    history_show
    # show_in_app
  end
end
