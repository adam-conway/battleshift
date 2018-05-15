require 'rails_helper'

describe 'User' do
  describe 'User visits home page' do
    scenario 'should be able to register for an account' do
      visit '/'

      click_on 'Register'

      expect(current_path).to eq('/register')

      fill_in 'user[email]', with: 'adam.n.conway@gmail.com'
      fill_in 'user[name]', with: 'Adam'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'

      click_on 'Submit'

      expect(current_path).to eq('/dashboard')
      expect(page).to have_content("Created a new account")
      expect(page).to have_content("Logged in as Adam")
      expect(page).to have_content("This account has not yet been activated. Please check your email.")
    end

    scenario 'should not be able to register for an account with wrong password' do
      visit '/'

      click_on 'Register'

      expect(current_path).to eq('/register')

      fill_in 'user[email]', with: 'adam.n.conway@gmail.com'
      fill_in 'user[name]', with: 'Adam'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'wrong_password'

      click_on 'Submit'

      expect(page).to have_content("Unable to create account")
    end
  end
end
