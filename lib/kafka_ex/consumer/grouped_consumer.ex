defmodule KafkaEx.Consumer.GroupedConsumer do
  use GenServer

  @moduledoc """
    This is a very basic implementation of a consumer that uses
    the Kafka consumer group stuff to coordinate work between
    instances.

    Whenever more data is asked for during a poll, a heartbeat is sent. This
    will keep the group membership alive. When the broker rebalances, an
    optional callback is notified.

    Overall, this consumer is a simple variant of
    https://kafka.apache.org/090/javadoc/index.html?org/apache/kafka/clients/consumer/KafkaConsumer.html
  """

  defmodule ConfigState do
    defstruct bootstrap_servers: [], group_id: "", topics: []
  end

  defmodule RunState do
    defstruct config: %ConfigState{}
  end

  # Public API

  @doc """
    Start a consumer that connects to the bootstrap servers, belongs
    to the group identified by group_id, and subscribes to the indicated
    topics
  """
  def start_link(bootstrap_servers, group_id, topics) do
    config_state = %ConfigState{
      boostrap_servers: bootstrap_servers,
      group_id: group_id,
      topics: topics
    }
    run_state = %RunState{
      config: config_state
    }
    {:ok, pid} = GenServer.start_link(KafkaEx.Consumer.GroupedConsumer, run_state)
    :ok = GenServer.call(pid, :connect)
    {:ok, pid}
  end

  # GenServer implementation

  # Connect to Kafka, subscribe and stuff
  def handle_call(:connect, state) do

  end
  
end