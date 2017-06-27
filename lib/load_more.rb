require 'load_more/version'
require 'load_more/engine' if defined?(Rails)
require 'load_more/action_view'

ActiveSupport.on_load(:action_view) do
  include LoadMore::ActionView
end