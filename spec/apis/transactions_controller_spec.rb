describe TransactionsController, type: :api do
  let(:api_attributes) do
    {
      debtor:   create(:user).name,
      creditor: create(:user).name,
      message:  Faker::Lorem.sentence,
      euros:    rand(2),
      cents:    1 + rand(100)
    }
  end

  before :each do
    @client = Client.create name: "Tap"
    @key = @client.key
  end

  describe "Authentication" do
    it "should require a client authentication key" do
      post '/transactions'
      expect(last_response.status).to eq(401)
    end

    it "should work with valid key" do
      post '/transactions', { transaction: api_attributes }, { 'HTTP_ACCEPT' => "application/json", "X_API_KEY" => @key }
      expect(last_response.status).to eq(201)
    end
  end
end
