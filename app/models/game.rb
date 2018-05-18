class Game < ApplicationRecord
  attr_accessor :messages

  enum current_turn: ["challenger", "opponent"]
  serialize :player_1_board
  serialize :player_2_board

  validates :player_1_turns, presence: true
  validates :player_2_turns, presence: true
  validates :current_turn, presence: true

  belongs_to :player_1, class_name: "User"
  belongs_to :player_2, class_name: "User"
  belongs_to :player_1_board, class_name: "Board"
  belongs_to :player_2_board, class_name: "Board"
  belongs_to :winner, class_name: "User", optional: true
end
