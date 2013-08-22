require 'spec_helper'

describe Nerve do

  it "should announce the machine" do
    zookeeper.single.start
    zookeeper.single.wait_for_up

    nerve.initialize_zk

    nerve.start
    nerve.wait_for_up

    until_timeout(10) do
      zookeeper.children(nerve.machine_check_path).should_not be_empty
    end
  end

  it "should go down with zookeeeper" do
    zookeeper.single.start
    zookeeper.single.wait_for_up

    nerve.initialize_zk

    nerve.start
    nerve.wait_for_up

    zookeeper.single.stop(:signal => :KILL)
    nerve.process.wait(:timeout => 10)

    nerve.process.should_not be_running
  end

end