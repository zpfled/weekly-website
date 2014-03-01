require File.expand_path '../spec_helper.rb', __FILE__

feature "menu" do

	background do
		MenuItem.all.destroy
		@calimari = MenuItem.create(menu: 'lunch',
									category: 'starters',
									name: 'calimari', 
									description: 'Peoria\'s best, served with remoulade', 
									price: 7)
	end

	feature "should display items under" do
		
		scenario "the correct menu" do
			visit '/'
			within('#lunch') do
				expect(page).to have_selector('.item-name', 		text: 'calimari')
				expect(page).to have_selector('.item-price', 		text: '7')
				expect(page).to have_selector('.item-description', 	text: 'Peoria\'s best, served with remoulade')
			end
		end

		scenario "the correct category" do

			visit '/'
			within('#starters') do
				expect(page).to have_selector('.item-name', 		text: 'calimari')
				expect(page).to have_selector('.item-price', 		text: '7')
				expect(page).to have_selector('.item-description', 	text: 'Peoria\'s best, served with remoulade')
			end
		end
	end
end