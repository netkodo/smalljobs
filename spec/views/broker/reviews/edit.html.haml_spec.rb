require 'spec_helper'

describe 'provider/reviews/edit.html.haml' do

  let(:region) { Fabricate(:region) }
  let(:job) { Fabricate(:job) }
  let(:review) { Fabricate(:review) }

  before do
    assign(:job, job)
    assign(:review, review)
    view.stub(current_region: region)
    render
  end

  context 'form elements' do
    it 'renders the review input' do
      expect(rendered).to have_field('Jugendlicher')
      expect(rendered).to have_field('Nachricht')
    end

    context 'form actions' do
      it 'renders the edit button' do
        expect(rendered).to have_button('Bearbeiten')
      end
    end
  end

  context 'global actions' do
    it 'contains the link to the job' do
      expect(rendered).to have_link('Zurück', provider_job_path(job))
    end
  end
end
