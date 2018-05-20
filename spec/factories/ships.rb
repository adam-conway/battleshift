FactoryBot.define do
  factory :ship do
    length 3
    damage 0
  end

  factory :small_ship, class: Ship do
    length 2
    damage 0
  end
end
