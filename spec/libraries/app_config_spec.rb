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

    context "with overriding arguments" do
      let(:args) { [{ :a => 1 }, { :a => 2}] }

      it "makes the first one have priority" do
        expect(app_config[:a]).to eq 1
      end
    end
  end

  describe "#to_environment_variables" do
    let(:args) do
      [{
        'test1' => 123,
        'test2' => 'abc',
        'test3' => {},
        'test4' => [],
        'test5' => 'def',
        'test6' => true,
        'test7' => false,
        'test8' => nil,
      }]
    end

    it 'creates environment variables' do
      expect(app_config.to_environment_variables).to eq(<<EOF
export TEST1="123"
export TEST2="abc"
export TEST5="def"
export TEST6="true"
export TEST7="false"
EOF
)
    end
  end

  describe "#to_yaml" do
    let(:args) { [{ :a => 1 }] }

    it "does not include class names in the YAML string" do
      expect(app_config.to_yaml).not_to match(described_class.to_s)
    end
  end
end
