class User < ActiveRecord::Base
  devise :timeoutable, :omniauthable, :omniauth_providers => [:zeuswpi]
end
