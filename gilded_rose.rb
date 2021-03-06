CONCERT_TICKETS = 'Backstage passes to a TAFKAL80ETC concert'.freeze
LEGENDARY_ITEM = 'Sulfuras, Hand of Ragnaros'.freeze
CONJURED_ITEM = 'Conjured Mana Cake'.freeze
CHEESE = 'Aged Brie'.freeze

def update_quality(items)
  items.each do |item|
    case item.name
    when CONCERT_TICKETS
      case item.sell_in
      when 6..10
        item.quality += 2
      when 1..5
        item.quality += 3
      when 0
        item.quality = 0
      else
        item.quality += 1
      end
    when CHEESE
      sellable?(item) ? item.quality += 1 : item.quality += 2
    when CONJURED_ITEM
      sellable?(item) ? item.quality -= 2 : item.quality -= 4
    when LEGENDARY_ITEM
      nil
    else
      sellable?(item) ? item.quality -= 1 : item.quality -= 2
    end

    case item.name
    when LEGENDARY_ITEM
      nil
    else
      ensure_quality_within_range(item)
      item.sell_in -= 1
    end
  end
end

private 

def sellable?(item)
  item.sell_in > 0
end

def ensure_quality_within_range(item)
  if item.quality > 50 
    item.quality = 50
  elsif item.quality < 0
    item.quality = 0
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

