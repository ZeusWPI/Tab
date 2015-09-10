describe TransactionsController, type: :api do
  before :each do
    @debtor   = create :user
    @creditor = create :user
    @api_attributes = {
      debtor:   @debtor.name,
      creditor: @creditor.name,
      message:  Faker::Lorem.sentence,
      euros:    1,
      cents:    25
    }
  end

  def post_transaction(extra_attributes = {})
    post '/transactions', { transaction: @api_attributes.merge(extra_attributes) },
        { 'HTTP_ACCEPT' => "application/json", "X_API_KEY" => @key }
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
      post_transaction
      expect(last_response.status).to eq(201)
    end
  end

  describe "successfull creating transaction" do
    it "should create a transaction" do
      expect { post_transaction }.to change { Transaction.count }.by(1)
    end

    it "should set issuer" do
      post_transaction
      @transaction = Transaction.last
      expect(@transaction.issuer).to eq(@client)
    end
  end

  describe "failed creating transaction" do
    it "should create a transaction" do
      expect { post_transaction(euros: -5) }.to change { Transaction.count }.by(0)
    end

    it "should give 402 status" do
      post_transaction(euros: -4)
      expect(last_response.status).to eq(422)
    end
  end
end
