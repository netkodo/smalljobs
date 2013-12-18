# coding: UTF-8

require 'spec_helper'

feature 'Omniauth registration' do
  context 'as a new user' do
    background do
      mock_facebook_oauth(Fabricate.build(:job_seeker, email: 'rolf@example.com', confirmed: false, active: false))
    end

    scenario 'registers for confirmation' do
      visit '/'
      click_on 'Als Sucher registrieren'
      click_on 'Mit Facebook anmelden'

      within_notifications do
        expect(page).to have_content('Sie erhalten in wenigen Minuten eine E-Mail mit einem Link für die Bestätigung der Registrierung. Klicken Sie auf den Link um Ihren Account zu bestätigen.')
      end

      expect(current_path).to eql('/')

      open_email('rolf@example.com')
      current_email.click_link 'Konto bestätigen'

      within_notifications do
        expect(page).to have_content('Vielen Dank für Ihre Bestätigung. Wir werden uns in Kürze bei Ihnen melden um ihr Konto zu aktivieren.')
      end

      expect(current_path).to eql('/')
    end
  end

  context 'as an existing user' do
    context 'that is unconfirmed' do
      background do
        mock_facebook_oauth(Fabricate(:job_seeker, email: 'rolf@example.com', confirmed: false, active: false, provider: 'facebook', uid: '1234'))
      end

      scenario 'registers again' do
        visit '/'
        click_on 'Als Sucher registrieren'
        click_on 'Mit Facebook anmelden'

        within_notifications do
          expect(page).to have_content('Sie erhalten in wenigen Minuten eine E-Mail mit einem Link für die Bestätigung der Registrierung. Klicken Sie auf den Link um Ihren Account zu bestätigen.')
        end

        expect(current_path).to eql('/')

        open_email('rolf@example.com')
        current_email.click_link 'Konto bestätigen'

        within_notifications do
          expect(page).to have_content('Vielen Dank für Ihre Bestätigung. Wir werden uns in Kürze bei Ihnen melden um ihr Konto zu aktivieren.')
        end

        expect(current_path).to eql('/')
      end
    end

    context 'that is inactive' do
      background do
        mock_facebook_oauth(Fabricate(:job_seeker, confirmed: true, active: false, provider: 'facebook', uid: '1234'))
      end

      scenario 'registers again' do
        visit '/'
        click_on 'Als Sucher registrieren'
        click_on 'Mit Facebook anmelden'

        within_notifications do
          expect(page).to have_content('Sie haben sich erfolgreich registriert. Wir konnten Sie jedoch nicht anmelden, weil Ihr Account noch nicht aktiviert ist.')
        end

        expect(current_path).to eql('/')
      end
    end
  end

end
