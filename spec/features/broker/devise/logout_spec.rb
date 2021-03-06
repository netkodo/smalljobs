# coding: UTF-8

require_relative '../../../spec_helper'

feature 'Logout' do
  let(:broker) do
    Fabricate(:broker_with_regions,
              email: 'rolf@example.com',
              password: 'tester1234',
              password_confirmation: 'tester1234')
  end

  background do
    login_as(broker, scope: :broker)
  end

  scenario 'Successfully log out' do
    visit_on broker, '/broker/dashboard'
    click_on 'Abmelden'

    within_notifications do
      expect(page).to have_content('Erfolgreich abgemeldet.')
    end
  end
end
