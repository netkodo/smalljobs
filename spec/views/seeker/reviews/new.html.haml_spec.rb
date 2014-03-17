require 'spec_helper'

describe 'seeker/reviews/new.html.haml' do

  let(:region) { Fabricate(:region) }
  let(:job) { Fabricate(:job) }
  let(:review) { Fabricate.build(:review) }

  before do
    assign(:job, job)
    assign(:review, review)
    view.stub(current_region: region)
    render
  end

  context 'form elements' do
    it 'renders the review input' do
      expect(rendered).to have_field('Anbieter')
      expect(rendered).to have_field('Nachricht')
    end

    context 'form actions' do
      it 'renders the create button' do
        expect(rendered).to have_button('Erstellen')
      end
    end
  end

  context 'global actions' do
    it 'contains the link to the job' do
      expect(rendered).to have_link('Zurück', seeker_job_path(job))
    end
  end
end
