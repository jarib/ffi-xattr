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
    xattr.set "user.bar", "boo"

    xattr.list.sort.should == ["user.bar", "user.foo"]

    xattr.get("user.foo").should == "bar"
    xattr.get("user.bar").should == "boo"
  end

  it "can get and set with #[] and #[]=" do
    xattr['user.foo'] = 'baz'
    xattr['user.foo'].should == 'baz'
  end

  it "can remove attributes" do
    xattr.set "user.foo", "bar"
    xattr.list.should == ["user.foo"]

    xattr.remove "user.foo"
    xattr.list.should == []
  end

  it "returns nil if the attribute is not set" do
    xattr.get("hello").should be_nil
  end

  it "can iterate over all attributes" do
    xattr.set("user.hello", "world")

    called = false
    xattr.each do |key, value|
      called = true

      key.should == "user.hello"
      value.should == "world"
    end

    called.should be_true
  end

  it "is Enumerable" do
    xattr.should be_kind_of(Enumerable)

    xattr['user.foo'] = 'bar'
    xattr.to_a.should == [['user.foo', 'bar']]
  end

  it "returns a Hash for #as_json" do
    xattr['user.foo'] = 'bar'
    xattr['user.bar'] = 'baz'

    xattr.as_json.should == {'user.foo' => 'bar', 'user.bar' => 'baz'}
  end

  it "raises Errno::ENOENT if the file doesn't exist" do
    lambda { Xattr.new("no-such-file") }.should raise_error(Errno::ENOENT)
  end

end
