require 'spec_helper'

describe 'broker/providers/index.html.haml' do

  let(:provider_A) { Fabricate(:provider) }
  let(:provider_B) { Fabricate(:provider) }

  before do
    assign(:providers, [provider_A, provider_B])
    render
  end

  context 'list items' do
    it 'render the provider first name' do
      expect(rendered).to have_text(provider_A.firstname)
      expect(rendered).to have_text(provider_B.firstname)
    end

    it 'render the provider last name' do
      expect(rendered).to have_text(provider_A.lastname)
      expect(rendered).to have_text(provider_B.lastname)
    end

    it 'render the provider zip' do
      expect(rendered).to have_text(provider_A.zip)
      expect(rendered).to have_text(provider_B.zip)
    end

    it 'render the provider city' do
      expect(rendered).to have_text(provider_A.city)
      expect(rendered).to have_text(provider_B.city)
    end

    context 'list item data' do
      it 'contains the link to show the providers details' do
        expect(rendered).to have_link('Anzeigen', href: broker_provider_path(provider_A))
        expect(rendered).to have_link('Anzeigen', href: broker_provider_path(provider_B))
      end

      it 'contains the link to edit the providers details' do
        expect(rendered).to have_link('Bearbeiten', href: edit_broker_provider_path(provider_A))
        expect(rendered).to have_link('Bearbeiten', href: edit_broker_provider_path(provider_B))
      end

      it 'contains the link to destroy the providers' do
        expect(rendered).to have_link('Löschen', href: broker_provider_path(provider_A))
        expect(rendered).to have_link('Löschen', href: broker_provider_path(provider_B))
      end
    end
  end

  context 'global actions' do
    it 'contains the link to add a new provider' do
      expect(rendered).to have_link('Neuen Anbieter hinzufügen', new_provider_registration_path)
    end
  end
end
