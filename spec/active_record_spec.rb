require 'load_more/loading'
module LoadMore
  describe Loading do
    before(:all) do
      %w(a b c d e f g h i j).each do |i|
        entry = Entry.create!(string: i)
        %w(a b c d e f).each do |s|
          entry.posts.create(string: (i + s))
        end
      end

      4.times do
        Param.create!
      end
    end

    describe 'By ID' do
      it 'should get first 3 items' do
        expect(Entry.all.load_more(1, 3)).to match_ids [*1..3]
      end

      it 'should get first 10 items with no parameters' do
        expect(Entry.all.load_more).to match_ids [*1..10]
      end

      it 'should get first 3 items with amount parameter' do
        expect(Entry.all.load_more(nil, 3)).to match_ids [*1..3]
      end

      it 'should get next 7 items with start parameter' do
        expect(Entry.all.load_more(3)).to match_ids [*3..10]
      end

      it 'should get next 3 items' do
        expect(Entry.all.load_more(3, 3)).to match_ids [*3..5]
      end

      it 'should get first 3 items in ActiveRecord::Associations::CollectionProxy' do
        expect(Entry.first.posts.load_more(1, 3)).to match_ids [*1..3]
      end

      it 'should get next 3 items in ActiveRecord::Associations::CollectionProxy' do
        expect(Entry.first.posts.load_more(4, 3)).to match_ids [*4..6]
      end
    end

    describe 'By :string' do
      it 'should get first 3 items' do
        expect(Entry.all.load_more('a', 3, { find_by: :string }))
            .to match_ids [*1..3]
      end

      it 'should get next 3 items' do
        expect(Entry.all.load_more('d', 3, { find_by: :string }))
            .to match_ids [*4..6]
      end

      it 'should get first 3 items in Associations::CollectionProxy' do
        expect(Entry.first.posts.load_more('aa', 3, { find_by: :string }))
            .to match_ids [*1..3]
      end
    end

    describe 'Bad arguments' do
      it 'should only accept symbols for find_by' do
        expect{ Entry.all.load_more(1, 3, { find_by: 'id' }) }
            .to raise_error ArgumentError
      end

      it 'should only accept column name in find_by' do
        expect{ Entry.all.load_more(1, 3, { find_by: :abcd }) }
            .to raise_error ArgumentError
      end

      it 'should only accept integers in amount' do
        expect{ Entry.all.load_more(1, '3') }
            .to raise_error ArgumentError
      end

      it 'should only accept start values that are in the ActiveRecord::Relation' do
        expect{ Entry.all.load_more(11, 3) }
            .to raise_error ArgumentError
        expect{ Entry.all.load_more(10, 3) }
            .to_not raise_error
      end

      it 'should only accept start values that are in the ActiveRecord::Associations::CollectionProxy' do
        expect{ Entry.first.posts.load_more(7, 3) }
            .to raise_error ArgumentError
        expect{ Entry.first.posts.load_more(6, 3) }
            .to_not raise_error
      end

      it 'should require start value when find_by is given' do
        expect{ Entry.all.load_more(options={ find_by: :string })}
            .to raise_error ArgumentError
      end
    end

    describe 'Using values set in model' do
      # Model: Param
      # Values: per_load = 2
      it 'should use amount value (per_load) set in model' do
        expect(Param.all.load_more(1)).to match_ids [1, 2]
      end
    end

    after(:all) do
      Entry.destroy_all
    end
  end
end
