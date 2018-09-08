class Ability
  include CanCan::Ability
  # include BaseDataHandleModule

  def initialize(user)
    # if user.email == 'admin@qq.com'
    #   can :manage, :all
    # end
    # if user.has_role? :admin
    # can :manage, :all
    # end
    #if user.has_role? :top_manage
    #  can :manage, :all
    #end
    #if user.has_role? :manage
    #  can :default_statistics, TaskEntity
    #  can :read, TaskEntity do |task|
    #    audit_read_task_entity(task, user) || base_read_task_entity(task, user)
    #  end
    #  can :manage, Person
    #  can :update, Issue
    #  can :create, Notice
    #  can :create, NoticeAccepter
    #  can [:set_manage, :cancel_manage], Person
    #  can :audit, TaskEntity do |task|
    #    audit_read_task_entity(task, user)
    #  end
    #end
    alias_action :show_group, :read, :to => :show_task
    alias_action :split_new, :split_create, :read, :to => :split

    #基础权限
    # can [:tree_data], [Person, Department, Organization]
    # can [:load_department_by_person, :validate_person, :update_password, :sync_data], Person
    # can [:load_by_org_for_select], Department

    #orgs = present_and_sort(Organization.find(user.organization_id).self_and_descendants).map{|org| org.id}
    #can :manage, Person, ['organization_id IN (?)', can_organization(user)] do |person|
    #  can_organization(user).include?(entity.organization_id)
    #end

    can :manage, ExpressOrder, shop: {managers: {id: user.id}}

    permissions = user.permissions
    permissions.each do |permission|
      if permission.code.present? #有code筛选
        if permission.fetching.present? #有查询筛选
          can permission.use_action, permission.use_subject, eval(permission.fetching) do |entity|
            eval(permission.code)
          end
        else #只有code筛选
          can permission.use_action, permission.use_subject do |entity|
            eval(permission.code)
          end
        end
      elsif permission.fetching.present? #只有查询筛选
        can permission.use_action, permission.use_subject, eval(permission.fetching)
      else #无筛选
        can permission.use_action, permission.use_subject
      end
    end
  end

  #可以操作的单位ID集合
  def can_organization(user)
    orgs = present_and_sort(Organization.find(user.organization_id).self_and_descendants).map { |org| org.id }
  end
end
