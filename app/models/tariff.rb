class Tariff < ActiveRecord::Base
  def all_info
    arr_id = []
    TariffInfo.all.each do |ti|
      arr_id << ti.id if ti.array_ids.include?(id.to_s)
    end
    TariffInfo.where(id: arr_id)
  end
end
