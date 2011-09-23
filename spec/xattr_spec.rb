require 'ffi-xattr'

describe Xattr do
  let(:path)  { "test.txt" }
  let(:xattr) { Xattr.new(path) }

  before { File.open(path, "w") { |io| io << "some content" } }
  after  { File.delete(path) }

  it "has an inital empty list of xattrs" do
    xattr.list.should be_kind_of(Array)
    xattr.list.should be_empty
  end

  it "can set and get attributes" do
    xattr.set "user.foo", "bar"
    xattr.list.should == ["user.foo"]

    xattr.get("user.foo").should == "bar"
  end

  it "can remove attributes" do
    xattr.set "user.foo", "bar"
    xattr.list.should == ["user.foo"]

    xattr.remove "user.foo"
    xattr.list.should == []
  end

  it "raises Errno::ENOENT if the file doesn't exist" do
    lambda { Xattr.new("no-such-file") }.should raise_error(Errno::ENOENT)
  end

end
