# Alerts and UpTimeChecks for DEMO3

## Compatibility

This project is meant for use with Terraform v0.12.20 and Google provider v3.8.0

### Resources

- `google_monitoring_uptime_check_config`     create uptime check of resource
- `google_monitoring_notification_channel`   create notification channel for alerting
- `google_monitoring_alert_policy`                    create alert policy for monitoring

### Metrics for alert_policies

###### Nginx

`"metric.type=\"agent.googleapis.com/nginx/request_count\" resource.type=\"gce_instance\""`

###### Redis

`"metric.type=\"agent.googleapis.com/redis/clients/connected\"resource.type=\"gce_instance\""`

###### Zookeeper

`"metric.type=\"agent.googleapis.com/zookeeper/connections_count\" resource.type=\"gce_instance\""`

###### PostgreSQL

`"metric.type=\"cloudsql.googleapis.com/database/postgresql/num_backends\" resource.type=\"cloudsql_database\""`

######  Memcached

`"metric.type=\"agent.googleapis.com/memcached/current_connections\" resource.type=\"gce_instance\""`

### Permissions

In order to execute this module you must have a Service Account with the following roles:

- `roles/monitoring.editor`
- `roles/monitoring.metricWriter`
- `roles/logging.logWriter`
