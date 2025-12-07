# frozen_string_literal: true

if Rails.env.development? && defined?(Annotate)
  Annotate.set_defaults(
    "position_in_routes"   => "bottom",
    "position_in_class"    => "bottom",
    "position_in_file"     => "bottom",
    "position_in_test"     => "bottom",
    "position_in_fixture"  => "bottom",
    "position_in_factory"  => "bottom",
    "show_indexes"         => "true",
    "simple_indexes"       => "false",
    "model_dir"            => "app/models",
    "include_version"      => "false",
    "format_bare"          => "true"
  )
end
