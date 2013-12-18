# coding: UTF-8

require 'spec_helper'

feature 'Logout' do
  let(:user) do
    Fabricate(:job_provider,
              email: 'rolf@example.com',
              password: 'tester1234',
              password_confirmation: 'tester1234')
  end

  background do
    login_as(user, scope: :job_provider)
  end

  scenario 'Successfully log out' do
    visit '/job_providers/dashboard'
    click_on 'Abmelden'

    within_notifications do
      expect(page).to have_content('Erfolgreich abgemeldet.')
    end
  end
end
