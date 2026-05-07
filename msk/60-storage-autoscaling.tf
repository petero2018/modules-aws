resource "aws_appautoscaling_target" "default" {
  count = var.storage_autoscaling_enabled ? 1 : 0

  max_capacity       = var.storage_scaling_max_capacity
  min_capacity       = 1
  resource_id        = aws_msk_cluster.cluster.arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}

resource "aws_appautoscaling_policy" "default" {
  count = var.storage_autoscaling_enabled ? 1 : 0

  name               = "${aws_msk_cluster.cluster.cluster_name}-broker-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_msk_cluster.cluster.arn
  scalable_dimension = aws_appautoscaling_target.default[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.default[0].service_namespace

  target_tracking_scaling_policy_configuration {
    disable_scale_in = var.storage_autoscaling_disable_scale_in
    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = var.storage_scaling_target_value
  }
}
