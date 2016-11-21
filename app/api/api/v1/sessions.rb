module API
  module V1
    class Sessions < Grape::API
      include APIDefaults
      include APIGuard

      guard_all!

      resource :sessions do

        desc "Validate oauth token"
        params do
          requires :token, type: String, desc: "Oauth token to validate"
        end
        post "/validate_token" do
          user_access_token = Doorkeeper::AccessToken.where(token: permitted_params[:token]).first
          unless user_access_token.present?
            return {success: false, errors: ["Invalid Access Token."]}
          else
            return {success: true}
          end
        end

        desc "User login"
        params do
          requires :email, type: String, desc: "User email"
          requires :pass, type: String, desc: "User password"
        end
        post "/login" do
          email = permitted_params[:email]
          pass = permitted_params[:pass]

          user = User.find_by(email: email.downcase)
          if user.nil?
            return {success: false, errors: ["Invalid email."]}
          end

          unless user.valid_password?(pass)
            return {success: false, errors: ["Invalid password."]}
          else
            # TODO: Check it
            # user.ensure_authentication_token!
            # user.save
            authentication_token = Doorkeeper::AccessToken.create(application_id: current_application, resource_owner_id: user.id)
            return {success: true, data: {user: user, user_access_token: authentication_token.token}}
          end
        end

        desc "Remove oauth token"
        params do
          requires :token, type: String, desc: "Oauth Token to remove"
        end
        post "/logout" do
          user_access_token = Doorkeeper::AccessToken.where(token: permitted_params[:token]).first
          if user_access_token.present? && user_access_token.destroy
            return {success: true}
          else
            return {success: false}
          end
        end
      end
    end
  end
end
