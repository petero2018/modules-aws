################################################################################
# Policy
################################################################################

variable "policy_id" {
  type = string

  description = "The name of the policy."
}

variable "description" {
  type = string

  description = "A human-readable description of the policy."
}

variable "default_state" {
  type = string

  description = "The default starting state for each index that uses this policy."
}

################################################################################
# States
################################################################################

# https://opensearch.org/docs/latest/im-plugin/ism/policies/
variable "states" {
  type = list(object({
    # The name of the state.
    name = string
    # The actions to execute after entering a state.
    actions = list(object({
      # The timeout period for the action. Accepts time units for minutes, hours, and days.
      timeout = optional(string)
      # The retry configuration for the action.
      retry = optional(object({
        # The number of retry counts.
        count = number
        # The backoff policy type to use when retrying. Valid values are Exponential, Constant, and Linear.
        backoff = optional(string)
        # The time to wait between retries. Accepts time units for minutes, hours, and days.
        delay = optional(string)
      }))
      # Reduces the number of Lucene segments by merging the segments of individual shards.
      # This operation attempts to set the index to a read-only state before starting the merging process.
      force_merge = optional(object({
        # The number of segments to reduce the shard to.
        max_num_segments = number
      }))
      # Sets a managed index to be read only.
      read_only = optional(object({}))
      # Sets a managed index to be writeable.
      read_write = optional(object({}))
      # Sets the number of replicas to assign to an index.
      replica_count = optional(object({
        # Defines the number of replicas to assign to an index.
        number_of_replicas = number
      }))
      # Allows you to reduce the number of primary shards in your indexes.
      shrink = optional(object({
        # The maximum number of primary shards in the shrunken index.
        # it cannot be used with max_shard_size or percentage_of_source_shards
        num_new_shards = optional(number)
        # The maximum size in bytes of a shard for the target index.
        # it cannot be used with num_new_shards or percentage_of_source_shards
        max_shard_size = optional(string)
        # Percentage of the number of original primary shards to shrink.
        # This parameter indicates the minimum percentage to use when shrinking the number of primary shards.
        # Must be between 0.0 and 1.0, exclusive.
        # it cannot be used with max_shard_size or num_new_shards
        percentage_of_source_shards = optional(number)
        # The name of the shrunken index. Accepts strings and the Mustache variables and.
        target_index_name_template = optional(string)
        # Aliases to add to the new index.
        aliases = optional(map(any))
        # If true, executes the shrink action even if there are no replicas.
        force_unsafe = optional(bool)
      }))
      # Closes the managed index.
      # Closed indexes remain on disk, but consume no CPU or memory. You can’t read from, write to, or search closed indexes.
      close = optional(object({}))
      # Opens a managed index.
      open = optional(object({}))
      # Deletes a managed index.
      delete = optional(object({}))
      # Migrates to warm
      warm_migration = optional(object({}))
      # Rolls an alias over to a new index when the managed index meets one of the rollover conditions.
      rollover = optional(object({
        # The minimum size of the total primary shard storage (not counting replicas) required to roll over the index.
        min_size = optional(string)
        # The minimum storage size of a single primary shard required to roll over the index.
        min_primary_shard_size = optional(string)
        # The minimum number of documents required to roll over the index.
        min_doc_count = optional(number)
        # The minimum age required to roll over the index.
        min_index_age = optional(string)
      }))
      # Back up your cluster’s indexes and state.
      snapshot = optional(object({
        # The repository name that you register through the native snapshot API operations.
        repository = optional(string)
        # The name of the snapshot. Accepts strings and the Mustache variables and.
        # If the Mustache variables are invalid, then the snapshot name defaults to the index’s name.
        snapshot = optional(string)
      }))
      # Set the priority for the index in a specific state.
      index_priority = optional(object({
        # The priority for the index as soon as it enters a state.
        priority = number
      }))
      # Allocate the index to a node with a specific attribute set like this.
      # For example, setting require to warm moves your data only to “warm” nodes.
      allocation = optional(object({
        # Allocate the index to a node with a specified attribute.
        require = optional(string)
        # Allocate the index to a node with any of the specified attributes.
        include = optional(string)
        # Don’t allocate the index to a node with any of the specified attributes.
        exclude = optional(string)
        # Wait for the policy to execute before allocating the index to a node with a specified attribute.
        wait_for = optional(string)
      }))
      # Index rollup lets you periodically reduce data granularity by rolling up old data into summarized indexes.
      rollup = optional(map(any))
    }))
    # The next states and the conditions required to transition to those states.
    transitions = optional(list(object({
      # The name of the state to transition to if the conditions are met.
      state_name = string
      # List the conditions for the transition.
      conditions = optional(object({
        # The minimum age of the index required to transition.
        min_index_age = optional(string)
        # The minimum age required after a rollover has occurred to transition to the next state.
        min_rollover_age = optional(string)
        # The minimum document count of the index required to transition.
        min_doc_count = optional(string)
        # The minimum size of the total primary shard storage (not counting replicas) required to transition.
        min_size = optional(string)
        # The cron job that triggers the transition if no other transition happens first.
        cron = optional(object({
          cron = object({
            # The cron expression that triggers the transition.
            expression = string
            # The timezone that triggers the transition.
            timezone = string
          })
        }))
      }))
    })))
  }))

  description = "The states that you define in the policy."
}

################################################################################
# Index Template
################################################################################

variable "ism_template" {
  type = list(object({
    index_patterns = list(string)
    priority       = number
  }))

  description = "Index template to use for this ISM."
}
