require "../spec_helper"

describe Packlink::ApiKey do
  before_each do
    configure_test_api_key
  end

  describe ".verify" do
    it "fetches the current api key" do
      WebMock.stub(:get, "https://apisandbox.packlink.com/v1/users/api/keys")
        .with(headers: {"Authorization" => "c80cfc01d13504e8a8cbe37ad2ea4e6f3464e388b7f56c7104724b4f5d557262"})
        .to_return(status: 200, body: read_fixture("api_keys/post-response"))

      response = Packlink::ApiKey.verify("c80cfc01d13504e8a8cbe37ad2ea4e6f3464e388b7f56c7104724b4f5d557262")
      response.should be_a(Packlink::ApiKey::Resource)
      response.token.should eq("c80cfc01d13504e8a8cbe37ad2ea4e6f3464e388b7f56c7104724b4f5d557262")
    end
  end

  describe ".valid?" do
    it "verifies validity of the current key" do
      WebMock.stub(:get, "https://apisandbox.packlink.com/v1/users/api/keys")
        .with(headers: {"Authorization" => "c80cfc01d13504e8a8cbe37ad2ea4e6f3464e388b7f56c7104724b4f5d557262"})
        .to_return(status: 200, body: read_fixture("api_keys/post-response"))
      WebMock.stub(:get, "https://apisandbox.packlink.com/v1/users/api/keys")
        .with(headers: {"Authorization" => "invalid_key"})
        .to_return(status: 200, body: read_fixture("api_keys/post-response"))

      valid = Packlink::ApiKey.valid?("c80cfc01d13504e8a8cbe37ad2ea4e6f3464e388b7f56c7104724b4f5d557262")
      valid.should be_true
      valid = Packlink::ApiKey.valid?("invalid_key")
      valid.should be_false
    end
  end

  describe ".renew" do
    it "creates a new api key" do
      WebMock.stub(:post, "https://apisandbox.packlink.com/v1/users/api/keys")
        .with(headers: {"Authorization" => "44c2a45734386ca1ff9a77a6f82cd4f20962c094835f1f6d6ba8c7ef94b0a155"})
        .to_return(status: 201, body: read_fixture("api_keys/post-response"))

      response = Packlink::ApiKey.renew("44c2a45734386ca1ff9a77a6f82cd4f20962c094835f1f6d6ba8c7ef94b0a155")
      response.should be_a(Packlink::ApiKey::Response)
      response.token.should eq("c80cfc01d13504e8a8cbe37ad2ea4e6f3464e388b7f56c7104724b4f5d557262")
    end
  end
end