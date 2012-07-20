module ApplicationHelper
  def comma_separated_list_of(list, attr_name)
    list.map(&attr_name.to_sym).join(", ")
  end
end
