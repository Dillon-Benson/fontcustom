require 'spec_helper'

describe Fontcustom do
  let(:input_dir) { 'spec/fixtures/vectors' }
  let(:output_dir) { 'tmp' }
  let(:fake_file) { output_dir + '/non-vector.txt' }

  context 'when ouput_dir already contains files' do
    # Compile, add non-fontcustom file, change input vectors, recompile
    before(:all) do
      Fontcustom.compile(input_dir, output_dir)
      FileUtils.touch(fake_file, :verbose => true)
      @original_fonts = Dir[output_dir + '/fontcustom-*.{woff,eot,ttf,svg}']
      @original_css = File.read(output_dir + '/fontcustom.css')
      FileUtils.mv(input_dir + '/B.svg', input_dir + '/E.svg', :verbose => true)
      Fontcustom.compile(input_dir, output_dir)
    end

    after(:all) do
      cleanup(output_dir)
      FileUtils.mv(input_dir + '/E.svg', input_dir + '/B.svg', :verbose => true)
    end

    it 'should delete previous fontcustom generated files' do
      new_files = Dir[output_dir + '/*']
      @original_fonts.each do |original|
        new_files.should_not include(original)
      end
    end

    it 'should not delete non-fontcustom generated files' do
      File.exists?(fake_file).should be_true
    end

    it 'should generate different css' do
      new_css = File.read(output_dir + '/fontcustom.css')
      new_css.should_not equal(@original_css)
    end
  end
end
