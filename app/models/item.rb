class Item < ActiveRecord::Base

  belongs_to :course

  def father
    father_id == -1 ? nil : Item.where(id: father_id).first
  end

  def children
    Item.where(father_id: id)
  end

  def is_sub?
    father_id != -1
  end

  def has_sub?
    child_count != 0
  end

  def binding_value(user_id)
    Value.where(item_id: id, user_id: user_id).first
  end

  def count(user_id)
    if has_sub?
      res = children.inject(0) { |mem, item| mem + item.count(user_id) }
      res * weight / 100.0
    else
      val = binding_value(user_id)
      val.nil? ? 0 : val.value * weight / 100.0
    end
  end

  def label_name
    has_sub? ? "#{name} (#{weight}%)" : "Score"
  end

end
