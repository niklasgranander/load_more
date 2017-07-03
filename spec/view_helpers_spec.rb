require 'rails_helper'
#require 'action_view' Necessary?

module LoadMore
  describe ActionView, type: :helper do
    before(:all) do
      %w(a b c d e f g h i j).each do |i|
        Entry.create!(string: i)
      end

      Param.create!
    end

    describe 'load_more_btn' do
      it 'should display message if collection is nil' do
        expect(load_more_btn(nil)).to have_text 'No more content'
        expect(load_more_btn(nil)).to have_selector 'div.load-more-btn.end'
      end

      it 'should display message if collection has only one item' do
        expect(load_more_btn(Param.all)).to have_text 'No more content'
        expect(load_more_btn(nil)).to have_selector 'div.load-more-btn.end'
      end

      it 'should display with collection' do
        html = load_more_btn(Entry.all, { url_params: { controller: 'sample' } })
        expect(html).to have_selector 'div.load-more-btn a.btn.btn-primary-outline'
        expect(html).to have_link 'View more'
      end

      it 'should have a href attribute with last_item: j when order_by: :string' do
        expect(load_more_btn(Entry.all, {
            order_by: :string,
            url_params: { controller: 'sample' }
        })).to have_link 'View more', href: '/?last_item=j'
      end

      it 'should have a href attribute with last_item: 10 when order_by: nil' do
        expect(load_more_btn(Entry.all, {
            url_params: { controller: 'sample' }
        }))
            .to have_link 'View more', href: '/?last_item=10'
      end
    end

    after(:all) do
      Entry.destroy_all
      Param.destroy_all
    end
  end
end
