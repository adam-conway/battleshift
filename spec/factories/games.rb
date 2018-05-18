FactoryBot.define do
  factory :game do
    player_1_board board
    player_2_board board
    winner nil
    player_1_turns 0
    player_2_turns 0
    current_turn "challenger"
  end
end
