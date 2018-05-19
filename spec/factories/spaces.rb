FactoryBot.define do
  factory :space do
    status "Not attacked"
    board board
    ship ship
  end
end
