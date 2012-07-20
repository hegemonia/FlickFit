module AppearsInCommaSeparatedList
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def in_comma_separated_list(list)
      list.split(",").map do |name|
        pretty_name = prettify_name name
        find_by_name(pretty_name) || create(:name => pretty_name)
      end
    end

    def prettify_name(name)
      name.gsub(/[-|_]/, " ").downcase.strip.titleize
    end
  end
end