# # coding: UTF-8
# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)
#
#
# # #
# permission_group = CodeTable.create(id: '011', name: '权限分组', remark: '系统初始化')
# pg_admin = CodeTable.create(id: '011001', name: '管理模块', remark: '系统初始化', parent_id: permission_group.id)
# pg_shop = CodeTable.create(id: '011002', name: '商店内部模块', remark: '系统初始化', parent_id: permission_group.id)
# pg_statistics = CodeTable.create(id: '011003', name: '统计模块', remark: '系统初始化', parent_id: permission_group.id)
# pg_customer = CodeTable.create(id: '011004', name: '客户模块', remark: '系统初始化', parent_id: permission_group.id)
# pg_evaluate = CodeTable.create(id: '011005', name: '评价模块', remark: '系统初始化', parent_id: 11)
#
#
#
#
#
# #=====基础=====
# all_permission = Permission.create!(action: ':manage', subject: 'all', description: '所有权限', group_id: pg_admin.id)
# attachment_permission = Permission.create!(action: ':manage', subject: 'Attachment', description: '附件管理', group_id: pg_admin.id)
# user_permission =  Permission.create!(action: '[:update,:read]', subject: 'User', description: '人员管理', group_id: pg_admin.id)
# role_permission =  Permission.create!(action: ':manage', subject: 'Role', description: '角色管理', group_id: pg_admin.id)
# Permission.create!(action: ':manage', subject: 'CodeTable', description: '码表管理', group_id: pg_admin.id)
# shop_permission = Permission.create!(action: ':manage', subject: 'Shop', description: '商店管理', group_id: pg_admin.id)
# employee_permission = Permission.create!(action: ':manage', subject: 'Employee', description: '雇员管理', group_id: pg_admin.id)
# classification_permission = Permission.create!(action: ':manage', subject: 'Classification', description: '货品分类管理', group_id: pg_admin.id)
# commodity_permission = Permission.create!(action: ':manage', subject: 'Commodity', description: '商品管理', group_id: pg_admin.id)
# shop_commodity_permission = Permission.create!(action: ':manage', subject: 'ShopCommodity', description: '商品管理', group_id: pg_admin.id)
#
#
#
#
# #=====商店内部操作=====
# #==查看待派送==
# #==分配派送==
# paisong_read = Permission.create!(action: ':read', subject: 'OrderExpress', description: '查看待派送/查看已派送信息', group_id: pg_shop.id)
# paisong_update = Permission.create!(action: ':update', subject: 'OrderExpress', description: '分配配送', group_id: pg_shop.id)
#
# #==退货管理==
# cancel_order_permission =  Permission.create!(action: ':manage', subject: 'CancelOrder', description: '退货管理', group_id: pg_shop.id)
#
# #==订单管理==
# order_permission = Permission.create!(action: ':read', subject: 'Order', description: '订单信息', group_id: pg_shop.id)
#
#
#
#
# #=====统计模块=====
# statistic_permission =  Permission.create!(action: ':read', subject: 'Order', description: '统计管理', group_id: pg_statistics.id)
#
#
#
# #=====客户模块=====
# customer_permission = Permission.create!(action: ':read', subject: 'Customer', description: '会员管理', group_id: pg_customer.id)
#
#
# #=====评价模块=====
# order_comment_permission =  Permission.create!(action: ':read', subject: 'OrderComment', description: '评价管理', group_id: pg_evaluate.id)
# #
#
#
# #=====初始化数据======
# #
# CodeTable.create(id: 2, name: '送货预计时间', default_value: '30', position: 1)
# CodeTable.create(id: 1, name: '店铺区域')
# CodeTable.create(id: 1001, name:'渝北区', parent_id: 1)
# CodeTable.create(id: 1002, name:'巴南区', parent_id: 1)
# CodeTable.create(id: 1003, name:'南岸区', parent_id: 1)
# CodeTable.create(id: 1004, name:'渝中区', parent_id: 1)
# CodeTable.create(id: 1005, name:'江北区', parent_id: 1)
# CodeTable.create(id: 1006, name:'九龙坡区', parent_id: 1)
# CodeTable.create(id: 1007, name:'沙坪坝区', parent_id: 1)
# CodeTable.create(id: 1008, name:'大渡口区', parent_id: 1)
# person_manage =User.create({id: 1, name: '管理员', phone: '13988887777', email: 'admin@qq.com', password: '12345678', password_confirmation: '12345678'})
# person_shop =User.create({id: 2, name: '商店管理员', phone: '98765432111', email: 'admin_shop@qq.com', password: '12345678', password_confirmation: '12345678'})
# person_handle =User.create({id: 3, name: '经理', phone: '15978463211', email: 'admin_handle@qq.com', password: '12345678', password_confirmation: '12345678'})
#
# role_manage = Role.create(id: 1, name: '管理员', description: '系统初始化角色')
# role_shop = Role.create(id: 2, name: '商店管理员', description: '系统初始化角色')
# role_handle = Role.create(id: 3, name: '经理', description: '系统初始化角色')
# #
# UserRole.create(user_id: person_manage.id, role_id: role_manage.id)
# UserRole.create(user_id: person_shop.id, role_id: role_shop.id)
# UserRole.create(user_id: person_handle.id, role_id: role_handle.id)
#
# #======分配权限======
# #==管理员部分
# RolePermission.create(role_id: role_manage.id, permission_id: shop_permission.id)
# RolePermission.create(role_id: role_manage.id, permission_id: commodity_permission.id)
# RolePermission.create(role_id: role_manage.id, permission_id: classification_permission.id)
# RolePermission.create(role_id: role_manage.id, permission_id: all_permission.id)
# RolePermission.create(role_id: role_manage.id, permission_id: role_permission.id)
# RolePermission.create(role_id: role_manage.id, permission_id: shop_commodity_permission.id)
# RolePermission.create(role_id: role_manage.id, permission_id: employee_permission.id)
# #===商店管理员部分
# RolePermission.create(role_id: role_shop.id, permission_id: paisong_read.id)
# RolePermission.create(role_id: role_shop.id, permission_id: paisong_update.id)
# RolePermission.create(role_id: role_shop.id, permission_id: cancel_order_permission.id)
# #==经理部分
# RolePermission.create(role_id: role_handle.id, permission_id: order_permission.id)
# RolePermission.create(role_id: role_handle.id, permission_id: statistic_permission.id)
# RolePermission.create(role_id: role_handle.id, permission_id: customer_permission.id)
# RolePermission.create(role_id: role_handle.id, permission_id: order_comment_permission.id)
#
#
#
#
Permission.create({action: ':manage', subject: Order.name, description: '店铺订单管理', group_id: 11002,
                   fetching: '["shop_id = ? ", user.shop_manage_id]',
                   code: 'entity.owner_id == user.owner_id && entity.owner_type == user.owner_type'})
Permission.create({action: ':manage', subject: ShopCommodity.name, description: '店铺商品配置管理', group_id: 11002,
                   fetching: '["shop_id = ? ", user.shop_manage_id]',
                   code: 'entity.owner_id == user.owner_id && entity.owner_type == user.owner_type'})
RolePermission.create(role_id: 2, permission_id: 18)
RolePermission.create(role_id: 2, permission_id: 19)
