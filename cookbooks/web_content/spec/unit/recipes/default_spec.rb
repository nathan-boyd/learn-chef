require 'spec_helper'

describe 'web_content::default' do
  context 'On Windows 2012 R2' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2') do |node|
        node.override['web_content']['document_root'] = 'c:\\fake_path'
        node.override['web_content']['group'] = 'fake_group'
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates a directory with windows rights' do
      expect(chef_run).to create_directory('c:\\fake_path')
        .with(
          rights: [{ permissions: :read, principals: 'fake_group' }],
          recursive: true
        )
    end
  end
end