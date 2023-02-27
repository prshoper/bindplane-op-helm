{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "bindplane.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bindplane.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
The image to use
*/}}
{{- define "bindplane.image" -}}
{{- if eq .Values.enterprise true -}}
{{- printf "%s" (default (printf "ghcr.io/observiq/bindplane-ee") .Values.image.name) }}
{{- else -}}
{{- printf "%s" (default (printf "ghcr.io/observiq/bindplane") .Values.image.name) }}
{{- end -}}
{{- end -}}

{{/*
The image tag to use
*/}}
{{- define "bindplane.tag" -}}
{{- printf "%s" (default (printf "%s" .Chart.AppVersion) .Values.image.tag) }}
{{- end -}}

{{/*
Determine if bindplane should be managed by a StatefulSet or Deployment.

When bbolt is selected, always run as a StatefulSet. When Postgres or any other
remote storage option is selected, run as a Deployment.
*/}}
{{- define "bindplane.deployment_type" -}}
{{- if eq .Values.backend.type "bbolt" -}}
{{- printf "%s" "StatefulSet" -}}
{{- else -}}
{{- printf "%s" "Deployment" -}}
{{- end -}}
{{- end -}}

{{/*
Merge ldap and active-directory into one auth type because they
have identical configuration as of right now. This makes it easier to check for
instead of checking 'if ldap || active-directory'.
*/}}
{{- define "bindplane.auth.type" -}}
{{- if or (eq .Values.auth.type "ldap") (eq .Values.auth.type "active-directory") -}}
{{- printf "%s" "ldap" }}
{{- else }}
{{- printf "%s" .Values.auth.type }}
{{- end -}}
{{- end -}}
