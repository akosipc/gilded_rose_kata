require_relative './gilded_rose'

DummyItem = Struct.new(:sell_in, :quality)

RSpec.shared_examples "A Normal Item" do |ref|
  describe '#update_quality' do
    it 'decreases the quality by 1' do
      expect(items[0].quality).to eq ref.quality - 1
    end

    it 'decreases the sell_in by 1' do
      expect(items[0].sell_in).to eq ref.sell_in - 1
    end
  end
end

RSpec.shared_examples "An Expired Item" do |ref|
  describe '#update_quality' do
    it 'decreases the quality by 2' do
      expect(items[0].quality).to eq ref.quality - 2
    end

    it 'decreases the sell_in by 1' do
      expect(items[0].sell_in).to eq ref.sell_in - 1
    end
  end
end

RSpec.shared_examples "A Legendary Item" do |ref|
  describe '#update_quality' do
    it 'quality does not change' do
      expect(items[0].quality).to eq ref.quality
    end

    it 'sell_in does not change' do
      expect(items[0].sell_in).to eq ref.sell_in
    end
  end
end

RSpec.shared_examples "A Cheese" do |ref|
  if ref.sell_in > 0
    describe '#update_quality' do
      it 'increase the quality by 1' do
        expect(items[0].quality).to eq ref.quality + 1
      end

      it 'decreases the sell_in by 1' do
        expect(items[0].sell_in).to eq ref.sell_in - 1
      end
    end
  else
    describe '#update_quality' do
      it 'increase the quality by 1' do
        expect(items[0].quality).to eq ref.quality + 2
      end

      it 'decreases the sell_in by 1' do
        expect(items[0].sell_in).to eq ref.sell_in - 1
      end
    end
  end
end

RSpec.shared_examples "A Conjured Item" do |ref|
  if ref.sell_in > 0
    describe '#update_quality' do
      it 'decreases the quality by 2' do
        expect(items[0].quality).to eq ref.quality - 2
      end

      it 'decreases the sell_in by 1' do
        expect(items[0].sell_in).to eq ref.sell_in - 1
      end
    end
  else
    describe '#update_quality' do
      it 'decreases the quality by 2' do
        expect(items[0].quality).to eq ref.quality - 4
      end

      it 'decreases the sell_in by 1' do
        expect(items[0].sell_in).to eq ref.sell_in - 1
      end
    end
  end
end

RSpec.describe "GildedRose" do
  let!(:items) { [] }

  describe '#update_quality' do
    before { update_quality(items) }

    context 'Backstage passes' do
      context 'increases in quality' do
        let!(:items) do
          [ Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20) ]
        end

        it 'quality increase by 1' do
          expect(items[0].quality).to eq 21
        end
      end

      context 'increases in quality by 2 if sell_in is within 6..10' do
        let!(:items) do
          [ Item.new("Backstage passes to a TAFKAL80ETC concert", 6, 20) ]
        end

        it 'quality increase by 2' do
          expect(items[0].quality).to eq 22
        end
      end

      context 'increases in quality by 3 if sell_in is within 1..5' do
        let!(:items) do
          [ Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 20) ]
        end

        it 'quality increase by 3' do
          expect(items[0].quality).to eq 23
        end
      end

      context 'quality is set to 0 when sell_in is 0' do
        let!(:items) do
          [ Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 99) ]
        end

        it 'quality is set to 0' do
          expect(items[0].quality).to eq 0
        end
      end
    end

    context 'Quality Limits' do
      let!(:items) do
        [
          Item.new("+5 Dexterity Vest", 10, 0),
          Item.new("Aged Brie", 0, 50),
        ]
      end

      it 'quality is between 0..50' do
        expect(items[0].quality).to eq 0
        expect(items[1].quality).to eq 50
      end

      it 'always decreases the sell_in' do
        expect(items[0].sell_in).to eq 9
        expect(items[1].sell_in).to eq -1
      end
    end

    it_should_behave_like 'A Conjured Item', DummyItem.new(3, 6) do
      let(:items) do
        [Item.new("Conjured Mana Cake", 3, 6)]
      end
    end

    it_should_behave_like 'A Conjured Item', DummyItem.new(0, 6) do
      let(:items) do
        [Item.new("Conjured Mana Cake", 0, 6)]
      end
    end

    it_should_behave_like 'A Cheese', DummyItem.new(2, 0) do
      let(:items) do
        [Item.new("Aged Brie", 2, 0)]
      end
    end

    it_should_behave_like 'A Cheese', DummyItem.new(0, 6) do
      let(:items) do
        [Item.new("Aged Brie", 0, 6)]
      end
    end

    it_should_behave_like 'A Normal Item', DummyItem.new(10, 20) do
      let(:items) do
        [Item.new("+5 Dexterity Vest", 10, 20)]
      end
    end

    it_should_behave_like 'A Normal Item', DummyItem.new(5, 7) do
      let(:items) do
        [Item.new("Elixir of the Mongoose", 5, 7)]
      end
    end

    it_should_behave_like 'An Expired Item', DummyItem.new(0, 50) do
      let(:items) do
        [Item.new("+5 Dexterity Vest", 0, 50)]
      end
    end

    it_should_behave_like 'An Expired Item', DummyItem.new(0, 7) do
      let(:items) do
        [Item.new("Elixir of the Mongoose", 0, 7)]
      end
    end

    it_should_behave_like 'A Legendary Item', DummyItem.new(0, 80) do
      let(:items) do
        [Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]
      end
    end
  end
end

