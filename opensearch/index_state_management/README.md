# index_state_management

OpenSearch Index State Management

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_opensearch"></a> [opensearch](#requirement\_opensearch) | >= 2.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opensearch"></a> [opensearch](#provider\_opensearch) | >= 2.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_body"></a> [body](#module\_body) | ../../../terraform/object_clean | n/a |

## Resources

| Name | Type |
|------|------|
| [opensearch_ism_policy.cleanup](https://registry.terraform.io/providers/opensearch-project/opensearch/latest/docs/resources/ism_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_state"></a> [default\_state](#input\_default\_state) | The default starting state for each index that uses this policy. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | A human-readable description of the policy. | `string` | n/a | yes |
| <a name="input_ism_template"></a> [ism\_template](#input\_ism\_template) | Index template to use for this ISM. | <pre>list(object({<br>    index_patterns = list(string)<br>    priority       = number<br>  }))</pre> | n/a | yes |
| <a name="input_policy_id"></a> [policy\_id](#input\_policy\_id) | The name of the policy. | `string` | n/a | yes |
| <a name="input_states"></a> [states](#input\_states) | The states that you define in the policy. | <pre>list(object({<br>    # The name of the state.<br>    name = string<br>    # The actions to execute after entering a state.<br>    actions = list(object({<br>      # The timeout period for the action. Accepts time units for minutes, hours, and days.<br>      timeout = optional(string)<br>      # The retry configuration for the action.<br>      retry = optional(object({<br>        # The number of retry counts.<br>        count = number<br>        # The backoff policy type to use when retrying. Valid values are Exponential, Constant, and Linear.<br>        backoff = optional(string)<br>        # The time to wait between retries. Accepts time units for minutes, hours, and days.<br>        delay = optional(string)<br>      }))<br>      # Reduces the number of Lucene segments by merging the segments of individual shards.<br>      # This operation attempts to set the index to a read-only state before starting the merging process.<br>      force_merge = optional(object({<br>        # The number of segments to reduce the shard to.<br>        max_num_segments = number<br>      }))<br>      # Sets a managed index to be read only.<br>      read_only = optional(object({}))<br>      # Sets a managed index to be writeable.<br>      read_write = optional(object({}))<br>      # Sets the number of replicas to assign to an index.<br>      replica_count = optional(object({<br>        # Defines the number of replicas to assign to an index.<br>        number_of_replicas = number<br>      }))<br>      # Allows you to reduce the number of primary shards in your indexes.<br>      shrink = optional(object({<br>        # The maximum number of primary shards in the shrunken index.<br>        # it cannot be used with max_shard_size or percentage_of_source_shards<br>        num_new_shards = optional(number)<br>        # The maximum size in bytes of a shard for the target index.<br>        # it cannot be used with num_new_shards or percentage_of_source_shards<br>        max_shard_size = optional(string)<br>        # Percentage of the number of original primary shards to shrink.<br>        # This parameter indicates the minimum percentage to use when shrinking the number of primary shards.<br>        # Must be between 0.0 and 1.0, exclusive.<br>        # it cannot be used with max_shard_size or num_new_shards<br>        percentage_of_source_shards = optional(number)<br>        # The name of the shrunken index. Accepts strings and the Mustache variables and.<br>        target_index_name_template = optional(string)<br>        # Aliases to add to the new index.<br>        aliases = optional(map(any))<br>        # If true, executes the shrink action even if there are no replicas.<br>        force_unsafe = optional(bool)<br>      }))<br>      # Closes the managed index.<br>      # Closed indexes remain on disk, but consume no CPU or memory. You can’t read from, write to, or search closed indexes.<br>      close = optional(object({}))<br>      # Opens a managed index.<br>      open = optional(object({}))<br>      # Deletes a managed index.<br>      delete = optional(object({}))<br>      # Migrates to warm<br>      warm_migration = optional(object({}))<br>      # Rolls an alias over to a new index when the managed index meets one of the rollover conditions.<br>      rollover = optional(object({<br>        # The minimum size of the total primary shard storage (not counting replicas) required to roll over the index.<br>        min_size = optional(string)<br>        # The minimum storage size of a single primary shard required to roll over the index.<br>        min_primary_shard_size = optional(string)<br>        # The minimum number of documents required to roll over the index.<br>        min_doc_count = optional(number)<br>        # The minimum age required to roll over the index.<br>        min_index_age = optional(string)<br>      }))<br>      # Back up your cluster’s indexes and state.<br>      snapshot = optional(object({<br>        # The repository name that you register through the native snapshot API operations.<br>        repository = optional(string)<br>        # The name of the snapshot. Accepts strings and the Mustache variables and.<br>        # If the Mustache variables are invalid, then the snapshot name defaults to the index’s name.<br>        snapshot = optional(string)<br>      }))<br>      # Set the priority for the index in a specific state.<br>      index_priority = optional(object({<br>        # The priority for the index as soon as it enters a state.<br>        priority = number<br>      }))<br>      # Allocate the index to a node with a specific attribute set like this.<br>      # For example, setting require to warm moves your data only to “warm” nodes.<br>      allocation = optional(object({<br>        # Allocate the index to a node with a specified attribute.<br>        require = optional(string)<br>        # Allocate the index to a node with any of the specified attributes.<br>        include = optional(string)<br>        # Don’t allocate the index to a node with any of the specified attributes.<br>        exclude = optional(string)<br>        # Wait for the policy to execute before allocating the index to a node with a specified attribute.<br>        wait_for = optional(string)<br>      }))<br>      # Index rollup lets you periodically reduce data granularity by rolling up old data into summarized indexes.<br>      rollup = optional(map(any))<br>    }))<br>    # The next states and the conditions required to transition to those states.<br>    transitions = optional(list(object({<br>      # The name of the state to transition to if the conditions are met.<br>      state_name = string<br>      # List the conditions for the transition.<br>      conditions = optional(object({<br>        # The minimum age of the index required to transition.<br>        min_index_age = optional(string)<br>        # The minimum age required after a rollover has occurred to transition to the next state.<br>        min_rollover_age = optional(string)<br>        # The minimum document count of the index required to transition.<br>        min_doc_count = optional(string)<br>        # The minimum size of the total primary shard storage (not counting replicas) required to transition.<br>        min_size = optional(string)<br>        # The cron job that triggers the transition if no other transition happens first.<br>        cron = optional(object({<br>          cron = object({<br>            # The cron expression that triggers the transition.<br>            expression = string<br>            # The timezone that triggers the transition.<br>            timezone = string<br>          })<br>        }))<br>      }))<br>    })))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | Policy ID. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
