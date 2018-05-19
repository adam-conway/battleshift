FactoryBot.define do
  factory :game do
    association :player_1_board, factory: :board
    association :player_2_board, factory: :board
    winner nil
    association :player_1, factory: :user
    association :player_2, factory: :user
    player_1_turns 0
    player_2_turns 0
    current_turn "challenger"
  end
end
