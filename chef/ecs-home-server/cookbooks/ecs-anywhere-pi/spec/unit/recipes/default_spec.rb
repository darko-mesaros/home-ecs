require 'chefspec'

EXPECTED_BEHAVIOUR = 'default demo recipe on'

shared_examples EXPECTED_BEHAVIOUR do |platform, version|
  context 'When all attributes are provided' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: platform, version: version) do |node|
        node.normal['filepath'] = '/tmp/test.txt'
        node.normal['content']  = 'Random content'
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect {chef_run}.to_not raise_error
    end

    it 'creates a file in the given path with the given content' do
      expect(chef_run).to create_file('/tmp/test.txt').with(
        content: 'Random content'
      )
    end
  end

  context 'When no attribute is provided' do
      let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.converge(described_recipe)
      end

      it 'converges successfully' do
        expect {chef_run}.to_not raise_error
      end

      it 'uses default values for attributes' do
        expect(chef_run).to create_file('/tmp/example.txt').with(
          content: 'Hello, World!'
        )
      end
    end
end

describe 'apply-chef-recipes-example-cookbook::default' do
  it_behaves_like EXPECTED_BEHAVIOUR, 'amazon', '2'
  it_behaves_like EXPECTED_BEHAVIOUR, 'centos', '8'
  it_behaves_like EXPECTED_BEHAVIOUR, 'debian', '10'
  it_behaves_like EXPECTED_BEHAVIOUR, 'fedora', '28'
  it_behaves_like EXPECTED_BEHAVIOUR, 'fedora', '29'
  it_behaves_like EXPECTED_BEHAVIOUR, 'fedora', '30'
  it_behaves_like EXPECTED_BEHAVIOUR, 'redhat', '7.4'
  it_behaves_like EXPECTED_BEHAVIOUR, 'redhat', '8'
  it_behaves_like EXPECTED_BEHAVIOUR, 'ubuntu', '16.04'
  it_behaves_like EXPECTED_BEHAVIOUR, 'ubuntu', '18.04'
end