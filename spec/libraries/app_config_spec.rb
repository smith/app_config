require_relative "../../libraries/app_config"

describe AppConfig do
  subject(:app_config) { described_class.new(*args) }
  let(:args) { nil }

  describe "#initialize" do
    context "with no arguments" do
      it "is empty" do
        expect(app_config).to be_empty
      end
    end
  end
end
