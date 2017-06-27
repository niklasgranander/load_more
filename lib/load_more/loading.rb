require 'active_record'
require 'load_more/per_load'

module LoadMore
  module Loading
    def load_more(last=nil, amount=nil, options={})
      options.reject!{ |k, v| not v.present? }
      opts = OPTS.merge(options)

      last = last || 0
      amount = amount || self.per_load
      order = opts[:desc] ? ' desc' : ''

      check_arguments!(last, amount, opts)

      if opts[:find_by] != :id
        last = self.pluck(opts[:find_by]).index(last) + 1 unless last == 0
        order = opts[:find_by].to_s + order
      else
        order.strip!
      end

      self.order(order).offset(last).limit(amount)
    end

    private
    OPTS = {
        find_by:    :id,
        order_by:   nil,
        desc:       false,
    }

    def check_arguments!(last, amount, options={})
      if amount.present?
        unless amount.is_a?(Integer)
          raise ArgumentError.new(':amount parameter must be an integer')
        end
      end

      if options.present?
        if options[:find_by].present?
          unless options[:find_by].is_a?(Symbol) && self.column_names.include?(options[:find_by].to_s)
            raise ArgumentError.new(':find_by option must be a symbol that corresponds to a column name')
          end
        end

        if options[:order_by].present?
          unless options[:order_by].is_a?(Symbol) && self.column_names.include?(options[:order_by])
            raise ArgumentError.new('find_by option must be a symbol that corresponds to a key')
          end
        end

        if options[:desc].present?
          unless options[:desc] == true or options[:desc] == false
            raise ArgumentError.new(':desc parameter must be a boolean')
          end
        end
      end
    end
  end

  ::ActiveRecord::Base.extend Loading
  ::ActiveRecord::Base.extend PerLoad

  klasses = [::ActiveRecord::Relation]
  if defined? ::ActiveRecord::Associations::CollectionProxy
    klasses << ::ActiveRecord::Associations::CollectionProxy
  else
    klasses << ::ActiveRecord::Associations::AssociationCollection
  end

  # support pagination on associations and scopes
  klasses.each { |klass| klass.send(:include, Loading) }


end



