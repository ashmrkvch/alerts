
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

resource "google_monitoring_uptime_check_config" "http" {
  count = "${length(var.monitoring)}"
  display_name = "HTTP UPTIME CHECK"
  timeout = "10s"
  period = "60s"
  http_check {
    path = split(";", var.monitoring[count.index])[1]
    port = split(";", var.monitoring[count.index])[2]
  }
  monitored_resource {
    type = "uptime_url"
    labels = {
      host = split(";", var.monitoring[count.index])[0]
    }
  }
}

resource "google_monitoring_uptime_check_config" "tcp_group" {
  count = "${length(var.monitoring)}"
  display_name = "TCP UPTIME CHECK"
  timeout      = "60s"

  tcp_check {
    port = split(";", var.monitoring[count.index])[2]
  }

   monitored_resource {
    type = "uptime_url"
    labels = {
      host = split(";", var.monitoring[count.index])[0]
    }
  }
}

resource "google_monitoring_uptime_check_config" "https" {
  count = "${length(var.monitoring)}"
  display_name = "HTTPS UPTIME CHECK"
  timeout = "10s"
  period = "60s"
   http_check {
    path = split(";", var.monitoring[count.index])[1]
    port = split(";", var.monitoring[count.index])[2]
    use_ssl = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = split(";", var.monitoring[count.index])[0]
    }
  }
}

resource "google_monitoring_notification_channel" "project1" {
  display_name = "Notification Channel"
  type         = "email"
  labels = {
    email_address = var.email_adress
  }
}

locals {
  project1_id = "${google_monitoring_notification_channel.project1.name}"
}
resource "google_monitoring_alert_policy" "alert_policy_nginx" {
  display_name = "Alert Policy_Nginx"
  combiner     = "OR"
 conditions {
   display_name = "Nginx request count"

    condition_threshold {
     filter     = "metric.type=\"agent.googleapis.com/nginx/request_count\" resource.type=\"gce_instance\""
      duration   = "60s"
       threshold_value = 30
     comparison = "COMPARISON_GT"
     aggregations {
       alignment_period   = "60s"
      per_series_aligner = "ALIGN_DELTA"
      }    
    }
    }
  notification_channels = [
       "${local.project1_id}"
  ]
  }



resource "google_monitoring_alert_policy" "alert_policy_redis" {
  display_name = "Alert Policy_Redis"
  combiner     = "OR"
  conditions {
    display_name = "Redis clients connected"

     condition_threshold {
     filter     = "metric.type=\"agent.googleapis.com/redis/clients/connected\" resource.type=\"gce_instance\""
     duration   = "60s"
     threshold_value = 30
     comparison = "COMPARISON_GT"
     aggregations {
     alignment_period   = "60s"
     per_series_aligner = "ALIGN_COUNT"
      }     
    }  
  }
  notification_channels = [
       "${local.project1_id}"
  ]

}

resource "google_monitoring_alert_policy" "alert_policy_zookeeper" {
  display_name = "Alert Policy_Zookeeper"
  combiner     = "OR"
  conditions {
    display_name = "Zookeeper connections count"
    condition_threshold {
    filter     = "metric.type=\"agent.googleapis.com/zookeeper/connections_count\" resource.type=\"gce_instance\""
    duration   = "60s"
    threshold_value = 30
    comparison = "COMPARISON_GT"
    aggregations {
    alignment_period   = "60s"
    per_series_aligner = "ALIGN_COUNT"
    }     
    }
  }
  notification_channels = [
       "${local.project1_id}"
  ]
  
}

resource "google_monitoring_alert_policy" "alert_policy_postgres" {
  display_name = "Alert Policy_Postgres"
  combiner     = "OR"
  conditions {
    display_name = "PostgreSQL num backends"
    condition_threshold {
    filter     = "metric.type=\"cloudsql.googleapis.com/database/postgresql/num_backends\" resource.type=\"cloudsql_database\""
    duration   = "60s"
    threshold_value = 30
    comparison = "COMPARISON_GT"
    aggregations {
    alignment_period   = "60s"
    per_series_aligner = "ALIGN_COUNT"
     }     
    }
  }
  notification_channels = [
       "${local.project1_id}"
  ]
  
}

resource "google_monitoring_alert_policy" "alert_policy_memcached" {
  display_name = "Alert Policy_Memcached"
  combiner     = "OR"
  conditions {
    display_name = "Memcacheds current connections"
     condition_threshold {
     filter     = "metric.type=\"agent.googleapis.com/memcached/current_connections\" resource.type=\"gce_instance\""
     duration   = "60s"
     threshold_value = 30
     comparison = "COMPARISON_GT"
     aggregations {
     alignment_period   = "60s"
      per_series_aligner = "ALIGN_COUNT"
      }     
     }
  }
  notification_channels = [
       "${local.project1_id}"
  ]

}



