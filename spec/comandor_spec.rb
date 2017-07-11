# frozen_string_literal: true

require_relative './services/success'
require_relative './services/fail'
require_relative './services/fail_errors_array'
require_relative './services/params'
require_relative './services/args'
require_relative './services/no_method'

RSpec.describe Comandor do
  let!(:service) { ServiceSuccess.new('Vader', '100') }
  let!(:service_error) { ServiceFail.new }
  let!(:service_errors) { ServiceFailErrorsArray.new }

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
    it { expect(subject.failed?).to be_falsey }
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

  context 'when result is fail with errors array?' do
    subject { service_errors.perform }

    it { is_expected.to be_a(Comandor) }
    it { is_expected.to be_a(ServiceFailErrorsArray) }

    it { expect(subject.success?).to be_falsey }
    it { expect(subject.fail?).to be_truthy }
    it { expect(subject.failed?).to be_truthy }

    it { expect(subject.errors).to be_a(Hash) }
    it { expect(subject.errors).to include(name: %i[blank nil]) }
    it { expect(subject.errors).to include(age: [:blank]) }
  end

  context 'when perform method not implemented' do
    subject { ServiceNoMethod.new }

    it { expect { subject.perform }.to raise_error NoMethodError }
  end

  context 'when #perform with simple arguments' do
    describe 'with arguments' do
      subject { ServiceParams.new.perform('Vader', 100) }

      it { is_expected.to be_a(Comandor) }
      it { is_expected.to be_a(ServiceParams) }

      it { expect(subject.success?).to be_truthy }
      it { expect(subject.fail?).to be_falsey }
      it { expect(subject.failed?).to be_falsey }

      it { expect(subject.result).to eq 'Vader 100' }
    end

    describe 'without arguments' do
      it { expect { ServiceParams.new.perform }.to raise_error(ArgumentError) }
    end
  end

  context 'when #perform with complex arguments' do
    describe 'with arguments' do
      subject do
        ServiceArgs.new.perform 'Vader', age: 100 do |age|
          age + 5
        end
      end

      it { is_expected.to be_a(Comandor) }
      it { is_expected.to be_a(ServiceArgs) }

      it { expect(subject.success?).to be_truthy }
      it { expect(subject.fail?).to be_falsey }
      it { expect(subject.failed?).to be_falsey }

      it { expect(subject.result).to eq 'Vader 105' }
    end

    describe 'without arguments' do
      it { expect { ServiceArgs.new.perform }.to raise_error(ArgumentError) }
    end
  end
end
