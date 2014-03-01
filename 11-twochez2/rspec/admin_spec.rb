require File.expand_path '../spec_helper.rb', __FILE__

feature "admin page" do

	feature "for not-logged-in users" do
		background do
			Manager.create(name: 'Todd', email: 'todd@email.com', password: 'foobar')
		end

		scenario "should redirect them to '/'" do
			visit '/admin'
			expect(page).to have_title('Login | 2Chez')
		end
	end
	
	feature "for logged in users" do

		background do
			Manager.create(name: 'Todd', email: 'todd@email.com', password: 'foobar')
			visit '/login'
			within('#form') do
				fill_in 'name', 	with: 'Todd'
				fill_in 'password', with: 'foobar'
			end
			click_button 'submit'
		end

		scenario "should be accessible at /admin" do
			visit '/admin'
			expect(page).to have_title('Dashboard | 2Chez')
		end

		scenario "should greet user by name" do
			visit '/admin'
			expect(page).to have_selector('h1', text: 'Hi, Todd.')
		end

		feature "upon 'add item' submission" do
			background do
				@items = MenuItem.all.length
				visit '/admin'
				within('#add-item') do
					fill_in 'name', 		with: 'pizza'
					fill_in 'description',	with: 'the best food in the world'
					fill_in 'price',		with: '9'
				end
				click_button 'submit'
			end

			scenario "should create new MenuItem" do
				new_items = (@items + 1)
				new_items == MenuItem.all.length
			end
		end
	end
end