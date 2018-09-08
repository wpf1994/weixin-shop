class CodeTable < ActiveRecord::Base
  has_many :children, -> {order position: :asc}, class_name: 'CodeTable', foreign_key: 'parent_id'

  belongs_to :parent, class_name: 'CodeTable'
  acts_as_list scope: :parent

  has_many :communities
  has_many :shops, class_name: 'Shop', foreign_key: 'region_id'
  # acts_as_nested_set


  def self.ids
    @@code_table
  end

  def self.get(id)
    CodeTable.find(id)
  end

  def self.get_list(ids)
    CodeTable.where(id: ids)
  end

  def self.get_children(id)
    CodeTable.joins(:parent).where('parents_code_tables.id = ?', id)
  end

  private
  @@code_table = {
      role: {
          group:{
              id: '011'
          }
      }
  }
end
