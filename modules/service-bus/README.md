# Module storage-account

A terraform module that provisions a service namespace with the following characteristics: 

- Supports Topics with Forwarding (Topic subscriptions).
- Supports Queues.
- Supports the ability to specify authorization rules.


## Usage

```
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "service_bus" {
  source              = "github.com/danielscholl/iac-terraform/modules/service-bus"
  name                = "iac-terraform-servicebus-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  topics = [
    {
      name = "terraform-topic"
      enable_partitioning = true
      authorization_rules = [
        {
          name   = "iac"
          rights = ["listen", "send"]
        }
      ]
    }
  ]

  queues = [
    {
      name = "terraform-queue"
      authorization_rules = [
        {
          name   = "iac"
          rights = ["listen", "send"]
        }
      ]
    }
  ]

  resource_tags = {
    iac = "terraform"
  }
}
```

## Inputs

| Variable Name                     | Type       | Description                          | 
| --------------------------------- | ---------- | ------------------------------------ |
| `name`                            | _string_   | The name of the namespace. |
| `resource_group_name`             | _string_   | The name of an existing resource group. |
| `resource_tags`                   | _list_     | Map of tags to apply to taggable resources in this module. |
| `sku`                             | _string_   | The SKU of the namespace. The options are: `Basic`, `Standard`, `Premium`. Default: `Standard`. |
| `capacity`                        | _number_   | The number of message units. The options are: `1`, `2`, `4`. |
| `authorization_rules`             | _list_     | List of namespace authorization rules. |
| `topics`                          | _list_     | List of `topics`. |
| `queues`                          | _list_     | List of `queues`. |


The `authorization_rules` object must have the following keys:

| Variable Name                     | Type       | Description                          | 
| --------------------------------- | ---------- | ------------------------------------ |
| `name`                            | _string_   | The name of the authorization rule.  |
| `rights`                          | _list_     | List of authorization rule rights. The options are: `listen`, `send` and `manage`. |

The `topics` object accepts the following keys:

| Variable Name                     | Type       | Description                          | 
| --------------------------------- | ---------- | ------------------------------------ |
| `name`                            | _string_   | **Required**. The name of the topic. |
| `status`                          | _string_   | The status of the topic. The options are: `Active` and `Disabled`. Default: `Active`. |
| `auto_delete_on_idle`             | _string_   | ISO 8601 timespan duration for idle interval after which the topic is automatically deleted. |
| `default_message_ttl`             | _string_   | ISO 8601 timespan duration for default message time to live value. |
| `duplicate_detection_history_time_window` | _string_ | ISO 8601 timespan duration that defines the duration of the duplicate detection history. |
| `enable_batched_operations`       | _bool_     | Allow server-side batched operations. |
| `enable_express`                  | _bool_`     | Enable Express Entities. |
| `enable_partitioning`             | _bool_     | Whether the topic is partitioned across multiple message brokers. |
| `max_size`                        | _number_   | Maximum size of topic in megabytes, which is the size of the memory allocated for the topic. | 
| `enable_duplicate_detection`      | _bool_     | Whether the topic requires duplicate detection. |
| `enable_ordering`                 | _bool_     | Whether the topic supports ordering. |
| `authorization_rules`             | _list_     | List of topic authorization rules. |
| `subscriptions`                   | _list_     | List of topic subscriptions. |

The `subscriptions` object accepts the following keys:

| Variable Name                     | Type       | Description                          | 
| --------------------------------- | ---------- | ------------------------------------ |
| `name`                            | _string_   | **Required**. The name of the subscription. |
| `auto_delete_on_idle`             | _string_   | ISO 8601 timespan duration for idle interval after which the topic is automatically deleted. |
| `default_message_ttl`             | _string_   | ISO 8601 timespan duration for default message timespan to live value. |
| `lock_duration`                   | _string_   | ISO 8601 timespan duration for lock duration timespan for the subscription. |
| `enable_batched_operations`       | _bool_     | Allow server-side batched operations. |
| `max_delivery_count`              | _number_   | The number of maximum deliveries. |
| `enable_session`                  | _bool_     | Whether the subscription supports the concept of sessions. |
| `forward_to`                      | _string_   | The queue or topic name to forward the messages to. |
| `enable_dead_lettering_on_message_expiration`  | _bool_ | Whether a subscription has dead letter support when a message expires. |
| `rules`                           | _list_     | List of subscription rules. |

The `rules` object accepts the following keys:

| Variable Name                     | Type       | Description                          | 
| --------------------------------- | ---------- | ------------------------------------ |
| `name`                            | _string_   | **Required**. The name of the topic subscription rule. |
| `sql_filter`                      | _string_   | The filter SQL expression. |
| `action`                          | _string_   | The action SQL expression. |

The `queues` object accepts the following keys:

| Variable Name                     | Type       | Description                          | 
| --------------------------------- | ---------- | ------------------------------------ |
| `name`                            | _string_   | **Required**. The name of the queue. |
| `auto_delete_on_idle`             | _string_   | ISO 8601 timespan duration for idle interval after which the queue is automatically deleted. |
| `default_message_ttl`             | _string_   | ISO 8601 timespan duration for default message to live value. |
| `enable_express`                  | _bool_     | Whether Express Entities are enabled.  |
| `enable_partitioning`             | _bool_     | Whether the queue is to be partitioned across multiple message brokers. |
| `lock_duration`                   | _string_   | ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. |
| `max_size`                        | _string_   | Maximum size of queue in megabytes, which is the size of the memory allocated for the queue. |
| `enable_duplicate_detection`      | _bool_     | Whether this queue requires duplicate detection. |
| `enable_session`                  | _bool_     | Whether the queue supports the concept of sessions. |
| `max_delivery_count`              | _number_   | The maximum delivery count. A message is automatically deadlettered after this number of deliveries. |
| `enable_dead_lettering_on_message_expiration` | _bool_ | Whether this queue has dead letter support when a message expires. |
| `duplicate_detection_history_time_window` | _string_ | ISO 8601 timespan duration that defines the duration of the duplicate detection history. |
| `authorization_rules`             | _list_     | List of queue authorization rules. |


## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `id`: The ID of the service bus namespace.
- `name`: The name of the service bus namespace.
- `authorization_rules`: Map of authorization rules.
- `topics`: Map of topics.
- `queues`: Map of queues.
