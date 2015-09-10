describe UsersController, type: :controller do
   before :each do
     @user = create :penning
     sign_in @user
   end

   describe 'GET show' do
     before :each do
       get :show, id: @user
     end

     it 'should be successful' do
       expect(response).to render_template(:show)
       expect(response).to have_http_status(200)
     end

     it 'should load the correct user' do
       expect(assigns(:user)).to eq(@user)
     end
   end

   describe 'GET index' do
     before :each do
       get :index
     end

     it 'should load an array of all users' do
       expect(assigns(:users)).to eq([@user])
     end

     it 'should render the correct template' do
       expect(response).to have_http_status(200)
       expect(response).to render_template(:index)
     end
   end
end
