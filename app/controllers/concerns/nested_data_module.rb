# coding: UTF-8
module NestedDataModule
  # == Params
  #  * +class_or_item+ - Class name or top level times
  #  * +mover+ - The item that is being move, used to exlude impossible moves
  #  * +from_self+ - 是否从自己这一节点开始，而不是从root开始
  #  * +with_self+ - 在显示的时候是否包括自己
  #  * +to_custon+ - 自定义数据格式
  #  * +&block+ - a block that will be used to display: { |item| ... item.name }
  def nested_set_options_ts(class_or_item, mover = nil, from_self = false, with_self = true, to_custom = false)
    if class_or_item.is_a? Array
      items = from_self ? class_or_item : class_or_item.reject { |e| !e.root? }
    else
      class_or_item = class_or_item.roots if class_or_item.respond_to?(:scoped)
      items = Array(class_or_item)
    end
    result = []
    items.each do |root|
      result += root.class.associate_parents(with_self ? root.self_and_descendants : root.descendants).map do |i|
        if mover.nil? || mover.new_record? || mover.move_possible?(i)
          to_custom ? yield(i) : [yield(i), i.id]
        end
      end.compact
    end
    result
  end

  #获取上下级结构的数据
  def nested_set_options(class_or_item, mover = nil, to_custom = false)
    if class_or_item.is_a? Array
      items = class_or_item.reject { |e| !e.root? }
    else
      class_or_item = class_or_item.roots if class_or_item.respond_to?(:scoped)
      items = Array(class_or_item)
    end
    result = []
    items.each do |root|
      result += root.class.associate_parents(root.self_and_descendants).map do |i|
        if mover.nil? || mover.new_record? || mover.move_possible?(i)
          if block_given?
            to_custom ? yield(i) : [yield(i), i.id]
          else
            ["#{'-' * i.level} #{i.name}", i.id]
          end
        end
      end.compact
    end
    result
  end

end