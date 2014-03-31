require File.expand_path(File.join(File.dirname(__FILE__), '..', 'performance_helper'))

require 'benchmark'

DatabaseCleaner.start

Benchmark.bm(22) do |x|
  ids_draft = []
  ids_no_draft = []

  # Write performance
  x.report("write without draft  ") do
    500.times { |i| ids_no_draft << MonkeyNoDraft.create(:name => "Baboo", :age => 12, ).id }
  end
  x.report("write with draft     ") do
    500.times { |i| ids_draft << Monkey.create(:name => "Baboo", :age => 12, ).id }
  end

  # Read performance
  x.report("read with draft      ") do
    ids_draft.each { |id| Monkey.first(:id => id) }
  end
  x.report("read without draft   ") do
    ids_no_draft.each { |id| MonkeyNoDraft.first(:id => id) }
  end
end

DatabaseCleaner.clean
