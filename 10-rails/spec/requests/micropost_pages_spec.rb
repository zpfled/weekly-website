require 'spec_helper'

describe "MicropostPages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
		before { sign_in user }

		describe "micropost creation" do
		before { visit root_path }

		describe "with invalid information" do
			it "should not create a micropost" do		
			expect { click_button "Post" }.not_to change(Micropost, :count)               
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do

			before { fill_in 'micropost_content', with: "Lorem ipsum" }
			it "should create a micropost" do
				expect { click_button "Post" }.should change(Micropost, :count).by(1)
			end
		end
	 	
	 	describe "micropost destruction" do
	 		before { FactoryGirl.create(:micropost, user: user) }

	 		describe "as correct user" do
	 			before { visit root_path }

	 			it "should delete a micropost" do
	 				expect { click_link "delete" }.should change(Micropost, :count).by(-1)
	 			end
	 		end
	 		
	 		describe "as incorrect user" do
	 			before { visit root_path }
	 			# before { click_link "Sign out" }
	 			let(:user2) { FactoryGirl.create(:user) }
	 			before { sign_in user2 }

	 			it "should not delete a micropost" do
	 				page { should_not have_link "delete" }
	 			end
	 		end


	 	end
	end
end