terraform {
  required_providers {
    bindplane = {
      source = "observiq/bindplane-enterprise"
    }
  }
}

// API key is configured using the environment variable BINDPLANE_TF_API_KEY
provider "bindplane" {
  remote_url = "https://app.bindplane.com"
}

resource "bindplane_source" "host" {
  rollout = true
  name = "example-host"
  type = "host"
}

variable "newrelic_license_key" {
  description = "The newrelic license key should be passed in at runtime"
}

resource "bindplane_destination" "newrelic" {
  rollout = true
  name = "example-newrelic"
  type = "newrelic_otlp"
  parameters_json = jsonencode(
    [
      {
        "name": "endpoint",
        "value": "https://otlp.nr-data.net"
      },
      {
        "name": "license_key",
        "value": "${var.newrelic_license_key}"
      },
    ]
  )
}

resource "bindplane_configuration" "test-tf" {
  rollout = true
  name = "test-tf"
  platform = "linux"

  source {
    name = bindplane_source.host.name
  }

  destination {
    name = bindplane_destination.newrelic.name
  }
}
