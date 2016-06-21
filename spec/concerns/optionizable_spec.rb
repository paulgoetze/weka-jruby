require 'spec_helper'

describe Weka::Concerns::Optionizable do
  subject do
    Class.new { include Weka::Concerns::Optionizable }.new
  end

  it { is_expected.to respond_to :use_options }
  it { is_expected.to respond_to :options }

  it 'responds to .default_options' do
    expect(subject.class).to respond_to :default_options
  end

  describe '#use_options' do
    let(:options) { double('options') }

    before do
      allow(subject).to receive(:set_options)
      allow(Java::WekaCore::Utils).to receive(:split_options).and_return(options)
    end

    context 'when called with hash options' do
      it 'sets the given options' do
        expect(Java::WekaCore::Utils)
          .to receive(:split_options).once
          .with('-I 100 -K 0')

        expect(subject).to receive(:set_options).once.with(options)
        subject.use_options(I: 100, K: 0)
      end
    end

    context 'when called with single options' do
      it 'sets the given options' do
        expect(Java::WekaCore::Utils)
          .to receive(:split_options).once
          .with('-O -B')

        expect(subject).to receive(:set_options).once.with(options)
        subject.use_options(:O, :B)
      end
    end

    context 'when called with single options & hash options' do
      it 'sets the given options' do
        expect(Java::WekaCore::Utils)
          .to receive(:split_options).once
          .with('-O -I 100')

        expect(subject).to receive(:set_options).once.with(options)
        subject.use_options(:O, I: 100)
      end
    end

    context 'when called with a string' do
      it 'sets the given options' do
        expect(Java::WekaCore::Utils)
          .to receive(:split_options).once
          .with('-O -I 100')

        expect(subject).to receive(:set_options).once.with(options)
        subject.use_options('-O -I 100')
      end
    end
  end

  describe '#options' do
    before { allow(subject).to receive(:set_options) }

    context 'if both single options & hash option are defined' do
      before { subject.use_options(:O, :B, I: 100) }

      it 'returns the defined options' do
        expect(subject.options).to eq '-O -B -I 100'
      end
    end

    context 'if only single options are defined' do
      before { subject.use_options(:O, :B) }

      it 'does not include an empty hash' do
        expect(subject.options).to eq '-O -B'
      end
    end

    context 'if no option was defined' do
      let(:default_options) { 'default' }

      before do
        allow(subject.class)
          .to receive(:default_options)
          .and_return(default_options)
      end

      it 'returns the default options' do
        expect(subject.options).to eq default_options
      end
    end
  end

  describe '.default_options' do
    before do
      allow_any_instance_of(subject.class)
        .to receive(:get_options)
        .and_return(%w(-C last -Z -P 10 -M -B 0.1))
    end

    it 'receives Java’s #get_options' do
      expect_any_instance_of(subject.class).to receive(:get_options).once
      subject.class.default_options
    end

    it 'returns a string with the default options' do
      options = '-C last -Z -P 10 -M -B 0.1'
      expect(subject.class.default_options).to eq options
    end
  end
end
