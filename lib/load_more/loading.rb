require 'active_record'
require 'load_more/per_load'

module LoadMore
  module Loading
    def load_more(last=nil, amount=nil, options={})
      options.reject!{ |k, v| not v.present? }
      opts = OPTS.merge(options)

      amount = amount || self.per_load

      check_arguments!(last, amount, opts)

      if last.present?
        id_find_by = self.limit(amount).pluck(:id, opts[:order_by])

        if opts[:order_by] != :id
          found_id = nil

          # Try to find value of :order_by with last
          # If not found, try using :id
          id_find_by.each_with_index do |id_value, index|
            if id_value[1] == last
              last = index + 1
              break
            elsif id_value[0] == last and not found_id
              found_id = index + 1
            end
          end
          last ||= found_id
        else
          last = id_find_by.index(last) + 1
        end
      else
        last = 0
      end

      order = opts[:order_by].to_s + (opts[:desc] ? ' desc' : '')

      self.order(order).offset(last).limit(amount)
    end

    private
    OPTS = {
        order_by:   :id,
        desc:       false,
    }

    def check_arguments!(last, amount, options={})
      unless amount.is_a?(Integer)
          raise ArgumentError.new(':amount parameter must be an integer')
      end

      unless options[:order_by].is_a?(Symbol) && self.column_names.include?(options[:order_by].to_s)
        raise ArgumentError.new(':order_by option must be a symbol that corresponds to an attribute')
      end

      unless options[:desc] == true or options[:desc] == false
        raise ArgumentError.new(':desc parameter must be a boolean')
      end
    end
  end

  ::ActiveRecord::Base.extend PerLoad

  [::ActiveRecord::Relation, ::ActiveRecord::Associations::CollectionProxy]
      .each { |klass| klass.send(:include, Loading) }
end



