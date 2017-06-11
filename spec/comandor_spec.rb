# frozen_string_literal: true

require_relative './services/success'
require_relative './services/fail'
require_relative './services/no_method'

RSpec.describe Comandor do
  let!(:service) { ServiceSuccess.new('Vader', '100') }
  let!(:service_error) { ServiceFail.new }

  it 'has a version number' do
    expect(Comandor::VERSION).not_to be nil
  end

  context 'when service is not called' do
    describe 'success service' do
      subject { service }

      it { is_expected.to be_a(ServiceSuccess) }
      it { is_expected.to be_a(Comandor) }

      it { expect(subject.errors).to be_empty }
      it { expect(subject.success?).to be_falsey }
      it { expect(subject.fail?).to be_falsey }
      it { expect(subject.failed?).to be_falsey }
    end
  end

  context 'when result is success?' do
    subject { service.perform }

    it { is_expected.to be_a(Comandor) }
    it { is_expected.to be_a(ServiceSuccess) }

    it { expect(subject.success?).to be_truthy }
    it { expect(subject.fail?).to be_falsey }
    it { expect(subject.result).to eq 'Vader 100' }
  end

  context 'when result is fail?' do
    subject { service_error.perform }

    it { is_expected.to be_a(Comandor) }
    it { is_expected.to be_a(ServiceFail) }

    it { expect(subject.success?).to be_falsey }
    it { expect(subject.fail?).to be_truthy }
    it { expect(subject.failed?).to be_truthy }

    it { expect(subject.errors).to be_a(Hash) }
    it { expect(subject.errors).to include(name: %i[blank nil]) }
    it { expect(subject.errors).to include(age: [:blank]) }
  end

  context 'when perform method not implemented' do
    subject { ServiceNoMethod.new }

    it { expect{ subject.perform }.to raise_error NoMethodError }
  end
end