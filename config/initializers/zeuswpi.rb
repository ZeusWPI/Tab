require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Zeuswpi < OmniAuth::Strategies::OAuth2

      # Give your strategy a name.
      option :name, 'zeuswpi'

      # This is important, see https://github.com/omniauth/omniauth-oauth2/issues/93#issuecomment-257319242
      def callback_url
        full_host + callback_path
      end

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        site: 'https://adams.ugent.be',
        authorize_url: '/oauth/authorize/',
        token_url: '/oauth/token/'
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid { raw_info['username'] }

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/current_user').parsed
      end
    end
  end
end
