require 'ffi-xattr/extensions'

describe "Xattr extensions" do
  let(:path)  { "test.txt" }
  let(:xattr) { Xattr.new(path) }

  before { File.open(path, "w") { |io| io << "some content" } }
  after  { File.delete(path) }

  describe "File.xattr" do
    it "should return an Xattr for the supplied path" do
      x = File.xattr(path)

      x.should be_kind_of(Xattr)

      #and operate on the real path
      x["user.file"] = "foo"
      Xattr.new(path)["user.file"].should == "foo"
    end
  end

  describe "Pathname#xattr" do
    it "should return an Xattr for the underlying path" do
      p = Pathname.new(path)
      x = p.xattr

      x.should be_kind_of(Xattr)
      
      #and operate on the real path
      x["user.path"] = "foo"
      Xattr.new(path)["user.path"].should == "foo"
    end
  end

end
