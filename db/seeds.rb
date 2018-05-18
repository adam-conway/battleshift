User.destroy_all
Space.destroy_all
Ship.destroy_all
Board.destroy_all
Game.destroy_all

user1 = User.create!(name: "Adam", email: "adam.n.conway@gmail.com", api_key: "123456789a", password: "help")
user2 = User.create!(name: "Jimmy", email: "nelson.jimmy@gmail.com", api_key: "987654321a", password: "help")

user_1_board = BoardGenerator.new(4).generate
user_2_board = BoardGenerator.new(4).generate

game_attributes = {
  player_1_board: user_1_board,
  player_2_board: user_2_board,
  player_1: user1,
  player_2: user2,
  player_1_turns: 0,
  player_2_turns: 0,
  current_turn: "challenger"
}

Game.create!(game_attributes)
