module Concerns::Slugifiable
  module ClassMethods
    def slugify(string)
      string.gsub(/\s/, '-').gsub(/[^\w-]/, '').downcase
    end

    def find_by_slug(slug)
      self.all.find { |obj| obj.slug == slug }
    end
  end

  module InstanceMethods
    def slug
      self.class.slugify(name)
    end
  end
end
