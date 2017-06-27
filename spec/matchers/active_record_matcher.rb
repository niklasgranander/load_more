RSpec::Matchers.define :match_ids do |expected|
  match do |actual|
    actual.pluck(:id) == expected
  end

  # optional
  failure_message do |actual|
    "expected that id's of #{actual.map(&:id)} would match #{expected}"
  end

  # optional
  failure_message_when_negated do |actual|
    "expected that id's of #{actual.map(&:id)} would not match #{expected}"
  end
end