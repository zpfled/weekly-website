require File.expand_path '../spec_helper.rb', __FILE__

feature "signup page" do
  it "should be accessible at '/signup'" do
    get '/signup'
    last_response.should be_ok
  end

  feature "when a user signs up" do

    background do
      Manager.first.destroy
      visit '/signup'
      fill_in 'name',  with: 'todd'
      fill_in 'email', with: 'todd@email.com'
      fill_in 'password', with: 'foobar'
      click_button 'submit'
    end

    scenario "should capitalize the username" do
      user = Manager.first
      expect(user.name).to eq('Todd')
    end

    scenario "should create a new Manager on 'submit'" do
      user = Manager.first
      expect(user.email).to eq('todd@email.com')
      expect(user.password).to eq('foobar')
      expect(Manager.all.length).to eq(1)
      expect(user.admin).to eq(false)
    end
  end


end