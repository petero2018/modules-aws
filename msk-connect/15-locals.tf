locals {
  cloudwatch_log_group_name = "/aws/msk/connect/${var.name}"

  default_connector_configuration = {
    custom = {}
    s3 = {
      # Bucket parameters
      "s3.bucket.name" = var.output_bucket_name
      "s3.region"      = data.aws_region.current.name

      # Timestamp extraction
      "timestamp.extractor" = "RecordField"
      "timestamp.field"     = "occurred_on"

      # Object size parameters
      # See https://docs.confluent.io/kafka-connectors/s3-sink/current/overview.html#s3-object-uploads
      "flush.size"                  = "1000"    # Max number of events in files
      "rotate.schedule.interval.ms" = "600000"  # Always triggered, based on internal clock
      "partition.duration.ms"       = "3600000" # Triggered on incoming events, based on timestamp extractor

      # Other parameters
      "s3.object.tagging"               = "false" # Enabling this can increase storage costs
      "s3.compression.type"             = "gzip"
      "s3.elastic.buffer.enable"        = "true"
      "s3.elastic.buffer.init.capacity" = "4096"    # Minimum, default is 131072
      "s3.part.size"                    = "5242880" # Minimum, default is 26214400
      "connector.class"                 = "io.confluent.connect.s3.S3SinkConnector"
      "format.class"                    = "io.confluent.connect.s3.format.json.JsonFormat"
      "value.converter"                 = "org.apache.kafka.connect.json.JsonConverter"
      "value.converter.schemas.enable"  = "false"
      "schema.compatibility"            = "NONE"
      "key.converter"                   = "org.apache.kafka.connect.storage.StringConverter"
      "storage.class"                   = "io.confluent.connect.s3.storage.S3Storage"
      "locale"                          = "US"
      "timezone"                        = "UTC"
      "partition.field.format.path"     = "false"
    }
  }
}
