require_relative '../spec_helper'

describe Provider do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:provider)).to be_valid
    end
  end

  context 'attributes' do
    describe '#firstname' do
      it 'is not valid without a firstname' do
        expect(Fabricate.build(:provider, firstname: nil)).not_to be_valid
      end
    end

    describe '#lastname' do
      it 'is not valid without a lastname' do
        expect(Fabricate.build(:provider, lastname: nil)).not_to be_valid
      end
    end

    describe '#street' do
      it 'is not valid without a street' do
        expect(Fabricate.build(:provider, street: nil)).not_to be_valid
      end
    end

    describe '#place' do
      it 'is not valid without a place' do
        expect(Fabricate.build(:provider, place: nil)).not_to be_valid
      end
    end

    describe '#email' do
      it 'must be a valid email' do
        expect(Fabricate.build(:provider, email: 'michinetz.ch')).not_to be_valid
        expect(Fabricate.build(:provider, email: 'michi@netzpiraten.ch')).to be_valid
      end
    end

    describe '#phone' do
      it 'should be a plausible phone number' do
        expect(Fabricate.build(:provider, phone: 'abc123')).not_to be_valid
        expect(Fabricate.build(:provider, phone: '056 496 03 58')).to be_valid
      end

      it 'normalizes the phone number' do
        expect(Fabricate(:provider, phone: '056 496 03 58').phone).to eql('+41564960358')
      end
    end

    describe '#mobile' do
      it 'should be a plausible phone number' do
        expect(Fabricate.build(:provider, phone: 'abc123')).not_to be_valid
        expect(Fabricate.build(:provider, phone: '079 244 55 61')).to be_valid
      end

      it 'normalizes the phone number' do
        expect(Fabricate(:provider, phone: "079/244'55'61").phone).to eql('+41792445561')
      end
    end

    describe '#active' do
      it 'is active by default' do
        expect(Fabricate(:provider)).to be_active
      end
    end

    describe '#contact_preference' do
      it 'must be one of email, phone, mobile or postal' do
        expect(Fabricate.build(:provider, contact_preference: 'abc123')).not_to be_valid
        expect(Fabricate.build(:provider, contact_preference: 'email')).to be_valid
        expect(Fabricate.build(:provider, contact_preference: 'mobile')).to be_valid
        expect(Fabricate.build(:provider, contact_preference: 'phone')).to be_valid
        expect(Fabricate.build(:provider, contact_preference: 'postal')).to be_valid
      end
    end

    describe '#contact_availability' do
      it 'is not necessary for email and postal' do
        expect(Fabricate.build(:provider, contact_preference: 'email', contact_availability: nil)).to be_valid
        expect(Fabricate.build(:provider, contact_preference: 'postal', contact_availability: nil)).to be_valid
      end
    end
  end

  describe '#email_required?' do
    it 'does not require an email' do
      expect(Fabricate(:provider).email_required?).to be false
    end
  end

  describe '#unauthenticated_message' do
    context 'when confirmed' do
      it 'is inactive' do
        expect(Fabricate(:provider).unauthenticated_message).to eql(:inactive)
      end
    end

    context 'when unconfirmed' do
      it 'is unconfirmed' do
        expect(Fabricate(:provider).unauthenticated_message).to eql(:inactive)
      end
    end
  end

  describe '#active_for_authentication?' do
    it 'is not active when not confirmed' do
      expect(Fabricate(:provider, active: true).active_for_authentication?).to be true
    end

    it 'is not active when not activated' do
      expect(Fabricate(:provider, active: false).active_for_authentication?).to be true
    end

    it 'is active when activated and confirmed' do
      expect(Fabricate(:provider, active: true).active_for_authentication?).to be true
    end
  end

  describe '#contact_preference_enum' do
    it 'returns the list of contact strings' do
      expect(Fabricate(:provider).contact_preference_enum).to eq(%w(email phone mobile postal))
    end
  end

  describe "#name" do
    it 'uses the first and last as name' do
      expect(Fabricate(:provider, firstname: 'Otto', lastname: 'Biber').name).to eql('Otto Biber')
    end
  end

  describe '#inactive_message' do
    context 'with an email' do
      it 'is unconfirmed' do
        expect(Fabricate(:provider, email: 'joe@example.com').inactive_message).to eql(:inactive)
      end
    end

    context 'with an email' do
      it 'is unconfirmed' do
        expect(Fabricate(:provider, email: nil).inactive_message).to eql(:inactive)
      end
    end
  end

  describe '#send_activation_email' do
    let(:provider) { Fabricate(:provider, active: false) }
    let(:mailer) { double('mailer') }

    it 'sends an email when a provider is activated' do
      expect(Notifier).to receive(:provider_activated_for_provider).and_return(mailer)
      expect(mailer).to receive(:deliver)
      provider.update_attributes(active: true)
    end
  end

end
