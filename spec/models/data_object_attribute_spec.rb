require 'spec_helper'

describe DataObjectAttribute do

  describe "Post-processing" do
    it 'should clean up spaces and new lines in options on save' do
      doa = Factory(:data_object_attribute, :options => "a,b ,c\n,d, e")
      doa.options_to_a.should eq %W(a b c d e)
    end
  end

end
