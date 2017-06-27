module LoadMore
  module PerLoad
    def per_load
      defined?(@per_load) ? @per_load : LoadMore.per_load
    end

    def per_load=(limit)
      @per_load = limit.to_i
    end

    def self.extended(base)
      base.extend Inheritance if base.is_a? Class
    end

    module Inheritance
      def inherited(subclass)
        super
        subclass.per_load = self.per_load
      end
    end
  end

  extend PerLoad

  self.per_load = 40
end