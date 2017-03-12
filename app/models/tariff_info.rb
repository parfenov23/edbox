class TariffInfo < ActiveRecord::Base
  serialize :array_ids, Array

  def checked
    all_tariff = Tariff.where(active: true)
    corp_id = all_tariff.find_by_type_tariff("corp").id.to_s rescue nil
    person_id = all_tariff.find_by_type_tariff("person").id.to_s rescue nil
    free = all_tariff.find_by_type_tariff("free").id.to_s rescue nil

    result = []
    if all_tariff.count == 3
      result = [array_ids.include?( corp_id ),  array_ids.include?( person_id ), array_ids.include?( free )  ]
    else
      result = []
      all_tariff.reverse.each do |at|
        result << array_ids.include?( at.id.to_s )
      end
    end
    result
  end
end
