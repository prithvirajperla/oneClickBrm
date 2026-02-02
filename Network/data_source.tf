data "oci_core_services" "osn" {
  filter {
    name = "name"
    # Adding '.*' at the end to catch regional variations like 'All PHX Services...'
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}