require 'test_helper'

class CreateUsersTest < ActionDispatch::IntegrationTest

    test "user cannot sign in with invalid username" do
        get signup_path
        assert_template 'users/new'
        assert_no_difference 'User.count' do
            email = "aaa123@hotmail.com"
            password = "password"
            post users_path, params: { user: {username: "aa", email: email, password: password} }
            assert_error_view
            
            post users_path, params: { user: {username: "a" * 26 , email: email, password: password} }
            assert_error_view

        end
    end
    
    test "user cannot have duplicate names" do
        get signup_path
        assert_template 'users/new'
        assert_difference 'User.count', 1 do
            email = "john@hotmail.com"
            password = "password"
            #debugger
            post users_path, params: { user: {username: "john", email: email, password: password} }
            follow_redirect!
            assert_template 'users/show'
            assert_match "john", response.body
        end
        
        get signup_path
        assert_template 'users/new'
        assert_no_difference 'User.count' do
            email = "john123@hotmail.com"
            password = "password"
            post users_path, params: { user: {username: "john", email: email, password: password} }
            assert_error_view
        end
        
    end
    
    def assert_error_view
        assert_template 'users/new'
        assert_select 'div.card-body'
        assert_select 'h2.card-title'
        assert_select 'div.card-text'
    end

end