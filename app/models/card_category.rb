class CardCategory < ActiveRecord::Base
  has_many :card_items

  def html_child_cards
    html = ""
    card_items.each do |card|
      html << "<li>#{card.html_cards}</li>"
    end
    html
  end
end
