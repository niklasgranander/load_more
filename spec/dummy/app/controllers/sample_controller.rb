class SampleController < ApplicationController
  def index
    @entries = Entry.all.load_more(nil, 3, {find_by: :string})
  end
end
