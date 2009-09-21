require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Address' do

  describe "#initialize" do

    it "should remap attributes from parser" do
      address = Fog::AWS::EC2::Address.new(
        'instanceId'  => 'i-00000000',
        'publicIp'    => '0.0.0.0'
      )
      address.instance_id.should == 'i-00000000'
      address.public_ip.should == '0.0.0.0'
    end

  end

  describe "#addresses" do

    it "should return a Fog::AWS::EC2::Addresses" do
      ec2.addresses.new.addresses.should be_a(Fog::AWS::EC2::Addresses)
    end

    it "should be the addresses the address is related to" do
      addresses = ec2.addresses
      addresses.new.addresses.should == addresses
    end

  end

  describe "#destroy" do

    it "should return true if the address is deleted" do
      address = ec2.addresses.create
      address.destroy.should be_true
    end

  end

  describe "#reload" do

    before(:each) do
      @address = ec2.addresses.create
      @reloaded = @address.reload
    end

    after(:each) do
      @address.destroy
    end

    it "should return a Fog::AWS::EC2::Address" do
      @reloaded.should be_a(Fog::AWS::EC2::Address)
    end

    it "should reset attributes to remote state" do
      @address.attributes.should == @reloaded.attributes
    end

  end

  describe "#save" do

    before(:each) do
      @address = ec2.addresses.new
    end

    it "should return true when it succeeds" do
      @address.save.should be_true
      @address.destroy
    end

    it "should not exist in addresses before save" do
      @address.addresses.get(@address.public_ip).should be_nil
    end

    it "should exist in buckets after save" do
      @address.save
      @address.addresses.get(@address.public_ip).should_not be_nil
      @address.destroy
    end

  end

end
