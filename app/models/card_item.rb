class CardItem < ActiveRecord::Base
  has_many :card_items, :foreign_key => :card_id
  belongs_to :card_category
  belongs_to :card_item, :foreign_key => :card_id

  def html_cards
    html = []
    if card_items.present? 
      card_items.map{|c| html << "<li>#{c.html_cards}</li>" }
      html = "<ul>#{html.join}</ul>"
    else
      html = title
    end
    html
  end
end
