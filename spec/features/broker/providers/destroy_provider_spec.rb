# coding: UTF-8

require 'spec_helper'

feature 'Destroy a provider' do
  let(:broker) do
    Fabricate(:broker_with_regions)
  end

  background do
    Fabricate(:provider, {
      firstname: 'Dora',
      lastname: 'Doretty'
    })

    login_as(broker, scope: :broker)
  end

  scenario 'remove the provider' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Anbieter anzeigen'
    click_on 'Dora Doretty löschen'

    within_notifications do
      expect(page).to have_content('Anbieter wurde erfolgreich gelöscht.')
    end
  end

 end
