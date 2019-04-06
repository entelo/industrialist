require 'spec_helper'

RSpec.describe Industrialist::Config do
  after { described_class.manufacturable_paths.clear }

  describe '.manufacturable_paths' do
    subject(:manufacturable_paths) { described_class.manufacturable_paths }

    context 'when there are NO manufacturable paths' do
      it 'returns an empty array' do
        expect(manufacturable_paths).to eq([])
      end
    end

    context 'when there are manufacturable paths' do
      let(:path1) { 'path1' }
      let(:path2) { 'path2' }

      before do
        manufacturable_paths << path1
        manufacturable_paths << path2
      end

      it 'returns an array containing the manufacturable paths' do
        expect(manufacturable_paths).to eq([path1, path2])
      end
    end
  end

  describe '.load_manufacturables' do
    subject(:load_manufacturables) { described_class.load_manufacturables }

    let(:path1_files) { [file1, file2] }
    let(:path2_files) { [file3, file4] }
    let(:file1) { 'file1' }
    let(:file2) { 'file2' }
    let(:file3) { 'file3' }
    let(:file4) { 'file4' }
    let(:path1) { 'path1' }
    let(:path2) { 'path2' }

    before do
      described_class.manufacturable_paths << path1
      described_class.manufacturable_paths << path2

      allow(Dir).to receive(:[]).with("#{path1}/**/*.rb").and_return(path1_files)
      allow(Dir).to receive(:[]).with("#{path2}/**/*.rb").and_return(path2_files)
      described_class.require_method = require_method
    end

    context 'when a require method is NOT set' do
      let(:require_method) { nil }

      before do
        allow(Kernel).to receive(:require)

        load_manufacturables
      end

      it 'requires all files under all manufacturable paths' do
        [file1, file2, file3, file4].each { |file| expect(Kernel).to have_received(:require).with(file) }
      end
    end

    context 'when a require method is set' do
      let(:require_method) { :require_dependency }

      before do
        allow(Kernel).to receive(require_method)

        load_manufacturables
      end

      it 'requires all files under all manufacturable paths' do
        [file1, file2, file3, file4].each { |file| expect(Kernel).to have_received(require_method).with(file) }
      end
    end
  end
end
