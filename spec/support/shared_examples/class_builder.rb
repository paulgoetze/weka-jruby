shared_examples 'class builder' do
  subject { described_class }

  it { is_expected.to respond_to :build_class }
  it { is_expected.to respond_to :build_classes }
end
