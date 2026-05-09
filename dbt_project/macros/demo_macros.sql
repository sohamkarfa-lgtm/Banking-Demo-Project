{% macro demo_project_audit_column() %}
  current_timestamp() as stg_loaded_at,
  '{{ invocation_id }}' as invocation_id,
  '{{ target.profile_name }}' as target_user
{% endmacro %}
