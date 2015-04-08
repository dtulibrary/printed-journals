class Ability
  include Hydra::Ability
  
  include Worthwhile::Ability
# self.ability_logic += [:everyone_can_create_curation_concerns]

  # Define any customized permissions here.
  def custom_permissions
    # Limits deleting objects to a the admin user
    #
    # if current_user.admin?
    #   can [:destroy], ActiveFedora::Base
    # end

    # Limits creating new objects to a specific group
    if user_groups.include? 'catalog'
      can [:create, :edit, :update], :all
    end
    if user_groups.include? 'admin'
      can [:discover, :show, :read, :edit, :update, :destroy], :all
    end
  end
end
