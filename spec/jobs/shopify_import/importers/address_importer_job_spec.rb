require 'spec_helper'

describe ShopifyImport::Importers::AddressImporterJob, type: :job do
  subject { described_class.new }

  describe '#perfrom' do
    let(:resource) { double('ShopifyAddress') }
    let(:spree_user) { double('SpreeUser') }

    it 'calls a importer service' do
      expect(ShopifyImport::Importers::AddressImporter).to receive(:new).and_call_original
      expect_any_instance_of(ShopifyImport::Importers::AddressImporter).to receive(:import!)

      subject.perform(resource, spree_user)
    end
  end
end
