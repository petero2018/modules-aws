variable "streams" {
  type = map(object({
    name        = string
    stream_mode = string
    tags        = map(string)
  }))
  description = "A Map of streams to create in the AWS Kinesis service."
}
