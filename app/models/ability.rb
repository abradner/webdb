class Ability
  include CanCan::Ability

  def initialize(user)
    # alias edit_role to update_role so that they don't have to be declared separately
    alias_action :edit_role, :to => :update_role
    alias_action :edit_approval, :to => :approve

    # alias activate and deactivate to "activate_deactivate" so its just a single permission
    alias_action :deactivate, :to => :activate_deactivate
    alias_action :activate, :to => :activate_deactivate

    # alias access_requests to view_access_requests so the permission name is more meaningful
    alias_action :access_requests, :to => :admin

    # alias reject_as_spam to reject so they are considered the same
    alias_action :reject_as_spam, :to => :reject

    #return unless user.role
    #user.role.permissions.each do |permission|
    #  action = permission.action.to_sym
    #  can action, permission.entity.constantize
    #end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    # Superuser privileges
    if user.is_superuser?
      can :admin, User
      can :read, User
      can :update_role, User
      can :activate_deactivate, User
      can :approve, User
      can :reject, User
      can :manage, System
      can :configure, System

      can :create, System
      can :update, System
      can :destroy, System

      can :manage, ColourScheme
      can :manage, StorageLocation
      can :manage, ImportJob
      #can :manage, FileContentType
    end

    can :list, User #TODO security

    system_administrations = user.system_administration_ids
    system_memberships = user.system_membership_ids

    # System privileges
    can :read, System, :id => system_memberships
    can :update, System, :id => system_administrations
    can :configure, System, :id => system_administrations
    #can :edit_member, System, :id => system_administrations
    can :edit_permissions, System, :id => system_administrations
    can :edit_file_types_old, System, :id => system_administrations
    can :edit_members, System, :id => system_administrations
    can :update_members, System, :id => system_administrations

    can :list_members, System, :id => system_administrations
    can :list_administrators, System, :id => system_administrations
    can :list_collaborators, System, :id => system_administrations

    #Security Group privileges
    can :manage, SecurityGroup, :system_id => system_administrations

    #File Type privileges
    can :manage, FileType, :system_id => system_administrations


    can :update, RawFile, :user_id => user.id


    # Data Object privileges
    can_manage_data_object = user.can_manage_data_objects
    can_read_data_object   = user.can_read_data_objects
    can_write_data_object  = user.can_read_data_objects


    can :show,            DataObject, :system_id => system_memberships
    can :export,          DataObject, :system_id => system_memberships
    can :manage,          DataObject, :system_id => system_administrations

    can :write,           DataObject, :system_id => system_administrations
    can :update,          DataObject, :system_id => system_administrations

    can :change_content,  DataObject, :system_id => system_memberships

    can :manage,  DataObjectAttribute, :data_object_id => can_manage_data_object
    can :read,    DataObjectAttribute, :data_object_id => can_read_data_object

    can :manage,  DataObjectRow, :data_object_id => can_write_data_object
    can :read,    DataObjectRow, :data_object_id => can_read_data_object

    can :manage,  ImportJob, :data_object_id => can_manage_data_object
    can :read,    ImportJob, :data_object_id => can_read_data_object

    #Data Object Relationship privileges
    #can :manage, DataObjectRelationship, :system_id => system_administrations ##TODO admin security groups (both objects )& administrators

    #Data Object Security privileges
    can :edit_security, DataObject, :system_id => system_administrations #TODO admin security groups & administrators
    can :update_security, DataObject, :system_id => system_administrations #TODO admin security groups & administrators

    #Data Object FileType privileges
    can :manage, ImportMapping, :data_object => {:system_id => system_administrations} #TODO admin security groups & administrators


  end
end
