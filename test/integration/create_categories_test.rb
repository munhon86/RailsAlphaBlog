require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest

   def setup
        @user = User.create(username: "john", email: "john@hotmail.com", password: "password", admin: true)
   end
   
    
    test "get new category and create category" do
        sign_in_as(@user, "password")
        get new_category_path
        assert_template 'categories/new'
        assert_difference 'Category.count', 1 do
        #post :create, params: { category: {name: "sports"} }
          
#begin
       post categories_path, params: { category: {name: "sports"} }
       follow_redirect!
       assert_template 'categories/index'
       assert_match "sports", response.body
#end
        end
    end
    
    test "incorrect category submission results in error" do
        sign_in_as(@user, "password")
        get new_category_path
        assert_template 'categories/new'
        assert_no_difference 'Category.count' do
        #post :create, params: { category: {name: "sports"} }
          

        post categories_path, params: { category: {name: " "} }
        #follow_redirect!
        assert_template 'categories/new'
        assert_select 'div.card-body'
        assert_select 'h2.card-title'
        assert_select 'div.card-text'
        end
    
    
    end


end