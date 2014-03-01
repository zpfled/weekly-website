require File.expand_path '../spec_helper.rb', __FILE__

feature "login page" do
	
	scenario "should be accessible at /login" do
		visit '/login'
		expect(page).to have_selector('.form-login-heading', text: 'Please log in.')
	end

	feature "when logging in" do

		background do
			Manager.create(name: 'Todd', email: 'todd@email.com', password: 'foobar')
		end

		scenario "with correct credentials" do
			visit '/login'
			within('#form') do
				fill_in 'name', 	with: 'Todd'
				fill_in 'password', with: 'foobar'
			end
			click_button 'submit'
			expect(page).to have_title('Dashboard | 2Chez')
		end

		scenario "with the wrong credentials" do
			visit '/login'
			within('#form') do
				fill_in 'name', 	with: 'Jimmy'
				fill_in 'password', with: 'cracked_corn'
			end
			click_button 'submit'
			expect(page).to have_title('Welcome | 2Chez')
		end
		
	end
end